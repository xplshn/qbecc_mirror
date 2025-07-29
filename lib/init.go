// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"slices"
	"strings"

	"modernc.org/cc/v4"
)

var dbgInit = false

// initializer list reader
type initListReader struct {
	d *cc.DesignatorList
	n *cc.InitializerList
}

func newInitListReader(n *cc.InitializerList) (r *initListReader) {
	r = &initListReader{n: n}
	if n != nil && n.Designation != nil {
		r.d = n.Designation.DesignatorList
	}
	return r
}

func (lr *initListReader) peek() (r *cc.InitializerList) {
	return lr.n
}

func (lr *initListReader) consume() {
	if lr.n != nil {
		lr.n = lr.n.InitializerList
		lr.d = nil
		if lr.n != nil && lr.n.Designation != nil {
			lr.d = lr.n.Designation.DesignatorList
		}
	}
}

func (lr *initListReader) peekDesignator() (r *cc.Designator) {
	if lr.d == nil {
		return nil
	}

	return lr.d.Designator
}

func (lr *initListReader) consumeDesignator() {
	if lr.d != nil {
		lr.d = lr.d.DesignatorList
	}
}

type initMapItem struct {
	//f    *cc.Field // only for bitfields
	expr cc.ExpressionNode
	t    cc.Type
}

func (n *initMapItem) String() string {
	return fmt.Sprintf("%v: %s %s", n.expr.Position(), cc.NodeSource(n.expr), n.t)
}

// initializer renderer
type initMap map[int64]*initMapItem // offset: item

func (c *ctx) initLocalVar(n cc.Node, v *localVar, t cc.Type, m initMap, offs []int64) {
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

func (c *ctx) littleEndianUTF32string(s cc.UTF32StringValue) (r string) {
	var b strings.Builder
	for _, v := range s {
		for i := 0; i < 4; i++ {
			b.WriteByte(byte(v))
			v >>= 8
		}
	}
	return b.String()
}

func (c *ctx) initEscapedVar(n cc.Node, v *escapedVar, t cc.Type, m initMap, offs []int64) {
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
			et := at.Elem()
			switch x := item.expr.Value().(type) {
			case cc.StringValue:
				switch et.Size() {
				case 1:
					switch al, sl := at.Len(), int64(len(x)); {
					case al > sl:
						switch {
						case zeroed:
							c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), sl)
						default:
							panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
						}
					default: // al <= sl
						c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), al)
					}
				default:
					panic(todo("%v: %s %v", item.expr.Position(), cc.NodeSource(item.expr), et.Size()))
				}
			case cc.UTF32StringValue:
				switch et.Size() {
				case 4:
					switch al, sl := at.Len(), int64(len(x)); {
					case al > sl:
						switch {
						case zeroed:
							c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), 4*sl)
						default:
							panic(todo("%v: %s al=%v sl=%v", item.expr.Position(), cc.NodeSource(item.expr), al, sl))
						}
					default: // al <= sl
						c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(c.littleEndianUTF32string(x)), 4*al)
					}
				default:
					panic(todo("%v: %s %v", item.expr.Position(), cc.NodeSource(item.expr), et.Size()))
				}
			default:
				panic(todo("%v: %s %T", item.expr.Position(), cc.NodeSource(item.expr), x))
			}
		default:
			switch {
			case c.isAggType(item.t):
				e := c.expr(item.expr, aggRvalue, item.t)
				c.w("\tblit %s, %s, %v\n", e, p, item.t.Size())
			default:
				e := c.expr(item.expr, rvalue, item.t)
				c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
			}
		}
	}
}

func (c *ctx) initStaticVar(n cc.Node, v variable, t cc.Type, m initMap, offs []int64) {
	noff := int64(-1)
	var size int64
	if dbgInit {
		trc("==== t=%s", t)
		for _, off := range offs {
			item := m[off]
			sz := c.sizeof(item.expr, item.t)
			trc("%v: off=%v t=%v sz=%v e=%v", item.expr.Position(), off, item.t, sz, cc.NodeSource(item.expr))
		}
	}
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
					// flexible array members
					panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
				}

				et := at.Elem()
				switch et.Size() {
				case 1:
					if len(s) > al {
						s = s[:al]
					}
					switch et.Kind() {
					case cc.Char, cc.SChar, cc.UChar:
						c.w("\t%s,\n", c.safeString(s))
						if len(s) < al {
							c.w("\tz %v,\n", al-len(s))
						}
					default:
						panic(todo("", item.t))
					}
				default:
					panic(todo("%v: %s %v", n.Position(), cc.NodeSource(n), et.Size()))
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
		case cc.UTF32StringValue:
			switch t.Kind() {
			case cc.Array:
				at := t.(*cc.ArrayType)
				if at.Len() < 0 {
					panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
				}

				et := at.Elem()
				switch et.Size() {
				case 4:
					switch al, sl := at.Len(), int64(len(x)); {
					case al < sl:
						panic(todo("%v: %s al=%v sl=%v", n.Position(), cc.NodeSource(n), al, sl))
					default: // al <= sl
						for _, v := range x[:al] {
							c.w("\tw %v,\n", v)
						}
					}
				default:
					panic(todo("%v: %s %v", n.Position(), cc.NodeSource(n), et.Size()))
				}
			default:
				panic(todo("%v: %s %v", n.Position(), cc.NodeSource(n), t.Kind()))
			}
		default:
			panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
		}
		noff = off + c.sizeof(item.expr, item.t)
	}
	if n := c.sizeof(n, t) - size; n != 0 {
		c.w("\tz %v,\n", n)
	}
}

func (c *ctx) initComplit(n cc.Node, v *complitVar, t cc.Type, m initMap, offs []int64) {
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
		switch {
		case c.isAggType(item.t):
			e := c.expr(item.expr, aggRvalue, item.t)
			c.w("\tblit %s, %s, %v\n", e, p, item.t.Size())
		case c.isAggType(item.expr.Type()):
			e := c.expr(item.expr, aggRvalue, item.t)
			c.w("\tblit %s, %s, %v\n", e, p, item.expr.Type().Size())
		default:
			e := c.expr(item.expr, rvalue, item.t)
			c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
		}
	}
}

// Outer
func (c *ctx) initializerList(n *cc.InitializerList, v variable, t cc.Type) {
	if dbgInit {
		trc("==== %v: t=%v", n.Position(), t)
	}
	c.initializer(
		&cc.Initializer{
			Case:            cc.InitializerInitList,
			InitializerList: n,
		},
		v,
		t,
	)
}

// Outer
func (c *ctx) initializer(n *cc.Initializer, v variable, t cc.Type) {
	if dbgInit {
		trc("==== %v: t=%v", n.Position(), t)
	}
	m := initMap{}
	c.init(n, 0, t, m)
	var offs []int64
	for k := range m {
		offs = append(offs, k)
	}
	slices.Sort(offs)
	switch x := v.(type) {
	case *localVar:
		c.initLocalVar(n, x, t, m, offs)
	case *escapedVar:
		c.initEscapedVar(n, x, t, m, offs)
	case *staticVar:
		c.initStaticVar(n, x, t, m, offs)
	case *complitVar:
		c.initComplit(n, x, t, m, offs)
	default:
		panic(todo("", n.Position(), cc.NodeSource(n), x, t, m))
	}
}

func (c *ctx) init(n *cc.Initializer, off int64, t cc.Type, m initMap) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		if dbgInit {
			trc("%v: case=%v off=%v t=%v: %s", n.Position(), n.Case, off, t, cc.NodeSource(n))
		}
		m[off] = &initMapItem{n.AssignmentExpression, t}
		if dbgInit {
			trc("m[%v]=%s", off, cc.NodeSource(n.AssignmentExpression))
		}
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		if dbgInit {
			trc("%v: case=%v off=%v t=%v: %s", n.Position(), n.Case, off, t, cc.NodeSource(n))
		}
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
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v: %s", n.Position(), t.Kind(), off, t, cc.NodeSource(r.peek()))
		}
		c.initArray(n, r, off, t.(*cc.ArrayType), m)
	case cc.Struct:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v: %s", n.Position(), t.Kind(), off, t, cc.NodeSource(r.peek()))
		}
		c.initStruct(n, r, off, t.(*cc.StructType), m)
	case cc.Union:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v: %s", n.Position(), t.Kind(), off, t, cc.NodeSource(r.peek()))
		}
		c.initUnion(n, r, off, t.(*cc.UnionType), m)
	default:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v: %s", n.Position(), t.Kind(), off, t, cc.NodeSource(r.peek()))
		}
		// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20050316-1.c
		// panic(todo("%v: %s off=%v t=%v m=%v kind=%v", n.Position(), cc.NodeSource(n), off, t, m, t.Kind()))
		ln := r.peek()
		r.consume()
		c.init(ln.Initializer, off, t, m)
	}
}

func (c *ctx) initArray(n cc.Node, r *initListReader, off int64, t *cc.ArrayType, m initMap) {
	if dbgInit {
		trc("(%s IN) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		}()
	}
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

		if d := r.peekDesignator(); d != nil {
			r.consumeDesignator()
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

type fielder interface {
	FieldByName(s string) *cc.Field
}

func (c *ctx) fieldDesignator(n *cc.Designator, t fielder) (r *cc.Field) {
	var fn string
	switch n.Case {
	case cc.DesignatorIndex: // '[' ConstantExpression ']'
		c.err(n, "invalid field designator: %s", cc.NodeSource(n))
		return nil
	case cc.DesignatorIndex2: // '[' ConstantExpression "..." ConstantExpression ']'
		c.err(n, "not supported: %s", cc.NodeSource(n))
		return nil
	case cc.DesignatorField: // '.' IDENTIFIER
		fn = n.Token2.SrcStr()
	case cc.DesignatorField2: // IDENTIFIER ':'
		fn = n.Token.SrcStr()
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
		return nil
	}

	if r = t.FieldByName(fn); r == nil {
		c.err(n, "type %s has no field %s", t, fn)
	}
	return r
}

func (c *ctx) initStruct(n cc.Node, r *initListReader, off int64, t *cc.StructType, m initMap) {
	if dbgInit {
		trc("(%s IN) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		}()
	}
	limit := t.NumFields()
	var f *cc.Field
	for ix := 0; ix < limit; ix++ {
		ln := r.peek()
		if ln == nil {
			return
		}

		switch d := r.peekDesignator(); {
		case d != nil:
			if dbgInit {
				trc("designator=%s", cc.NodeSource(d))
			}
			if f = c.fieldDesignator(d, t); f == nil {
				r.consume()
				continue
			}

			r.consumeDesignator()
			ix = f.Index()
		default:
			if ln.Initializer.Case == cc.InitializerExpr && ln.Initializer.AssignmentExpression.Type().IsCompatible(t) {
				r.consume()
				m[off] = &initMapItem{ln.Initializer.AssignmentExpression, t}
				return
			}

			f = t.FieldByIndex(ix)
		}
		if dbgInit {
			trc("f=%q ix=%v", f.Name(), ix)
		}
		if f.IsBitfield() {
			// "20000113-1.c": {},
			// "20011113-1.c": {},
			// "20020404-1.c": {},
			// "20031201-1.c": {},
			// "20031211-1.c": {},
			// "20040307-1.c": {},
			// "20040331-1.c": {},
			// "20081117-1.c": {},
			// "20180921-1.c": {},
			// "93_integer_promotion.c": {},
			// "990326-1.c": {},
			// "991118-1.c": {},
			// "bf-sign-1.c": {},
			// "bf64-1.c": {},
			// "bitfld-3.c": {},
			// "bitfld-4.c": {},
			// "compndlit-1.c": {},
			// "pr23324.c": {},
			// "pr39339.c": {},
			// "pr49768.c": {},
			// "pr52979-1.c": {},
			// "pr52979-2.c": {},
			// "pr58984.c": {},
			// "pr60017.c": {},
			// "pr65215-3.c": {},
			// "pr66556.c": {},
			// "pr70127.c": {},
			// "pr70602.c": {},
			// "pr71700.c": {},
			// "pr78170.c": {},
			// "pr79737-1.c": {},
			// "pr89195.c": {},
			// "struct-ini-2.c": {},
			// "struct-ini-3.c": {},
			panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
		}

		if f.IsFlexibleArrayMember() {
			// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20010924-1.c
			// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030109-1.c
			// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr28865.c
			// all_test.go:261: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr33382.c
			panic(todo("%v: %s", n.Position(), cc.NodeSource(n)))
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
	if dbgInit {
		trc("(%s IN) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v: %s", t.Kind(), n.Position(), off, t, cc.NodeSource(r.peek()))
		}()
	}
	limit := 1
	var f *cc.Field
	for ix := 0; ix < limit; ix++ {
		ln := r.peek()
		if ln == nil {
			return
		}

		switch d := r.peekDesignator(); {
		case d != nil:
			if dbgInit {
				trc("designator=%s", cc.NodeSource(d))
			}
			if f = c.fieldDesignator(d, t); f == nil {
				r.consume()
				continue
			}

			r.consumeDesignator()
			ix = f.Index()
		default:
			f = t.FieldByIndex(ix)
		}
		if dbgInit {
			trc("f=%q ix=%v", f.Name(), ix)
		}
		if f.IsBitfield() {
			// all_test.go:336: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr88739.c
			panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
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
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}
