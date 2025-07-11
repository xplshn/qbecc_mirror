// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"slices"
	"strconv"

	"modernc.org/cc/v4"
)

// initializer list reader
type initListReader struct {
	n *cc.InitializerList
}

func newInitListReader(n *cc.InitializerList) (r *initListReader) {
	return &initListReader{n}
}

func (lr *initListReader) peek() (r *cc.InitializerList) {
	return lr.n
}

func (lr *initListReader) consume() {
	if lr.n != nil {
		lr.n = lr.n.InitializerList
	}
}

type initMapItem struct {
	expr cc.ExpressionNode
	t    cc.Type
}

func (n *initMapItem) String() string {
	return fmt.Sprintf("%v: %s %s", n.expr.Position(), cc.NodeSource(n.expr), n.t)
}

// initializer renderer
type initMap map[int64]*initMapItem // offset: item

func (c *ctx) initLocalVar(n cc.Node, v *local, t cc.Type, m initMap, offs []int64) {
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		c.w("\t%s =%s copy 0\n", v.name, c.baseType(n, v.d.Type()))
	}
	switch len(m) {
	case 1:
		item := m[offs[0]]
		e := c.expr(item.expr, rvalue, v.d.Type())
		c.w("\t%s =%s copy %s\n", v.name, c.baseType(n, v.d.Type()), e)
	default:
		panic(todo("", n.Position(), cc.NodeSource(n), v, t, m))
	}
}

func (c *ctx) initEscapedVar(n cc.Node, v *escaped, t cc.Type, m initMap, offs []int64) {
	zeroed := false
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset)
		c.w("\tcall $memset(%s %s, w 0, %[1]s %[3]v)\n", c.wordTag, p, c.sizeof(n, t))
		zeroed = true
	}
	for _, off := range offs {
		item := m[off]
		if zeroed {
			switch x := item.expr.Value().(type) {
			case cc.Int64Value:
				if x == 0 {
					continue
				}
			case cc.UInt64Value:
				if x == 0 {
					continue
				}
			case cc.Float64Value:
				if x == 0 {
					continue
				}
			}
		}
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset+off)
		switch item.t.Kind() {
		case cc.Array:
			at := item.t.(*cc.ArrayType)
			switch x := item.expr.Value().(type) {
			case cc.StringValue:
				switch al, sl := at.Len(), int64(len(x)); {
				case al < sl:
					panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
				case al == sl:
					c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), al)
				default: // al > sl
					switch {
					case zeroed:
						c.w("\tcall $strcpy(%s %s, %[1]s %[3]s)\n", c.wordTag, p, c.addString(string(x)))
					default:
						panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
					}
				}
			default:
				panic(todo("%v: %s %T", item.expr.Position(), cc.NodeSource(item.expr), x))
			}
		default:
			e := c.expr(item.expr, rvalue, item.t)
			c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
		}
	}
}

func (c *ctx) initStaticVar(n cc.Node, v variable, t cc.Type, m initMap, offs []int64) {
	noff := int64(-1)
	var size int64
	// trc("==== t=%s", t)
	// for _, off := range offs {
	// 	item := m[off]
	// 	sz := c.sizeof(item.expr, item.t)
	// 	trc("%v: off=%v t=%v sz=%v e=%v", item.expr.Position(), off, item.t, sz, cc.NodeSource(item.expr))
	// }
	for _, off := range offs {
		item := m[off]
		sz := c.sizeof(item.expr, item.t)
		if sz == 0 {
			continue
		}

		size = off + sz
		switch {
		case noff < 0 && off != 0:
			c.w("\tz %v,\n", off)
		case noff >= 0 && off > noff:
			c.w("\tz %v,\n", off-noff)
		}
		switch x := item.expr.Value().(type) {
		case *cc.UnknownValue:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.expr, constRvalue, item.t))
		case cc.Int64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x, false))
		case cc.UInt64Value:
			switch {
			case item.t.Kind() == cc.Ptr && x != 0:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.expr, constRvalue, item.t))
			default:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x, false))
			}
		case cc.StringValue:
			s := string(x)
			switch item.t.Kind() {
			case cc.Array:
				at := item.t.(*cc.ArrayType)
				al := int(at.Len())
				if al < 0 {
					// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010924-1.c
					panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
				}

				et := at.Elem()
				if len(s) > al {
					s = s[:al]
				}
				switch et.Kind() {
				case cc.Char, cc.SChar, cc.UChar:
					c.w("\tb %s,\n", strconv.QuoteToASCII(s))
					if len(s) < al {
						c.w("\tz %v,\n", al-len(s))
					}
				default:
					panic(todo("", item.t))
				}
			case cc.Ptr:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.addString(s))
			default:
				// all_test.go:340: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010924-1.c
				panic(todo("", item.expr.Position(), cc.NodeSource(item.expr), off, sz, t, item.t))
			}
		case cc.Float64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x, false))
		case *cc.ZeroValue:
			// nop
		default:
			// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/wchar_t-1.c
			panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
		}
		noff = off + c.sizeof(item.expr, item.t)
	}
	if n := c.sizeof(n, t) - size; n != 0 {
		c.w("\tz %v,\n", n)
	}
}

func (c *ctx) initComplit(n cc.Node, v *complit, t cc.Type, m initMap, offs []int64) {
	zeroed := false
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset)
		c.w("\tcall $memset(%s %s, w 0, %[1]s %[3]v)\n", c.wordTag, p, c.sizeof(n, t))
		zeroed = true
	}
	for _, off := range offs {
		item := m[off]
		if zeroed {
			switch x := item.expr.Value().(type) {
			case cc.Int64Value:
				if x == 0 {
					continue
				}
			case cc.UInt64Value:
				if x == 0 {
					continue
				}
			case cc.Float64Value:
				if x == 0 {
					continue
				}
			}
		}
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset+off)
		e := c.expr(item.expr, rvalue, item.t)
		c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
	}
}

func (c *ctx) initializer(n *cc.Initializer, v variable, t cc.Type) {
	// trc("==== %v: t=%v", n.Position(), t)
	m := initMap{}
	c.init(n, 0, t, m)
	var offs []int64
	for k := range m {
		offs = append(offs, k)
	}
	slices.Sort(offs)
	switch x := v.(type) {
	case *local:
		c.initLocalVar(n, x, t, m, offs)
	case *escaped:
		c.initEscapedVar(n, x, t, m, offs)
	case *static:
		c.initStaticVar(n, x, t, m, offs)
	case *complit:
		c.initComplit(n, x, t, m, offs)
	default:
		panic(todo("", n.Position(), cc.NodeSource(n), x, t, m))
	}
}

func (c *ctx) init(n *cc.Initializer, off int64, t cc.Type, m initMap) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		// trc("%v: case=%v off=%v t=%v: %s", n.Position(), n.Case, off, t, cc.NodeSource(n))
		m[off] = &initMapItem{n.AssignmentExpression, t}
		// trc("m[%v]=%s", off, cc.NodeSource(n.AssignmentExpression))
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		// trc("%v: case=%v off=%v t=%v: %s", n.Position(), n.Case, off, t, cc.NodeSource(n))
		r := newInitListReader(n.InitializerList)
		c.initList(n, r, off, t, m)
		if n := r.peek(); n != nil {
			c.err(n, "initializer not consumed")
		}
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) initList(n cc.Node, r *initListReader, off int64, t cc.Type, m initMap) {
	switch t.Kind() {
	case cc.Array:
		// trc("%v: kind=%v off=%v t=%v", n.Position(), t.Kind(), off, t)
		c.initArray(n, r, off, t.(*cc.ArrayType), m)
	case cc.Struct:
		// trc("%v: kind=%v off=%v t=%v", n.Position(), t.Kind(), off, t)
		c.initStruct(n, r, off, t.(*cc.StructType), m)
	case cc.Union:
		// trc("%v: kind=%v off=%v t=%v", n.Position(), t.Kind(), off, t)
		c.initUnion(n, r, off, t.(*cc.UnionType), m)
	default:
		// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20050316-1.c
		// panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.Position(), cc.NodeSource(n), off, t, m, t.Kind()))
		ln := r.peek()
		r.consume()
		c.init(ln.Initializer, off, t, m)
	}
}

func (c *ctx) initArray(n cc.Node, r *initListReader, off int64, t *cc.ArrayType, m initMap) {
	// trc("(%s A) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// defer func() {
	// 	trc("(%s Z) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// }()
	limit := t.Len()
	if limit < 0 {
		c.err(n, "unsupported type")
		return
	}

	et := t.Elem()
	sz := c.sizeof(n, et)
	ln := r.peek()
	if ln == nil {
		return
	}

	if ln.Initializer.Case == cc.InitializerExpr {
		switch et.Kind() {
		case cc.Char, cc.SChar, cc.UChar:
			switch ln.Initializer.AssignmentExpression.Value().(type) {
			case cc.StringValue:
				r.consume()
				m[off] = &initMapItem{expr: ln.Initializer.AssignmentExpression, t: t}
				return
			}
		}
	}
	for ix := int64(0); ix < limit; ix++ {
		ln := r.peek()
		if ln == nil {
			return
		}

		if ln.Designation != nil {
			ix = ln.Initializer.Offset() / sz
		}

		switch et.Kind() {
		case cc.Array, cc.Struct, cc.Union:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				c.initList(ln.Initializer, r, off+ix*sz, et, m)
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+ix*sz, et, m)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+ix*sz, et, m)
			case cc.InitializerInitList:
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}

// 6.7.8/9: unnamed members of objects of structure and union type do not
// participate in initialization.

func (c *ctx) initStruct(n cc.Node, r *initListReader, off int64, t *cc.StructType, m initMap) {
	// trc("(%s A) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// defer func() {
	// 	trc("(%s Z) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// }()
	limit := t.NumFields()
	var f *cc.Field
	for ix := 0; ix < limit; ix++ {
		ln := r.peek()
		if ln == nil {
			return
		}

		switch {
		case ln.Designation != nil:
			f = ln.Initializer.Field()
		default:
			for f = t.FieldByIndex(ix); f.Name() == ""; f = t.FieldByIndex(ix) {
				if ix = ix + 1; ix == limit {
					c.err(ln, "unused initializer element")
					return
				}
			}
		}
		if f.IsBitfield() {
			// all_test.go:344: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000113-1.c
			panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
		}

		if f.IsFlexibleArrayMember() {
			c.err(n, "flexible array members not supported")
		}

		switch f.Type().Kind() {
		case cc.Array, cc.Struct, cc.Union:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				c.initList(ln.Initializer, r, off+f.Offset(), f.Type(), m)
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m)
			case cc.InitializerInitList:
				// all_test.go:340: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/tcc-0.9.27/tests/tests2/90_struct-init.c
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}

func (c *ctx) initUnion(n cc.Node, r *initListReader, off int64, t *cc.UnionType, m initMap) {
	// trc("(%s A) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// defer func() {
	// 	trc("(%s Z) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
	// }()
	limit := 1
	var f *cc.Field
	for ix := 0; ix < limit; ix++ {
		ln := r.peek()
		if ln == nil {
			return
		}

		switch {
		case ln.Designation != nil:
			f = ln.Initializer.Field()
		default:
			for f = t.FieldByIndex(ix); f.Name() == ""; f = t.FieldByIndex(ix) {
				if ix = ix + 1; ix == limit {
					c.err(ln, "unused initializer element")
					return
				}
			}
		}
		if f.IsBitfield() {
			// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr88739.c
			panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
		}
		switch f.Type().Kind() {
		case cc.Array, cc.Struct, cc.Union:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m)
			case cc.InitializerInitList:
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}
