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
)

func (c *ctx) expr(n cc.ExpressionNode, mode int, t cc.Type) (r string) {
	switch x := n.(type) {
	case *cc.AssignmentExpression:
		return c.assignmentExpression(x, mode, t)
	case *cc.PostfixExpression:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	case *cc.PrimaryExpression:
		return c.primaryExpression(x, mode, t)
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpression(n *cc.AssignmentExpression, mode int, t cc.Type) (r string) {
	switch n.Case {
	case cc.AssignmentExpressionCond: // ConditionalExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AssignmentExpressionAssign: // UnaryExpression '=' AssignmentExpression
		rhs := c.expr(n.AssignmentExpression, rvalue, n.UnaryExpression.Type())
		lhs := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
		c.w("\t%s =%s copy %s\n", lhs, c.typ(n, n.UnaryExpression.Type()), rhs)
		switch mode {
		case void:
			return ""
		default:
			panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
		}
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

func (c *ctx) primaryExpression(n *cc.PrimaryExpression, mode int, t cc.Type) (r string) {
	switch n.Case {
	case cc.PrimaryExpressionIdent: // IDENTIFIER
		switch x := n.ResolvedTo().(type) {
		case *cc.Declarator:
			switch x.StorageDuration() {
			case cc.Automatic:
				local := c.fn.locals[x]
				switch {
				case local.isValue:
					return local.renamed
				default:
					panic(todo("%v: %s %v", n.Position(), x.StorageDuration(), cc.NodeSource(n)))
				}
			default:
				panic(todo("%v: %s %v", n.Position(), x.StorageDuration(), cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: x=%T %v", n.Position(), x, cc.NodeSource(n)))
		}
	case cc.PrimaryExpressionInt: // INTCONST
		switch t.Kind() {
		case cc.Int:
			return fmt.Sprint(n.Value())
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	case cc.PrimaryExpressionFloat: // FLOATCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionChar: // CHARCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionLChar: // LONGCHARCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionString: // STRINGLITERAL
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
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
