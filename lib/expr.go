// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

type mode int

const (
	void mode = iota
	lvalue
	rvalue
	call
)

const nothing = "<void>"

func (c *ctx) convertRValue(n cc.Node, dst, src cc.Type, v string) (r string) {
	switch {
	case dst == src:
		return v
	case dst.Kind() == src.Kind():
		switch dst.Kind() {
		case
			cc.Ptr,
			cc.Int, cc.UInt,
			cc.Char, cc.SChar, cc.UChar,
			cc.Short, cc.UShort,
			cc.Long, cc.ULong,
			cc.LongLong, cc.ULongLong:

			return v
		default:
			panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dst, dst.Kind(), dst.Size(), src, src.Kind(), src.Size(), cc.NodeSource(n)))
		}
	case dst.Kind() == cc.Ptr && cc.IsIntegerType(src):
		switch src.Size() {
		case 4:
			if dst.Size() == 4 {
				return v
			}

			r = c.temp()
			switch {
			case cc.IsSignedInteger(src):
				c.w("\t%s =%s extsw %s\n", r, c.wordTag, v)
			default:
				c.w("\t%s =%s extuw %s\n", r, c.wordTag, v)
			}
			return r
		case 8:
			return v
		default:
			panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dst, dst.Kind(), dst.Size(), src, src.Kind(), src.Size(), cc.NodeSource(n)))
		}
	case dst.Kind() == cc.Enum && cc.IsIntegerType(src):
		if dst.Size() == src.Size() {
			return v
		}

		panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dst, dst.Kind(), dst.Size(), src, src.Kind(), src.Size(), cc.NodeSource(n)))
	default:
		panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dst, dst.Kind(), dst.Size(), src, src.Kind(), src.Size(), cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpressionAssign(n *cc.AssignmentExpression, mode mode, t cc.Type) (r string) {
	lhs := c.expr(n.UnaryExpression, lvalue, n.Type())
	rhs := c.expr(n.AssignmentExpression, rvalue, n.Type())
	d := c.declaratorOf(n.UnaryExpression)
	local := c.fn.locals[d]
	switch {
	case local != nil:
		switch {
		case local.isStatic:
			panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
		case local.isValue:
			c.w("\t%s =%s copy %s\n", lhs, c.typ(n, n.Type()), rhs)
		default:
			switch n.Type().Size() {
			case 4, 8:
				c.w("\tstore%s %s, %s\n", c.typ(n, n.Type()), rhs, lhs)
			default:
				panic(todo("%v: %v %v", n.Position(), n.Type().Size(), cc.NodeSource(n)))
			}
		}
	default:
		switch n.Type().Size() {
		case 4, 8:
			c.w("\tstore%s %s, %s\n", c.typ(n, n.Type()), rhs, lhs)
		default:
			panic(todo("%v: %v %v", n.Position(), n.Type().Size(), cc.NodeSource(n)))
		}
	}
	switch mode {
	case void:
		return nothing
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		switch {
		case local != nil:
			return local.renamed
		default:
			panic(todo("%v: %v %v", n.Position(), n.Type().Size(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpression(n *cc.AssignmentExpression, mode mode, t cc.Type) (r string) {
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
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
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

func (c *ctx) primaryExpressionIdent(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case lvalue:
		switch x := n.ResolvedTo().(type) {
		case *cc.Declarator:
			switch local := c.fn.locals[x]; {
			case local != nil:
				switch {
				case local.isStatic:
					panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
				case local.isValue:
					return local.renamed
				default:
					r = c.temp()
					c.w("\t%s =%s add %%.bp., %v\n", r, c.wordTag, local.offset)
				}
			default:
				r = c.temp()
				c.w("\t%s =%s copy $%s\n", r, c.wordTag, x.Name())
			}
		default:
			panic(todo("%v: x=%T %v", n.Position(), x, cc.NodeSource(n)))
		}
		return r
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		switch x := n.ResolvedTo().(type) {
		case *cc.Declarator:
			switch local := c.fn.locals[x]; {
			case local != nil:
				switch {
				case local.isStatic:
					panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
				case local.isValue:
					r = c.temp()
					c.w("\t%s =%s copy %s\n", r, c.typ(n, x.Type()), local.renamed)
				default:
					panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
				}
			default:
				switch x.Type().Kind() {
				case cc.Function:
					r = c.temp()
					c.w("\t%s =%s copy $%s\n", r, c.wordTag, x.Name())
					t = c.ast.PVoid
				default:
					panic(todo("%v: %v %v %v", n.Position(), x.Type(), x.Type().Kind(), cc.NodeSource(n)))
				}
			}
		case *cc.Enumerator:
			switch y := x.Value().(type) {
			case cc.Int64Value:
				return fmt.Sprint(int64(y))
			default:
				panic(todo("%v: %T %v", n.Position(), y, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
		}
		return r
	case call:
		switch x := n.ResolvedTo().(type) {
		case *cc.Declarator:
			switch local := c.fn.locals[x]; {
			case local != nil:
				panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
			default:
				switch x.StorageDuration() {
				case cc.Static:
					return fmt.Sprintf("$%s", x.Name())
				default:
					panic(todo("%v: %v %v", n.Position(), x.StorageDuration(), cc.NodeSource(n)))
				}
			}
		default:
			panic(todo("%v: x=%T %v", n.Position(), x, cc.NodeSource(n)))
		}
		return r
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionInt(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch t.Kind() {
		case cc.Int, cc.Ptr, cc.Enum:
			return c.convertRValue(n, t, n.Type(), fmt.Sprint(n.Value()))
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionString(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch t.Kind() {
		case cc.Ptr:
			switch e := t.(*cc.PointerType).Elem().Kind(); e {
			case cc.Char:
				return c.convertRValue(n, t, n.Type(), c.addString(string(n.Value().(cc.StringValue))))
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

func (c *ctx) primaryExpressionChar(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch {
		case cc.IsIntegerType(t):
			return c.convertRValue(n, t, n.Type(), fmt.Sprint(n.Value()))
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpression(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.PrimaryExpressionIdent: // IDENTIFIER
		return c.primaryExpressionIdent(n, mode, t)
	case cc.PrimaryExpressionInt: // INTCONST
		return c.primaryExpressionInt(n, mode, t)
	case cc.PrimaryExpressionFloat: // FLOATCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionChar: // CHARCONST
		return c.primaryExpressionChar(n, mode, t)
	case cc.PrimaryExpressionLChar: // LONGCHARCONST
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionString: // STRINGLITERAL
		return c.primaryExpressionString(n, mode, t)
	case cc.PrimaryExpressionLString: // LONGSTRINGLITERAL
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
		return c.expr(n.ExpressionList, mode, t)
	case cc.PrimaryExpressionStmt: // '(' CompoundStatement ')'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionGeneric: // GenericSelection
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) postfixExpressionCall(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
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
	r = nothing
	switch mode {
	case void:
		c.w("\tcall %s(", c.expr(callee, call, ct))
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		r = c.temp()
		switch {
		case cc.IsScalarType(n.Type()):
			switch n.Type().Size() {
			case 4, 8:
				c.w("\t%s =%s call %s(", r, c.typ(n, n.Type()), c.expr(callee, call, ct))
			default:
				panic(todo("%v: %v %s", n.Position(), n.Type().Size(), cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	for i, expr := range exprs {
		if i == len(params) {
			c.w("...,")
		}
		c.w("%s %s,", c.typ(args[i], types[i]), expr)
	}
	c.w(")\n")
	return r
}

func (c *ctx) unparen(n cc.ExpressionNode) cc.ExpressionNode {
	for {
		switch x := n.(type) {
		case *cc.ExpressionList:
			if x.ExpressionList == nil {
				n = x.AssignmentExpression
				continue
			}
		case *cc.PrimaryExpression:
			if x.Case == cc.PrimaryExpressionExpr {
				n = x.ExpressionList
				continue
			}
		}

		return n
	}
}

func (c *ctx) declaratorOf(n cc.ExpressionNode) (r *cc.Declarator) {
	for n != nil {
		n = c.unparen(n)
		switch x := n.(type) {
		case *cc.PrimaryExpression:
			switch x.Case {
			case cc.PrimaryExpressionIdent: // IDENTIFIER
				switch y := x.ResolvedTo().(type) {
				case *cc.Declarator:
					return y
				case *cc.Parameter:
					return y.Declarator
				case *cc.Enumerator, nil:
					return nil
				default:
					panic(todo("%v: %s %s", n.Position(), x.Case, cc.NodeSource(n)))
				}
			case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
				n = x.ExpressionList
			default:
				return nil
			}
		case *cc.PostfixExpression:
			switch x.Case {
			case cc.PostfixExpressionPrimary: // PrimaryExpression
				n = x.PrimaryExpression
			case cc.PostfixExpressionSelect:
				n = x.PostfixExpression
			case cc.PostfixExpressionPSelect:
				n = x.PostfixExpression
			case cc.PostfixExpressionIndex:
				n = x.PostfixExpression
			default:
				return nil
			}
		case *cc.ExpressionList:
			if x == nil {
				return nil
			}

			for l := x; l != nil; l = l.ExpressionList {
				n = l.AssignmentExpression
			}
		case *cc.CastExpression:
			switch x.Case {
			case cc.CastExpressionUnary: // UnaryExpression
				n = x.UnaryExpression
			case cc.CastExpressionCast:
				if x.Type() != x.CastExpression.Type() {
					return nil
				}

				n = x.CastExpression
			default:
				return nil
			}
		case *cc.UnaryExpression:
			switch x.Case {
			case cc.UnaryExpressionPostfix: // PostfixExpression
				n = x.PostfixExpression
			default:
				return nil
			}
		case *cc.ConditionalExpression:
			switch x.Case {
			case cc.ConditionalExpressionLOr: // LogicalOrExpression
				n = x.LogicalOrExpression
			default:
				return nil
			}
		case *cc.AdditiveExpression:
			switch x.Case {
			case cc.AdditiveExpressionMul: // MultiplicativeExpression
				n = x.MultiplicativeExpression
			default:
				return nil
			}
		case *cc.InclusiveOrExpression:
			switch x.Case {
			case cc.InclusiveOrExpressionXor: // ExclusiveOrExpression
				n = x.ExclusiveOrExpression
			default:
				return nil
			}
		case *cc.ShiftExpression:
			switch x.Case {
			case cc.ShiftExpressionAdd:
				n = x.AdditiveExpression
			default:
				return nil
			}
		case *cc.AndExpression:
			switch x.Case {
			case cc.AndExpressionEq:
				n = x.EqualityExpression
			default:
				return nil
			}
		case *cc.MultiplicativeExpression:
			switch x.Case {
			case cc.MultiplicativeExpressionCast:
				n = x.CastExpression
			default:
				return nil
			}
		case *cc.EqualityExpression:
			switch x.Case {
			case cc.EqualityExpressionRel:
				n = x.RelationalExpression
			default:
				return nil
			}
		case *cc.RelationalExpression:
			switch x.Case {
			case cc.RelationalExpressionShift:
				n = x.ShiftExpression
			default:
				return nil
			}
		case *cc.LogicalOrExpression:
			switch x.Case {
			case cc.LogicalOrExpressionLAnd:
				n = x.LogicalAndExpression
			default:
				return nil
			}
		case *cc.AssignmentExpression:
			switch x.Case {
			case cc.AssignmentExpressionCond:
				n = x.ConditionalExpression
			default:
				return nil
			}
		case *cc.LogicalAndExpression:
			switch x.Case {
			case cc.LogicalAndExpressionOr:
				n = x.InclusiveOrExpression
			default:
				return nil
			}
		case *cc.ExclusiveOrExpression:
			switch x.Case {
			case cc.ExclusiveOrExpressionAnd:
				n = x.AndExpression
			default:
				return nil
			}
		case *cc.ConstantExpression:
			n = x.ConditionalExpression
		default:
			panic(todo("%T", n))
		}
	}
	return nil
}

func (c *ctx) postfixExpressionInc(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case void:
		switch d := c.declaratorOf(n.PostfixExpression); {
		case d != nil:
			switch local := c.fn.locals[d]; {
			case local != nil:
				switch {
				case local.isValue:
					s := c.expr(n.PostfixExpression, lvalue, t)
					c.w("\t%s =%s add %[1]s, 1\n", s, c.typ(n, n.PostfixExpression.Type()))
				default:
					panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
				}
			default:
				panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
		}
		return nothing
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// PostfixExpression '.' IDENTIFIER
func (c *ctx) postfixExpressionSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch f := n.Field(); {
	case f.IsBitfield():
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		// return c.postfixExpressionSelectBitfield(n, mode, t, f)
	default:
		switch mode {
		case lvalue:
			p := c.expr(n.PostfixExpression, mode, nil)
			r = c.temp()
			c.w("\t%s =%s add %s, %v\n", r, c.wordTag, p, f.Offset())
			return r
		case rvalue:
			p := c.expr(n.PostfixExpression, lvalue, nil)
			c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
			r = c.temp()
			switch n.Type().Size() {
			case 4, 8:
				c.w("\t%s =%s load%[2]s %s\n", r, c.typ(n, n.Type()), p)
			default:
				panic(todo("%v: %v %s", n.Position(), n.Type().Size(), cc.NodeSource(n)))
			}
			return c.convertRValue(n, t, n.Type(), r)
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	}
}

// PostfixExpression "->" IDENTIFIER
func (c *ctx) postfixExpressionPSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch f := n.Field(); {
	case f.IsBitfield():
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		// return c.postfixExpressionPSelectBitfield(n, mode, t, f)
	default:
		switch mode {
		case rvalue:
			defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

			p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
			c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
			r = c.temp()
			switch n.Type().Size() {
			case 4, 8:
				c.w("\t%s =%s load%[2]s %s\n", r, c.typ(n, n.Type()), p)
			default:
				panic(todo("%v: %v %s", n.Position(), n.Type().Size(), cc.NodeSource(n)))
			}
		case lvalue:
			p := c.expr(n.PostfixExpression, lvalue, c.ast.PVoid)
			c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
			return p
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	}
	return r
}

// PostfixExpression '[' ExpressionList ']'
func (c *ctx) postfixExpressionIndex(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	p := c.temp()
	var et cc.Type
	switch {
	case n.PostfixExpression.Type().Kind() == cc.Ptr:
		et = n.PostfixExpression.Type().(*cc.PointerType).Elem()
		ix := c.expr(n.ExpressionList, rvalue, c.ast.PVoid)
		ix2 := c.temp()
		c.w("\t%s =%s mul %s, %v #852\n", ix2, c.wordTag, ix, et.Size())
		p0 := c.expr(n.PostfixExpression, lvalue, c.ast.PVoid)
		c.w("\t%s =%s add %s, %s\n", p, c.wordTag, p0, ix2)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
	switch mode {
	case lvalue:
		return p
	case rvalue:
		r = c.temp()
		c.w("\t%s =%s load%[2]s %s\n", r, c.typ(n, n.Type()), p)
		return c.convertRValue(n, t, n.Type(), r)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) postfixExpression(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.PostfixExpressionPrimary: // PrimaryExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionIndex: // PostfixExpression '[' ExpressionList ']'
		return c.postfixExpressionIndex(n, mode, t)
	case cc.PostfixExpressionCall: // PostfixExpression '(' ArgumentExpressionList ')'
		return c.postfixExpressionCall(n, mode, t)
	case cc.PostfixExpressionSelect: // PostfixExpression '.' IDENTIFIER
		return c.postfixExpressionSelect(n, mode, t)
	case cc.PostfixExpressionPSelect: // PostfixExpression "->" IDENTIFIER
		return c.postfixExpressionPSelect(n, mode, t)
	case cc.PostfixExpressionInc: // PostfixExpression "++"
		return c.postfixExpressionInc(n, mode, t)
	case cc.PostfixExpressionDec: // PostfixExpression "--"
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PostfixExpressionComplit: // '(' TypeName ')' '{' InitializerList ',' '}'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) unaryExpressionMinus(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		e := c.expr(n.CastExpression, mode, t)
		r = c.temp()
		c.w("\t%s =%s neg %s\n", r, c.typ(n, t), e)
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) temp() string {
	return fmt.Sprintf("%%.%v", c.id())
}

// '&' CastExpression
func (c *ctx) unaryExpressionAddrof(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	d := c.declaratorOf(n.CastExpression)
	local := c.fn.locals[d]
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()
		switch {
		case local != nil:
			switch {
			case local.isStatic:
				panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
			case local.isValue:
				panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
			default:
				r = c.temp()
				c.w("\t%s =%s add %%.bp., %v\n", r, c.wordTag, local.offset)
			}
		default:
			r = c.expr(n.CastExpression, lvalue, n.Type())
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// '*' CastExpression
func (c *ctx) unaryExpressionDeref(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		switch et := n.Type(); {
		case cc.IsScalarType(et):
			switch et.Size() {
			case 4, 8:
				p := c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
				r = c.temp()
				c.w("\t%s =%s load%[2]s %s\n", r, c.typ(n, et), p)
			default:
				panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) unaryExpression(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.UnaryExpressionPostfix: //  PostfixExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionInc: // "++" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionDec: // "--" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionAddrof: // '&' CastExpression
		return c.unaryExpressionAddrof(n, mode, t)
	case cc.UnaryExpressionDeref: // '*' CastExpression
		return c.unaryExpressionDeref(n, mode, t)
	case cc.UnaryExpressionPlus: // '+' CastExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionMinus: // '-' CastExpression
		return c.unaryExpressionMinus(n, mode, t)
	case cc.UnaryExpressionCpl: // '~' CastExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionNot: // '!' CastExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionSizeofExpr: // "sizeof" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionSizeofType: // "sizeof" '(' TypeName ')'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionLabelAddr: // "&&" IDENTIFIER
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionAlignofExpr: // "_Alignof" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionAlignofType: // "_Alignof" '(' TypeName ')'
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionImag: // "__imag__" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.UnaryExpressionReal: // "__real__" UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) usualArithmeticConversions(a, b cc.Type) (r cc.Type) {
	if a.Kind() == cc.Ptr && (cc.IsIntegerType(b) || b.Kind() == cc.Ptr) {
		return a
	}

	if b.Kind() == cc.Ptr && (cc.IsIntegerType(a) || a.Kind() == cc.Ptr) {
		return b
	}

	return cc.UsualArithmeticConversions(a, b)
}

func (c *ctx) relationalExpressionLEQ(n *cc.RelationalExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		ct := c.usualArithmeticConversions(n.RelationalExpression.Type(), n.ShiftExpression.Type())
		lhs := c.expr(n.RelationalExpression, rvalue, ct)
		rhs := c.expr(n.ShiftExpression, rvalue, ct)
		r = c.temp()
		switch {
		case cc.IsSignedInteger(ct):
			c.w("\t%s =w csle%s %s, %s\n", r, c.typ(n, ct), lhs, rhs)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
		return c.convertRValue(n, t, c.ast.Int, r)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) relationalExpressionLT(n *cc.RelationalExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		ct := c.usualArithmeticConversions(n.RelationalExpression.Type(), n.ShiftExpression.Type())
		lhs := c.expr(n.RelationalExpression, rvalue, ct)
		rhs := c.expr(n.ShiftExpression, rvalue, ct)
		r = c.temp()
		switch {
		case cc.IsSignedInteger(ct):
			c.w("\t%s =w cslt%s %s, %s\n", r, c.typ(n, ct), lhs, rhs)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
		return c.convertRValue(n, t, c.ast.Int, r)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) relationalExpression(n *cc.RelationalExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.RelationalExpressionShift: //  ShiftExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.RelationalExpressionLt: // RelationalExpression '<' ShiftExpression
		return c.relationalExpressionLT(n, mode, t)
	case cc.RelationalExpressionGt: // RelationalExpression '>' ShiftExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.RelationalExpressionLeq: // RelationalExpression "<=" ShiftExpression
		return c.relationalExpressionLEQ(n, mode, t)
	case cc.RelationalExpressionGeq: // RelationalExpression ">=" ShiftExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) additiveExpressionAdd(n *cc.AdditiveExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch {
		case cc.IsArithmeticType(n.Type()):
			ct := c.usualArithmeticConversions(n.AdditiveExpression.Type(), n.MultiplicativeExpression.Type())
			lhs := c.expr(n.AdditiveExpression, rvalue, ct)
			rhs := c.expr(n.MultiplicativeExpression, rvalue, ct)
			r = c.temp()
			c.w("\t%s =%s add %s, %s\n", r, c.typ(n, ct), lhs, rhs)
			return c.convertRValue(n, t, n.Type(), r)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) additiveExpressionSub(n *cc.AdditiveExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch {
		case cc.IsArithmeticType(n.Type()):
			ct := c.usualArithmeticConversions(n.AdditiveExpression.Type(), n.MultiplicativeExpression.Type())
			lhs := c.expr(n.AdditiveExpression, rvalue, ct)
			rhs := c.expr(n.MultiplicativeExpression, rvalue, ct)
			r = c.temp()
			c.w("\t%s =%s sub %s, %s\n", r, c.typ(n, ct), lhs, rhs)
			return c.convertRValue(n, t, n.Type(), r)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) additiveExpression(n *cc.AdditiveExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.AdditiveExpressionMul: // MultiplicativeExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AdditiveExpressionAdd: // AdditiveExpression '+' MultiplicativeExpression
		return c.additiveExpressionAdd(n, mode, t)
	case cc.AdditiveExpressionSub: // AdditiveExpression '-' MultiplicativeExpression
		return c.additiveExpressionSub(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// LogicalOrExpression "||" LogicalAndExpression
func (c *ctx) logicalOrExpressionLOr(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		//	%e = orExpr
		//	%r = 1
		//	jnz %e, @z, @a
		// @a
		//	%e2 = andExpr
		//	jnz %e2, @z, @b
		// @b
		//	%r = 0
		// @z
		a := c.label()
		b := c.label()
		z := c.label()
		e := c.expr(n.LogicalOrExpression, mode, n.LogicalOrExpression.Type())
		r = c.temp()
		c.w("\t%s =w copy 1\n", r)
		c.w("\tjnz %s, %s, %s #909\n", e, z, a)
		c.w("%s\n", a)
		e2 := c.expr(n.LogicalAndExpression, mode, n.LogicalAndExpression.Type())
		c.w("\tjnz %s, %s, %s #912 %q\n", e2, z, b, e2)
		c.w("%s\n", b)
		c.w("\t%s =w copy 0\n", r)
		c.w("%s\n", z)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) logicalOrExpression(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.LogicalOrExpressionLAnd: // LogicalAndExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.LogicalOrExpressionLOr: // LogicalOrExpression "||" LogicalAndExpression
		return c.logicalOrExpressionLOr(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// LogicalAndExpression "&&" InclusiveOrExpression
func (c *ctx) logicalAndExpressionLAnd(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		//	%e = andExpr
		//	%r = 0
		//	jnz %e, @a, @z
		// @a
		//	%e2 = orExpr
		//	jnz %e2, @b, @z
		// @b
		//	%r = 1
		// @z
		a := c.label()
		b := c.label()
		z := c.label()
		e := c.expr(n.LogicalAndExpression, mode, n.LogicalAndExpression.Type())
		r = c.temp()
		c.w("\t%s =w copy 0\n", r)
		c.w("\tjnz %s, %s, %s #954\n", e, a, z)
		c.w("%s\n", a)
		e2 := c.expr(n.InclusiveOrExpression, mode, n.InclusiveOrExpression.Type())
		c.w("\tjnz %s, %s, %s #957\n", e2, b, z)
		c.w("%s\n", b)
		c.w("\t%s =w copy 1\n", r)
		c.w("%s\n", z)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) logicalAndExpression(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.LogicalAndExpressionOr: // InclusiveOrExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.LogicalAndExpressionLAnd: // LogicalAndExpression "&&" InclusiveOrExpression
		return c.logicalAndExpressionLAnd(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// MultiplicativeExpression '*' CastExpression
func (c *ctx) multiplicativeExpressionMul(n *cc.MultiplicativeExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch {
		case cc.IsArithmeticType(n.Type()):
			ct := c.usualArithmeticConversions(n.MultiplicativeExpression.Type(), n.CastExpression.Type())
			lhs := c.expr(n.MultiplicativeExpression, rvalue, ct)
			rhs := c.expr(n.CastExpression, rvalue, ct)
			r = c.temp()
			c.w("\t%s =%s mul %s, %s\n", r, c.typ(n, ct), lhs, rhs)
			return c.convertRValue(n, t, n.Type(), r)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// MultiplicativeExpression '/' CastExpression
func (c *ctx) multiplicativeExpressionDiv(n *cc.MultiplicativeExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch {
		case cc.IsArithmeticType(n.Type()):
			ct := c.usualArithmeticConversions(n.MultiplicativeExpression.Type(), n.CastExpression.Type())
			lhs := c.expr(n.MultiplicativeExpression, rvalue, ct)
			rhs := c.expr(n.CastExpression, rvalue, ct)
			r = c.temp()
			c.w("\t%s =%s div %s, %s\n", r, c.typ(n, ct), lhs, rhs)
			return c.convertRValue(n, t, n.Type(), r)
		default:
			panic(todo("%v: %s %s", n.Position(), n.Type(), cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) multiplicativeExpression(n *cc.MultiplicativeExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.MultiplicativeExpressionCast: // CastExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.MultiplicativeExpressionMul: // MultiplicativeExpression '*' CastExpression
		return c.multiplicativeExpressionMul(n, mode, t)
	case cc.MultiplicativeExpressionDiv: // MultiplicativeExpression '/' CastExpression
		return c.multiplicativeExpressionDiv(n, mode, t)
	case cc.MultiplicativeExpressionMod: // MultiplicativeExpression '%' CastExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) constantExpression(n *cc.ConstantExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		switch x := n.Value().(type) {
		case cc.Int64Value:
			return c.convertRValue(n, t, n.Type(), fmt.Sprint(int64(x)))
		default:
			panic(todo("%T", x))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// InclusiveOrExpression '|' ExclusiveOrExpression
func (c *ctx) inclusiveOrExpressionOr(n *cc.InclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		ct := c.usualArithmeticConversions(n.InclusiveOrExpression.Type(), n.ExclusiveOrExpression.Type())
		lhs := c.expr(n.InclusiveOrExpression, rvalue, ct)
		rhs := c.expr(n.ExclusiveOrExpression, rvalue, ct)
		r = c.temp()
		c.w("\t%s =%s or %s, %s\n", r, c.typ(n, ct), lhs, rhs)
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) inclusiveOrExpression(n *cc.InclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.InclusiveOrExpressionXor: // ExclusiveOrExpression
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.InclusiveOrExpressionOr: // InclusiveOrExpression '|' ExclusiveOrExpression
		return c.inclusiveOrExpressionOr(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// ExclusiveOrExpression '^' AndExpression
func (c *ctx) exclusiveOrExpressionXor(n *cc.ExclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		ct := c.usualArithmeticConversions(n.ExclusiveOrExpression.Type(), n.AndExpression.Type())
		lhs := c.expr(n.ExclusiveOrExpression, rvalue, ct)
		rhs := c.expr(n.AndExpression, rvalue, ct)
		r = c.temp()
		c.w("\t%s =%s xor %s, %s\n", r, c.typ(n, ct), lhs, rhs)
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) exclusiveOrExpression(n *cc.ExclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.ExclusiveOrExpressionAnd: // AndExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.ExclusiveOrExpressionXor: // ExclusiveOrExpression '^' AndExpression
		return c.exclusiveOrExpressionXor(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// AndExpression '&' EqualityExpression
func (c *ctx) andExpressionAnd(n *cc.AndExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		ct := c.usualArithmeticConversions(n.AndExpression.Type(), n.EqualityExpression.Type())
		lhs := c.expr(n.AndExpression, rvalue, ct)
		rhs := c.expr(n.EqualityExpression, rvalue, ct)
		r = c.temp()
		c.w("\t%s =%s and %s, %s\n", r, c.typ(n, ct), lhs, rhs)
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) andExpression(n *cc.AndExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.AndExpressionEq: // EqualityExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.AndExpressionAnd: // AndExpression '&' EqualityExpression
		return c.andExpressionAnd(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// EqualityExpression "==" RelationalExpression
func (c *ctx) equalityExpressionEq(n *cc.EqualityExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		ct := c.usualArithmeticConversions(n.EqualityExpression.Type(), n.RelationalExpression.Type())
		lhs := c.expr(n.EqualityExpression, rvalue, ct)
		rhs := c.expr(n.RelationalExpression, rvalue, ct)
		r = c.temp()
		switch {
		case cc.IsScalarType(ct):
			c.w("\t%s =%s ceq%s %s, %s\n", r, c.typ(n, ct), c.typ(n, ct), lhs, rhs)
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// EqualityExpression "!=" RelationalExpression
func (c *ctx) equalityExpressionNeq(n *cc.EqualityExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		ct := c.usualArithmeticConversions(n.EqualityExpression.Type(), n.RelationalExpression.Type())
		lhs := c.expr(n.EqualityExpression, rvalue, ct)
		rhs := c.expr(n.RelationalExpression, rvalue, ct)
		r = c.temp()
		switch {
		case cc.IsScalarType(ct):
			c.w("\t%s =%s cne%s %s, %s\n", r, c.typ(n, ct), c.typ(n, ct), lhs, rhs)
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) equalityExpression(n *cc.EqualityExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.EqualityExpressionRel: // RelationalExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.EqualityExpressionEq: // EqualityExpression "==" RelationalExpression
		return c.equalityExpressionEq(n, mode, t)
	case cc.EqualityExpressionNeq: // EqualityExpression "!=" RelationalExpression
		return c.equalityExpressionNeq(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// ShiftExpression "<<" AdditiveExpression
func (c *ctx) shiftExpressionLsh(n *cc.ShiftExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		lhs := c.expr(n.ShiftExpression, rvalue, n.ShiftExpression.Type())
		rhs := c.expr(n.AdditiveExpression, rvalue, c.ast.Int)
		r = c.temp()
		c.w("\t%s =%s shl %s, %s\n", r, c.typ(n, n.ShiftExpression.Type()), lhs, rhs)
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// ShiftExpression ">>" AdditiveExpression
func (c *ctx) shiftExpressionRsh(n *cc.ShiftExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		lhs := c.expr(n.ShiftExpression, rvalue, n.ShiftExpression.Type())
		rhs := c.expr(n.AdditiveExpression, rvalue, c.ast.Int)
		r = c.temp()
		switch {
		case cc.IsSignedInteger(n.ShiftExpression.Type()):
			c.w("\t%s =%s sar %s, %s\n", r, c.typ(n, n.ShiftExpression.Type()), lhs, rhs)
		default:
			c.w("\t%s =%s shr %s, %s\n", r, c.typ(n, n.ShiftExpression.Type()), lhs, rhs)
		}
		return r
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) shiftExpression(n *cc.ShiftExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.ShiftExpressionAdd: // AdditiveExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.ShiftExpressionLsh: // ShiftExpression "<<" AdditiveExpression
		return c.shiftExpressionLsh(n, mode, t)
	case cc.ShiftExpressionRsh: // ShiftExpression ">>" AdditiveExpression
		return c.shiftExpressionRsh(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// '(' TypeName ')' CastExpression
func (c *ctx) castExpressionCast(n *cc.CastExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convertRValue(n, t, n.Type(), r) }()

		r = c.expr(n.CastExpression, mode, n.CastExpression.Type())
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) castExpression(n *cc.CastExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.CastExpressionUnary: // UnaryExpression
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.CastExpressionCast: // '(' TypeName ')' CastExpression
		return c.castExpressionCast(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) expr(n cc.ExpressionNode, mode mode, t cc.Type) (r string) {
	switch x := n.(type) {
	case *cc.AssignmentExpression:
		return c.assignmentExpression(x, mode, t)
	case *cc.PostfixExpression:
		return c.postfixExpression(x, mode, t)
	case *cc.PrimaryExpression:
		return c.primaryExpression(x, mode, t)
	case *cc.UnaryExpression:
		return c.unaryExpression(x, mode, t)
	case *cc.RelationalExpression:
		return c.relationalExpression(x, mode, t)
	case *cc.AdditiveExpression:
		return c.additiveExpression(x, mode, t)
	case *cc.MultiplicativeExpression:
		return c.multiplicativeExpression(x, mode, t)
	case *cc.ConstantExpression:
		return c.constantExpression(x, mode, t)
	case *cc.LogicalOrExpression:
		return c.logicalOrExpression(x, mode, t)
	case *cc.LogicalAndExpression:
		return c.logicalAndExpression(x, mode, t)
	case *cc.InclusiveOrExpression:
		return c.inclusiveOrExpression(x, mode, t)
	case *cc.ExclusiveOrExpression:
		return c.exclusiveOrExpression(x, mode, t)
	case *cc.AndExpression:
		return c.andExpression(x, mode, t)
	case *cc.EqualityExpression:
		return c.equalityExpression(x, mode, t)
	case *cc.ShiftExpression:
		return c.shiftExpression(x, mode, t)
	case *cc.CastExpression:
		return c.castExpression(x, mode, t)
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
