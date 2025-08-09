// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"math/big"

	"modernc.org/cc/v4"
)

// ExpressionList ';'
func (c *ctx) expressionStatement(n *cc.ExpressionStatement) {
	if n.ExpressionList == nil {
		return
	}

	switch esCtx, t := c.fn.exprStatementCtx, n.ExpressionList.Type(); {
	case esCtx != nil && t.Kind() != cc.Void:
		switch {
		case c.isAggType(t):
			esCtx.expr = c.expr(n.ExpressionList, aggRvalue, t)
			esCtx.typ = t
		default:
			esCtx.expr = c.expr(n.ExpressionList, rvalue, t)
			esCtx.typ = t
		}
	default:
		c.expr(n.ExpressionList, void, nil)
	}
}

// "return" ExpressionList ';'
func (c *ctx) jumpStatementReturn(n *cc.JumpStatement) {
	s := any("")
	switch {
	case c.fn.returns.Kind() != cc.Void:
		switch {
		case n.ExpressionList != nil:
			switch {
			case c.isAggType(c.fn.returns):
				_, info := c.variable(n)
				switch x := info.(type) {
				case *escapedVar:
					s = c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
					p := c.expr(n.ExpressionList, aggRvalue, c.fn.returns)
					c.w("\tblit %s, %s, %v\n", p, s, n.ExpressionList.Type().Size())
				default:
					panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
				}
			default:
				s = c.expr(n.ExpressionList, rvalue, c.fn.returns)
			}
		}
	default:
		switch {
		case n.ExpressionList != nil:
			c.expr(n.ExpressionList, void, c.fn.returns)
		}
	}
	switch {
	case c.fn.inlineStack != nil:
		switch {
		case c.isAggType(c.fn.returns):
			c.w("\t%s =%s copy %s\n", c.fn.inlineStack.returnVar, c.wordTag, s)
		default:
			c.w("\t%s =%s copy %s\n", c.fn.inlineStack.returnVar, c.baseType(n, c.fn.returns), s)
		}
	default:
		c.w("\tret %s\n", s)
		c.w("%s\n", c.label())
	}
}

func (c *ctx) jumpStatement(n *cc.JumpStatement) {
	switch n.Case {
	case cc.JumpStatementGoto: // "goto" IDENTIFIER ';'
		c.w("\tjmp @%s\n", n.Token2.Src())
		c.w("%s\n", c.label())
	case cc.JumpStatementGotoExpr: // "goto" '*' ExpressionList ';'
		c.err(n, "indirect goto statements not supported")
	case cc.JumpStatementContinue: // "continue" ';'
		c.jumpStatementContinue(n)
	case cc.JumpStatementBreak: // "break" ';'
		c.jumpStatementBreak(n)
	case cc.JumpStatementReturn: // "return" ExpressionList ';'
		c.jumpStatementReturn(n)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) statement(n *cc.Statement) {
	switch n.Case {
	case cc.StatementLabeled: // LabeledStatement
		c.labeledStatement(n.LabeledStatement)
	case cc.StatementCompound: // CompoundStatement
		c.compoundStatement(n.CompoundStatement)
	case cc.StatementExpr: // ExpressionStatement
		// c.w("\n# %v: %s\n", n.Position(), cc.NodeSource(n))
		c.expressionStatement(n.ExpressionStatement)
	case cc.StatementSelection: // SelectionStatement
		c.selectionStatement(n.SelectionStatement)
	case cc.StatementIteration: // IterationStatement
		c.iterationStatement(n.IterationStatement)
	case cc.StatementJump: // JumpStatement
		c.jumpStatement(n.JumpStatement)
	case cc.StatementAsm: // AsmStatement
		c.err(n, "assembler statements not supported")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) labeledStatement(n *cc.LabeledStatement) {
	switch n.Case {
	case cc.LabeledStatementLabel: // IDENTIFIER ':' Statement
		c.w("@%s\n", n.Token.Src())
		c.statement(n.Statement)
	case
		cc.LabeledStatementCaseLabel, // "case" ConstantExpression ':' Statement
		cc.LabeledStatementDefault:   // "default" ':' Statement

		c.labeledStatementSwitchLabel(n)
	case cc.LabeledStatementRange: // "case" ConstantExpression "..." ConstantExpression ':' Statement
		c.err(n, "case ranges not supported")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
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
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

/*

switch (expr) {
case 30:
	stmt30; // optional
	break;  // optional
case 10:
	stmt10; // optional
	break;  // optional
default:
	stmtd; // optional
	break; // optional
case 20:
	stmt20; // optional
	break;  // optional
}

# ---------------------------------------------------------------------
	%expr = ...

# [0: default, 1: case 10, 2: case 20, 3: case 30, 4: default]
	%temp =w cslt %expr, 20
	jnz temp, @lt20, @ge20

# [0: default, 1: case 10]
@lt20
	%temp =w ceq %expr, 10
	jnz %temp, @case10, @default

# [case 20, 3: case 30, 4: default]
@ge20
	%temp =w clt %expr, 30
	jnz %temp, @lt30, @ge30

# [case 20]
@lt30
	%temp = ceq %expr, 20
	jnz %temp, @case20, @default

# [case 30, 4: default]
@ge30
	%temp = ceq %expr, 30
	jnz %temp, @case30, @default

# ---------------------------------------------------------------------
@case30
	stmt30;     // optional
	jmp @break; // optional
@x30
	jmp @case10 // fallthrough
# ---------------------------------------------------------------------
@case10
	stmt10;      // optional
	jmp @break;  // optional
@x10
	jmp @default // fallthrough
# ---------------------------------------------------------------------
@default:
	stmtd;      // optional
	jmp @break; // optional
@xdefault
	jmp @case20 // fallthrough
# ---------------------------------------------------------------------
@case20
	stmt20;     // optional
	jmp @break; // optional
@x20
	jmp @break
# ---------------------------------------------------------------------
@break

*/

// "switch" '(' ExpressionList ')' Statement
func (c *ctx) selectionStatementSwitch(n *cc.SelectionStatement) {
	el := n.ExpressionList
	et := el.Type()

	ctx := c.fn.newSwitchCtx(c.expr(el, rvalue, et), et, n.LabeledStatements())
	c.fn.newBreakCtx(c.fn.ctx.label())

	defer func() {
		c.fn.restoreBreakCtx()
		c.fn.switchCtx = c.fn.switchCtx.prev
	}()

	var f func(cases []*switchCase, label, comment string)
	comments := false
	f = func(cases []*switchCase, label, comment string) {
		if label != "" {
			c.w("%s", label)
			if comment != "" && comments {
				c.w("%s", comment)
			}
			c.w("\n")
		}
		m := len(cases) / 2
		partL, partR := cases[:m], cases[m:]
		switch n := len(cases); {
		case n == 2:
			switch {
			case partL[0].isDefault && partR[0].isDefault:
				// [default] [default]
				c.w("\tjmp %s\n", ctx.defaultCase.label)
				c.w("%s\n", c.label())
			case partL[0].isDefault:
				// [default] [case x]
				t := c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partR[0].val0)
				c.w("\tjnz %s, %s, %s\n", t, partR[0].label, partL[0].label)
				c.w("%s\n", c.label())
			case partR[0].isDefault:
				// [case x] [default]
				t := c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partL[0].val0)
				c.w("\tjnz %s, %s, %s\n", t, partL[0].label, partR[0].label)
				c.w("%s\n", c.label())
			default:
				//  [case x] [case y]
				t := c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partL[0].val0)
				labelR := c.label()
				c.w("\tjnz %s, %s, %s\n", t, partL[0].label, labelR)
				c.w("%s\n", labelR)
				t = c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partR[0].val0)
				c.w("\tjnz %s, %s, %s\n", t, partR[0].label, ctx.defaultCase.label)
				c.w("%s\n", c.label())
			}
		case n == 3:
			switch {
			case partL[0].isDefault:
				// [default] [case x, case y]
				t := c.temp("w c%slt%s %s, %v\n", ctx.sign, ctx.suff, ctx.expr, partR[0].val0)
				labelR := c.label()
				c.w("\tjnz %s, %s, %s\n", t, ctx.defaultCase.label, labelR)
				c.w("%s\n", c.label())
				f(partR, labelR, fmt.Sprintf(" # %s >= %v", ctx.expr, partR[0].val0))
			case partR[1].isDefault:
				// [case x] [case y, default]
				t := c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partL[0].val0)
				labelR := c.label()
				c.w("\tjnz %s, %s, %s\n", t, partL[0].label, labelR)
				c.w("%s\n", c.label())
				f(partR, labelR, fmt.Sprintf(" # %s > %v", ctx.expr, partL[0].val0))
			default:
				// [case x] [case y,  case z]
				t := c.temp("w ceq%s %s, %v\n", ctx.suff, ctx.expr, partL[0].val0)
				labelR := c.label()
				c.w("\tjnz %s, %s, %s\n", t, partL[0].label, labelR)
				c.w("%s\n", c.label())
				f(partR, labelR, fmt.Sprintf(" # %s > %v", ctx.expr, partL[0].val0))
			}
		case n > 3:
			t := c.temp("w c%slt%s %s, %v\n", ctx.sign, ctx.suff, ctx.expr, partR[0].val0)
			labelL, labelR := c.label(), c.label()
			c.w("\tjnz %s, %s, %s\n", t, labelL, labelR)
			f(partL, labelL, fmt.Sprintf(" # %s < %v", ctx.expr, partR[0].val0))
			f(partR, labelR, fmt.Sprintf(" # %s >= %v", ctx.expr, partR[0].val0))
		}
	}
	f(ctx.cases, "", "")
	c.statement(n.Statement)
	if ctx.defaultCase.LabeledStatement == nil {
		c.w("%s\n\tjmp %s\n", ctx.cases[0].label, c.fn.breakCtx.label)
		c.w("%s\n", c.label())
	}
	c.w("%s\n", c.fn.breakCtx.label)
}

// "case" ConstantExpression ':' Statement
func (c *ctx) labeledStatementSwitchLabel(n *cc.LabeledStatement) {
	ctx := c.fn.switchCtx
	cs := ctx.cases[ctx.case2index[n]]
	c.w("%s\n\tjmp %s\n", c.label(), cs.label)
	c.w("%s\n", cs.label)
	c.statement(n.Statement)
}

func (c *ctx) jumpStatementBreak(n *cc.JumpStatement) {
	c.w("%s\n\tjmp %s\n", c.label(), c.fn.breakCtx.label)
	c.w("%s\n", c.label())
}

func (c *ctx) jumpStatementContinue(n *cc.JumpStatement) {
	c.w("%s\n\tjmp %s\n", c.label(), c.fn.continueCtx.label)
	c.w("%s\n", c.label())
}

func (c *ctx) isZero(n cc.ExpressionNode) (r bool) {
	switch x := n.Value().(type) {
	case *cc.UnknownValue:
		return false
	case cc.Int64Value:
		return x == 0
	case cc.UInt64Value:
		return x == 0
	case cc.Float64Value:
		return x == 0
	case *cc.LongDoubleValue:
		return (*big.Float)(x).Sign() == 0
	default:
		return false
	}
}

func (c *ctx) isNonzero(n cc.ExpressionNode) (r bool) {
	switch x := n.Value().(type) {
	case *cc.UnknownValue:
		return false
	case cc.Int64Value:
		return x != 0
	case cc.UInt64Value:
		return x != 0
	case cc.Float64Value:
		return x != 0
	case *cc.LongDoubleValue:
		return (*big.Float)(x).Sign() != 0
	default:
		return false
	}
}

// "if" '(' ExpressionList ')' Statement
func (c *ctx) selectionStatementIf(n *cc.SelectionStatement) {
	a := c.label()
	z := c.label()
	//	jnz expr @a, @z
	// @a
	//	stmt
	// @z
	e := c.bool(n.ExpressionList)
	switch {
	case c.isZero(n.ExpressionList):
		c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
		c.w("\tjmp %s\n", z)
		c.w("%s\n", c.label())
		c.statement(n.Statement)
		c.w("%s\n", z)
	case c.isNonzero(n.ExpressionList):
		c.statement(n.Statement)
	default:
		c.w("\tjnz %v, %s, %s\n", e, a, z)
		c.w("%s\n", a)
		c.statement(n.Statement)
		c.w("%s\n", z)
	}
}

// "if" '(' ExpressionList ')' Statement "else" Statement
func (c *ctx) selectionStatementIfElse(n *cc.SelectionStatement) {
	a := c.label()
	b := c.label()
	z := c.label()
	//	jnz expr @a, @b
	// @a
	//	stmt
	//	jmp @z
	// @b
	//	stmt2
	// @z
	e := c.bool(n.ExpressionList)
	switch {
	case c.isZero(n.ExpressionList):
		c.w("\tjmp %s\n", b)
		c.w("%s\n", a)
		c.statement(n.Statement)
		c.w("%s\n", c.label())
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		c.statement(n.Statement2)
		c.w("%s\n", z)
	case c.isNonzero(n.ExpressionList):
		c.statement(n.Statement)
		c.w("%s\n", c.label())
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		c.statement(n.Statement2)
		c.w("%s\n", z)
	default:
		c.w("\tjnz %v, %s, %s\n", e, a, b)
		c.w("%s\n", a)
		c.statement(n.Statement)
		c.w("%s\n", c.label())
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		c.statement(n.Statement2)
		c.w("%s\n", z)
	}
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
		c.iterationStatementForDecl(n)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

// "do" Statement "while" '(' ExpressionList ')' ';'
func (c *ctx) iterationStatementDo(n *cc.IterationStatement) {
	a := c.label()
	cont := c.fn.newContinueCtx(c.label())
	z := c.fn.newBreakCtx(c.label())
	// @a
	//	stmt
	// @cont
	//	jnz expr @a, @z
	// @z

	defer c.fn.restoreBreakCtx()
	defer c.fn.restoreContinueCtx()

	c.w("%s\n", a)
	c.statement(n.Statement)
	c.w("%s\n", cont)
	e := c.bool(n.ExpressionList)
	switch {
	case c.isZero(n.ExpressionList):
		c.w("\tjmp %s\n", z)
	case c.isNonzero(n.ExpressionList):
		c.w("\tjmp %s\n", a)
	default:
		c.w("\tjnz %v, %s, %s\n", e, a, z)
	}
	c.w("%s\n", z)
}

// "while" '(' ExpressionList ')' Statement
func (c *ctx) iterationStatementWhile(n *cc.IterationStatement) {
	a := c.fn.newContinueCtx(c.label())
	b := c.label()
	z := c.fn.newBreakCtx(c.label())
	// @a
	//	jnz expr @b, @z
	// @b
	//	stmt
	//	jmp @a
	// @z

	defer c.fn.restoreBreakCtx()
	defer c.fn.restoreContinueCtx()

	c.w("%s\n", a)
	e := c.bool(n.ExpressionList)
	switch {
	case c.isZero(n.ExpressionList):
		c.w("\tjmp %s\n", z)
	case c.isNonzero(n.ExpressionList):
		// nop
	default:
		c.w("\tjnz %v, %s, %s\n", e, b, z)
	}
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.w("%s\n", c.label())
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

// "for" '(' Declaration ExpressionList ';' ExpressionList ')' Statement
func (c *ctx) iterationStatementForDecl(n *cc.IterationStatement) {
	a := c.label()
	b := c.label()
	cont := c.fn.newContinueCtx(c.label())
	z := c.fn.newBreakCtx(c.label())
	//	decl
	// @a
	//	jnz expr @b, @z
	// @b
	//	stmt
	// @cont
	//	expr2
	//	jmp @a
	// @z

	defer c.fn.restoreBreakCtx()
	defer c.fn.restoreContinueCtx()

	c.blockItemDecl(n.Declaration)
	c.w("%s\n", a)
	if n.ExpressionList != nil {
		e2 := c.bool(n.ExpressionList)
		switch {
		case c.isZero(n.ExpressionList):
			c.w("\tjmp %s\n", z)
		case c.isNonzero(n.ExpressionList):
			// nop
		default:
			c.w("\tjnz %v, %s, %s\n", e2, b, z)
		}
	}
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.w("%s\n", cont)
	c.expr(n.ExpressionList2, void, nil)
	c.w("%s\n", c.label())
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

// "for" '(' ExpressionList ';' ExpressionList ';' ExpressionList ')' Statement
func (c *ctx) iterationStatementFor(n *cc.IterationStatement) {
	a := c.label()
	b := c.label()
	cont := c.fn.newContinueCtx(c.label())
	z := c.fn.newBreakCtx(c.label())
	//	expr1
	// @a
	//	jnz expr2 @b, @z
	// @b
	//	stmt
	// @cont
	//	expr3
	//	jmp @a
	// @z

	defer c.fn.restoreBreakCtx()
	defer c.fn.restoreContinueCtx()

	c.expr(n.ExpressionList, void, nil)
	c.w("%s\n", a)
	if n.ExpressionList2 != nil {
		e2 := c.bool(n.ExpressionList2)
		switch {
		case c.isZero(n.ExpressionList2):
			c.w("\tjmp %s\n", z)
		case c.isNonzero(n.ExpressionList2):
			// nop
		default:
			c.w("\tjnz %v, %s, %s\n", e2, b, z)
		}
	}
	c.w("%s\n", b)
	c.statement(n.Statement)
	c.w("%s\n", cont)
	c.expr(n.ExpressionList3, void, nil)
	c.w("%s\n", c.label())
	c.w("\tjmp %s\n", a)
	c.w("%s\n", z)
}

func (c *ctx) label() string {
	return fmt.Sprintf("@.%v", c.id())
}

func (c *ctx) blockItemDeclAutomatic(n *cc.InitDeclarator) {
	if n.Asm != nil {
		c.err(n, "assembler statements not supported")
		return
	}

	_, info := c.variable(n.Declarator)
	switch n.Case {
	case cc.InitDeclaratorDecl: // Declarator Asm
		c.declare(n, info)
	case cc.InitDeclaratorInit: // Declarator Asm '=' Initializer
		c.initializer(n.Initializer, info, n.Declarator.Type())
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

// Declaration
func (c *ctx) blockItemDecl(n *cc.Declaration) {
	// c.w("\n# %v: %s\n", n.Position(), cc.NodeSource(n))
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		for l := n.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
			switch l.InitDeclarator.Declarator.StorageDuration() {
			case cc.Static:
				if l.InitDeclarator.Declarator.IsExtern() {
					break
				}

				if l.InitDeclarator.Declarator.Type().Kind() != cc.Function {
					c.fn.static = append(c.fn.static, l.InitDeclarator)
				}
			case cc.Automatic:
				c.blockItemDeclAutomatic(l.InitDeclarator)
			default:
				panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
			}
		}
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		switch n.Declarator.StorageDuration() {
		case cc.Automatic:
			_, info := c.variable(n.Declarator)
			c.initializer(n.Initializer, info, n.Declarator.Type())
		default:
			trc("%v: %v %s", n.Position(), n.Declarator.StorageDuration(), cc.NodeSource(n))
			panic(todo("%v: %v %s", n.Position(), n.Declarator.StorageDuration(), cc.NodeSource(n)))
		}
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) blockItem(n *cc.BlockItem) {
	switch n.Case {
	case cc.BlockItemDecl: // Declaration
		c.blockItemDecl(n.Declaration)
	case cc.BlockItemLabel: // LabelDeclaration
		c.err(n, "label declarations not supported")
	case cc.BlockItemStmt: // Statement
		c.statement(n.Statement)
	case cc.BlockItemFuncDef: // DeclarationSpecifiers Declarator CompoundStatement
		c.err(n, "nested functions not supported")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
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
