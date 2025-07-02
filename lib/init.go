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

func (lr *initListReader) next() (r *cc.InitializerList) {
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

func (c *ctx) initializeOuter(n *cc.Initializer, v variable, t cc.Type) {
	// trc("", n.Position(), cc.NodeSource(n), v, t)
	m := initMap{}
	c.initialize(n, 0, t, m)
	var offs []int64
	for k := range m {
		offs = append(offs, k)
	}
	slices.Sort(offs)
	switch x := v.(type) {
	case *local:
		c.initializeLocal(n, x, t, m, offs)
	case *escaped:
		c.initializeEscaped(n, x, t, m, offs)
	case *static:
		c.initializeStatic(n, x, t, m, offs)
	default:
		panic(todo("", n.Position(), cc.NodeSource(n), x, t, m))
	}
}

func (c *ctx) initializeLocal(n cc.Node, v *local, t cc.Type, m initMap, offs []int64) {
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

func (c *ctx) initializeEscaped(n cc.Node, v *escaped, t cc.Type, m initMap, offs []int64) {
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset)
		c.w("\tcall $memset(%s %s, w 0, %[1]s %[3]v)\n", c.wordTag, p, t.Size())
	}
	for _, off := range offs {
		item := m[off]
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset+off)
		e := c.expr(item.expr, rvalue, item.t)
		c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
	}
}

func (c *ctx) initializeStatic(n cc.Node, v variable, t cc.Type, m initMap, offs []int64) {
	noff := int64(-1)
	var sz int64
	for _, off := range offs {
		item := m[off]
		sz = off + item.t.Size()
		if noff >= 0 && off > noff {
			c.w("\tz %v,\n", off-noff)
		}
		switch x := item.expr.Value().(type) {
		case *cc.UnknownValue:
			if item.expr == oneByte {
				c.w("\tb 0,\n")
				return
			}

			c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.expr, rvalue, item.t))
		case cc.Int64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, rvalue, item.t, x))
		case cc.UInt64Value:
			c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.expr, rvalue, item.t, x))
		case cc.StringValue:
			switch item.t.Kind() {
			case cc.Array:
				at := item.t.(*cc.ArrayType)
				al := int(at.Len())
				if al < 0 {
					panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
				}

				et := at.Elem()
				if len(x) > al {
					x = x[:al]
				}
				switch et.Kind() {
				case cc.Char, cc.SChar, cc.UChar:
					c.w("\tb %s,\n", strconv.QuoteToASCII(string(x)))
					if len(x) < al {
						c.w("\tz %v,\n", al-len(x))
					}
				default:
					panic(todo("", item.t))
				}
			default:
				panic(todo("", item.t))
			}
		default:
			panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
		}
		noff = off + item.t.Size()
	}
	if n := t.Size() - sz; n != 0 {
		c.w("\tz %v,\n", n)
	}
}

func (c *ctx) initialize(n *cc.Initializer, off int64, t cc.Type, m initMap) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		m[off] = &initMapItem{n.AssignmentExpression, t}
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		c.initializeList(newInitListReader(n.InitializerList), off, t, m)
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) initializeList(n *initListReader, off int64, t cc.Type, m initMap) {
	switch t.Kind() {
	case cc.Array:
		c.initializeListArray(n, off, t.(*cc.ArrayType), m)
	case cc.Struct:
		c.initializeListStruct(n, off, t.(*cc.StructType), m)
	case cc.Union:
		panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
	default:
		panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
	}
}

var oneByte = &cc.PrimaryExpression{}

func (c *ctx) initializeListArray(n *initListReader, off int64, t *cc.ArrayType, m initMap) {
	l := t.Len()
	if l < 0 {
		switch {
		case n.n == nil:
			// int d[][8] = {};
			m[off] = &initMapItem{expr: oneByte, t: c.ast.Char}
			return
		default:
			panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		}
	}

	et := t.Elem()
	sz := et.Size()
	var ix int64
	for item := n.next(); item != nil; item = n.next() {
		switch {
		case item.Designation != nil:
			panic(todo("", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		default:
			// ok
		}

		c.initialize(item.Initializer, off+ix*sz, et, m)
		ix++
		if ix == l {
			return
		}
	}
}

func (c *ctx) initializeListStruct(n *initListReader, off int64, t *cc.StructType, m initMap) {
	nf := t.NumFields()
	var ix int
	var f *cc.Field
	for item := n.next(); item != nil; item = n.next() {
		switch {
		case item.Designation != nil:
			panic(todo("", n.n.Position(), cc.NodeSource(n.n), off, t, m, t.Kind()))
		default:
			f = t.FieldByIndex(ix)
		}

		c.initialize(item.Initializer, off+f.Offset(), f.Type(), m)
		ix++
		if ix == nf {
			return
		}
	}
}
