// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"reflect"
	"runtime"
	"runtime/debug"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"modernc.org/cc/v4"
	"modernc.org/token"
)

const (
	errLimit = 10
)

var (
	zeroReflectValue reflect.Value
)

// origin returns caller's short position, skipping skip frames.
//
//lint:ignore U1000 debug helper
func origin(skip int) string {
	pc, fn, fl, _ := runtime.Caller(skip)
	f := runtime.FuncForPC(pc)
	var fns string
	if f != nil {
		fns = f.Name()
		if x := strings.LastIndex(fns, "."); x > 0 {
			fns = fns[x+1:]
		}
		if strings.HasPrefix(fns, "func") {
			num := true
			for _, c := range fns[len("func"):] {
				if c < '0' || c > '9' {
					num = false
					break
				}
			}
			if num {
				return origin(skip + 2)
			}
		}
	}
	return fmt.Sprintf("%s:%d:%s", filepath.Base(fn), fl, fns)
}

// todo prints and return caller's position and an optional message tagged with TODO. Output goes to stderr.
//
//lint:ignore U1000 debug helper
func todo(s string, args ...interface{}) string {
	switch {
	case s == "":
		s = fmt.Sprintf(strings.Repeat("%v ", len(args)), args...)
	default:
		s = fmt.Sprintf(s, args...)
	}
	r := fmt.Sprintf("%s TODO %s", origin(2), s)
	return r
}

// trc prints and return caller's position and an optional message tagged with TRC. Output goes to stderr.
//
//lint:ignore U1000 debug helper
func trc(s string, args ...interface{}) string {
	switch {
	case s == "":
		s = fmt.Sprintf(strings.Repeat("%v ", len(args)), args...)
	default:
		s = fmt.Sprintf(s, args...)
	}
	r := fmt.Sprintf("%s: TRC %s", origin(2), s)
	fmt.Fprintf(os.Stderr, "%s\n", r)
	os.Stderr.Sync()
	return r
}

type tooManyErrors struct{}

func (tooManyErrors) Error() string {
	return "too many errors"
}

type posErr struct {
	token.Position
	Err error
}

func (e *posErr) Error() string {
	return fmt.Sprintf("%v: %v", e.Position, e.Err)
}

type errList struct {
	sync.Mutex
	errs []*posErr

	extendedErrors bool
}

func (e *errList) Error() string {
	e.Lock()

	defer e.Unlock()

	var a []string
	for _, v := range e.errs {
		switch {
		case e.extendedErrors:
			a = append(a, v.Error())
		default:
			b := strings.Split(v.Error(), "\n")
			a = append(a, b[0])
		}
	}
	return strings.Join(a, "\n")
}

func (e *errList) Err() error {
	e.Lock()

	defer e.Unlock()

	if len(e.errs) == 0 {
		return nil
	}

	return e
}

func (e *errList) err(n cc.Node, s string, args ...any) {
	var pos token.Position
	if n != nil {
		pos = n.Position()
	}
	err := &posErr{pos, fmt.Errorf(s, args...)}
	e.Lock()

	defer e.Unlock()

	if len(e.errs) > errLimit {
		return
	}

	e.errs = append(e.errs, err)
	if len(e.errs) == errLimit {
		panic(tooManyErrors{})
	}
}

type fileNode string

func (n fileNode) Position() (r token.Position) {
	r.Filename = string(n)
	return r
}

type parallel struct {
	sync.Mutex

	limit chan struct{}
	wg    sync.WaitGroup
}

func newParallel(limit int) (r *parallel) {
	return &parallel{
		limit: make(chan struct{}, limit),
	}
}

func (p *parallel) exec(run func()) {
	p.limit <- struct{}{}
	p.wg.Add(1)

	go func() {
		defer func() {
			p.wg.Done()
			<-p.limit
		}()

		run()
	}()
}

func (p *parallel) wait() {
	p.wg.Wait()
}

type buf struct {
	b bytes.Buffer
}

func (b *buf) w(s string, args ...any) (r []byte) {
	n := b.b.Len()
	fmt.Fprintf(&b.b, s, args...)
	return b.b.Bytes()[n:b.b.Len()]
}

func (t *Task) recover(fail *atomic.Bool) {
	var err error
	switch x := recover().(type) {
	case nil, tooManyErrors:
		// ok
		return
	case error:
		err = x
	default:
		// trc("\n%s", debug.Stack())
		err = fmt.Errorf("%v", x)
	}
	if fail != nil {
		fail.Store(true)
	}
	switch {
	case t.errs.extendedErrors:
		err = fmt.Errorf("PANIC: %v\n%s", err, debug.Stack())
	default:
		err = fmt.Errorf("PANIC: %v", err)
	}
	t.errs.Lock()

	defer t.errs.Unlock()

	if len(t.errs.errs) < errLimit {
		t.errs.errs = append(t.errs.errs, &posErr{token.Position{}, err})
	}
}

func stripExtCH(s string) (r string) {
	switch ext := filepath.Ext(s); ext {
	case ".c", ".h":
		return s[:len(s)-len(ext)]
	}

	return s
}

func stripExtS(s string) (r string) {
	switch ext := filepath.Ext(s); ext {
	case ".s":
		return s[:len(s)-len(ext)]
	}

	return s
}

func shell(timeout time.Duration, cmd string, args ...string) (out []byte, err error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	return exec.CommandContext(ctx, cmd, args...).CombinedOutput()
}

const (
	walkTok = iota
	walkPre
	walkPost
)

func walk(n cc.Node, fn func(n cc.Node, mode int)) {
	if n == nil {
		return
	}

	if _, ok := n.(cc.Token); ok {
		fn(n, walkTok)
		return
	}

	t := reflect.TypeOf(n)
	v := reflect.ValueOf(n)
	if t.Kind() == reflect.Pointer {
		t = t.Elem()
		v = v.Elem()
	}
	if v == zeroReflectValue || v.IsZero() || t.Kind() != reflect.Struct {
		return
	}

	fn(n, walkPre)
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		if !f.IsExported() {
			continue
		}

		if m, ok := v.Field(i).Interface().(cc.Node); ok {
			walk(m, fn)
		}
	}
	fn(n, walkPost)
}

func round(n, to int64) int64 {
	if m := n % to; m != 0 {
		n += to - m
	}
	return n
}

func (c *ctx) declaratorOf(n cc.ExpressionNode) (r *cc.Declarator) {
	for n != nil {
		n = unparen(n)
		switch x := n.(type) {
		case *cc.PrimaryExpression:
			switch x.Case {
			case cc.PrimaryExpressionIdent: // IDENTIFIER
				switch y := x.ResolvedTo().(type) {
				case *cc.Declarator:
					return y
				case *cc.Parameter:
					return y.Declarator
				case *cc.Enumerator, nil:
					return nil
				default:
					panic(todo("%v: %s %s", n.Position(), x.Case, cc.NodeSource(n)))
				}
			case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
				n = x.ExpressionList
			default:
				return nil
			}
		case *cc.PostfixExpression:
			switch x.Case {
			case cc.PostfixExpressionPrimary: // PrimaryExpression
				n = x.PrimaryExpression
			default:
				return nil
			}
		case *cc.ExpressionList:
			if x == nil {
				return nil
			}

			for l := x; l != nil; l = l.ExpressionList {
				n = l.AssignmentExpression
			}
		case *cc.CastExpression:
			switch x.Case {
			case cc.CastExpressionUnary: // UnaryExpression
				n = x.UnaryExpression
			case cc.CastExpressionCast:
				if x.Type() != x.CastExpression.Type() {
					return nil
				}

				n = x.CastExpression
			default:
				return nil
			}
		case *cc.UnaryExpression:
			switch x.Case {
			case cc.UnaryExpressionPostfix: // PostfixExpression
				n = x.PostfixExpression
			default:
				return nil
			}
		case *cc.ConditionalExpression:
			switch x.Case {
			case cc.ConditionalExpressionLOr: // LogicalOrExpression
				n = x.LogicalOrExpression
			default:
				return nil
			}
		case *cc.AdditiveExpression:
			switch x.Case {
			case cc.AdditiveExpressionMul: // MultiplicativeExpression
				n = x.MultiplicativeExpression
			default:
				return nil
			}
		case *cc.InclusiveOrExpression:
			switch x.Case {
			case cc.InclusiveOrExpressionXor: // ExclusiveOrExpression
				n = x.ExclusiveOrExpression
			default:
				return nil
			}
		case *cc.ShiftExpression:
			switch x.Case {
			case cc.ShiftExpressionAdd:
				n = x.AdditiveExpression
			default:
				return nil
			}
		case *cc.AndExpression:
			switch x.Case {
			case cc.AndExpressionEq:
				n = x.EqualityExpression
			default:
				return nil
			}
		case *cc.MultiplicativeExpression:
			switch x.Case {
			case cc.MultiplicativeExpressionCast:
				n = x.CastExpression
			default:
				return nil
			}
		case *cc.EqualityExpression:
			switch x.Case {
			case cc.EqualityExpressionRel:
				n = x.RelationalExpression
			default:
				return nil
			}
		case *cc.RelationalExpression:
			switch x.Case {
			case cc.RelationalExpressionShift:
				n = x.ShiftExpression
			default:
				return nil
			}
		case *cc.LogicalOrExpression:
			switch x.Case {
			case cc.LogicalOrExpressionLAnd:
				n = x.LogicalAndExpression
			default:
				return nil
			}
		case *cc.AssignmentExpression:
			switch x.Case {
			case cc.AssignmentExpressionCond:
				n = x.ConditionalExpression
			default:
				return nil
			}
		case *cc.LogicalAndExpression:
			switch x.Case {
			case cc.LogicalAndExpressionOr:
				n = x.InclusiveOrExpression
			default:
				return nil
			}
		case *cc.ExclusiveOrExpression:
			switch x.Case {
			case cc.ExclusiveOrExpressionAnd:
				n = x.AndExpression
			default:
				return nil
			}
		case *cc.ConstantExpression:
			n = x.ConditionalExpression
		default:
			panic(todo("%T", n))
		}
	}
	return nil
}

func buildDefs(D, U []string) string {
	var a []string
	for _, v := range D {
		v = v[len("-D"):]
		if i := strings.IndexByte(v, '='); i > 0 {
			a = append(a, fmt.Sprintf("#define %s %s", v[:i], v[i+1:]))
			continue
		}

		a = append(a, fmt.Sprintf("#define %s 1", v))
	}
	for _, v := range U {
		v = v[len("-U"):]
		a = append(a, fmt.Sprintf("#undef %s", v))
	}
	return strings.Join(a, "\n")
}

//lint:ignore U1000 debug helper
func pos(n cc.Node) string {
	if n == nil {
		return "-:"
	}

	p := n.Position()
	p.Filename = filepath.Base(p.Filename)
	return p.String()
}
