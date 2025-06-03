// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"modernc.org/cc/v4"
	"modernc.org/libqbe"
)

type local struct {
	renamed string

	isValue bool
}

// Function compile context
type fnCtx struct {
	locals  map[*cc.Declarator]*local
	returns cc.Type
	static  []*cc.InitDeclarator
}

func (f *fnCtx) registerLocal(d *cc.Declarator) (r *local) {
	if f.locals == nil {
		f.locals = map[*cc.Declarator]*local{}
	}
	if r = f.locals[d]; r == nil {
		r = &local{
			isValue: !d.AddressTaken(),
			renamed: fmt.Sprintf("%%%s.%d", d.Name(), len(f.locals)),
		}
		f.locals[d] = r
	}
	return r
}

// Translation unit compile context
type ctx struct {
	asm     string // foo/bar.s
	ast     *cc.AST
	buf     // QBE SSA
	fn      *fnCtx
	in      string // foo/bar.c
	nextID  int
	obj     string            // foo/bar.o
	strings map[string]string // value: name
	t       *Task

	failed bool
}

func (t *Task) newCtx(ast *cc.AST) *ctx {
	return &ctx{
		ast: ast,
		t:   t,
	}
}

func (c *ctx) err(n cc.Node, s string, args ...any) {
	c.failed = true
	c.t.err(n, s, args...)
}

func (c *ctx) translationUnit(n *cc.TranslationUnit) (ok bool) {
	for ; n != nil; n = n.TranslationUnit {
		c.externalDeclaration(n.ExternalDeclaration)
	}
	if c.failed {
		return false
	}

	var a []string
	for k := range c.strings {
		a = append(a, k)
	}
	sort.Strings(a)
	c.w("\n")
	for _, k := range a {
		c.w("data %s = { b %s }\n", c.strings[k], strconv.QuoteToASCII(k))
	}
	return true
}

func (c *ctx) pos(n cc.Node) {
	if n != nil {
		switch c.t.positions {
		case posBase:
			p := n.Position()
			p.Filename = filepath.Base(p.Filename)
			c.w("# %v:\n", p)
		case posFull:
			c.w("# %v:\n", n.Position())
		}
	}
}

func (c *ctx) id() (r int) {
	r = c.nextID
	c.nextID++
	return r
}

func (c *ctx) addString(s string) (r string) {
	if c.strings == nil {
		c.strings = map[string]string{}
	}
	if r = c.strings[s]; r == "" {
		r = fmt.Sprintf("$.ts.%d", c.id())
		c.strings[s] = r
	}
	return r
}

// fn is .c or .h
func (t *Task) sourcesFor(fn string) (r []cc.Source, err error) {
	r = []cc.Source{
		{Name: "<predefined>", Value: t.cfg.Predefined + predefined},
		{Name: "<builtin>", Value: builtin},
	}
	return append(r, cc.Source{Name: fn}), nil
}

func (t *Task) asmFile(in string, c *ctx) (err error) {
	strippedNm := stripExtCH(in)
	fn := strippedNm + ".ssa"
	var asm buf
	asm.w(".section .qbecc_ssa, \"\", @progbits\n")
	asm.w(".global .qbecc_ssa_start\n")
	asm.w(".global .qbecc_ssa_end\n")
	asm.w(".global .qbecc_ssa_size\n\n")
	asm.w("qbecc_ssa_start:\n")
	for _, v := range strings.Split(c.b.String(), "\n") {
		asm.w("\t.ascii %s\n", strconv.QuoteToASCII(v+"\n"))
	}
	asm.w("qbecc_ssa_end:\n")
	asm.w("\n.set qbecc_ssa_size, qbecc_ssa_end - qbecc_ssa_start\n\n")
	if err := libqbe.Main(t.target, fn, &c.b, &asm.b, nil); err != nil {
		return err
	}

	fn = strippedNm + ".s"
	if err = os.WriteFile(fn, asm.b.Bytes(), 0660); err != nil {
		return err
	}

	c.asm = fn
	return nil
}

// fn is .c or .h
func (t *Task) compileOne(fn string) (r *ctx) {
	srcs, err := t.sourcesFor(fn)
	if err != nil {
		t.err(nil, "%v", err)
		return
	}

	ast, err := cc.Translate(t.cfg, srcs)
	if err != nil {
		t.err(nil, "%v", err)
		return
	}

	defer func() {
		r.ast = nil
	}()

	r = t.newCtx(ast)
	r.in = fn
	r.w(t.ssaHeader)
	if !r.translationUnit(ast.TranslationUnit) {
		return nil
	}

	if err = t.asmFile(fn, r); err != nil {
		t.err(nil, "%v", err)
		return nil
	}

	return r
}

func (t *Task) compile() (ok bool) {
	defer t.recover(&ok)

	ok = true

	ctxs := make([]*ctx, len(t.inputFiles))
	for i, v := range t.inputFiles {
		switch filepath.Ext(v) {
		case ".c", ".h":
			t.parallel.exec(func() {
				defer t.recover(&ok)
				ctxs[i] = t.compileOne(v)
				if ctxs[i].failed {
					ok = false
				}
			})
		default:
			t.err(nil, "unexpected file type: %s", v)
			return false
		}
	}
	t.parallel.wait()
	t.compiled = ctxs
	return ok
}
