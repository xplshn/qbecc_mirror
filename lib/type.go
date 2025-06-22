// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

// BASETY := 'w' | 'l' | 's' | 'd' # Base types
func (c *ctx) baseType(n cc.Node, t cc.Type) string {
	switch t.Kind() {
	case cc.Ptr:
		switch t.Size() {
		case 4:
			return "w"
		case 8:
			return "l"
		default:
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	case cc.Enum:
		return c.baseType(n, t.(*cc.EnumType).UnderlyingType())
	default:
		switch {
		case c.isIntegerType(t):
			switch sz := t.Size(); {
			case sz <= 4:
				return "w"
			case sz <= 8:
				return "l"
			default:
				panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
			}
		case c.isFloatingPointType(t):
			switch t.Size() {
			case 4:
				return "s"
			case 8:
				return "d"
			default:
				panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
			}
		default:
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	}
}

// EXTTY  := BASETY | 'b' | 'h'    # Extended types
func (c *ctx) extType(n cc.Node, t cc.Type) string {
	if t.Size() >= 4 {
		return c.baseType(n, t)
	}

	switch {
	case c.isIntegerType(t):
		switch sz := t.Size(); {
		case sz == 1:
			return "b"
		case sz <= 2:
			return "h"
		default:
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	default:
		panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
	}
}
