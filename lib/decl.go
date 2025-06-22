// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"strings"

	"modernc.org/cc/v4"
)

type nfo interface {
	isInfo()
}

type nfo0 struct{}

func (nfo0) isInfo() {}

// declared in function scope, storage automatic
type local struct {
	nfo0
	d    *cc.Declarator
	name string
}

// declared in function scope, storage automatic, escaped to TLSAlloc
type escaped struct {
	nfo0
	d      *cc.Declarator
	offset int64 // into %.bp.
}

// declared in function scope, storage static
type static struct {
	nfo0
	d    *cc.Declarator
	name string
}

// declared in top-level scope, storage static
type global struct {
	nfo0
	d    *cc.Declarator
	name string
}

// function localOld variable
type localOld struct { //TODO-
	d       *cc.Declarator
	offset  int64 // relative to alloc
	renamed string

	isStatic bool
	isValue  bool
}

type breakCtx struct {
	label string
}

type switchCtx struct {
	dflt     string
	expr     string
	nextCase string
	typ      cc.Type
}

// Function compile context
type fnCtx struct {
	allocs    int64
	breakCtx  *breakCtx
	ctx       *ctx
	infos     map[cc.Node]nfo
	locals    map[*cc.Declarator]*localOld
	returns   cc.Type
	static    []*cc.InitDeclarator
	switchCtx *switchCtx

	nextID int
}

func (c *ctx) newFnCtx(n *cc.FunctionDefinition) (r *fnCtx) {
	r = &fnCtx{
		ctx:   c,
		infos: map[cc.Node]nfo{},
	}
	walk(n, func(n cc.Node, mode int) {
		switch mode {
		case walkPre:
			switch x := n.(type) {
			case *cc.Declarator:
				if x.ReadCount() != 0 || x.WriteCount() != 0 || x.HasInitializer() || x.AddressTaken() { //TODO-
					r.registerLocal(x)
				}

				r.registerDeclarator(x)
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
	f.breakCtx = &breakCtx{label: label}
	return func() {
		f.breakCtx = old
	}
}

func (f *fnCtx) newSwitchCtx(expr string, typ cc.Type) func() {
	old := f.switchCtx
	f.switchCtx = &switchCtx{
		expr: expr,
		typ:  typ,
	}
	g := f.newBreakCtx(f.ctx.label())
	return func() {
		f.switchCtx = old
		g()
	}
}

func (f *fnCtx) alloc(align, size int64) (r int64) {
	r = round(f.allocs, align)
	f.allocs = r + size
	return r
}

func (f *fnCtx) registerDeclarator(d *cc.Declarator) {
	if d == nil {
		return
	}

	dt := d.Type()
	k := dt.Kind()
	switch dt := d.Type(); d.StorageDuration() {
	case cc.Static:
		switch sc := d.ResolvedIn(); sc {
		case nil:
			// dead
		default:
			switch {
			case sc.Parent == nil:
				f.infos[d] = &global{
					d:    d,
					name: fmt.Sprintf("$%s", d.Name()),
				}
			default:
				f.infos[d] = &static{
					d:    d,
					name: fmt.Sprintf("$%s.%v", d.Name(), f.ctx.id()),
				}
			}
		}
	case cc.Automatic:
		switch {
		case d.AddressTaken() || k == cc.Array || k == cc.Struct || k == cc.Union:
			f.infos[d] = &escaped{
				d:      d,
				offset: f.alloc(int64(dt.Align()), dt.Size()),
			}
		default:
			suff := ""
			if !d.IsParam() {
				//TODO suff = fmt.Sprintf(".%d", f.id())
				suff = fmt.Sprintf(".%d", len(f.locals)-1)
			}
			f.infos[d] = &local{
				d:    d,
				name: fmt.Sprintf("%%%s%s", d.Name(), suff),
			}
		}
	default:
		panic(todo("", d.StorageDuration()))
	}
}

func (f *fnCtx) info(n cc.Node) (d *cc.Declarator, nfo nfo) {
	switch x := n.(type) {
	case *cc.Declarator:
		d = x
	case cc.ExpressionNode:
		d = f.ctx.declaratorOf(x)
	default:
		panic(todo("%T", x))
	}
	return d, f.infos[d]
}

func (f *fnCtx) registerLocal(d *cc.Declarator) (r *localOld) { //TODO-
	if d.StorageDuration() == cc.Static && (d.ResolvedIn() == nil || d.ResolvedIn().Parent == nil) {
		return nil
	}

	if f.locals == nil {
		f.locals = map[*cc.Declarator]*localOld{}
	}
	if r = f.locals[d]; r == nil {
		switch {
		case d.StorageDuration() == cc.Static:
			r = &localOld{
				d:       d,
				renamed: fmt.Sprintf("$%s.%d", d.Name(), f.ctx.id()),
			}
		default:
			isValue := !d.AddressTaken() && (f.ctx.isIntegerType(d.Type()) || f.ctx.isFloatingPointType(d.Type()) || d.Type().Kind() == cc.Ptr)
			var off int64
			if !isValue {
				off = f.alloc(int64(d.Type().Align()), d.Type().Size())
			}
			suff := ""
			if !d.IsParam() {
				suff = fmt.Sprintf(".%d", len(f.locals))
			}
			r = &localOld{
				d:       d,
				isValue: isValue,
				offset:  off,
				renamed: fmt.Sprintf("%%%s%s", d.Name(), suff),
			}
		}
		f.locals[d] = r
	}
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
	if n.DeclarationList != nil {
		c.err(n.DeclarationList, "unsupported declaration list style")
		return
	}

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
	c.compoundStatement(n.CompoundStatement)
	c.w("%s\n\tret\n", c.label())
	c.w("}\n\n")
}

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
		c.w("data $%s = align %d ", d.Name(), d.Type().Align())
		switch l.InitDeclarator.Case {
		case cc.InitDeclaratorDecl: // int d;
			c.w("{ z %d }", d.Type().Size())
		default:
			panic(todo("%v: %s %s", n.Position(), l.InitDeclarator.Case, cc.NodeSource(n)))
		}
		c.w("\n")
	}
}

func (c *ctx) externalDeclarationDecl(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		c.externalDeclarationDeclFull(n)
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) externalDeclaration(n *cc.ExternalDeclaration) {
	switch n.Case {
	case cc.ExternalDeclarationFuncDef: // FunctionDefinition
		c.externalDeclarationFuncDef(n.FunctionDefinition)
	case cc.ExternalDeclarationDecl: // Declaration
		c.externalDeclarationDecl(n.Declaration)
	case cc.ExternalDeclarationAsmStmt: // AsmStatement
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.ExternalDeclarationEmpty: // ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) isHeader(n cc.Node) bool {
	if n == nil {
		return false
	}

	return strings.HasSuffix(n.Position().Filename, ".h") ||
		c.t.goos == "windows" && strings.HasSuffix(n.Position().Filename, ".inl")
}
