// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"math"
	"math/big"
	"strings"

	"modernc.org/cc/v4"
)

type mode int

const (
	void mode = iota
	lvalue
	rvalue
	aggRvalue
	constLvalue
	constRvalue
)

const nothing = "<void>"

type float32Value float32

func (v float32Value) String() string {
	return fmt.Sprint(math.Float32bits(float32(v)))
}

type float64Value float64

func (v float64Value) String() string {
	return fmt.Sprint(math.Float64bits(float64(v)))
}

type int64Value int64

func (v int64Value) String() string {
	return fmt.Sprint(uint64(v))
}

type uint64Value uint64

func (v uint64Value) String() string {
	return fmt.Sprint(uint64(v))
}

type symbolValue struct {
	sym string
	off int64
}

func (v *symbolValue) String() string {
	switch {
	case v.off != 0:
		return fmt.Sprintf("%s%+v", v.sym, v.off)
	default:
		return v.sym
	}
}

func (c *ctx) convertConst(n cc.Node, dstType, srcType cc.Type, v any) (r any) {
	switch dstType.Kind() {
	case cc.Enum:
		dstType = dstType.(*cc.EnumType).UnderlyingType()
	case cc.LongDouble:
		dstType = c.ast.Double
	}
	switch srcType.Kind() {
	case cc.Enum:
		srcType = srcType.(*cc.EnumType).UnderlyingType()
	case cc.LongDouble:
		srcType = c.ast.Double
	}
	dstSize := c.sizeof(n, dstType)
	srcSize := c.sizeof(n, srcType)
	switch {
	case dstType == srcType:
		return v
	case dstType.Kind() == srcType.Kind():
		switch dstType.Kind() {
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
	case dstType.Kind() == cc.Ptr && c.isIntegerType(srcType):
		return v
	case c.isIntegerType(dstType) && c.isIntegerType(srcType):
		switch {
		case dstSize < srcSize:
			m := uint64(1)<<(8*(srcSize-dstSize)) - 1
			switch x := v.(type) {
			case int64Value:
				return int64Value(int64(x) & int64(m))
			case uint64Value:
				return int64Value(uint64(x) & m)
			default:
				panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), x))
			}
		default:
			return v
		}
	case c.isFloatingPointType(dstType) && c.isIntegerType(srcType):
		switch dstType.Kind() {
		case cc.Float:
			switch x := v.(type) {
			case int64Value:
				return float32Value(float32(int64(x)))
			case uint64Value:
				return float32Value(float32(uint64(x)))
			default:
				panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), x))
			}
		case cc.Double:
			switch x := v.(type) {
			case int64Value:
				return float64Value(float64(int64(x)))
			case uint64Value:
				return float64Value(float64(uint64(x)))
			default:
				panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), x))
			}
		}
	case dstType.Kind() == cc.Float && srcType.Kind() == cc.Double:
		switch x := v.(type) {
		case float64Value:
			return float32Value(float64(x))
		default:
			panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), x))
		}
	}

	// trc("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), v)
	panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v %T", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), v))
}

func (c *ctx) convert(n cc.Node, dstType, srcType cc.Type, v any) (r any) {
	if dstType.Kind() == cc.Enum {
		dstType = dstType.(*cc.EnumType).UnderlyingType()
	}
	if srcType.Kind() == cc.Enum {
		srcType = srcType.(*cc.EnumType).UnderlyingType()
	}
	dstSize := c.sizeof(n, dstType)
	srcSize := c.sizeof(n, srcType)
	// defer func() {
	// 	trc("%v: %s(%v, %v) <- %s(%v, %v) '%v': %v", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n), r)
	// }()
	switch {
	case dstType == srcType:
		return v
	case dstType.Kind() == srcType.Kind():
		switch dstType.Kind() {
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
	case dstType.Kind() == cc.Ptr && c.isIntegerType(srcType):
		//	D S
		//	u u	u
		//	u s	s
		s := "u"
		if cc.IsSignedInteger(srcType) {
			s = "s"
		}
		switch srcSize {
		case 1:
			return c.temp("%s ext%sb %s\n", c.wordTag, s, v)
		case 2:
			return c.temp("%s ext%sh %s\n", c.wordTag, s, v)
		case 4:
			if dstSize == 4 {
				return v
			}

			return c.temp("%s ext%sw %s\n", c.wordTag, s, v)
		case 8:
			return v
		}
	case c.isIntegerType(dstType) && c.isIntegerType(srcType):
		//	D S
		//	u u	u
		//	u s	s
		//	s u	u
		//	s s	s
		s := "u"
		if cc.IsSignedInteger(srcType) {
			s = "s"
		}
		switch {
		case dstSize < srcSize:
			switch {
			case dstSize < 4:
				return c.temp("%s ext%s%s %s\n", c.baseType(n, dstType), s, c.extType(n, dstType), v)
			default:
				return v
			}
		case dstSize == srcSize:
			return v
		default:
			return c.temp("%s ext%s%s %s\n", c.baseType(n, dstType), s, c.extType(n, srcType), v)
		}
	case dstType.Kind() == cc.Float:
		switch k := srcType.Kind(); {
		case k == cc.Double || k == cc.LongDouble:
			return c.temp("s truncd %s\n", v)
		case c.isIntegerType(srcType):
			switch srcSize {
			case 4:
				switch {
				case cc.IsSignedInteger(srcType):
					return c.temp("s swtof %s\n", v)
				default:
					return c.temp("s uwtof %s\n", v)
				}
			case 8:
				switch {
				case cc.IsSignedInteger(srcType):
					return c.temp("s sltof %s\n", v)
				default:
					return c.temp("s ultof %s\n", v)
				}
			}
		}
	case dstType.Kind() == cc.Double || dstType.Kind() == cc.LongDouble:
		if srcType.Kind() == cc.Double || srcType.Kind() == cc.LongDouble {
			return v
		}

		switch k := srcType.Kind(); {
		case k == cc.Float:
			return c.temp("d exts %s\n", v)
		case c.isIntegerType(srcType):
			switch srcSize {
			case 4:
				switch {
				case cc.IsSignedInteger(srcType):
					return c.temp("d swtof %s\n", v)
				default:
					return c.temp("d uwtof %s\n", v)
				}
			case 8:
				switch {
				case cc.IsSignedInteger(srcType):
					return c.temp("d sltof %s\n", v)
				default:
					return c.temp("d ultof %s\n", v)
				}
			}
		}
	case c.isIntegerType(dstType) && c.isFloatingPointType(srcType):
		sgn := "u"
		if cc.IsSignedInteger(dstType) {
			sgn = "s"
		}
		f := "s"
		if srcType.Kind() == cc.Double || srcType.Kind() == cc.LongDouble {
			f = "d"
		}
		return c.temp("%s %sto%si %s\n", c.baseType(n, dstType), f, sgn, v)
	case dstType.Kind() == cc.Function && srcType.Kind() == cc.Ptr:
		return v
	case c.isIntegerType(dstType) && srcType.Kind() == cc.Ptr:
		switch {
		case dstSize <= srcSize:
			return v
		}
	}
	// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030714-1.c
	// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr49644.c
	// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr56837.c
	// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr80692.c
	panic(todo("%v: %s(%v, %v) <- %s(%v, %v) %v", n.Position(), dstType, dstType.Kind(), dstSize, srcType, srcType.Kind(), srcSize, cc.NodeSource(n)))
}

func (c *ctx) value(n cc.Node, mode mode, t cc.Type, v cc.Value, neg bool) (r any) {
	var vt cc.Type
	switch mode {
	case void:
		return nothing
	case rvalue:
		defer func() { r = c.convert(n, t, vt, r) }()
	case constRvalue:
		defer func() { r = c.convertConst(n, t, vt, r) }()
	case lvalue:
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/960416-1.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}

	switch x := v.(type) {
	case cc.Int64Value:
		vt = c.ast.LongLong
		switch {
		case neg:
			return int64Value(-int64(x))
		default:
			return int64Value(x)
		}
	case cc.UInt64Value:
		vt = c.ast.ULongLong
		switch {
		case neg:
			return uint64Value(-uint64(x))
		default:
			return uint64Value(x)
		}
	case cc.Float64Value:
		vt = c.ast.Double
		switch {
		case neg:
			return float64Value(-float64(x))
		default:
			return float64Value(float64(x))
		}
	case *cc.LongDoubleValue:
		vt = c.ast.Double
		bf := (*big.Float)(x)
		f, _ := bf.Float64()
		switch {
		case neg:
			return float64Value(-float64(f))
		default:
			return float64Value(float64(f))
		}
	default:
		panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
	}
}

func (c *ctx) primaryExpressionIdent(n *cc.PrimaryExpression, mode mode, t cc.Type) (r any) {
	d, info := c.variable(n)
	switch mode {
	case lvalue, aggRvalue:
		switch x := info.(type) {
		case *local:
			return x.name
		case *escaped:
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		case *static:
			return c.temp("%s copy %s\n", c.wordTag, x.name)
		default:
			// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000412-3.c
			// struct function argument
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
				return c.value(n, mode, t, x.Value(), false)
			}

			panic(todo("%v: %T %v", n.Position(), x, cc.NodeSource(n)))
		}
	case void:
		return nothing
	case constLvalue:
		switch x := info.(type) {
		case *static:
			return &symbolValue{sym: x.name}
		default:
			// all_test.go:341: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030224-2.c
			panic(todo("%v: %T", n.Position(), x))
		}
	case constRvalue:
		switch x := info.(type) {
		case *static:
			return x.name
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		// all_test.go:381: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20011113-1.c
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionString(n *cc.PrimaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch t.Kind() {
		case cc.Ptr:
			switch e := t.(*cc.PointerType).Elem().Kind(); e {
			case cc.Char, cc.SChar, cc.UChar, cc.Void:
				return c.addString(string(n.Value().(cc.StringValue)))
			default:
				panic(todo("%v: e=%s %v", n.Position(), e, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: t=%s %v", n.Position(), t, cc.NodeSource(n)))
		}
	case lvalue, constLvalue:
		return c.addString(string(n.Value().(cc.StringValue)))
	default:
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpressionStmt(n *cc.CompoundStatement, mode mode, t cc.Type) (r any) {
	switch mode {
	case void:
		c.compoundStatement(n)
		return nothing
	case rvalue:
		defer func() { r = c.convert(n, t, c.fn.exprStatementCtx.typ, r) }()

		c.compoundStatement(n)
		return c.fn.exprStatementCtx.expr
	default:
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20020206-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20020320-1.c
		panic(todo("%v: mode=%v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) primaryExpression(n *cc.PrimaryExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.PrimaryExpressionIdent: // IDENTIFIER
		return c.primaryExpressionIdent(n, mode, t)
	case
		cc.PrimaryExpressionChar,  // CHARCONST
		cc.PrimaryExpressionFloat, // FLOATCONST
		cc.PrimaryExpressionInt,   // INTCONST
		cc.PrimaryExpressionLChar: // LONGCHARCONST

		return c.value(n, mode, t, n.Value(), false)
	case cc.PrimaryExpressionString: // STRINGLITERAL
		return c.primaryExpressionString(n, mode, t)
	case cc.PrimaryExpressionLString: // LONGSTRINGLITERAL
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010325-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/widechar-3.c
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.PrimaryExpressionExpr: // '(' ExpressionList ')'
		return c.expr(n.ExpressionList, mode, t)
	case cc.PrimaryExpressionStmt: // '(' CompoundStatement ')'
		c.fn.exprStatementCtx = &exprStatementCtx{prev: c.fn.exprStatementCtx}

		defer func() {
			c.fn.exprStatementCtx = c.fn.exprStatementCtx.prev
		}()

		return c.primaryExpressionStmt(n.CompoundStatement, mode, t)
	case cc.PrimaryExpressionGeneric: // GenericSelection
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/tcc-0.9.27/tests/tests2/94_generic.c
		panic(todo("%v: %v %v", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) load(n cc.Node, p any, et cc.Type) (r any) {
	switch x := p.(type) {
	case *bitfieldPtr:
		f := x.f
		p := x.ptr
		ft := f.Type()
		rawBits := 32
		tag := "w"
		switch f.AccessBytes() {
		case 1:
			r = c.temp("%s loadub %s\n", c.baseType(n, ft), p)
		case 2:
			r = c.temp("%s loaduh %s\n", c.baseType(n, ft), p)
		case 4:
			r = c.temp("%s loaduw %s\n", c.baseType(n, ft), p)
		case 8:
			rawBits = 64
			tag = "l"
			r = c.temp("l loadl %s\n", p)
		default:
			panic(todo("%v: %v %s", n.Position(), f.AccessBytes(), cc.NodeSource(n)))
		}
		switch {
		case cc.IsSignedInteger(ft):
			leftBits := rawBits - int(f.ValueBits()) - f.OffsetBits()
			r = c.temp("%s shl %s, %v\n", tag, r, leftBits)
			return c.temp("%s sar %s, %v\n", tag, r, rawBits-int(f.ValueBits()))
		default:
			r = c.temp("%s and %s, %v\n", tag, r, f.Mask())
			return c.temp("%s shr %s, %v\n", tag, r, f.OffsetBits())
		}
	default:
		switch c.sizeof(n, et) {
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
			trc("PANIC %v: p=%q et=%s %s", n.Position(), p, et, cc.NodeSource(n))
			panic(todo("%v: %q %s %s", n.Position(), p, et, cc.NodeSource(n)))
		}
	}
}

func (c *ctx) store(n cc.Node, et cc.Type, v, p any) {
	switch x := p.(type) {
	case *bitfieldPtr:
		f := x.f
		p := x.ptr
		ft := f.Type()
		tag := "w"
		var fv string
		switch f.AccessBytes() {
		case 1:
			fv = c.temp("%s loadub %s\n", c.baseType(n, ft), p)
		case 2:
			fv = c.temp("%s loaduh %s\n", c.baseType(n, ft), p)
		case 4:
			fv = c.temp("%s loaduw %s\n", c.baseType(n, ft), p)
		case 8:
			tag = "l"
			fv = c.temp("l loadl %s\n", p)
		default:
			panic(todo("%v: %v %s", n.Position(), f.AccessBytes(), cc.NodeSource(n)))
		}
		fv = c.temp("%s and %s, %v\n", tag, fv, ^f.Mask())
		v = c.temp("%s shl %s, %v\n", tag, v, f.OffsetBits())
		v = c.temp("%s and %s, %v\n", tag, v, f.Mask())
		v = c.temp("%s or %s, %s\n", tag, v, fv)
		switch f.AccessBytes() {
		case 1:
			c.w("\tstoreb %s, %s\n", v, p)
		case 2:
			c.w("\tstoreh %s, %s\n", v, p)
		case 4:
			c.w("\tstorew %s, %s\n", v, p)
		case 8:
			c.w("\tstorel %s, %s\n", v, p)
		default:
			panic(todo("%v: %v %s", n.Position(), f.AccessBytes(), cc.NodeSource(n)))
		}
	default:
		c.w("\tstore%s %s, %s\n", c.extType(n, et), v, p)
	}
}

func (c *ctx) isAggType(t cc.Type) (r bool) {
	switch t.Kind() {
	case cc.Struct, cc.Union:
		return true
	}

	return false
}

func (c *ctx) assignmentExpressionAssignAggType(n *cc.AssignmentExpression, mode mode, t cc.Type) (r any) {
	lhs := c.expr(n.UnaryExpression, lvalue, n.Type())
	switch mode {
	case void:
		s := c.expr(n.AssignmentExpression, aggRvalue, n.Type())
		c.w("\tblit %s, %s, %v\n", s, lhs, n.UnaryExpression.Type().Size())
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// UnaryExpression '=' AssignmentExpression
func (c *ctx) assignmentExpressionAssign(n *cc.AssignmentExpression, mode mode, t cc.Type) (r any) {
	if c.isAggType(n.AssignmentExpression.Type()) {
		return c.assignmentExpressionAssignAggType(n, mode, t)
	}

	lhs := c.expr(n.UnaryExpression, lvalue, n.Type())
	rhs := c.expr(n.AssignmentExpression, rvalue, n.Type())
	_, info := c.variable(n.UnaryExpression)
	switch x := info.(type) {
	case *local:
		c.w("\t%s =%s copy %s\n", lhs, c.baseType(n, n.Type()), rhs)
	case *escaped, *static, nil:
		c.store(n, n.Type(), rhs, lhs)
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
		case *static, nil:
			return c.load(n, lhs, n.UnaryExpression.Type())
		default:
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

func (c *ctx) assignmentExpressionOp(n *cc.AssignmentExpression, mode mode, t cc.Type, op string) (r any) {
	switch mode {
	case void:
		lhs, rhs := n.UnaryExpression, n.AssignmentExpression
		lt, rt := lhs.Type(), rhs.Type()
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *local:
			ct := c.usualArithmeticConversions(lt, rt)
			var v any
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(n, lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.w("\t%s =%s copy %s\n", x.name, c.baseType(n, lt), v)
		case *static:
			ct := c.usualArithmeticConversions(lt, rt)
			var v any
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(n, lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.store(n, lt, v, x.name)
		default:
			ct := c.usualArithmeticConversions(lt, rt)
			switch op {
			case "shl", "shr":
				c.shiftop(lhs, rhs, lvalue, ct, op)
			default:
				c.arithmeticOp(n, lhs, rhs, lvalue, ct, op)
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
			var v any
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(n, lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.w("\t%s =%s copy %s\n", x.name, c.baseType(n, lt), v)
			return c.temp("%s copy %s\n", c.baseType(n, lt), x.name)
		case *static:
			ct := c.usualArithmeticConversions(lt, rt)
			var v any
			switch op {
			case "shl", "shr":
				v = c.shiftop(lhs, rhs, rvalue, ct, op)
			default:
				v = c.arithmeticOp(n, lhs, rhs, rvalue, ct, op)
			}
			v = c.convert(n, lt, ct, v)
			c.store(n, lt, v, x.name)
			return c.load(n, x.name, lt)
		case nil:
			ct := c.usualArithmeticConversions(lt, rt)
			var lv any
			switch op {
			case "shl", "shr":
				lv = c.shiftop(lhs, rhs, lvalue, ct, op)
			default:
				lv = c.arithmeticOp(n, lhs, rhs, lvalue, ct, op)
			}
			return c.load(n, lv, lt)
		default:
			// trc("%v: %v %T %v", n.Position(), mode, x, cc.NodeSource(n))
			panic(todo("%v: %v %T %v", n.Position(), mode, x, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %v %v", n.Position(), mode, cc.NodeSource(n)))
	}
}

func (c *ctx) assignmentExpression(n *cc.AssignmentExpression, mode mode, t cc.Type) (r any) {
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
	if d := c.declaratorOf(unparen(n)); d != nil && d.Type().Kind() == cc.Function {
		if r = d.Type().(*cc.FunctionType); len(r.Parameters()) != 0 {
			return r
		}

		// d is an implicit or incomplete prototype of the form '[type] f()', try to
		// find a better definition/prototype.
		nm := d.Name()
		a := c.ast.Scope.Nodes[nm]
		a = a[:len(a):len(a)]
		const prefix = "__builtin_"
		switch {
		case strings.HasPrefix(nm, prefix):
			nm = nm[len(prefix):]
			a = append(a, c.ast.Scope.Nodes[nm]...)
		default:
			a = append(a, c.ast.Scope.Nodes[prefix+nm]...)
		}
		for _, v := range a {
			if x, ok := v.(*cc.Declarator); ok && x.Type().Kind() == cc.Function {
				if r = x.Type().(*cc.FunctionType); len(r.Parameters()) != 0 {
					return r
				}
			}
		}
	}

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

// PostfixExpression '(' ArgumentExpressionList ')'
func (c *ctx) vaStart(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	if n.ArgumentExpressionList == nil {
		c.err(n, "missing argument")
		return nothing
	}

	arg := n.ArgumentExpressionList.AssignmentExpression
	_, info := c.variable(arg)
	switch mode {
	case void:
		switch x := info.(type) {
		case *escaped:
			p := c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
			c.w("\tvastart %s\n", p)
		case nil:
			p := c.expr(arg, lvalue, c.ast.PVoid)
			c.w("\tvastart %s\n", p)
		case *local:
			c.w("\tvastart %s\n", x.name)
		case *static:
			c.w("\tvastart %s\n", x.name)
		default:
			panic(todo("%v: %T %s", n.Position(), info, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// PostfixExpression '(' ArgumentExpressionList ')'
func (c *ctx) vaArg(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	if n.ArgumentExpressionList == nil {
		c.err(n, "missing argument")
		return nothing
	}

	switch mode {
	case rvalue, void:
		// Intentionally no call to convert here.

		vaListExpr := n.ArgumentExpressionList.AssignmentExpression
		switch d, info := c.variable(vaListExpr); {
		case d != nil && d.IsParam():
			return c.temp("%s vaarg %s\n", c.baseType(n, t), info.(*local).name)
		default:
			vaList := c.expr(vaListExpr, rvalue, c.ast.PVoid)
			return c.temp("%s vaarg %s\n", c.baseType(n, t), vaList)
		}
	default:
		panic(todo("%v: %s %s %s", n.Position(), mode, cc.NodeSource(n), t))
	}
	return r
}

func (c *ctx) isVaList(d *cc.Declarator) (r bool) {
	if d == nil {
		return false
	}

	if x, ok := d.Type().(*cc.PointerType); ok {
		if x.Elem().String() == "__qbe_va_list_elem" {
			return true
		}
	}
	return false
}

func (c *ctx) isMemcpy(n cc.ExpressionNode) (r bool) {
	if d := c.declaratorOf(n); d != nil {
		if !d.IsFuncDef() && (d.Name() == "memcpy" || d.Name() == "__builtin_memcpy") {
			return true
		}
	}

	return false
}

// PostfixExpression '(' ArgumentExpressionList ')'
func (c *ctx) postfixExpressionCall(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	if x, ok := unparen(n.PostfixExpression).(*cc.PrimaryExpression); ok && x.Case == cc.PrimaryExpressionIdent {
		switch x.Token.SrcStr() {
		case "__builtin_va_start":
			return c.vaStart(n, mode, t)
		case "__builtin_va_arg":
			return c.vaArg(n, mode, t)
		case "__builtin_va_end":
			return nothing
		}
	}

	callee := n.PostfixExpression
	isMemcpy := c.isMemcpy(callee)
	ct := c.ft(callee)
	//trc("%v: %v %T %v", n.Position(), cc.NodeSource(n), ct, ct)
	params := ct.Parameters()
	switch {
	case len(params) == 1 && params[0].Type().Kind() == cc.Void:
		params = nil
	}
	var args []cc.ExpressionNode
	var exprs []any
	var types []cc.Type
	for iArg, l := 0, n.ArgumentExpressionList; l != nil; iArg, l = iArg+1, l.ArgumentExpressionList {
		e := l.AssignmentExpression
		args = append(args, e)
		et := e.Type()
		isVaList := false
		switch {
		case len(exprs) < len(params):
			param := params[len(exprs)]
			isVaList = c.isVaList(param.Declarator)
			et = params[len(exprs)].Type()
		default:
			switch {
			case c.isIntegerType(et):
				et = cc.IntegerPromotion(et)
			case et.Kind() == cc.Float:
				et = c.ast.Double
			}
		}
		d, info := c.variable(e)
		var expr any
		switch x := info.(type) {
		case *local:
			if isMemcpy && iArg < 2 {
				expr = x.name
				break
			}

			expr = c.expr(e, rvalue, et)
		default:
			switch {
			case c.isAggType(et):
				expr = c.expr(e, lvalue, et)
			default:
				expr = c.expr(e, rvalue, et)
			}
		}
		if isVaList {
			switch {
			case d != nil && d.IsParam():
				// nop
			default:
				nm := fmt.Sprintf("%%._va_list%d", c.fn.id()) // va_list[0] is va_arg
				c.w("\t%s =%s copy %s\n", nm, c.wordTag, expr)
				expr = nm
			}
		}
		exprs = append(exprs, expr)
		types = append(types, et)
	}
	if len(exprs) > len(params) && (len(params) == 0 || !ct.IsVariadic()) {
		c.err(n, "arguments '%s' do not match signature '%s' (missing prototype?)", cc.NodeSource(n.ArgumentExpressionList), ct)
	}
	r = nothing
	switch mode {
	case void:
		switch {
		case n.Type().Kind() != cc.Void:
			c.temp("%s call %s(", c.abiType(n, n.Type()), c.expr(callee, rvalue, ct))
		default:
			c.w("\tcall %s(", c.expr(callee, rvalue, ct))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch {
		case c.isIntegerType(n.Type()) || c.isFloatingPointType(n.Type()) || n.Type().Kind() == cc.Ptr:
			r = c.temp("%s call %s(", c.abiType(n, ct.Result()), c.expr(callee, rvalue, ct))
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/990525-2.c
			// struct typed function result
			panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
		}
	case aggRvalue:
		r = c.temp("%s call %s(", c.abiType(n, ct.Result()), c.expr(callee, rvalue, ct))
	default:
		switch _, info := c.variable(n); x := info.(type) {
		case *escaped:
			r = c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
			v := c.temp("%s call %s(", c.abiType(n, ct.Result()), c.expr(callee, rvalue, ct))
			defer c.w("\tblit %s, %s, %v\n", v, r, ct.Result().Size())
		default:
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	}
	for i, expr := range exprs {
		if i == len(params) {
			c.w("...,")
		}
		c.w("%s %s,", c.abiType(args[i], types[i]), expr)
	}
	if ct.IsVariadic() && len(exprs) == len(params) {
		c.w("...,w 0")
	}
	c.w(")\n")
	return r
}

func unparen(n cc.ExpressionNode) cc.ExpressionNode {
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
func (c *ctx) postfixExpressionIncDec(n *cc.PostfixExpression, mode mode, t cc.Type, op string) (r any) {
	_, info := c.variable(n.PostfixExpression)
	idelta := int64(1)
	if x, ok := n.PostfixExpression.Type().(*cc.PointerType); ok {
		idelta = c.sizeof(n.PostfixExpression, x.Elem())
	}
	delta := c.value(n, constRvalue, n.PostfixExpression.Type(), cc.Int64Value(idelta), false)
	switch mode {
	case void:
		switch x := info.(type) {
		case *local:
			v := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			c.w("\t%s =%s %s %[1]s, %[4]v\n", v, c.baseType(n, n.PostfixExpression.Type()), op, delta)
		case *static:
			v := c.load(n, x.name, x.d.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, v, delta)
			c.store(n, x.d.Type(), v, x.name)
		case nil, *escaped:
			p := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			v := c.load(n, p, n.PostfixExpression.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, v, delta)
			c.store(n, n.PostfixExpression.Type(), v, p)
		default:
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
			c.store(n, x.d.Type(), v, x.name)
		case nil:
			p := c.expr(n.PostfixExpression, lvalue, n.PostfixExpression.Type())
			r = c.load(n, p, n.PostfixExpression.Type())
			v := c.temp("%s %s %s, %v\n", c.baseType(n, n.PostfixExpression.Type()), op, r, delta)
			c.store(n, n.PostfixExpression.Type(), v, p)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

type bitfieldPtr struct {
	f   *cc.Field
	ptr any
}

// PostfixExpression '.' IDENTIFIER
func (c *ctx) postfixExpressionSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	f := n.Field()
	switch mode {
	case lvalue:
		p := c.expr(n.PostfixExpression, mode, nil)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
		}
		return p
	case rvalue:
		if f.Type().Kind() == cc.Array {
			return c.postfixExpression(n, lvalue, t)
		}

		defer func() { r = c.convert(n, t, n.Type(), r) }()

		p := c.expr(n.PostfixExpression, lvalue, nil)
		c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
			// all_test.go:345: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000914-1.c
			//TODO aborts
		}
		return c.load(n, p, f.Type())
	case void:
		if f.Type().Kind() == cc.Array {
			c.postfixExpression(n, lvalue, t)
			return nothing
		}

		p := c.expr(n.PostfixExpression, lvalue, nil)
		c.w("\t%s =%s add %s, %v\n", p, c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
			// all_test.go:345: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000914-1.c
			//TODO aborts
		}
		c.load(n, p, f.Type())
		return nothing
	case constLvalue:
		switch x := c.expr(n.PostfixExpression, constLvalue, nil).(type) {
		case *symbolValue:
			x.off += f.Offset()
			return x
		default:
			// all_test.go:341: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/lto-tbaa-1.c
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	case aggRvalue:
		p := c.expr(n.PostfixExpression, mode, nil)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		return p
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// PostfixExpression "->" IDENTIFIER
func (c *ctx) postfixExpressionPSelect(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	f := n.Field()
	switch mode {
	case lvalue:
		p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
		}
		return p
	case rvalue:
		if f.Type().Kind() == cc.Array {
			return c.postfixExpression(n, lvalue, t)
		}

		defer func() { r = c.convert(n, t, n.Type(), r) }()

		p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
		}
		return c.load(n, p, f.Type())
	case void:
		if f.Type().Kind() == cc.Array {
			c.postfixExpression(n, lvalue, t)
			return nothing
		}

		p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		if f.IsBitfield() {
			p = &bitfieldPtr{f: f, ptr: p}
		}
		c.load(n, p, f.Type())
		return nothing
	case aggRvalue:
		p := c.expr(n.PostfixExpression, rvalue, c.ast.PVoid)
		p = c.temp("%s add %s, %v\n", c.wordTag, p, f.Offset())
		return p
	default:
		// all_test.go:356: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/const-addr-expr-1.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// PostfixExpression '[' ExpressionList ']'
func (c *ctx) postfixExpressionIndex(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	var ptrExpr, indexExpr cc.ExpressionNode
	switch {
	case c.isIntegerType(n.PostfixExpression.Type()):
		ptrExpr = n.ExpressionList
		indexExpr = n.PostfixExpression
	default:
		ptrExpr = n.PostfixExpression
		indexExpr = n.ExpressionList
	}
	elemType := ptrExpr.Type().(*cc.PointerType).Elem()
	elemSize := elemType.Size()
	switch mode {
	case lvalue, aggRvalue:
		p := c.expr(ptrExpr, rvalue, c.ast.PVoid)
		x := c.expr(indexExpr, rvalue, c.ast.PVoid)
		if elemSize != 1 {
			x = c.temp("%s mul %s, %v\n", c.wordTag, x, c.sizeof(n.PostfixExpression, elemType))
		}
		return c.temp("%s add %s, %s\n", c.wordTag, p, x)
	case rvalue:
		defer func() { r = c.convert(n, t, elemType, r) }()

		p := c.expr(ptrExpr, rvalue, c.ast.PVoid)
		x := c.expr(indexExpr, rvalue, c.ast.PVoid)
		if elemSize != 1 {
			x = c.temp("%s mul %s, %v\n", c.wordTag, x, c.sizeof(n.PostfixExpression, elemType))
		}
		p = c.temp("%s add %s, %s\n", c.wordTag, p, x)
		switch {
		case elemType.Kind() == cc.Array:
			elemType = c.ast.PVoid
			return p
		default:
			return c.load(n, p, elemType)
		}
	case constLvalue:
		p := c.expr(ptrExpr, constLvalue, c.ast.PVoid)
		x := c.expr(indexExpr, constRvalue, c.ast.PVoid)
		switch y := x.(type) {
		case int64Value:
			return fmt.Sprintf("%s+%v", p, int64(y)*elemSize)
		case uint64Value:
			return fmt.Sprintf("%s+%v", p, int64(y)*elemSize)
		default:
			panic(todo("%v: %T %s", n.Position(), y, cc.NodeSource(n)))
		}
	case void:
		p := c.expr(ptrExpr, rvalue, c.ast.PVoid)
		x := c.expr(indexExpr, rvalue, c.ast.PVoid)
		switch {
		case elemType.Kind() == cc.Array:
			// nop
		default:
			if elemSize != 1 {
				x = c.temp("%s mul %s, %v\n", c.wordTag, x, c.sizeof(n.PostfixExpression, elemType))
			}
			p = c.temp("%s add %s, %s\n", c.wordTag, p, x)
			c.load(n, p, elemType)
		}
		return nothing
	default:
		// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr66556.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '(' TypeName ')' '{' InitializerList ',' '}'
func (c *ctx) postfixExpressionComplit(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
	_, info := c.variable(n)
	switch mode {
	case lvalue:
		switch x := info.(type) {
		case *complit:
			c.initializerList(n.InitializerList, x, n.TypeName.Type())
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		default:
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	case aggRvalue:
		switch x := info.(type) {
		case *complit:
			c.initializerList(n.InitializerList, x, n.TypeName.Type())
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		default:
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	default:
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030224-2.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20050929-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr22098-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr22098-2.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr22098-3.c
		panic(todo("%v: %v %s %s->%s", n.Position(), mode, cc.NodeSource(n), n.TypeName.Type(), t))
	}
	return r
}

func (c *ctx) postfixExpression(n *cc.PostfixExpression, mode mode, t cc.Type) (r any) {
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
		return c.postfixExpressionComplit(n, mode, t)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// '-' CastExpression
func (c *ctx) unaryExpressionMinus(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		e := c.expr(n.CastExpression, mode, n.Type())
		return c.temp("%s neg %s\n", c.baseType(n, n.Type()), e)
	case constRvalue:
		return c.value(n, mode, t, n.CastExpression.Value(), true)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '+' CastExpression
func (c *ctx) unaryExpressionPlus(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return c.expr(n.CastExpression, mode, t)
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '&' CastExpression
func (c *ctx) unaryExpressionAddrof(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
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
		case *complit:
			c.initializerList(x.n.InitializerList, x, x.n.TypeName.Type())
			return c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	case constRvalue:
		defer func() { r = c.convertConst(n, t, n.Type(), r) }()

		return c.expr(n.CastExpression, constLvalue, n.Type())
	case void:
		return nothing
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// '*' CastExpression
func (c *ctx) unaryExpressionDeref(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case void:
		switch et := n.Type(); {
		case et.Kind() == cc.Ptr:
			switch x := n.CastExpression.Type().(type) {
			case *cc.PointerType:
				switch y := x.Elem().(type) {
				case *cc.ArrayType:
					c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
				default:
					panic(todo("%v: %T %s", n.Position(), y, cc.NodeSource(n.CastExpression)))
				}
			default:
				panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n.CastExpression)))
			}
		default:
			// all_test.go:356: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20060929-1.c
			panic(todo("%v: %v %s", n.Position(), et, cc.NodeSource(n)))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		// trc("%v: %s et=%s(%s)", n.Position(), cc.NodeSource(n), n.Type(), n.Type().Undecay())
		// trc("cet=%s(%s)", n.CastExpression.Type(), n.CastExpression.Type().Undecay())
		switch et := n.Type().Undecay(); {
		case et.Kind() == cc.Ptr:
			switch x := n.CastExpression.Type().(type) {
			case *cc.PointerType:
				switch x.Elem().(type) {
				case *cc.FunctionType:
					return c.expr(n.CastExpression, rvalue, x)
				case *cc.ArrayType:
					return c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
				default:
					p := c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
					return c.load(n, p, et)
				}
			default:
				panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n.CastExpression)))
			}
		case c.isIntegerType(et) || c.isFloatingPointType(et) || et.Kind() == cc.Ptr:
			return c.load(n, c.expr(n.CastExpression, rvalue, n.CastExpression.Type()), et)
		case et.Kind() == cc.Array:
			return c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
		case et.Kind() == cc.Function:
			return c.expr(n.CastExpression, rvalue, et)
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-10.c
			panic(todo("%v: %v %s", n.Position(), et.Kind(), cc.NodeSource(n)))
		}
	case lvalue:
		return c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
	case aggRvalue:
		return c.expr(n.CastExpression, rvalue, n.CastExpression.Type())
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "sizeof" UnaryExpression
func (c *ctx) unaryExpressionSizeofExpr(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		if x, ok := n.UnaryExpression.Type().(*cc.PointerType); ok {
			if y, ok := x.Undecay().(*cc.ArrayType); ok {
				return fmt.Sprint(y.Len() * c.sizeof(n.UnaryExpression, y.Elem()))
			}
		}

		return fmt.Sprint(c.sizeof(n.UnaryExpression, n.UnaryExpression.Type()))
	case void:
		return nothing
	default:
		// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr58831.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "sizeof" '(' TypeName ')'
func (c *ctx) unaryExpressionSizeofType(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		return fmt.Sprint(c.sizeof(n.TypeName, n.TypeName.Type()))
	default:
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// "_Alignof" UnaryExpression
func (c *ctx) unaryExpressionAlignofExpr(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) unaryExpressionAlignofType(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) unaryExpressionIncDec(n *cc.UnaryExpression, mode mode, t cc.Type, op string) (r any) {
	_, info := c.variable(n.UnaryExpression)
	idelta := int64(1)
	if x, ok := n.UnaryExpression.Type().(*cc.PointerType); ok {
		idelta = c.sizeof(n.PostfixExpression, x.Elem())
	}
	delta := c.value(n, constRvalue, n.UnaryExpression.Type(), cc.Int64Value(idelta), false)
	switch mode {
	case void:
		switch x := info.(type) {
		case *local:
			v := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
			c.w("\t%s =%s %s %[1]s, %[4]v\n", v, c.baseType(n, n.UnaryExpression.Type()), op, delta)
		case *static:
			v := c.load(n, x.name, x.d.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.store(n, x.d.Type(), v, x.name)
		case nil:
			p := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
			v := c.load(n, p, n.UnaryExpression.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.store(n, n.UnaryExpression.Type(), v, p)
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		switch x := info.(type) {
		case *local:
			v := c.expr(n.UnaryExpression, rvalue, n.UnaryExpression.Type())
			c.w("\t%s =%s %s %s, %v\n", x.name, c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			return c.expr(n.UnaryExpression, rvalue, n.UnaryExpression.Type())
		case *static:
			v := c.load(n, x.name, x.d.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.store(n, x.d.Type(), v, x.name)
			return c.expr(n.UnaryExpression, rvalue, n.UnaryExpression.Type())
		case nil:
			p := c.expr(n.UnaryExpression, lvalue, n.UnaryExpression.Type())
			v := c.load(n, p, n.UnaryExpression.Type())
			v = c.temp("%s %s %s, %v\n", c.baseType(n, n.UnaryExpression.Type()), op, v, delta)
			c.store(n, n.UnaryExpression.Type(), v, p)
			r = v
		default:
			panic(todo("%v: %T", n.Position(), x))
		}
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// '~' CastExpression
func (c *ctx) unaryExpressionCpl(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		v := c.expr(n.CastExpression, rvalue, n.Type())
		k := ^int64(0)
		if c.sizeof(n, n.Type()) < 8 {
			k = 0xffffffff
		}
		r = c.temp("%s xor %s, %v\n", c.baseType(n, n.Type()), v, k)
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

// '!' CastExpression
func (c *ctx) unaryExpressionNot(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) unaryExpressionRealImag(n *cc.UnaryExpression, mode mode, t cc.Type, imag bool) (r any) {
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
		off = c.sizeof(n.UnaryExpression, et)
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

func (c *ctx) unaryExpression(n *cc.UnaryExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) relop(lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r any) {
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
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr85529-1.c
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
}

func (c *ctx) relationalExpression(n *cc.RelationalExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) equalityExpression(n *cc.EqualityExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) elemSize(t cc.Type) (r int64) {
	switch x := t.Undecay().(type) {
	case *cc.ArrayType:
		return x.Elem().Undecay().Size()
	case *cc.PointerType:
		return x.Elem().Undecay().Size()
	default:
		return 1
	}
}

func (c *ctx) arithmeticOp(n, lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r any) {
	lt, rt := lhs.Type(), rhs.Type()
	ct := c.usualArithmeticConversions(lt, rt)
	rmul := int64(1)
	lmul := int64(1)
	div := int64(1)
	switch op {
	case "add":
		lmul = c.elemSize(rt)
		rmul = c.elemSize(lt)
	case "sub":
		switch {
		case lt.Kind() == cc.Ptr && rt.Kind() == cc.Ptr:
			div = c.elemSize(lt)
		case lt.Kind() == cc.Ptr:
			rmul = c.elemSize(lt)
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
			rv := c.expr(rhs, rvalue, ct)
			lv := c.load(lhs, r, lhs.Type())
			lv = c.convert(lhs, ct, lhs.Type(), lv)
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
			c.store(lhs, lhs.Type(), v, r)
		case *local:
			rv := c.expr(rhs, rvalue, ct)
			lv := c.convert(lhs, ct, lhs.Type(), x.name)
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
			// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/const-addr-expr-1.c
			panic(todo("%v: %T", lhs.Position(), x))
		}
	case constRvalue:
		switch nv := n.Value().(type) {
		case *cc.UnknownValue:
			switch lv := lhs.Value().(type) {
			case *cc.LongDoubleValue:
				l := (*big.Float)(lv)
				switch rv := rhs.Value().(type) {
				case *cc.LongDoubleValue:
					r := (*big.Float)(rv)
					var v big.Float
					var f float64
					switch op {
					case "add":
						f, _ = v.Add(l, r).Float64()
					case "div":
						f, _ = v.Quo(l, r).Float64()
					case "mul":
						f, _ = v.Mul(l, r).Float64()
					case "sub":
						f, _ = v.Sub(l, r).Float64()
					default:
						panic(todo("%v: %v %s %s %s %q", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), op))
					}
					return float64Value(f)
				default:
					panic(todo("%v: %v %s %s %s %T", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), rv))
				}
			case cc.Float64Value:
				l := float64(lv)
				switch rv := rhs.Value().(type) {
				case cc.Float64Value:
					r := float64(rv)
					var f float64
					switch op {
					case "add":
						f = l + r
					case "div":
						f = l / r
					case "mul":
						f = l * r
					case "sub":
						f = l - r
					default:
						panic(todo("%v: %v %s %s %s %q", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), op))
					}
					return float64Value(f)
				default:
					panic(todo("%v: %v %s %s %s %T", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), rv))
				}
			default:
				// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr53084.c
				panic(todo("%v: %v %s %s %s %T", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), lv))
			}
		default:
			panic(todo("%v: %v %s %s %s %T", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs), nv))
		}
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
	return r
}

func (c *ctx) additiveExpression(n *cc.AdditiveExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.AdditiveExpressionMul: // MultiplicativeExpression
		return c.expr(n.MultiplicativeExpression, mode, t)
	case cc.AdditiveExpressionAdd: // AdditiveExpression '+' MultiplicativeExpression
		return c.arithmeticOp(n, n.AdditiveExpression, n.MultiplicativeExpression, mode, t, "add")
	case cc.AdditiveExpressionSub: // AdditiveExpression '-' MultiplicativeExpression
		return c.arithmeticOp(n, n.AdditiveExpression, n.MultiplicativeExpression, mode, t, "sub")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

// LogicalOrExpression "||" LogicalAndExpression
func (c *ctx) logicalOrExpressionLOr(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) logicalAndExpressionLAnd(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) logicalOrExpression(n *cc.LogicalOrExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) logicalAndExpression(n *cc.LogicalAndExpression, mode mode, t cc.Type) (r any) {
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

func (c *ctx) multiplicativeExpression(n *cc.MultiplicativeExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.MultiplicativeExpressionCast: // CastExpression
		return c.expr(n.CastExpression, mode, t)
	case cc.MultiplicativeExpressionMul: // MultiplicativeExpression '*' CastExpression
		return c.arithmeticOp(n, n.MultiplicativeExpression, n.CastExpression, mode, t, "mul")
	case cc.MultiplicativeExpressionDiv: // MultiplicativeExpression '/' CastExpression
		return c.arithmeticOp(n, n.MultiplicativeExpression, n.CastExpression, mode, t, "div")
	case cc.MultiplicativeExpressionMod: // MultiplicativeExpression '%' CastExpression
		return c.arithmeticOp(n, n.MultiplicativeExpression, n.CastExpression, mode, t, "rem")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) inclusiveOrExpression(n *cc.InclusiveOrExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.InclusiveOrExpressionXor: // ExclusiveOrExpression
		return c.expr(n.ExclusiveOrExpression, mode, t)
	case cc.InclusiveOrExpressionOr: // InclusiveOrExpression '|' ExclusiveOrExpression
		return c.arithmeticOp(n, n.InclusiveOrExpression, n.ExclusiveOrExpression, mode, t, "or")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) exclusiveOrExpression(n *cc.ExclusiveOrExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.ExclusiveOrExpressionAnd: // AndExpression
		return c.expr(n.AndExpression, mode, t)
	case cc.ExclusiveOrExpressionXor: // ExclusiveOrExpression '^' AndExpression
		return c.arithmeticOp(n, n.ExclusiveOrExpression, n.AndExpression, mode, t, "xor")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) andExpression(n *cc.AndExpression, mode mode, t cc.Type) (r any) {
	switch n.Case {
	case cc.AndExpressionEq: // EqualityExpression
		return c.expr(n.EqualityExpression, mode, t)
	case cc.AndExpressionAnd: // AndExpression '&' EqualityExpression
		return c.arithmeticOp(n, n.AndExpression, n.EqualityExpression, mode, t, "and")
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nothing
	}
}

func (c *ctx) shiftop(lhs, rhs cc.ExpressionNode, mode mode, t cc.Type, op string) (r any) {
	lt, rt := lhs.Type(), rhs.Type()
	plt := cc.IntegerPromotion(lt)
	prt := cc.IntegerPromotion(rt)
	switch op {
	case "shr":
		if cc.IsSignedInteger(plt) {
			op = "sar"
		}
	}
	switch mode {
	case rvalue:
		defer func() { r = c.convert(lhs, t, plt, r) }()

		return c.temp("%s %s %s, %s\n", c.baseType(lhs, plt), op, c.expr(lhs, rvalue, plt), c.expr(rhs, rvalue, prt))
	case lvalue:
		// stores operation result in lhs
		r = c.expr(lhs, lvalue, lhs.Type())
		_, info := c.variable(lhs)
		switch x := info.(type) {
		case *escaped, nil:
			rv := c.expr(rhs, rvalue, prt)
			lv := c.load(lhs, r, lt)
			lv = c.convert(lhs, plt, lt, lv)
			v := c.temp("%s %s %s, %s\n", c.baseType(lhs, plt), op, lv, rv)
			c.store(lhs, lt, v, r)
		default:
			panic(todo("%v: %T", lhs.Position(), x))
		}
	default:
		panic(todo("%v: %v %s %s %s", lhs.Position(), mode, cc.NodeSource(lhs), op, cc.NodeSource(rhs)))
	}
	return r
}

func (c *ctx) shiftExpression(n *cc.ShiftExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) castExpressionCast(n *cc.CastExpression, mode mode, t cc.Type) (r any) {
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, n.Type(), r) }()

		r = c.expr(n.CastExpression, mode, n.Type())
	case void:
		r = nothing
		c.expr(n.CastExpression, mode, n.Type())
	case lvalue:
		return c.expr(n.CastExpression, lvalue, c.ast.PVoid)
	case constRvalue:
		defer func() { r = c.convertConst(n, t, n.Type(), r) }()

		r = c.expr(n.CastExpression, mode, n.Type())
	case aggRvalue:
		return c.expr(n.CastExpression, aggRvalue, c.ast.PVoid)
	default:
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/920908-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-10.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-12.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-14.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-2.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-4.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-6.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/931004-8.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/stdarg-3.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/strct-stdarg-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/strct-varg-1.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/va-arg-22.c
		// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c
		// all_test.go:381: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/920625-1.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) castExpression(n *cc.CastExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) conditionalExpressionCond(n *cc.ConditionalExpression, mode mode, t cc.Type) (r any) {
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
		c.expr(n.ExpressionList, mode, n.ExpressionList.Type())
		c.w("%s\n", x)
		c.w("\tjmp %s\n", z)
		c.w("%s\n", b)
		c.expr(n.ConditionalExpression, mode, n.ExpressionList.Type())
		c.w("%s\n", z)
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20071120-1.c
		panic(todo("%v: %s %s", n.Position(), mode, cc.NodeSource(n)))
	}
	return r
}

func (c *ctx) conditionalExpression(n *cc.ConditionalExpression, mode mode, t cc.Type) (r any) {
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
func (c *ctx) expressionList(n *cc.ExpressionList, mode mode, t cc.Type) (r any) {
	for ; n != nil; n = n.ExpressionList {
		m := mode
		if n.ExpressionList != nil {
			m = void
		}
		r = c.expr(n.AssignmentExpression, m, t)
	}
	return r
}

func (c *ctx) expr(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
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
		return c.value(n, mode, t, n.Value(), false)
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
