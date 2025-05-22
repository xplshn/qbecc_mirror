// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

const (
	void = iota
	lvalue
	rvalue
	call
)

func (c *ctx) assignmentExpressionAssign(n *cc.AssignmentExpression, mode int, t cc.Type) (r string) {
	rhs := c.expr(n.AssignmentExpression, rvalue, n.UnaryExpression.Type())
	lhs := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
	c.w("\t%s =%s copy %s\n", lhs, c.typ(n, n.UnaryExpression.Type()), rhs)
	switch mode {
	case void:
		return ""
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpression(n *cc.AssignmentExpression, mode int, t cc.Type) (r string) {
	switch n.Case {
	case cc.AssignmentExpressionCond: // ConditionalExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionAssign: // UnaryExpression '=' AssignmentExpression
		return c.assignmentExpressionAssign(n, mode, t)
	case cc.AssignmentExpressionMul: // UnaryExpression "*=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionDiv: // UnaryExpression "/=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionMod: // UnaryExpression "%=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionAdd: // UnaryExpression "+=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionSub: // UnaryExpression "-=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionLsh: // UnaryExpression "<<=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionRsh: // UnaryExpression ">>=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionAnd: // UnaryExpression "&=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionXor: // UnaryExpression "^=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionOr: // UnaryExpression "|=" AssignmentExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) ft(n cc.ExpressionNode) (r *cc.FunctionType) {
	switch x := n.Type().(type) {
	case *cc.PointerType:
		switch x := x.Elem().(type) {
		case *cc.FunctionType:
			return x
		default:
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	case *cc.FunctionType:
		return x
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionIdent(n *cc.PrimaryExpression, mode int, t cc.Type) (r string) {
	switch x := n.ResolvedTo().(type) {
	case *cc.Declarator:
		switch x.StorageDuration() {
		case cc.Automatic:
			local := c.fn.locals[x]
			switch mode {
			case lvalue, rvalue:
				switch {
				case local.isValue:
					return local.renamed
				default:
					panic(todo("%v: %s %v", n.Position(), x.StorageDuration(), cc.NodeSource(n)))
				}
			default:
				panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
			}
		case cc.Static:
			switch x.Linkage() {
			case cc.External:
				switch mode {
				case call:
					return fmt.Sprintf("$%s", x.Name())
				default:
					panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
				}
			default:
				panic(todo("%v: %v %v", n.Position(), x.Linkage(), cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %s %v", n.Position(), x.StorageDuration(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: x=%T %v", n.Position(), x, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionInt(n *cc.PrimaryExpression, mode int, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch t.Kind() {
		case cc.Int:
			return fmt.Sprint(n.Value())
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionString(n *cc.PrimaryExpression, mode int, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch t.Kind() {
		case cc.Ptr:
			switch e := t.(*cc.PointerType).Elem().Kind(); e {
			case cc.Char:
				return c.addString(string(n.Value().(cc.StringValue)))
			default:
				panic(todo("%v: e=%s %v", n.Position(), e, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpression(n *cc.PrimaryExpression, mode int, t cc.Type) (r string) {
	switch n.Case {
	case cc.PrimaryExpressionIdent: // IDENTIFIER
		return c.primaryExpressionIdent(n, mode, t)
	case cc.PrimaryExpressionInt: // INTCONST
		return c.primaryExpressionInt(n, mode, t)
	case cc.PrimaryExpressionFloat: // FLOATCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionChar: // CHARCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionLChar: // LONGCHARCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionString: // STRINGLITERAL
		return c.primaryExpressionString(n, mode, t)
	case cc.PrimaryExpressionLString: // LONGSTRINGLITERAL
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionStmt: // '(' CompoundStatement ')'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionGeneric: // GenericSelection
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) postfixExpressionCall(n *cc.PostfixExpression, mode int, t cc.Type) (r string) {
	callee := n.PostfixExpression
	ct := c.ft(callee)
	params := ct.Parameters()
	var args []cc.ExpressionNode
	var exprs []string
	var types []cc.Type
	for l := n.ArgumentExpressionList; l != nil; l = l.ArgumentExpressionList {
		e := l.AssignmentExpression
		args = append(args, e)
		et := e.Type()
		switch {
		case len(exprs) < len(params):
			et = params[len(exprs)].Type()
		default:
			et = cc.IntegerPromotion(et)
		}
		exprs = append(exprs, c.expr(e, rvalue, et))
		types = append(types, et)
	}
	c.w("\tcall %s(", c.expr(callee, call, ct))
	for i, expr := range exprs {
		if i == len(params) {
			c.w("...,")
		}
		c.w("%s %s,", c.typ(args[i], types[i]), expr)
	}
	c.w(")\n")
	return "" //TODO-
	panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
}

func (c *ctx) postfixExpression(n *cc.PostfixExpression, mode int, t cc.Type) (r string) {
	switch n.Case {
	case cc.PostfixExpressionPrimary: // PrimaryExpression
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionIndex: // PostfixExpression '[' ExpressionList ']'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionCall: // PostfixExpression '(' ArgumentExpressionList ')'
		return c.postfixExpressionCall(n, mode, t)
	case cc.PostfixExpressionSelect: // PostfixExpression '.' IDENTIFIER
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionPSelect: // PostfixExpression "->" IDENTIFIER
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionInc: // PostfixExpression "++"
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionDec: // PostfixExpression "--"
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionComplit: // '(' TypeName ')' '{' InitializerList ',' '}'
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) expr(n cc.ExpressionNode, mode int, t cc.Type) (r string) {
	switch x := n.(type) {
	case *cc.AssignmentExpression:
		return c.assignmentExpression(x, mode, t)
	case *cc.PostfixExpression:
		return c.postfixExpression(x, mode, t)
	case *cc.PrimaryExpression:
		return c.primaryExpression(x, mode, t)
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
