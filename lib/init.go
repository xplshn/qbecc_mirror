// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"slices"
	"sort"
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
	f *cc.Field
	n cc.ExpressionNode
	t cc.Type
}

func (it *initMapItem) bf() (r *cc.Field) {
	if it.f != nil && it.f.IsBitfield() {
		return it.f
	}

	return nil
}

func (it *initMapItem) bo() int {
	if bf := it.bf(); bf != nil {
		return bf.OffsetBits()
	}

	return -1
}

func (it *initMapItem) nm() string {
	if bf := it.bf(); bf != nil {
		return bf.Name()
	}

	return ""
}

func (n *initMapItem) String() string {
	return fmt.Sprintf("%v: %s %s", n.n.Position(), cc.NodeSource(n.n), n.t)
}

// initializer renderer
type initMap map[int64][]*initMapItem // offset: item

func (c *ctx) initLocalVar(n cc.Node, v *localVar, t cc.Type, m initMap, offs []int64) {
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		c.w("\t%s =%s copy 0\n", v.name, c.baseType(n, v.d.Type()))
	}
	switch len(m) {
	case 1:
		item := m[offs[0]][0]
		if bf := item.bf(); bf != nil {
			panic(todo("%v: %s f=%s t=%s", item.n.Position(), cc.NodeSource(item.n), bf.Name(), item.t))
		}

		e := c.expr(item.n, rvalue, v.d.Type())
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
	if dbgInit {
		trc("==== t=%s(%v)", t, t.Size())
		for _, off := range offs {
			for _, item := range m[off] {
				sz := c.sizeof(item.n, item.t)
				trc("%v: off=%v(%v) t=%v sz=%v e=%v", item.n.Position(), off, item.bo(), item.t, sz, cc.NodeSource(item.n))
			}
		}
	}
	zeroed := false
	switch t.Kind() {
	case cc.Struct, cc.Union, cc.Array:
		p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset)
		c.w("\tcall $memset(%s %s, w 0, %[1]s %[3]v)\n", c.wordTag, p, c.sizeof(n, t))
		zeroed = true
	}
	for _, off := range offs {
		for _, item := range m[off] {
			if zeroed {
				switch x := item.n.Value().(type) {
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
			if bf := item.bf(); bf != nil {
				v := c.expr(item.n, rvalue, item.t)
				c.store(item.n, item.t, v, &bitfieldPtr{bf, p})
				continue
			}

			switch item.t.Kind() {
			case cc.Array:
				at := item.t.(*cc.ArrayType)
				et := at.Elem()
				switch x := item.n.Value().(type) {
				case cc.StringValue:
					switch et.Size() {
					case 1:
						switch al, sl := at.Len(), int64(len(x)); {
						case al > sl:
							switch {
							case zeroed:
								c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), sl)
							default:
								panic(todo("%v: %s al=%v sl=%v", item.n.Position(), cc.NodeSource(item.n), al, sl))
							}
						default: // al <= sl
							c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(string(x)), al)
						}
					default:
						panic(todo("%v: %s %v", item.n.Position(), cc.NodeSource(item.n), et.Size()))
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
								panic(todo("%v: %s al=%v sl=%v", item.n.Position(), cc.NodeSource(item.n), al, sl))
							}
						default: // al <= sl
							c.w("\tcall $memcpy(%s %s, %[1]s %[3]s, %[1]s %[4]v)\n", c.wordTag, p, c.addString(c.littleEndianUTF32string(x)), 4*al)
						}
					default:
						panic(todo("%v: %s %v", item.n.Position(), cc.NodeSource(item.n), et.Size()))
					}
				default:
					panic(todo("%v: %s %T", item.n.Position(), cc.NodeSource(item.n), x))
				}
			default:
				switch {
				case c.isAggType(item.t):
					e := c.expr(item.n, aggRvalue, item.t)
					c.w("\tblit %s, %s, %v\n", e, p, item.t.Size())
				default:
					e := c.expr(item.n, rvalue, item.t)
					c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
				}
			}
		}
	}
}

func (c *ctx) initStaticVar(n cc.Node, v variable, t cc.Type, m initMap, offs []int64) {
	noff := int64(-1)
	var size int64
	if dbgInit {
		trc("==== t=%s(%v)", t, t.Size())
		for _, off := range offs {
			for _, item := range m[off] {
				sz := c.sizeof(item.n, item.t)
				trc("%v: f=%s off=%v(%v) t=%v sz=%v e=%v", item.n.Position(), item.nm(), off, item.bo(), item.t, sz, cc.NodeSource(item.n))
			}
		}
	}
outer:
	for i, off := range offs {
		for j, item := range m[off] {
			if bf := item.bf(); bf != nil {
				if j != 0 {
					panic(todo("%v: %s f=%s t=%s", item.n.Position(), cc.NodeSource(item.n), bf.Name(), item.t))
				}

				if dbgInit {
					trc("off=%v noff=%v", off, noff)
				}
				switch {
				case noff < 0 && off != 0:
					c.w("\tz %v,\n", off)
					if dbgInit {
						trc("z %v", off)
					}
				case noff >= 0 && off > noff:
					c.w("\tz %v,\n", off-noff)
					if dbgInit {
						trc("z %v", off-noff)
					}
				}
				switch {
				case i+1 == len(offs):
					noff = t.Size()
					if dbgInit {
						trc("noff=%v (last)", noff)
					}
				default:
					noff = offs[i+1]
					if dbgInit {
						trc("noff=%v (not last)", noff)
					}
				}
				nb := noff - off
				size = off + nb
				bits := uint64(0)
				if dbgInit {
					trc("off=%v noff=%v size=%v nb=%v", off, noff, size, nb)
				}
				for _, item := range m[off] {
					bo := item.bo()
					if bo < 0 {
						panic(todo("%v: %s f=%s t=%s", item.n.Position(), cc.NodeSource(item.n), bf.Name(), item.t))
					}

					bf := item.bf()
					switch x := c.expr(item.n, constRvalue, item.t).(type) {
					case int64Value:
						bits |= (uint64(x) << bo) & bf.Mask()
					case uint64Value:
						bits |= (uint64(x) << bo) & bf.Mask()
					default:
						panic(todo("%v: %s f=%s t=%s %T", item.n.Position(), cc.NodeSource(item.n), bf.Name(), item.t, x))
					}
				}
				switch nb {
				case 1:
					c.w("\tb %v,\n", bits)
				case 2:
					c.w("\th %v,\n", bits)
				case 4:
					c.w("\tw %v,\n", bits)
				case 8:
					c.w("\tl %v,\n", bits)
				default:
					panic(todo("%v: %s f=%s t=%s nb=%v", item.n.Position(), cc.NodeSource(item.n), bf.Name(), item.t, nb))
				}
				continue outer
			}

			sz := c.sizeof(item.n, item.t)
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
			switch x := item.n.Value().(type) {
			case *cc.UnknownValue:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.n, constRvalue, item.t))
			case cc.Int64Value:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.n, constRvalue, item.t, x, false))
			case cc.UInt64Value:
				switch {
				case item.t.Kind() == cc.Ptr && x != 0:
					c.w("\t%s %s,\n", c.extType(n, item.t), c.expr(item.n, constRvalue, item.t))
				default:
					c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.n, constRvalue, item.t, x, false))
				}
			case cc.StringValue:
				s := string(x)
				switch item.t.Kind() {
				case cc.Array:
					at := item.t.(*cc.ArrayType)
					al := int(at.Len())
					if al < 0 {
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
					panic(todo("", item.n.Position(), cc.NodeSource(item.n), off, sz, t, item.t))
				}
			case cc.Float64Value:
				c.w("\t%s %s,\n", c.extType(n, item.t), c.value(item.n, constRvalue, item.t, x, false))
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
			noff = off + c.sizeof(item.n, item.t)
		}
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
		for _, item := range m[off] {
			if bf := item.bf(); bf != nil {
				p := c.temp("%s add %%.bp., %v\n", c.wordTag, v.offset+off)
				v := c.expr(item.n, rvalue, item.t)
				c.store(item.n, item.t, v, &bitfieldPtr{bf, p})
				continue
			}

			if zeroed {
				switch x := item.n.Value().(type) {
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
				e := c.expr(item.n, aggRvalue, item.t)
				c.w("\tblit %s, %s, %v\n", e, p, item.t.Size())
			case c.isAggType(item.n.Type()):
				e := c.expr(item.n, aggRvalue, item.t)
				c.w("\tblit %s, %s, %v\n", e, p, item.n.Type().Size())
			default:
				e := c.expr(item.n, rvalue, item.t)
				c.w("\tstore%s %s, %s\n", c.extType(n, item.t), e, p)
			}
		}
	}
}

// Outer
func (c *ctx) initializerList(n *cc.InitializerList, v variable, t cc.Type) {
	if dbgInit {
		trc("==== %v: t=%v(%v)", n.Position(), t, t.Size())
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
		trc("==== %v: t=%v(%v)", n.Position(), t, t.Size())
	}
	m := initMap{}
	c.init(n, 0, t, m, nil)
	for _, v := range m {
		sort.Slice(v, func(i, j int) bool {
			return v[i].bo() < v[j].bo()
		})
	}
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

func (c *ctx) init(n *cc.Initializer, off int64, t cc.Type, m initMap, f *cc.Field) {
	switch n.Case {
	case cc.InitializerExpr: // AssignmentExpression
		if dbgInit {
			trc("%v: case=%v off=%v t=%v(%v): %s", n.Position(), n.Case, off, t, t.Size(), cc.NodeSource(n))
		}
		m[off] = append(m[off], &initMapItem{f: f, n: n.AssignmentExpression, t: t})
		if dbgInit {
			trc("m[%v]=%s", off, cc.NodeSource(n.AssignmentExpression))
		}
	case cc.InitializerInitList: // '{' InitializerList ',' '}'
		if dbgInit {
			trc("%v: case=%v off=%v t=%v(%v): %s", n.Position(), n.Case, off, t, t.Size(), cc.NodeSource(n))
		}
		r := newInitListReader(n.InitializerList)
		c.initList(n, r, off, t, m, f)
		if n := r.peek(); n != nil {
			c.err(n, "initializer not consumed")
		}
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) initList(n cc.Node, r *initListReader, off int64, t cc.Type, m initMap, f *cc.Field) {
	switch t.Kind() {
	case cc.Array:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v(%v): %s", n.Position(), t.Kind(), off, t, t.Size(), cc.NodeSource(r.peek()))
		}
		c.initArray(n, r, off, t.(*cc.ArrayType), m)
	case cc.Struct:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v(%v): %s", n.Position(), t.Kind(), off, t, t.Size(), cc.NodeSource(r.peek()))
		}
		c.initStruct(n, r, off, t.(*cc.StructType), m)
	case cc.Union:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v(%v): %s", n.Position(), t.Kind(), off, t, t.Size(), cc.NodeSource(r.peek()))
		}
		c.initUnion(n, r, off, t.(*cc.UnionType), m)
	default:
		if dbgInit {
			trc("%v: kind=%v off=%v t=%v:(%v) %s", n.Position(), t.Kind(), off, t, t.Size(), cc.NodeSource(r.peek()))
		}
		ln := r.peek()
		r.consume()
		c.init(ln.Initializer, off, t, m, f)
	}
}

func (c *ctx) initArray(n cc.Node, r *initListReader, off int64, t *cc.ArrayType, m initMap) {
	if dbgInit {
		trc("(%s IN) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
		}()
	}
	limit := t.Len()
	if limit < 0 {
		c.err(n, "unsupported type: %s", t)
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
				m[off] = append(m[off], &initMapItem{n: ln.Initializer.AssignmentExpression, t: t})
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
				c.initList(ln.Initializer, r, off+ix*sz, et, m, nil)
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+ix*sz, et, m, nil)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+ix*sz, et, m, nil)
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
		trc("(%s IN) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
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
				m[off] = append(m[off], &initMapItem{n: ln.Initializer.AssignmentExpression, t: t})
				return
			}

			f = t.FieldByIndex(ix)
			for f.IsBitfield() && f.Name() == "" {
				ix++
				if ix == limit {
					return
				}

				f = t.FieldByIndex(ix)
			}
		}
		if dbgInit {
			trc("f=%q ix=%v", f.Name(), ix)
		}
		if f.IsFlexibleArrayMember() {
			panic(todo("%v: %s", n.Position(), cc.NodeSource(n)))
		}

		switch f.Type().Kind() {
		case cc.Array, cc.Struct, cc.Union:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				c.initList(ln.Initializer, r, off+f.Offset(), f.Type(), m, nil)
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m, nil)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m, f)
			case cc.InitializerInitList:
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}

func (c *ctx) initUnion(n cc.Node, r *initListReader, off int64, t *cc.UnionType, m initMap) {
	if dbgInit {
		trc("(%s IN) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
		defer func() {
			trc("(%s OUT) %v: off=%v t=%v(%v): %s", t.Kind(), n.Position(), off, t, t.Size(), cc.NodeSource(r.peek()))
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
			for f.IsBitfield() && f.Name() == "" {
				ix++
				if ix == limit {
					return
				}

				f = t.FieldByIndex(ix)
			}
		}
		if dbgInit {
			trc("f=%q ix=%v", f.Name(), ix)
		}
		switch f.Type().Kind() {
		case cc.Array, cc.Struct, cc.Union:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				c.initList(ln.Initializer, r, off+f.Offset(), f.Type(), m, nil)
			case cc.InitializerInitList:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m, nil)
			}
		default:
			switch ln.Initializer.Case {
			case cc.InitializerExpr:
				r.consume()
				c.init(ln.Initializer, off+f.Offset(), f.Type(), m, f)
			case cc.InitializerInitList:
				panic(todo("%v: %s", ln.Initializer.Position(), cc.NodeSource(ln.Initializer)))
			}
		}
	}
}
