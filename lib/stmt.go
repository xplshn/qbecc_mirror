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

func (c *ctx) jumpStatementBreak(n *cc.JumpStatement) {
	c.w("%s\n\tjmp %s\n", c.label(), c.fn.breakCtx.label)
}

func (c *ctx) jumpStatement(n *cc.JumpStatement) {
	switch n.Case {
	case cc.JumpStatementGoto: // "goto" IDENTIFIER ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementGotoExpr: // "goto" '*' ExpressionList ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementContinue: // "continue" ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.JumpStatementBreak: // "break" ';'
		c.jumpStatementBreak(n)
	case cc.JumpStatementReturn: // "return" ExpressionList ';'
		c.jumpStatementReturn(n)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) statement(n *cc.Statement) {
	switch n.Case {
	case cc.StatementLabeled: // LabeledStatement
		c.labeledStatement(n.LabeledStatement)
	case cc.StatementCompound: // CompoundStatement
		c.compoundStatement(n.CompoundStatement)
	case cc.StatementExpr: // ExpressionStatement
		c.expressionStatement(n.ExpressionStatement)
	case cc.StatementSelection: // SelectionStatement
		c.selectionStatement(n.SelectionStatement)
	case cc.StatementIteration: // IterationStatement
		c.iterationStatement(n.IterationStatement)
	case cc.StatementJump: // JumpStatement
		c.jumpStatement(n.JumpStatement)
	case cc.StatementAsm: // AsmStatement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) labeledStatement(n *cc.LabeledStatement) {
	switch n.Case {
	case cc.LabeledStatementLabel: // IDENTIFIER ':' Statement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.LabeledStatementCaseLabel: // "case" ConstantExpression ':' Statement
		c.labeledStatementCaseLabel(n)
	case cc.LabeledStatementRange: // "case" ConstantExpression "..." ConstantExpression ':' Statement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.LabeledStatementDefault: // "default" ':' Statement
		c.labeledStatementDefault(n)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// "default" ':' Statement
func (c *ctx) labeledStatementDefault(n *cc.LabeledStatement) {
	// @a
	//	jmp @next
	// @d:
	//	stmt
	// @e
	//	jmp @switchBreak
	// @next
	if next := c.fn.switchCtx.nextCase; next != "" {
		c.w("%s\n", next)
	}
	a := c.label()
	d := c.label()
	e := c.label()
	next := c.label()
	c.fn.switchCtx.dflt = d
	c.w("%s\n\tjmp %s\n", a, next)
	c.w("%s\n", d)
	c.statement(n.Statement)
	c.w("%s\n\tjmp %s\n", e, c.fn.breakCtx.label)
	c.fn.switchCtx.nextCase = next
}

// "case" ConstantExpression ':' Statement
func (c *ctx) labeledStatementCaseLabel(n *cc.LabeledStatement) {
	//TODO generate jump tables

	//	jnz constExpr == switchExpr, @a, @next
	// @a
	//	stmt
	// @next
	if next := c.fn.switchCtx.nextCase; next != "" {
		c.w("%s\n", next)
	}
	a := c.label()
	next := c.label()
	c.fn.switchCtx.nextCase = next
	test := c.temp("w ceq%s %s, %v\n", c.baseType(n, c.fn.switchCtx.typ), c.fn.switchCtx.expr, c.expr(n.ConstantExpression, rvalue, c.fn.switchCtx.typ))
	c.w("\tjnz %s, %s, %s\n", test, a, next)
	c.w("%s\n", a)
	c.statement(n.Statement)
}

func (c *ctx) selectionStatement(n *cc.SelectionStatement) {
	switch n.Case {
	case cc.SelectionStatementIf: // "if" '(' ExpressionList ')' Statement
		c.selectionStatementIf(n)
	case cc.SelectionStatementIfElse: // "if" '(' ExpressionList ')' Statement "else" Statement
		c.selectionStatementIfElse(n)
	case cc.SelectionStatementSwitch: // "switch" '(' ExpressionList ')' Statement
		c.selectionStatementSwitch(n)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// "switch" '(' ExpressionList ')' Statement
func (c *ctx) selectionStatementSwitch(n *cc.SelectionStatement) {
	el := n.ExpressionList
	et := el.Type()
	defer c.fn.newSwitchCtx(c.expr(el, rvalue, et), et)()
	c.statement(n.Statement)
	if next := c.fn.switchCtx.nextCase; next != "" {
		c.w("%s\n", next)
	}
	if d := c.fn.switchCtx.dflt; d != "" {
		c.w("%s\n\tjmp %s\n", c.label(), d)
	}
	c.w("%s\n", c.fn.breakCtx.label)
}

// "if" '(' ExpressionList ')' Statement
func (c *ctx) selectionStatementIf(n *cc.SelectionStatement) {
	//	jnz expr @a, @z
	// @a
	//	stmt
	// @z
	a := c.label()
	z := c.label()
	e := c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
	c.w("\tjnz %v, %s, %s\n", e, a, z)
	c.w("%s\n", a)
	c.statement(n.Statement)
	c.w("%s\n", z)
}

// "if" '(' ExpressionList ')' Statement "else" Statement
func (c *ctx) selectionStatementIfElse(n *cc.SelectionStatement) {
	//	jnz expr @a, @b
	// @a
	//	stmt
	// @x
	//	jmp @z
	// @b
	//	stmt2
	// @z
	a := c.label()
	x := c.label()
	b := c.label()
	z := c.label()
	e := c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
	c.w("\tjnz %v, %s, %s\n", e, a, b)
	c.w("%s\n", a)
	c.statement(n.Statement)
	c.w("%s\n", x)
	c.w("\tjmp %s\n", z)
	c.w("%s\n", b)
	c.statement(n.Statement2)
	c.w("%s\n", z)
}

func (c *ctx) iterationStatement(n *cc.IterationStatement) {
	switch n.Case {
	case cc.IterationStatementWhile: // "while" '(' ExpressionList ')' Statement
		c.iterationStatementWhile(n)
	case cc.IterationStatementDo: // "do" Statement "while" '(' ExpressionList ')' ';'
		c.iterationStatementDo(n)
	case cc.IterationStatementFor: // "for" '(' ExpressionList ';' ExpressionList ';' ExpressionList ')' Statement
		c.iterationStatementFor(n)
	case cc.IterationStatementForDecl: // "for" '(' Declaration ExpressionList ';' ExpressionList ')' Statement
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// "do" Statement "while" '(' ExpressionList ')' ';'
func (c *ctx) iterationStatementDo(n *cc.IterationStatement) {
	// @a
	//	stmt
	//	jnz expr @a, @z
	// @z
	a := c.label()
	z := c.label()

	defer c.fn.newBreakCtx(z)()

	c.w("%s\n", a)
	c.statement(n.Statement)
	e := c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
	c.w("\tjnz %v, %s, %s\n", e, a, z)
	c.w("%s\n", z)
}

// "while" '(' ExpressionList ')' Statement
func (c *ctx) iterationStatementWhile(n *cc.IterationStatement) {
	// @a
	//	jnz expr @b, @z
	// @b
	//	stmt
	// @x
	//	jmp @a
	// @z
	a := c.label()
	b := c.label()
	x := c.label()
	z := c.label()

	defer c.fn.newBreakCtx(z)()

	c.w("%s\n", a)
	e := c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
	c.w("\tjnz %v, %s, %s\n", e, b, z)
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.w("%s\n", x)
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

// "for" '(' ExpressionList ';' ExpressionList ';' ExpressionList ')' Statement
func (c *ctx) iterationStatementFor(n *cc.IterationStatement) {
	//	expr1
	// @a
	//	jnz expr2 @b, @z
	// @b
	//	stmt
	//	expr3
	// @x
	//	jmp @a
	// @z
	a := c.label()
	b := c.label()
	x := c.label()
	z := c.label()
	c.expr(n.ExpressionList, void, nil)
	c.w("%s\n", a)
	e2 := c.expr(n.ExpressionList2, rvalue, n.ExpressionList2.Type())
	c.w("\tjnz %v, %s, %s\n", e2, b, z)
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.expr(n.ExpressionList3, void, nil)
	c.w("%s\n", x)
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

func (c *ctx) label() string {
	return fmt.Sprintf("@.%v", c.id())
}

func (c *ctx) blockItemDeclAutomatic(n *cc.BlockItem, id *cc.InitDeclarator) {
	d, info := c.fn.info(id.Declarator)
	switch x := info.(type) {
	case *local:
		c.w("\t%s =%s copy %s\n", x.name, c.baseType(d, d.Type()), c.initializer(id.Initializer, d.Type()))
	case *escaped:
		if id.Initializer != nil {
			p := c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
			switch {
			case c.isIntegerType(d.Type()) || c.isFloatingPointType(d.Type()):
				v := c.initializer(id.Initializer, d.Type())
				c.w("\tstore%s %s, %s\n", c.extType(d, d.Type()), v, p)
			default:
				panic(todo("%v: %T", n.Position(), x))
			}
		}
	default:
		panic(todo("%v: %T", n.Position(), x))
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
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
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
