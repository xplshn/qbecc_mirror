// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

func (c *ctx) externalDeclaration(n *cc.ExternalDeclaration) {
	return //TODO-
	switch n.Case {
	case cc.ExternalDeclarationFuncDef: // FunctionDefinition
		c.w("# %v: %s\n", n.Position(), n.FunctionDefinition.Declarator.Name())
		//TODO panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
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

func (c *ctx) declaration(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		for l := n.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
			d := l.InitDeclarator.Declarator
			if d.IsTypename() { // typedef int i;
				continue
			}

			if d.IsExtern() { // extern int foo;
				continue
			}

			c.w("# %v:\n", n.Position())
			if d.Linkage() == cc.External {
				c.w("external ")
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
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}
