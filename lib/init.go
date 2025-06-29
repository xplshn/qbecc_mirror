// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

// local
// escaped
// static
// global

func (c *ctx) declare(n cc.Node, v variable) {
	switch x := v.(type) {
	case *local:
		c.w("\t%s =%s copy 0\n", x.name, c.baseType(n, x.d.Type()))
	case *escaped:
		// nop
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}

// func (c *ctx) zero(n cc.Node, v variable) {
// 	panic(todo(""))
// }

func (c *ctx) initialize(n *cc.Initializer, v variable, off int64, t cc.Type) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		c.initializeExpr(n.AssignmentExpression, v, off, t)
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		c.initializeInitList(n.InitializerList, v, off, t)
	default:
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (c *ctx) initializeExpr(n cc.ExpressionNode, v variable, off int64, t cc.Type) {
	switch x := v.(type) {
	case *local:
		if off != 0 {
			panic(todo("%v: %v %s", n.Position(), off, cc.NodeSource(n)))
		}

		e := c.expr(n, rvalue, x.d.Type())
		c.w("\t%s =%s copy %s\n", x.name, c.baseType(n, x.d.Type()), e)
	case *escaped:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset+off)
		e := c.expr(n, rvalue, t)
		c.w("\tstore%s %s, %s\n", c.extType(n, t), e, p)
	case *static:
		// 6.7.8 Initialization/4
		//
		// All the expressions in an initializer for an object that has static storage
		// duration shall be constant expressions or string literals.
		switch x := n.Value().(type) {
		case *cc.UnknownValue:
			switch y := n.(type) {
			case *cc.UnaryExpression:
				switch y.Case {
				case cc.UnaryExpressionPostfix: //  PostfixExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionInc: // "++" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionDec: // "--" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionAddrof: // '&' CastExpression
					switch d := c.declaratorOf(y.CastExpression); {
					case d != nil:
						c.w("%s $%s,\n", c.wordTag, d.Name())
					default:
						panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
					}
				case cc.UnaryExpressionDeref: // '*' CastExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionPlus: // '+' CastExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionMinus: // '-' CastExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionCpl: // '~' CastExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionNot: // '!' CastExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionSizeofExpr: // "sizeof" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionSizeofType: // "sizeof" '(' TypeName ')'
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionLabelAddr: // "&&" IDENTIFIER
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionAlignofExpr: // "_Alignof" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionAlignofType: // "_Alignof" '(' TypeName ')'
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionImag: // "__imag__" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				case cc.UnaryExpressionReal: // "__real__" UnaryExpression
					panic(todo("%v: %v %v", n.Position(), y.Case, cc.NodeSource(n)))
				default:
					panic(todo("%v: %v %s", n.Position(), y.Case, cc.NodeSource(n)))
				}
			default:
				// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20070614-1.c
				panic(todo("%v: %T %s", n.Position(), y, cc.NodeSource(n)))
			}
		case cc.Int64Value:
			c.w("%s %s", c.extType(n, t), c.value(n, rvalue, t, x))
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000314-3.c
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}

func (c *ctx) initializeInitList(n *cc.InitializerList, v variable, off int64, t cc.Type) {
	switch {
	case t.Kind() == cc.Array:
		c.initializeInitListArray(n, v, off, t.(*cc.ArrayType))
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000113-1.c
		panic(todo("%v: %v %s", n.Position(), t, cc.NodeSource(n)))
	}
}

func (c *ctx) initializeInitListArray(n *cc.InitializerList, v variable, off int64, t *cc.ArrayType) {
	et := t.Elem()
	esz := et.Size()
	switch x := v.(type) {
	case *escaped:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, x.offset+off)
		c.w("\tcall $memset(%s %s, w 0, %[1]s %[3]v)\n", c.wordTag, p, t.Size())
		var ix int64
		for ; n != nil; n = n.InitializerList {
			if n.Designation != nil {
				panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
			}
			c.initialize(n.Initializer, v, off+esz*ix, et)
			ix++
		}
	default:
		// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000403-1.c
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
