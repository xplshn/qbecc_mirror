// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"strings"

	"modernc.org/cc/v4"
)

// BASETY := 'w' | 'l' | 's' | 'd' # Base types
func (c *ctx) baseType(n cc.Node, t cc.Type) string {
	sz := c.sizeof(n, t)
	switch t.Kind() {
	case cc.Ptr:
		return c.wordTag
	case cc.Enum:
		return c.baseType(n, t.(*cc.EnumType).UnderlyingType())
	case cc.Function:
		return c.wordTag
	default:
		switch {
		case c.isIntegerType(t):
			switch {
			case sz <= 4:
				return "w"
			case sz <= 8:
				return "l"
			default:
				panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
			}
		case c.isFloatingPointType(t):
			switch sz {
			case 4:
				return "s"
			case 8:
				return "d"
			default:
				// all_test.go:356: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/pr85331.c
				panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
			}
		default:
			// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000419-1.c
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	}
}

// EXTTY  := BASETY | 'b' | 'h'    # Extended types
func (c *ctx) extType(n cc.Node, t cc.Type) string {
	sz := c.sizeof(n, t)
	if sz >= 4 {
		return c.baseType(n, t)
	}

	switch {
	case c.isIntegerType(t):
		switch {
		case sz == 1:
			return "b"
		case sz <= 2:
			return "h"
		default:
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	default:
		// all_test.go:356: C COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20041201-1.c
		panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
	}
}

// ABITY  := BASETY | SUBWTY | :IDENT
// SUBWTY := 'sb' | 'ub' | 'sh' | 'uh'  # Sub-word types
func (c *ctx) abiType(n cc.Node, t cc.Type) string {
	switch t.Kind() {
	case cc.Struct, cc.Union:
		return ":" + c.typename(n, t)
	default:
		isInt := c.isIntegerType(t)
		sign := "u"
		if isInt && cc.IsSignedInteger(t) {
			sign = "s"
		}
		switch sz := c.sizeof(n, t); {
		case isInt && sz == 1:
			return fmt.Sprintf("%sb", sign)
		case isInt && sz == 2:
			return fmt.Sprintf("%sh", sign)
		}

		return c.baseType(n, t)
	}
}

func (c *ctx) loadType(n cc.Node, et cc.Type) string {
	switch c.sizeof(n, et) {
	case 1, 2, 4:
		return "w"
	case 8:
		return "l"
	default:
		panic(todo("%v: %s %v", n.Position(), et, et.Kind()))
	}
}

type qtypeField struct {
	count int64
	tag   string // "b", "h", "w", "l", "s", "d" but also ":foo" etc.
}

var sizeToTag = map[int64]string{
	1: "b",
	2: "h",
	4: "w",
	8: "l",
}

type qtype []qtypeField

func (c *ctx) newQtype(n cc.Node, t cc.Type) (r qtype) {
	// trc(" IN: %v: %s %v", pos(n), cc.NodeSource(n), t)
	defer func() {
		// trc("OUT: %v: %s %v %q %+v (A)", pos(n), cc.NodeSource(n), t, r.id(), r)
		r = r.normalize()
		// trc("OUT: %v: %s %v %q %+v (B)", pos(n), cc.NodeSource(n), t, r.id(), r)
	}()

	if t = t.Undecay(); t.Size() <= 0 {
		return nil
	}

	switch x := t.Undecay().(type) {
	case *cc.ArrayType:
		qt := c.newQtype(n, x.Elem())
		for _, v := range qt {
			v.count *= x.Len()
			r = append(r, v)
		}
	case *cc.StructType:
		groupOff := int64(-1)
		var sz int64
		for i := 0; i < x.NumFields(); i++ {
			f := x.FieldByIndex(i)
			ft := f.Type()
			if ft.Size() == 0 {
				continue
			}

			switch {
			case f.IsBitfield():
				foff := f.Offset()
				if foff != groupOff {
					if foff > sz {
						r = append(r, qtypeField{foff - sz, sizeToTag[1]})
					}
					r = append(r, qtypeField{1, sizeToTag[int64(f.GroupSize())]})
					groupOff = foff
					sz = f.Offset() + int64(f.GroupSize())
				}
			default:
				if f.Offset() > sz {
					r = append(r, qtypeField{f.Offset() - sz, sizeToTag[1]})
				}
				r = append(r, c.newQtype(n, ft)...)
				sz = f.Offset() + ft.Size()
			}
		}
		if n := x.Size() - sz; n != 0 {
			r = append(r, qtypeField{n, "b"})
		}
	case *cc.UnionType:
		var f *cc.Field
		var sz int64
		tag := ""
		tagSz := int64(-1)
		for i := 0; i < x.NumFields(); i++ {
			f = x.FieldByIndex(i)
			sz0 := f.Type().Size()
			if sz0 == 0 {
				continue
			}

			if f.IsBitfield() {
				sz0 = int64(f.GroupSize())
			}
			if sz0 > sz {
				sz = sz0
				if s := sizeToTag[sz]; s != "" {
					tag = s
					tagSz = sz
				}
			}
		}
		rem := x.Size()
		if tag != "" {
			r = append(r, qtypeField{1, tag})
			rem -= tagSz
		}
		if rem != 0 {
			r = append(r, qtypeField{rem, "b"})
		}
	case *cc.PredefinedType:
		r = append(r, qtypeField{1, c.extType(n, x)})
	case *cc.PointerType:
		r = append(r, qtypeField{1, c.wordTag})
	case *cc.EnumType:
		r = append(r, qtypeField{1, c.extType(n, x)})
	default:
		panic(todo("%v: %s %T", n.Position(), cc.NodeSource(n), x))
	}
	return r
}

func (t *qtype) normalize() (r qtype) {
	a := *t
	w := 0
	var prev qtypeField
	for _, v := range a {
		switch {
		case v.tag == prev.tag:
			a[w-1].count += v.count
			continue
		default:
			a[w] = v
			w++
		}
		prev = v
	}
	a = a[:w]
	*t = a
	return a
}

func (t *qtype) id() (r string) {
	var b strings.Builder
	for _, v := range *t {
		switch {
		case v.count != 1:
			fmt.Fprintf(&b, "%v%s,", v.count, v.tag)
		default:
			fmt.Fprintf(&b, "%s,", v.tag)
		}
	}
	r = b.String()
	return strings.TrimRight(r, ",")
}

func (c *ctx) typename(n cc.Node, t cc.Type) string {
	qt := c.newQtype(n, t)
	id := qt.id()
	return c.typeID2Name[id]
}
