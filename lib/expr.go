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
)

const nothing = "<void>"

func (c *ctx) convert(n cc.Node, dst, src cc.Type, v string) (r string) {
	if dst.Kind() == cc.Enum {
		dst = dst.(*cc.EnumType).UnderlyingType()
	}
	if src.Kind() == cc.Enum {
		src = src.(*cc.EnumType).UnderlyingType()
	}
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
			cc.LongLong, cc.ULongLong,
			cc.Float, cc.Double, cc.LongDouble:

			return v
		}
	case dst.Kind() == cc.Ptr && c.isIntegerType(src):
		s := "s"
		if !cc.IsSignedInteger(src) {
			s = "u"
		}
		switch src.Size() {
		case 4:
			if dst.Size() == 4 {
				return v
			}

			return c.temp("%s ext%sw %s\n", c.wordTag, s, v)
		case 8:
			return v
		}
	case c.isIntegerType(dst) && c.isIntegerType(src):
		s := "s"
		if !cc.IsSignedInteger(src) {
			s = "u"
		}
		switch {
		case dst.Size() <= src.Size():
			return v
		default:
			return c.temp("%s ext%s%s %s\n", c.baseType(n, dst), s, c.extType(n, src), v)
		}
	case dst.Kind() == cc.Float:
		switch k := src.Kind(); {
		case k == cc.Double || k == cc.LongDouble:
			return c.temp("s truncd %s\n", v)
		case c.isIntegerType(src):
			switch src.Size() {
			case 4:
				switch {
				case cc.IsSignedInteger(src):
					return c.temp("s swtof %s\n", v)
				default:
					return c.temp("s uwtof %s\n", v)
				}
			case 8:
				switch {
				case cc.IsSignedInteger(src):
					return c.temp("s sltof %s\n", v)
				default:
					return c.temp("s ultof %s\n", v)
				}
			}
		}
	case dst.Kind() == cc.Double || dst.Kind() == cc.LongDouble:
		if src.Kind() == cc.Double || src.Kind() == cc.LongDouble {
			return v
		}

		switch k := src.Kind(); {
		case k == cc.Float:
			return c.temp("d exts %s\n", v)
		case c.isIntegerType(src):
			switch src.Size() {
			case 4:
				switch {
				case cc.IsSignedInteger(src):
					return c.temp("d swtof %s\n", v)
				default:
					return c.temp("d uwtof %s\n", v)
				}
			case 8:
				switch {
				case cc.IsSignedInteger(src):
					return c.temp("d sltof %s\n", v)
				default:
					return c.temp("d ultof %s\n", v)
				}
			}
		}
	case c.isIntegerType(dst) && c.isFloatingPointType(src):
		sgn := "u"
		if cc.IsSignedInteger(dst) {
			sgn = "s"
		}
		f := "s"
		if src.Kind() == cc.Double || src.Kind() == cc.LongDouble {
			f = "d"
		}
		return c.temp("%s %sto%si %s\n", c.baseType(n, dst), f, sgn, v)
	case dst.Kind() == cc.Function && src.Kind() == cc.Ptr:
		return v
	case c.isIntegerType(dst) && src.Kind() == cc.Ptr:
		switch {
		case dst.Size() <= src.Size():
			return v
		}
	}
	panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dst, dst.Kind(), dst.Size(), src, src.Kind(), src.Size(), cc.NodeSource(n)))
}

func (c *ctx) load(n cc.Node, p string, et cc.Type) (r string) {
	switch et.Size() {
	case 1:
		switch {
		case cc.IsSignedInteger(et):
			return c.temp("%s loadsb %s\n", c.loadType(n, et), p)
		default:
			return c.temp("%s loadub %s\n", c.loadType(n, et), p)
		}
	case 2:
		switch {
		case cc.IsSignedInteger(et):
			return c.temp("%s loadsh %s\n", c.loadType(n, et), p)
		default:
			return c.temp("%s loaduh %s\n", c.loadType(n, et), p)
		}
	case 4:
		switch {
		case et.Kind() == cc.Float:
			return c.temp("s loads %s\n", p)
		case cc.IsSignedInteger(et):
			return c.temp("%s loadsw %s\n", c.loadType(n, et), p)
		default:
			return c.temp("%s loaduw %s\n", c.loadType(n, et), p)
		}
	case 8:
		return c.temp("%s load%[1]s %s\n", c.baseType(n, et), p)
	default:
		panic(todo("%v: %q %s %s", n.Position(), p, et, cc.NodeSource(n)))
	}
}

func (c *ctx) value(n cc.Node, mode mode, t cc.Type, v cc.Value) (r string) {
	switch mode {
	case rvalue, void:
		var vt cc.Type
		defer func() { r = c.convert(n, t, vt, r) }()

		switch x := v.(type) {
		case cc.Int64Value:
			vt = c.ast.LongLong
			return fmt.Sprint(int64(x))
		case cc.UInt64Value:
			vt = c.ast.ULongLong
			return fmt.Sprint(uint64(x))
		case cc.Float64Value:
			vt = c.ast.Double
			return fmt.Sprintf("d_%v", float64(x))
		default:
			panic(todo("%T", x))
		}
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr58662.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionIdent(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	d, info := c.variable(n)
	switch mode {
	case lvalue:
		switch x := info.(type) {
		case *local:
			return x.name
		case *escaped:
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		case *static:
			return c.temp("%s copy %s\n", c.wordTag, x.name)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *local:
			return c.temp("%s copy %s\n", c.baseType(n, d.Type()), x.name)
		case *escaped:
			switch d.Type().Kind() {
			case cc.Array:
				return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
			default:
				p := c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
				return c.load(n, p, d.Type())
			}
		case *static:
			switch d.Type().Kind() {
			case cc.Function, cc.Array:
				return x.name
			default:
				return c.load(n, x.name, d.Type())
			}
		default:
			if x, ok := n.ResolvedTo().(*cc.Enumerator); ok {
				return c.value(n, mode, t, x.Value())
			}

			panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
		}
	case void:
		return nothing
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionString(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch t.Kind() {
		case cc.Ptr:
			switch e := t.(*cc.PointerType).Elem().Kind(); e {
			case cc.Char, cc.Void:
				return c.addString(string(n.Value().(cc.StringValue)))
			default:
				// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/920429-1.c
				panic(todo("%v: e=%s %v", n.Position(), e, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/921218-1.c
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionStmt(n *cc.CompoundStatement, mode mode, t cc.Type) (r string) {
	switch mode {
	case void:
		c.compoundStatement(n)
		return nothing
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpression(n *cc.PrimaryExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.PrimaryExpressionIdent: // IDENTIFIER
		return c.primaryExpressionIdent(n, mode, t)
	case
		cc.PrimaryExpressionChar,  // CHARCONST
		cc.PrimaryExpressionFloat, // FLOATCONST
		cc.PrimaryExpressionInt,   // INTCONST
		cc.PrimaryExpressionLChar: // LONGCHARCONST

		return c.value(n, mode, t, n.Value())
	case cc.PrimaryExpressionString: // STRINGLITERAL
		return c.primaryExpressionString(n, mode, t)
	case cc.PrimaryExpressionLString: // LONGSTRINGLITERAL
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010325-1.c
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
		return c.expr(n.ExpressionList, mode, t)
	case cc.PrimaryExpressionStmt: // '(' CompoundStatement ')'
		return c.primaryExpressionStmt(n.CompoundStatement, mode, t)
	case cc.PrimaryExpressionGeneric: // GenericSelection
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// UnaryExpression '=' AssignmentExpression
func (c *ctx) assignmentExpressionAssign(n *cc.AssignmentExpression, mode mode, t cc.Type) (r string) {
	lhs := c.expr(n.UnaryExpression, lvalue, n.Type())
	rhs := c.expr(n.AssignmentExpression, rvalue, n.Type())
	_, info := c.variable(n.UnaryExpression)
	switch x := info.(type) {
	case *local:
		c.w("\t%s =%s copy %s\n", lhs, c.baseType(n, n.Type()), rhs)
	case *escaped, nil:
		c.w("\tstore%s %s, %s\n", c.extType(n, n.Type()), rhs, lhs)
	case *static:
		c.w("\tstore%s %s, %s\n", c.extType(n, n.Type()), rhs, lhs)
	default:
		panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
	}
	switch mode {
	case void:
		return nothing
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *local:
			return x.name
		case nil:
			return c.load(n, lhs, n.UnaryExpression.Type())
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr57861.c
			panic(todo("%T", x))
		}
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

// Only the subset we support.
func (c *ctx) isIntegerType(t cc.Type) bool {
	switch t.Kind() {
	case
		cc.Bool,
		cc.Char,
		cc.Enum,
		cc.Int,
		cc.Long,
		cc.LongLong,
		cc.SChar,
		cc.Short,
		cc.UChar,
		cc.UInt,
		cc.ULong,
		cc.ULongLong,
		cc.UShort:

		return true
	default:
		return false
	}
}

// Only the subset we support.
func (c *ctx) isFloatingPointType(t cc.Type) bool {
	switch t.Kind() {
	case
		cc.Double,
		cc.Float,
		cc.LongDouble:

		return true
	default:
		return false
	}
}

func (c *ctx) assignmentExpressionOp(n *cc.AssignmentExpression, mode mode, t cc.Type, op string) (r string) {
	switch mode {
	case void:
		lhs, rhs := n.UnaryExpression, n.AssignmentExpression
		lt, rt := lhs.Type(), rhs.Type()
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *local:
			ct := c.usualArithmeticConversions(lt, rt)
			var v string
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.w("\t%s =%s copy %s\n", x.name, c.baseType(n, lt), v)
		case *static:
			ct := c.usualArithmeticConversions(lt, rt)
			var v string
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.w("\tstore%s %s, %s\n", c.extType(n, lt), v, x.name)
		default:
			ct := c.usualArithmeticConversions(lt, rt)
			switch op {
			case "shl", "shr":
				c.shiftop(lhs, rhs, lvalue, ct, op)
			default:
				c.arithmeticOp(lhs, rhs, lvalue, ct, op)
			}
		}
		return nothing
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		lhs, rhs := n.UnaryExpression, n.AssignmentExpression
		lt, rt := lhs.Type(), rhs.Type()
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *local:
			ct := c.usualArithmeticConversions(lt, rt)
			var v string
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.w("\t%s =%s copy %s\n", x.name, c.baseType(n, lt), v)
			return c.temp("%s copy %s\n", c.baseType(n, lt), x.name)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr58431.c
			panic(todo("%v: %v %T %v", n.Position(), mode, x, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpression(n *cc.AssignmentExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.AssignmentExpressionCond: // ConditionalExpression
		return c.expr(n.ConditionalExpression, mode, t)
	case cc.AssignmentExpressionAssign: // UnaryExpression '=' AssignmentExpression
		return c.assignmentExpressionAssign(n, mode, t)
	case cc.AssignmentExpressionMul: // UnaryExpression "*=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "mul")
	case cc.AssignmentExpressionDiv: // UnaryExpression "/=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "div")
	case cc.AssignmentExpressionMod: // UnaryExpression "%=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "rem")
	case cc.AssignmentExpressionAdd: // UnaryExpression "+=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "add")
	case cc.AssignmentExpressionSub: // UnaryExpression "-=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "sub")
	case cc.AssignmentExpressionLsh: // UnaryExpression "<<=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "shl")
	case cc.AssignmentExpressionRsh: // UnaryExpression ">>=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "shr")
	case cc.AssignmentExpressionAnd: // UnaryExpression "&=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "and")
	case cc.AssignmentExpressionXor: // UnaryExpression "^=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "xor")
	case cc.AssignmentExpressionOr: // UnaryExpression "|=" AssignmentExpression
		return c.assignmentExpressionOp(n, mode, t, "or")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
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
		c.err(n, "internal error %T", n)
		return nil
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
			switch {
			case c.isIntegerType(et):
				et = cc.IntegerPromotion(et)
			case et.Kind() == cc.Float:
				et = c.ast.Double
			}
		}
		exprs = append(exprs, c.expr(e, rvalue, et))
		types = append(types, et)
	}
	r = nothing
	switch mode {
	case void:
		c.w("\tcall %s(", c.expr(callee, rvalue, ct))
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch {
		case c.isIntegerType(n.Type()) || c.isFloatingPointType(n.Type()) || n.Type().Kind() == cc.Ptr:
			switch n.Type().Size() {
			case 4, 8:
				r = c.temp("%s call %s(", c.baseType(n, n.Type()), c.expr(callee, rvalue, ct))
			case 1, 2:
				r = c.temp("w call %s(", c.expr(callee, rvalue, ct))
			default:
				panic(todo("%v: %v %s", n.Position(), n.Type().Size(), cc.NodeSource(n)))
			}
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/990525-2.c
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	for i, expr := range exprs {
		if i == len(params) {
			c.w("...,")
		}
		c.w("%s %s,", c.baseType(args[i], types[i]), expr)
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

// PostfixExpression "++"
// PostfixExpression "--"
func (c *ctx) postfixExpressionIncDec(n *cc.PostfixExpression, mode mode, t cc.Type, op string) (r string) {
	_, info := c.variable(n.PostfixExpression)
	delta := int64(1)
	if x, ok := n.PostfixExpression.Type().(*cc.PointerType); ok {
		delta = x.Elem().Size()
	}
	switch mode {
	case void:
		switch x := info.(type) {
		case *local:
			v := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			c.w("\t%s =%s %s %[1]s, %[4]v\n", v, c.baseType(n, n.PostfixExpression.Type()), op, delta)
		case *static:
			v := c.load(n, x.name, x.d.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, v, delta)
			c.w("\tstore%s %s, %s\n", c.extType(n, x.d.Type()), v, x.name)
		case nil:
			p := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			v := c.load(n, p, n.PostfixExpression.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, v, delta)
			c.w("\tstore%s %s, %s\n", c.extType(n, n.PostfixExpression.Type()), v, p)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000605-2.c
			panic(todo("%v: %T", n.Position(), x))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *local:
			r = c.expr(n.PostfixExpression, rvalue, n.PostfixExpression.Type())
			s := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			c.w("\t%s =%s %s %[1]s, %[4]v\n", s, c.baseType(n, n.PostfixExpression.Type()), op, delta)
		case *static:
			r = c.expr(n.PostfixExpression, rvalue, n.PostfixExpression.Type())
			v := c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, r, delta)
			c.w("\tstore%s %s, %s\n", c.extType(n, x.d.Type()), v, x.name)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20040313-1.c
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// PostfixExpression '.' IDENTIFIER
func (c *ctx) postfixExpressionSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch f := n.Field(); {
	case f.IsBitfield():
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000815-1.c
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		// return c.postfixExpressionSelectBitfield(n, mode, t, f)
	default:
		switch mode {
		case lvalue:
			p := c.expr(n.PostfixExpression, mode, nil)
			return c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		case rvalue:
			if f.Type().Kind() == cc.Array {
				return c.postfixExpression(n, lvalue, t)
			}

			defer func() { r = c.convert(n, t, n.Type(), r) }()

			p := c.expr(n.PostfixExpression, lvalue, nil)
			c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
			return c.load(n, p, f.Type())
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	}
}

// PostfixExpression "->" IDENTIFIER
func (c *ctx) postfixExpressionPSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch f := n.Field(); {
	case f.IsBitfield():
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030714-1.c
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		// return c.postfixExpressionPSelectBitfield(n, mode, t, f)
	default:
		switch mode {
		case rvalue:
			if f.Type().Kind() == cc.Array {
				return c.postfixExpression(n, lvalue, t)
			}

			defer func() { r = c.convert(n, t, n.Type(), r) }()

			p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
			t := c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
			return c.load(n, t, f.Type())
		case lvalue:
			p := c.expr(n.PostfixExpression, lvalue, c.ast.PVoid)
			return c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		default:
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	}
	return r
}

// PostfixExpression '[' ExpressionList ']'
func (c *ctx) postfixExpressionIndex(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	var p string
	var et cc.Type
	switch {
	case c.isIntegerType(n.ExpressionList.Type()):
		et = n.PostfixExpression.Type().(*cc.PointerType).Elem()
		ix := c.expr(n.ExpressionList, rvalue, c.ast.PVoid)
		ix2 := c.temp("%s mul %s, %v\n", c.wordTag, ix, et.Size())
		p0 := c.expr(n.PostfixExpression, lvalue, c.ast.PVoid)
		p = c.temp("%s add %s, %s\n", c.wordTag, p0, ix2)
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr22061-1.c
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
	switch mode {
	case lvalue:
		return p
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return c.load(n, p, n.Type())
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) postfixExpression(n *cc.PostfixExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.PostfixExpressionPrimary: // PrimaryExpression
		return c.expr(n.PrimaryExpression, mode, t)
	case cc.PostfixExpressionIndex: // PostfixExpression '[' ExpressionList ']'
		return c.postfixExpressionIndex(n, mode, t)
	case cc.PostfixExpressionCall: // PostfixExpression '(' ArgumentExpressionList ')'
		return c.postfixExpressionCall(n, mode, t)
	case cc.PostfixExpressionSelect: // PostfixExpression '.' IDENTIFIER
		return c.postfixExpressionSelect(n, mode, t)
	case cc.PostfixExpressionPSelect: // PostfixExpression "->" IDENTIFIER
		return c.postfixExpressionPSelect(n, mode, t)
	case cc.PostfixExpressionInc: // PostfixExpression "++"
		return c.postfixExpressionIncDec(n, mode, t, "add")
	case cc.PostfixExpressionDec: // PostfixExpression "--"
		return c.postfixExpressionIncDec(n, mode, t, "sub")
	case cc.PostfixExpressionComplit: // '(' TypeName ')' '{' InitializerList ',' '}'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// '-' CastExpression
func (c *ctx) unaryExpressionMinus(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		e := c.expr(n.CastExpression, mode, n.Type())
		return c.temp("%s neg %s\n", c.baseType(n, n.Type()), e)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '+' CastExpression
func (c *ctx) unaryExpressionPlus(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return c.expr(n.CastExpression, mode, t)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '&' CastExpression
func (c *ctx) unaryExpressionAddrof(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	_, info := c.variable(n.CastExpression)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *escaped:
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		case *static:
			return x.name
		case nil:
			return c.expr(n.CastExpression, lvalue, n.Type())
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '*' CastExpression
func (c *ctx) unaryExpressionDeref(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch et := n.Type(); {
		case et.Kind() == cc.Ptr:
			switch x := n.CastExpression.Type().(type) {
			case *cc.PointerType:
				switch y := x.Elem().(type) {
				case *cc.FunctionType:
					return c.expr(n.CastExpression, rvalue, x)
				default:
					// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20070824-1.c
					panic(todo("%v: %T %s", n.Position(), y, cc.NodeSource(n.CastExpression)))
				}
			default:
				panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n.CastExpression)))
			}
		case c.isIntegerType(et) || c.isFloatingPointType(et) || et.Kind() == cc.Ptr:
			return c.load(n, c.expr(n.CastExpression, rvalue, n.CastExpression.Type()), et)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-10.c
			panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
		}
	case lvalue:
		switch et := n.Type(); {
		case c.isIntegerType(et) || c.isFloatingPointType(et) || et.Kind() == cc.Ptr:
			switch sz := et.Size(); {
			case sz <= 8:
				return c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
			default:
				panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
			}
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr35472.c
			panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
		}
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/va-arg-11.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// "sizeof" UnaryExpression
func (c *ctx) unaryExpressionSizeofExpr(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return fmt.Sprint(n.UnaryExpression.Type().Size())
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "sizeof" '(' TypeName ')'
func (c *ctx) unaryExpressionSizeofType(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return fmt.Sprint(n.TypeName.Type().Size())
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "_Alignof" UnaryExpression
func (c *ctx) unaryExpressionAlignofExpr(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return fmt.Sprint(n.UnaryExpression.Type().Align())
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "_Alignof" '(' TypeName ')'
func (c *ctx) unaryExpressionAlignofType(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return fmt.Sprint(n.TypeName.Type().Align())
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "++" UnaryExpression
// "--" UnaryExpression
func (c *ctx) unaryExpressionIncDec(n *cc.UnaryExpression, mode mode, t cc.Type, op string) (r string) {
	_, info := c.variable(n.UnaryExpression)
	delta := int64(1)
	if x, ok := n.UnaryExpression.Type().(*cc.PointerType); ok {
		delta = x.Elem().Size()
	}
	switch mode {
	case void:
		switch x := info.(type) {
		case *local:
			v := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
			c.w("\t%s =%s %s %[1]s, %[4]v\n", v, c.baseType(n, n.UnaryExpression.Type()), op, delta)
		case *static:
			v := c.load(n, x.name, x.d.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.w("\tstore%s %s, %s\n", c.extType(n, x.d.Type()), v, x.name)
		case nil:
			p := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
			v := c.load(n, p, n.UnaryExpression.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.w("\tstore%s %s, %s\n", c.extType(n, n.UnaryExpression.Type()), v, p)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *local:
			v := c.expr(n.UnaryExpression, rvalue, n.UnaryExpression.Type())
			c.w("\t%s =%s %s %s, %v\n", x.name, c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			r = c.expr(n.UnaryExpression, rvalue, n.UnaryExpression.Type())
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/990628-1.c
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// '~' CastExpression
func (c *ctx) unaryExpressionCpl(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	_, info := c.variable(n.CastExpression)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case nil:
			v := c.expr(n.CastExpression, rvalue, n.Type())
			k := ^int64(0)
			if n.Type().Size() < 8 {
				k = 0xffffffff
			}
			r = c.temp("%s xor %s, %v\n", c.baseType(n, n.Type()), v, k)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20020127-1.c
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// '!' CastExpression
func (c *ctx) unaryExpressionNot(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	//	%r = 1
	//	jnz @expr, @a, @b
	// @a
	//	%r = 0
	// @b
	a := c.label()
	b := c.label()
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		r = c.temp("w copy 1\n")
		v := c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
		c.w("\tjnz %s, %s, %s\n", v, a, b)
		c.w("%s\n", a)
		c.w("\t%s =w copy 0\n", r)
		c.w("%s\n", b)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "__real__" UnaryExpression
// "__imag__" UnaryExpression
func (c *ctx) unaryExpressionRealImag(n *cc.UnaryExpression, mode mode, t cc.Type, imag bool) (r string) {
	_, info := c.variable(n.UnaryExpression)
	var et cc.Type
	switch n.UnaryExpression.Type().Kind() {
	case cc.ComplexDouble:
		et = c.ast.Double
	case cc.ComplexFloat:
		et = c.ast.Float
	default:
		panic(todo("%v: %v %s", n.Position(), n.UnaryExpression.Type(), cc.NodeSource(n)))
	}
	var off int64
	if imag {
		off = et.Size()
	}
	switch mode {
	case lvalue:
		switch x := info.(type) {
		case *escaped:
			p := c.expr(n.UnaryExpression, lvalue, c.ast.PVoid)
			return c.temp("%s add %s, %v\n", c.wordTag, p, off)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *escaped:
			p := c.expr(n.UnaryExpression, lvalue, c.ast.PVoid)
			p = c.temp("%s add %s, %v\n", c.wordTag, p, off)
			switch n.UnaryExpression.Type().Kind() {
			case cc.ComplexDouble:
				return c.load(n, p, c.ast.Double)
			case cc.ComplexFloat:
				return c.load(n, p, c.ast.Float)
			default:
				panic(todo("%v: %v %s", n.Position(), n.UnaryExpression.Type(), cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) unaryExpression(n *cc.UnaryExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.UnaryExpressionPostfix: //  PostfixExpression
		return c.expr(n.PostfixExpression, mode, t)
	case cc.UnaryExpressionInc: // "++" UnaryExpression
		return c.unaryExpressionIncDec(n, mode, t, "add")
	case cc.UnaryExpressionDec: // "--" UnaryExpression
		return c.unaryExpressionIncDec(n, mode, t, "sub")
	case cc.UnaryExpressionAddrof: // '&' CastExpression
		return c.unaryExpressionAddrof(n, mode, t)
	case cc.UnaryExpressionDeref: // '*' CastExpression
		return c.unaryExpressionDeref(n, mode, t)
	case cc.UnaryExpressionPlus: // '+' CastExpression
		return c.unaryExpressionPlus(n, mode, t)
	case cc.UnaryExpressionMinus: // '-' CastExpression
		return c.unaryExpressionMinus(n, mode, t)
	case cc.UnaryExpressionCpl: // '~' CastExpression
		return c.unaryExpressionCpl(n, mode, t)
	case cc.UnaryExpressionNot: // '!' CastExpression
		return c.unaryExpressionNot(n, mode, t)
	case cc.UnaryExpressionSizeofExpr: // "sizeof" UnaryExpression
		return c.unaryExpressionSizeofExpr(n, mode, t)
	case cc.UnaryExpressionSizeofType: // "sizeof" '(' TypeName ')'
		return c.unaryExpressionSizeofType(n, mode, t)
	case cc.UnaryExpressionLabelAddr: // "&&" IDENTIFIER
		c.err(n, "taking address of a label not supported")
	case cc.UnaryExpressionAlignofExpr: // "_Alignof" UnaryExpression
		return c.unaryExpressionAlignofExpr(n, mode, t)
	case cc.UnaryExpressionAlignofType: // "_Alignof" '(' TypeName ')'
		return c.unaryExpressionAlignofType(n, mode, t)
	case cc.UnaryExpressionImag: // "__imag__" UnaryExpression
		return c.unaryExpressionRealImag(n, mode, t, true)
	case cc.UnaryExpressionReal: // "__real__" UnaryExpression
		return c.unaryExpressionRealImag(n, mode, t, false)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
	return nothing
}

func (c *ctx) usualArithmeticConversions(a, b cc.Type) (r cc.Type) {
	if a.Kind() == cc.Ptr && (c.isIntegerType(b) || b.Kind() == cc.Ptr) {
		return a
	}

	if b.Kind() == cc.Ptr && (c.isIntegerType(a) || a.Kind() == cc.Ptr) {
		return b
	}

	return cc.UsualArithmeticConversions(a, b)
}

func (c *ctx) relop(lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r string) {
	lt, rt := lhs.Type(), rhs.Type()
	ct := c.usualArithmeticConversions(lt, rt)
	switch op {
	case "eq", "ne", "o", "uo":
		// ok
	default:
		switch {
		case c.isIntegerType(ct):
			switch {
			case cc.IsSignedInteger(ct):
				op = "s" + op
			default:
				op = "u" + op
			}
		case ct.Kind() == cc.Ptr:
			op = "u" + op
		}
	}
	switch mode {
	case rvalue:
		defer func() { r = c.convert(lhs, t, c.ast.Int, r) }()

		return c.temp("w c%s%s %s, %s\n", op, c.baseType(lhs, ct), c.expr(lhs, rvalue, ct), c.expr(rhs, rvalue, ct))
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
}

func (c *ctx) relationalExpression(n *cc.RelationalExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.RelationalExpressionShift: //  ShiftExpression
		return c.expr(n.ShiftExpression, mode, t)
	case cc.RelationalExpressionLt: // RelationalExpression '<' ShiftExpression
		return c.relop(n.RelationalExpression, n.ShiftExpression, mode, t, "lt")
	case cc.RelationalExpressionGt: // RelationalExpression '>' ShiftExpression
		return c.relop(n.RelationalExpression, n.ShiftExpression, mode, t, "gt")
	case cc.RelationalExpressionLeq: // RelationalExpression "<=" ShiftExpression
		return c.relop(n.RelationalExpression, n.ShiftExpression, mode, t, "le")
	case cc.RelationalExpressionGeq: // RelationalExpression ">=" ShiftExpression
		return c.relop(n.RelationalExpression, n.ShiftExpression, mode, t, "ge")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) equalityExpression(n *cc.EqualityExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.EqualityExpressionRel: // RelationalExpression
		return c.expr(n.RelationalExpression, mode, t)
	case cc.EqualityExpressionEq: // EqualityExpression "==" RelationalExpression
		return c.relop(n.EqualityExpression, n.RelationalExpression, mode, t, "eq")
	case cc.EqualityExpressionNeq: // EqualityExpression "!=" RelationalExpression
		return c.relop(n.EqualityExpression, n.RelationalExpression, mode, t, "ne")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) arithmeticOp(lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r string) {
	lt, rt := lhs.Type(), rhs.Type()
	ct := c.usualArithmeticConversions(lt, rt)
	rmul := int64(1)
	lmul := int64(1)
	div := int64(1)
	switch op {
	case "add":
		switch {
		case lt.Kind() == cc.Ptr:
			rmul = lt.(*cc.PointerType).Elem().Size()
		case rt.Kind() == cc.Ptr:
			lmul = rt.(*cc.PointerType).Elem().Size()
		}
	case "sub":
		switch {
		case lt.Kind() == cc.Ptr && rt.Kind() == cc.Ptr:
			div = lt.(*cc.PointerType).Elem().Size()
		case lt.Kind() == cc.Ptr:
			rmul = lt.(*cc.PointerType).Elem().Size()
		}
	case "div":
		if c.isIntegerType(ct) && !cc.IsSignedInteger(ct) {
			op = "udiv"
		}
	case "rem":
		if c.isIntegerType(ct) && !cc.IsSignedInteger(ct) {
			op = "urem"
		}
	case "mul", "or", "xor", "and":
		// ok
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
	switch mode {
	case rvalue:
		defer func() { r = c.convert(lhs, t, ct, r) }()

		lv := c.expr(lhs, rvalue, ct)
		rv := c.expr(rhs, rvalue, ct)
		if lmul != 1 {
			lv = c.temp("%s mul %s, %v\n", c.baseType(lhs, ct), lv, lmul)
		}
		if rmul != 1 {
			rv = c.temp("%s mul %s, %v\n", c.baseType(rhs, ct), rv, rmul)
		}
		r = c.temp("%s %s %s, %s\n", c.baseType(lhs, ct), op, lv, rv)
		if div != 1 {
			r = c.temp("%s udiv %s, %v\n", c.wordTag, r, div)
		}
	case lvalue:
		// stores operation result in lhs
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *escaped, nil:
			r = c.expr(lhs, lvalue, lhs.Type())
			lv := c.load(lhs, r, lhs.Type())
			lv = c.convert(lhs, ct, lhs.Type(), lv)
			rv := c.expr(rhs, rvalue, ct)
			if lmul != 1 {
				lv = c.temp("%s mul %s, %v\n", c.baseType(lhs, ct), lv, lmul)
			}
			if rmul != 1 {
				rv = c.temp("%s mul %s, %v\n", c.baseType(rhs, ct), rv, rmul)
			}
			v := c.temp("%s %s %s, %s\n", c.baseType(lhs, ct), op, lv, rv)
			if div != 1 {
				v = c.temp("%s udiv %s, %v\n", c.wordTag, v, div)
			}
			c.w("\tstore%s %s, %s\n", c.extType(lhs, lhs.Type()), v, r)
		case *local:
			lv := c.convert(lhs, ct, lhs.Type(), x.name)
			rv := c.expr(rhs, rvalue, ct)
			if lmul != 1 {
				lv = c.temp("%s mul %s, %v\n", c.baseType(lhs, ct), lv, lmul)
			}
			if rmul != 1 {
				rv = c.temp("%s mul %s, %v\n", c.baseType(rhs, ct), rv, rmul)
			}
			v := c.temp("%s %s %s, %s\n", c.baseType(lhs, ct), op, lv, rv)
			if div != 1 {
				v = c.temp("%s udiv %s, %v\n", c.wordTag, v, div)
			}
			c.w("\t%s =%s copy %s\n", x.name, c.baseType(lhs, lhs.Type()), v)
		default:
			panic(todo("%v: %T", lhs.Position(), x))
		}
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
	return r
}

func (c *ctx) additiveExpression(n *cc.AdditiveExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.AdditiveExpressionMul: // MultiplicativeExpression
		return c.expr(n.MultiplicativeExpression, mode, t)
	case cc.AdditiveExpressionAdd: // AdditiveExpression '+' MultiplicativeExpression
		return c.arithmeticOp(n.AdditiveExpression, n.MultiplicativeExpression, mode, t, "add")
	case cc.AdditiveExpressionSub: // AdditiveExpression '-' MultiplicativeExpression
		return c.arithmeticOp(n.AdditiveExpression, n.MultiplicativeExpression, mode, t, "sub")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// LogicalOrExpression "||" LogicalAndExpression
func (c *ctx) logicalOrExpressionLOr(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r string) {
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
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		e := c.expr(n.LogicalOrExpression, mode, n.LogicalOrExpression.Type())
		r = c.temp("w copy 1\n")
		c.w("\tjnz %s, %s, %s\n", e, z, a)
		c.w("%s\n", a)
		e2 := c.expr(n.LogicalAndExpression, mode, n.LogicalAndExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e2, z, b)
		c.w("%s\n", b)
		c.w("\t%s =w copy 0\n", r)
		c.w("%s\n", z)
	case void:
		e := c.expr(n.LogicalOrExpression, rvalue, n.LogicalOrExpression.Type())
		r = c.temp("w copy 1\n")
		c.w("\tjnz %s, %s, %s\n", e, z, a)
		c.w("%s\n", a)
		e2 := c.expr(n.LogicalAndExpression, rvalue, n.LogicalAndExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e2, z, b)
		c.w("%s\n", b)
		c.w("\t%s =w copy 0\n", r)
		c.w("%s\n", z)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// LogicalAndExpression "&&" InclusiveOrExpression
func (c *ctx) logicalAndExpressionLAnd(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r string) {
	//	%e = andExpr
	//	%r = 0
	//	jnz %e, @a, @z
	// @a
	//	%e2 = inExpr
	//	jnz %e2, @b, @z
	// @b
	//	%r = 1
	// @z
	a := c.label()
	b := c.label()
	z := c.label()
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		e := c.expr(n.LogicalAndExpression, mode, n.LogicalAndExpression.Type())
		r = c.temp("w copy 0\n")
		c.w("\tjnz %s, %s, %s\n", e, a, z)
		c.w("%s\n", a)
		e2 := c.expr(n.InclusiveOrExpression, mode, n.InclusiveOrExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e2, b, z)
		c.w("%s\n", b)
		c.w("\t%s =w copy 1\n", r)
		c.w("%s\n", z)
	case void:
		e := c.expr(n.LogicalAndExpression, rvalue, n.LogicalAndExpression.Type())
		r = c.temp("w copy 0\n")
		c.w("\tjnz %s, %s, %s\n", e, a, z)
		c.w("%s\n", a)
		e2 := c.expr(n.InclusiveOrExpression, rvalue, n.InclusiveOrExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e2, b, z)
		c.w("%s\n", b)
		c.w("\t%s =w copy 1\n", r)
		c.w("%s\n", z)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) logicalOrExpression(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.LogicalOrExpressionLAnd: // LogicalAndExpression
		return c.expr(n.LogicalAndExpression, mode, t)
	case cc.LogicalOrExpressionLOr: // LogicalOrExpression "||" LogicalAndExpression
		return c.logicalOrExpressionLOr(n, mode, t)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) logicalAndExpression(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.LogicalAndExpressionOr: // InclusiveOrExpression
		return c.expr(n.InclusiveOrExpression, mode, t)
	case cc.LogicalAndExpressionLAnd: // LogicalAndExpression "&&" InclusiveOrExpression
		return c.logicalAndExpressionLAnd(n, mode, t)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) multiplicativeExpression(n *cc.MultiplicativeExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.MultiplicativeExpressionCast: // CastExpression
		return c.expr(n.CastExpression, mode, t)
	case cc.MultiplicativeExpressionMul: // MultiplicativeExpression '*' CastExpression
		return c.arithmeticOp(n.MultiplicativeExpression, n.CastExpression, mode, t, "mul")
	case cc.MultiplicativeExpressionDiv: // MultiplicativeExpression '/' CastExpression
		return c.arithmeticOp(n.MultiplicativeExpression, n.CastExpression, mode, t, "div")
	case cc.MultiplicativeExpressionMod: // MultiplicativeExpression '%' CastExpression
		return c.arithmeticOp(n.MultiplicativeExpression, n.CastExpression, mode, t, "rem")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) inclusiveOrExpression(n *cc.InclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.InclusiveOrExpressionXor: // ExclusiveOrExpression
		return c.expr(n.ExclusiveOrExpression, mode, t)
	case cc.InclusiveOrExpressionOr: // InclusiveOrExpression '|' ExclusiveOrExpression
		return c.arithmeticOp(n.InclusiveOrExpression, n.ExclusiveOrExpression, mode, t, "or")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) exclusiveOrExpression(n *cc.ExclusiveOrExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.ExclusiveOrExpressionAnd: // AndExpression
		return c.expr(n.AndExpression, mode, t)
	case cc.ExclusiveOrExpressionXor: // ExclusiveOrExpression '^' AndExpression
		return c.arithmeticOp(n.ExclusiveOrExpression, n.AndExpression, mode, t, "xor")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) andExpression(n *cc.AndExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.AndExpressionEq: // EqualityExpression
		return c.expr(n.EqualityExpression, mode, t)
	case cc.AndExpressionAnd: // AndExpression '&' EqualityExpression
		return c.arithmeticOp(n.AndExpression, n.EqualityExpression, mode, t, "and")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) shiftop(lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r string) {
	lt, rt := lhs.Type(), rhs.Type()
	ct := c.usualArithmeticConversions(lt, rt)
	switch op {
	case "shr":
		if cc.IsSignedInteger(ct) {
			op = "sar"
		}
	}
	switch mode {
	case rvalue:
		defer func() { r = c.convert(lhs, t, c.ast.Int, r) }()

		return c.temp("%s %s %s, %s\n", c.baseType(lhs, ct), op, c.expr(lhs, rvalue, ct), c.expr(rhs, rvalue, ct))
	case lvalue:
		// stores operation result in lhs
		r = c.expr(lhs, lvalue, lhs.Type())
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *escaped, nil:
			lv := c.load(lhs, r, lhs.Type())
			lv = c.convert(lhs, ct, lhs.Type(), lv)
			rv := c.expr(rhs, rvalue, ct)
			v := c.temp("%s %s %s, %s\n", c.baseType(lhs, ct), op, lv, rv)
			c.w("\tstore%s %s, %s\n", c.extType(lhs, lhs.Type()), v, r)
		default:
			panic(todo("%v: %T", lhs.Position(), x))
		}
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
	return r
}

func (c *ctx) shiftExpression(n *cc.ShiftExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.ShiftExpressionAdd: // AdditiveExpression
		return c.expr(n.AdditiveExpression, mode, t)
	case cc.ShiftExpressionLsh: // ShiftExpression "<<" AdditiveExpression
		return c.shiftop(n.ShiftExpression, n.AdditiveExpression, mode, t, "shl")
	case cc.ShiftExpressionRsh: // ShiftExpression ">>" AdditiveExpression
		return c.shiftop(n.ShiftExpression, n.AdditiveExpression, mode, t, "shr")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// '(' TypeName ')' CastExpression
func (c *ctx) castExpressionCast(n *cc.CastExpression, mode mode, t cc.Type) (r string) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		r = c.expr(n.CastExpression, mode, n.Type())
	case void:
		r = nothing
		c.expr(n.CastExpression, mode, n.Type())
	case lvalue:
		return c.expr(n.CastExpression, rvalue, c.ast.PVoid)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) castExpression(n *cc.CastExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.CastExpressionUnary: // UnaryExpression
		return c.expr(n.UnaryExpression, mode, t)
	case cc.CastExpressionCast: // '(' TypeName ')' CastExpression
		return c.castExpressionCast(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// LogicalOrExpression '?' ExpressionList ':' ConditionalExpression
func (c *ctx) conditionalExpressionCond(n *cc.ConditionalExpression, mode mode, t cc.Type) (r string) {
	//	jnz lorExpr, @a, @b
	// @a
	//	r = exprList
	// @x
	//	jmp @z
	// @b
	//	r = condExpr
	// @z
	a := c.label()
	b := c.label()
	x := c.label()
	z := c.label()
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		e := c.expr(n.LogicalOrExpression, mode, n.LogicalOrExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e, a, b)
		c.w("%s\n", a)
		el := c.expr(n.ExpressionList, mode, n.ExpressionList.Type())
		r = c.temp("%s copy %s\n", c.baseType(n, n.ExpressionList.Type()), el)
		c.w("%s\n", x)
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		ce := c.expr(n.ConditionalExpression, mode, n.ExpressionList.Type())
		c.w("\t%s =%s copy %s\n", r, c.baseType(n, n.ExpressionList.Type()), ce)
		c.w("%s\n", z)
	case void:
		e := c.expr(n.LogicalOrExpression, rvalue, n.LogicalOrExpression.Type())
		c.w("\tjnz %s, %s, %s\n", e, a, b)
		c.w("%s\n", a)
		el := c.expr(n.ExpressionList, rvalue, n.ExpressionList.Type())
		r = c.temp("%s copy %s\n", c.baseType(n, n.ExpressionList.Type()), el)
		c.w("%s\n", x)
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		ce := c.expr(n.ConditionalExpression, rvalue, n.ExpressionList.Type())
		c.w("\t%s =%s copy %s\n", r, c.baseType(n, n.ExpressionList.Type()), ce)
		c.w("%s\n", z)
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20071120-1.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) conditionalExpression(n *cc.ConditionalExpression, mode mode, t cc.Type) (r string) {
	switch n.Case {
	case cc.ConditionalExpressionLOr: // LogicalOrExpression
		return c.expr(n.LogicalOrExpression, mode, t)
	case cc.ConditionalExpressionCond: // LogicalOrExpression '?' ExpressionList ':' ConditionalExpression
		return c.conditionalExpressionCond(n, mode, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

// ExpressionList ',' AssignmentExpression
func (c *ctx) expressionList(n *cc.ExpressionList, mode mode, t cc.Type) (r string) {
	for ; n != nil; n = n.ExpressionList {
		m := mode
		if n.ExpressionList != nil {
			m = void
		}
		r = c.expr(n.AssignmentExpression, m, t)
	}
	return r
}

func (c *ctx) expr(n cc.ExpressionNode, mode mode, t cc.Type) (r string) {
	if n == nil && mode == void {
		return nothing
	}

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
		return c.value(n, mode, t, n.Value())
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
	case *cc.ConditionalExpression:
		return c.conditionalExpression(x, mode, t)
	case *cc.ExpressionList:
		return c.expressionList(x, mode, t)
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
