// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

// ExpressionStatement:
//	ExpressionList ';'

func (c *ctx) expressionStatement(n *cc.ExpressionStatement) {
	c.expr(n.ExpressionList, void, nil)
}

func (c *ctx) jumpStatementReturn(n *cc.JumpStatement) {
	s := ""
	if n.ExpressionList != nil {
		s = c.expr(n.ExpressionList, rvalue, c.fn.returns)
	}
	c.w("\tret %s\n", s)
}

func (c *ctx) jumpStatement(n *cc.JumpStatement) {
	switch n.Case {
	case cc.JumpStatementGoto: // "goto" IDENTIFIER ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementGotoExpr: // "goto" '*' ExpressionList ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementContinue: // "continue" ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementBreak: // "break" ';'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementReturn: // "return" ExpressionList ';'
		c.jumpStatementReturn(n)
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) statement(n *cc.Statement) {
	switch n.Case {
	case cc.StatementLabeled: // LabeledStatement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.StatementCompound: // CompoundStatement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.StatementExpr: // ExpressionStatement
		c.expressionStatement(n.ExpressionStatement)
	case cc.StatementSelection: // SelectionStatement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.StatementIteration: // IterationStatement
		c.iterationStatement(n.IterationStatement)
	case cc.StatementJump: // JumpStatement
		c.jumpStatement(n.JumpStatement)
	case cc.StatementAsm: // AsmStatement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) iterationStatement(n *cc.IterationStatement) {
	switch n.Case {
	case cc.IterationStatementWhile: // "while" '(' ExpressionList ')' Statement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.IterationStatementDo: // "do" Statement "while" '(' ExpressionList ')' ';'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.IterationStatementFor: // "for" '(' ExpressionList ';' ExpressionList ';' ExpressionList ')' Statement
		c.iterationStatementFor(n)
	case cc.IterationStatementForDecl: // "for" '(' Declaration ExpressionList ';' ExpressionList ')' Statement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// "for" '(' ExpressionList ';' ExpressionList ';' ExpressionList ')' Statement
func (c *ctx) iterationStatementFor(n *cc.IterationStatement) {
	//	expr1
	// @a
	//	jnz expr2 @b, @z
	// @b
	//	stmt
	//	expr3
	//	goto @a
	// @z
	a := c.label()
	b := c.label()
	z := c.label()
	c.expr(n.ExpressionList, void, nil)
	c.w("%s\n", a)
	e2 := c.expr(n.ExpressionList2, rvalue, n.ExpressionList2.Type())
	c.w("\tjnz %v, %s, %s\n", e2, b, z)
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.expr(n.ExpressionList3, void, nil)
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

func (c *ctx) label() string {
	return fmt.Sprintf("@.%v", c.id())
}

func (c *ctx) blockItemDeclAutomatic(n *cc.BlockItem, id *cc.InitDeclarator) {
	d := id.Declarator
	local := c.fn.registerLocal(d)
	switch {
	case d.AddressTaken():
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		switch {
		case cc.IsScalarType(d.Type()):
			var v int64
			if id.Initializer != nil {
				switch x := id.Initializer.Value().(type) {
				case cc.Int64Value:
					v = int64(x)
				default:
					panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
				}
			}
			switch d.Type().Size() {
			case 4:
				c.w("\t%s =%s copy %v\n", local.renamed, c.typ(d, d.Type()), v)
			default:
				panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
		}
	}
}

func (c *ctx) blockItemDecl(n *cc.BlockItem) {
	for l := n.Declaration.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
		switch d := l.InitDeclarator.Declarator; d.StorageDuration() {
		case cc.Static:
			c.fn.static = append(c.fn.static, l.InitDeclarator)
		case cc.Automatic:
			c.blockItemDeclAutomatic(n, l.InitDeclarator)
		default:
			panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
		}
	}
}

func (c *ctx) blockItem(n *cc.BlockItem) {
	switch n.Case {
	case cc.BlockItemDecl: // Declaration
		c.blockItemDecl(n)
	case cc.BlockItemLabel: // LabelDeclaration
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.BlockItemStmt: // Statement
		c.statement(n.Statement)
	case cc.BlockItemFuncDef: // DeclarationSpecifiers Declarator CompoundStatement
		// c.err(n.Declarator, "nested functions not supported")
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// CompoundStatement:
//	'{' BlockItemList '}'

func (c *ctx) compoundStatement(n *cc.CompoundStatement) {
	c.pos(n.Token)
	for l := n.BlockItemList; l != nil; l = l.BlockItemList {
		c.blockItem(l.BlockItem)
	}
	c.pos(n.Token2)
}
