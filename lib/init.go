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

func (lr *initListReader) consume() (r *cc.InitializerList) {
	if r = lr.n; r != nil {
		lr.n = lr.n.InitializerList
	}
	return r
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

func (c *ctx) initializer(n *cc.Initializer, v variable, t cc.Type) {
	// trc("", n.Position(), cc.NodeSource(n), v, t)
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
					// all_test.go:352: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000801-4.c
					panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
				default: // al > sl
					switch {
					case zeroed:
						c.w("\tcall $strcpy(%s %s, %[1]s %[3]s)\n", c.wordTag, p, c.addString(string(x)))
					default:
						panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
					}
				}
			default:
				// all_test.go:352: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr89369.c
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
	var sz int64
	for _, off := range offs {
		item := m[off]
		sz = off + c.sizeof(item.expr, item.t)
		if noff >= 0 && off > noff {
			c.w("\tz %v,\n", off-noff)
		}
		switch x := item.expr.Value().(type) {
		case *cc.UnknownValue:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.expr, constRvalue, item.t))
		case cc.Int64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x))
		case cc.UInt64Value:
			switch {
			case item.t.Kind() == cc.Ptr && x != 0:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.expr, constRvalue, item.t))
			default:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x))
			}
		case cc.StringValue:
			s := string(x)
			switch item.t.Kind() {
			case cc.Array:
				at := item.t.(*cc.ArrayType)
				al := int(at.Len())
				if al < 0 {
					// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010924-1.c
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
				panic(todo("", item.t))
			}
		case cc.Float64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, constRvalue, item.t, x))
		default:
			// all_test.go:352: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/wchar_t-1.c
			panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
		}
		noff = off + c.sizeof(item.expr, item.t)
	}
	if n := c.sizeof(n, t) - sz; n != 0 {
		c.w("\tz %v,\n", n)
	}
}

func (c *ctx) init(n *cc.Initializer, off int64, t cc.Type, m initMap) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		m[off] = &initMapItem{n.AssignmentExpression, t}
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		c.initList(newInitListReader(n.InitializerList), off, t, m)
		//TODO check list exhausted
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) initList(n *initListReader, off int64, t cc.Type, m initMap) {
	switch t.Kind() {
	case cc.Array:
		c.initArray(n, off, t.(*cc.ArrayType), m)
	case cc.Struct:
		c.initStruct(n, off, t.(*cc.StructType), m)
	case cc.Union:
		c.initUnion(n, off, t.(*cc.UnionType), m)
	default:
		// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20050316-2.c
		panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
	}
}

func (c *ctx) initArray(n *initListReader, off int64, t *cc.ArrayType, m initMap) {
	limit := t.Len()
	if limit < 0 {
		c.err(nil, "cannot initialize type %s", t)
		return
	}

	et := t.Elem()
	sz := c.sizeof(n.n, et)
	for ix, elem := int64(0), n.consume(); elem != nil && ix < limit; ix, elem = ix+1, n.consume() {
		switch {
		case elem.Designation != nil:
			panic(todo("", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		default:
			// ok
		}

		c.init(elem.Initializer, off+ix*sz, et, m)
	}
}

// 6.7.8/9: unnamed members of objects of structure and union type do not
// participate in initialization.

func (c *ctx) initStruct(n *initListReader, off int64, t *cc.StructType, m initMap) {
	limit := t.NumFields()
	var f *cc.Field
	for ix, elem := 0, n.consume(); elem != nil && ix < limit; ix, elem = ix+1, n.consume() {
		switch {
		case elem.Designation != nil:
			// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000801-3.c
			panic(todo("", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		default:
			for f = t.FieldByIndex(ix); f.Name() == ""; f = t.FieldByIndex(ix) {
				if ix = ix + 1; ix == limit {
					c.err(elem, "unused initializer element")
					return
				}
			}
		}
		c.init(elem.Initializer, off+f.Offset(), f.Type(), m)
	}
}

func (c *ctx) initUnion(n *initListReader, off int64, t *cc.UnionType, m initMap) {
	limit := 1
	var f *cc.Field
	for ix, elem := 0, n.consume(); elem != nil && ix < limit; ix, elem = ix+1, n.consume() {
		switch {
		case elem.Designation != nil:
			// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/991228-1.c
			panic(todo("", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		default:
			for f = t.FieldByIndex(ix); f.Name() == ""; f = t.FieldByIndex(ix) {
				if ix = ix + 1; ix == limit {
					c.err(elem, "unused initializer element")
					return
				}
			}
		}
		c.init(elem.Initializer, off+f.Offset(), f.Type(), m)
	}
}
