// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

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

	f := &fnCtx{}
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
