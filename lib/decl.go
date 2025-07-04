// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"sort"
	"strings"

	"modernc.org/cc/v4"
)

type variable interface {
	isVarinfo()
	String() string
}

type varinfo struct{}

func (varinfo) isVarinfo() {}

// declared in function scope, storage automatic
type local struct {
	varinfo
	d    *cc.Declarator
	name string
}

func (n *local) String() string {
	return fmt.Sprintf("%v: %T %s %s", n.d.Position(), n, n.d.Name(), n.name)
}

// declared in function scope, storage automatic, escaped to TLSAlloc.
type escaped struct {
	varinfo
	d      *cc.Declarator
	offset int64 // into %.bp.
}

func (n *escaped) String() string {
	return fmt.Sprintf("%v: %T %s", n.d.Position(), n, n.d.Name())
}

// storage static
type static struct {
	varinfo
	d    *cc.Declarator
	name string
}

type variables map[*cc.Declarator]variable

func (v *variables) register(n cc.Node, f *fnCtx) {
	m := *v
	if m == nil {
		m = variables{}
		*v = m
	}
	switch x := n.(type) {
	case nil:
		return
	case *cc.Declarator:
		if x == nil || m[x] != nil {
			return
		}

		// defer func() { trc("%v: %v %v", n.Position(), cc.NodeSource(n), m[x]) }()
		dt := x.Type()
		k := dt.Kind()
		switch x.StorageDuration() {
		case cc.Static:
			switch sc := x.ResolvedIn(); sc {
			case nil:
				if strings.HasPrefix(x.Name(), "__builtin_") {
					m[x] = &static{
						d:    x,
						name: fmt.Sprintf("$%s", x.Name()[len("__builtin_"):]),
					}
				}
			default:
				switch {
				case sc.Parent == nil:
					m[x] = &static{
						d:    x,
						name: fmt.Sprintf("$%s", x.Name()),
					}
				default:
					m[x] = &static{
						d:    x,
						name: fmt.Sprintf("$.%s.%v.", x.Name(), f.ctx.id()),
					}
				}
			}
		case cc.Automatic:
			switch {
			case x.AddressTaken() || k == cc.Array || k == cc.Struct || k == cc.Union:
				m[x] = &escaped{
					d:      x,
					offset: f.alloc(x, int64(dt.Align()), f.ctx.sizeof(x, dt)),
				}
			default:
				suff := ""
				if !x.IsParam() {
					suff = fmt.Sprintf(".%d", f.id())
				}
				m[x] = &local{
					d:    x,
					name: fmt.Sprintf("%%%s%s", x.Name(), suff),
				}
			}
		default:
			panic(todo("", x.StorageDuration()))
		}
	default:
		// compostite literal: COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000722-1.c
		panic(todo("%v: %v %T", n.Position(), cc.NodeSource(n), x))
	}
}

func (n *static) String() string {
	return fmt.Sprintf("%v: %T %s %s", n.d.Position(), n, n.d.Name(), n.name)
}

type breakContinueCtx struct {
	label string
}

type switchCase struct {
	*cc.LabeledStatement
	label string
	val0  any
	val   int64

	isDefault bool
}

type switchCtx struct {
	defaultCase *switchCase
	case2index  map[*cc.LabeledStatement]int // index into the sorted cases slice
	cases       []*switchCase
	expr        string
	sign        string // "s" or "u"
	suff        string // "w" or "l"
	typ         cc.Type

	isSigned bool
}

// Function compile context
type fnCtx struct {
	allocs      int64
	breakCtx    *breakContinueCtx
	continueCtx *breakContinueCtx
	ctx         *ctx
	returns     cc.Type
	static      []*cc.InitDeclarator
	switchCtx   *switchCtx
	variables   variables

	nextID int
}

func (c *ctx) newFnCtx(n *cc.FunctionDefinition) (r *fnCtx) {
	r = &fnCtx{
		ctx: c,
	}
	ignore := 0
	walk(n, func(n cc.Node, mode int) {
		switch mode {
		case walkPre:
			switch x := n.(type) {
			case *cc.StructDeclarator:
				ignore++
			case *cc.Declarator:
				if ignore == 0 {
					r.variables.register(x, r)
				}
			case *cc.PostfixExpression:
				switch x.Case {
				case cc.PostfixExpressionComplit:
					r.variables.register(x, r)
				}
			case *cc.PrimaryExpression:
				switch x.Case {
				case cc.PrimaryExpressionIdent:
					if d, ok := x.ResolvedTo().(*cc.Declarator); ok {
						r.variables.register(d, r)
					}
				}
			}
		case walkPost:
			switch n.(type) {
			case *cc.StructDeclarator:
				ignore--
			}
		}
	})
	return r
}

func (f *fnCtx) id() (r int) {
	r = f.nextID
	f.nextID++
	return r
}

func (f *fnCtx) newBreakCtx(label string) func() {
	old := f.breakCtx
	f.breakCtx = &breakContinueCtx{label: label}
	return func() {
		f.breakCtx = old
	}
}

func (f *fnCtx) newContinueCtx(label string) func() {
	old := f.breakCtx
	f.continueCtx = &breakContinueCtx{label: label}
	return func() {
		f.continueCtx = old
	}
}

func (f *fnCtx) newSwitchCtx(expr string, typ cc.Type, cases0 []*cc.LabeledStatement) func() {
	isSigned := cc.IsSignedInteger(typ)
	defaultCase := &switchCase{
		isDefault: true,
		label:     f.ctx.label(),
	}
	cases := []*switchCase{defaultCase}
	for _, v := range cases0 {
		switch v.Case {
		case cc.LabeledStatementDefault:
			defaultCase.LabeledStatement = v
		default:
			var val0 any
			var val int64
			switch x := v.ConstantExpression.Value().(type) {
			case cc.Int64Value:
				val0 = int64(x)
				val = int64(x)
			case cc.UInt64Value:
				val0 = uint64(x)
				val = int64(x)
			default:
				panic(todo("%v: %T %s", v.ConstantExpression, x, cc.NodeSource(v.ConstantExpression)))
			}
			cases = append(cases, &switchCase{
				LabeledStatement: v,
				label:            f.ctx.label(),
				val0:             val0,
				val:              val,
			})
		}
	}
	cases1 := cases[1:]
	sort.Slice(cases1, func(i, j int) bool {
		switch {
		case isSigned:
			return cases1[i].val < cases1[j].val
		default:
			return uint64(cases1[i].val) < uint64(cases1[j].val)
		}
	})
	cases2index := map[*cc.LabeledStatement]int{}
	for i, v := range cases {
		cases2index[v.LabeledStatement] = i
	}
	cases = append(cases, defaultCase)
	old := f.switchCtx
	sign := "u"
	if isSigned {
		sign = "s"
	}
	f.switchCtx = &switchCtx{
		defaultCase: defaultCase,
		case2index:  cases2index,
		cases:       cases,
		expr:        expr,
		isSigned:    isSigned,
		sign:        sign,
		suff:        f.ctx.baseType(nil, typ),
		typ:         typ,
	}
	g := f.newBreakCtx(f.ctx.label())
	return func() {
		f.switchCtx = old
		g()
	}
}

func (f *fnCtx) alloc(n cc.Node, align, size int64) (r int64) {
	if align <= 0 || size < 0 {
		f.ctx.err(n, "incomplete types not supported")
		align = 1
	}
	size = max(size, 1)
	r = round(f.allocs, align)
	f.allocs = r + size
	// trc("%v: (align=%v size=%v)=%v", n.Position(), align, size, r)
	return r
}

func (c *ctx) signature(l []*cc.Parameter) {
	c.w("(")
	for _, v := range l {
		if v.Type().Kind() == cc.Void {
			break
		}

		c.w("%s ", c.baseType(v, v.Type()))
		switch nm := v.Name(); nm {
		case "":
			c.w("TODO, ")
		default:
			c.w("%%%s, ", nm)
		}
	}
	c.w(")")
}

// FunctionDefinition:
//	DeclarationSpecifiers Declarator DeclarationList CompoundStatement

func (c *ctx) externalDeclarationFuncDef(n *cc.FunctionDefinition) {
	f := c.newFnCtx(n)
	c.fn = f

	defer func() {
		c.fn = nil
	}()

	d := n.Declarator
	if d.IsInline() && c.isHeader(d) {
		return
	}

	c.pos(n)
	if d.Linkage() == cc.External {
		c.w("export ")
	}
	c.w("function ")
	ft := d.Type().(*cc.FunctionType)
	if f.returns = ft.Result(); f.returns.Kind() != cc.Void {
		c.w("%s ", c.baseType(d, f.returns))
	}
	c.w("$%s", d.Name())
	c.signature(ft.Parameters())
	c.w(" {\n")
	c.w("@start.0\n")
	if f.allocs != 0 {
		c.w("\t%%.bp. =%s alloc8 %v\n", c.wordTag, f.allocs)
	}
	for _, v := range ft.Parameters() {
		switch d, info := c.variable(v.Declarator); x := info.(type) {
		case *escaped:
			c.w("\t%%._l =%s add %%.bp., %v\n", c.wordTag, x.offset)
			c.w("\tstore%s %%%s, %%._l\n", c.baseType(d, d.Type()), d.Name())
		}
	}
	c.compoundStatement(n.CompoundStatement)
	switch {
	case c.fn.returns.Kind() != cc.Void:
		c.w("%s\n\tret 0\n", c.label())
	default:
		c.w("%s\n\tret\n", c.label())
	}
	c.w("}\n\n")
	for _, v := range c.fn.static {
		d := v.Declarator
		// trc("%v: %p %s", d.Position(), d, d.Name())
		if d.ReadCount() == 0 {
			continue
		}

		_, info := c.variable(d)
		c.w("data %s = align %d ", info.(*static).name, d.Type().Align())
		switch {
		case v.Initializer != nil:
			c.w("{")
			c.initializer(v.Initializer, info, d.Type())
			c.w("}\n\n")
		default:
			c.w("{ z %d }\n\n", c.sizeof(d, d.Type()))
		}
	}
}

// DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
func (c *ctx) externalDeclarationDeclFull(n *cc.Declaration) {
	for l := n.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
		d := l.InitDeclarator.Declarator
		if d.IsTypename() { // typedef int i;
			continue
		}

		if d.IsExtern() { // extern int foo;
			continue
		}

		if d.Type().Kind() == cc.Function { // int foo(int);
			continue
		}

		c.pos(n)
		if d.Linkage() == cc.External {
			c.w("export ")
		}
		if l.InitDeclarator.Asm != nil {
			c.err(n, "assembler not supported")
			return
		}

		switch n := l.InitDeclarator; n.Case {
		case cc.InitDeclaratorDecl: // Declarator Asm
			c.w("data $%s = align %d { z %d }", d.Name(), d.Type().Align(), c.sizeof(d, d.Type()))
		case cc.InitDeclaratorInit: // Declarator Asm '=' Initializer
			c.w("data $%s = align %d {", d.Name(), d.Type().Align())
			c.initializer(n.Initializer, &static{
				d:    d,
				name: fmt.Sprintf("$%s", d.Name()),
			}, d.Type())
			c.w(" }")
		default:
			panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		}
		c.w("\n")
	}
}

// Declaration
func (c *ctx) externalDeclarationDecl(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		c.externalDeclarationDeclFull(n)
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) externalDeclaration(n *cc.ExternalDeclaration) {
	switch n.Case {
	case cc.ExternalDeclarationFuncDef: // FunctionDefinition
		c.externalDeclarationFuncDef(n.FunctionDefinition)
	case cc.ExternalDeclarationDecl: // Declaration
		c.externalDeclarationDecl(n.Declaration)
	case cc.ExternalDeclarationAsmStmt: // AsmStatement
		c.err(n, "assembler statements not supported")
	case cc.ExternalDeclarationEmpty: // ';'
		// ok
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) isHeader(n cc.Node) bool {
	if n == nil {
		return false
	}

	return strings.HasSuffix(n.Position().Filename, ".h") ||
		c.t.goos == "windows" && strings.HasSuffix(n.Position().Filename, ".inl")
}

// v has no initializer
func (c *ctx) declare(n cc.Node, v variable) {
	switch x := v.(type) {
	case *local:
		c.w("\t%s =%s copy 0\n", x.name, c.baseType(n, x.d.Type()))
	case *escaped:
		// nop
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
