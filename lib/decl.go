// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

// function local variable
type local struct {
	renamed string
	offset  int64 // relative to alloc

	isValue bool
}

// Function compile context
type fnCtx struct {
	allocs  int64
	locals  map[*cc.Declarator]*local
	returns cc.Type
	static  []*cc.InitDeclarator
}

func newFnCtx(n *cc.FunctionDefinition) (r *fnCtx) {
	r = &fnCtx{}
	walk(n, func(n cc.Node, mode int) {
		switch mode {
		case walkPre:
			switch x := n.(type) {
			case *cc.Declarator:
				switch x.StorageDuration() {
				case cc.Automatic:
					r.local(x)
				}
			}
		}
	})
	return r
}

func (f *fnCtx) alloc(align, size int64) (r int64) {
	r = round(f.allocs, align)
	f.allocs = r + size
	return r
}

func (f *fnCtx) local(d *cc.Declarator) (r *local) {
	if f.locals == nil {
		f.locals = map[*cc.Declarator]*local{}
	}
	if r = f.locals[d]; r == nil {
		isValue := !d.AddressTaken() && cc.IsScalarType(d.Type())
		var off int64
		if !isValue {
			off = f.alloc(int64(d.Type().Align()), d.Type().Size())
		}
		r = &local{
			isValue: isValue,
			offset:  off,
			renamed: fmt.Sprintf("%%%s.%d", d.Name(), len(f.locals)),
		}
		f.locals[d] = r
	}
	return r
}

func (c *ctx) signature(l []*cc.Parameter) {
	c.w("(")
	for _, v := range l {
		c.w("%s ", c.typ(v, v.Type()))
		c.w("TODO, ")
	}
	c.w(")")
}

// FunctionDefinition:
//	DeclarationSpecifiers Declarator DeclarationList CompoundStatement

func (c *ctx) functionDefinition(n *cc.FunctionDefinition) {
	if n.DeclarationList != nil {
		c.err(n.DeclarationList, "unsupported declaration list style")
		return
	}

	f := newFnCtx(n)
	c.fn = f

	defer func() {
		c.fn = nil
	}()

	c.pos(n)
	d := n.Declarator
	if d.Linkage() == cc.External {
		c.w("export ")
	}
	c.w("function ")
	ft := d.Type().(*cc.FunctionType)
	if f.returns = ft.Result(); f.returns.Kind() != cc.Void {
		c.w("%s ", c.typ(d, f.returns))
	}
	c.w("$%s", d.Name())
	c.signature(ft.Parameters())
	c.w(" {\n")
	c.w("@start.0\n")
	c.compoundStatement(n.CompoundStatement)
	c.w("}\n")
}

func (c *ctx) declarationDecl(n *cc.Declaration) {
	for l := n.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
		d := l.InitDeclarator.Declarator
		if d.IsTypename() { // typedef int i;
			continue
		}

		if d.IsExtern() { // extern int foo;
			continue
		}

		c.pos(n)
		if d.Linkage() == cc.External {
			c.w("export ")
		}
		c.w("$%s = align %d ", d.Name(), d.Type().Align())
		switch l.InitDeclarator.Case {
		case cc.InitDeclaratorDecl: // int d;
			c.w("{ z %d }", d.Type().Size())
		default:
			panic(todo("%v: %s %s", n.Position(), l.InitDeclarator.Case, cc.NodeSource(n)))
		}
		c.w("\n")
	}
}

func (c *ctx) declaration(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		c.declarationDecl(n)
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) externalDeclaration(n *cc.ExternalDeclaration) {
	switch n.Case {
	case cc.ExternalDeclarationFuncDef: // FunctionDefinition
		c.functionDefinition(n.FunctionDefinition)
	case cc.ExternalDeclarationDecl: // Declaration
		c.declaration(n.Declaration)
	case cc.ExternalDeclarationAsmStmt: // AsmStatement
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.ExternalDeclarationEmpty: // ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}
