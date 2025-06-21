// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

func (c *ctx) initializer(n *cc.Initializer, t cc.Type) (r string) {
	defer func() {
		if n != nil {
			r = c.convertRValue(n, t, n.Type(), r)
		}
	}()

	switch {
	case n == nil:
		switch sz := t.Size(); {
		case sz <= 8:
			return "0"
		}

		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		switch x := n.Value().(type) {
		case cc.Int64Value:
			return fmt.Sprint(int64(x))
		case *cc.UnknownValue:
			// nop
		default:
			panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
		}

		switch it := n.Type(); {
		case cc.IsScalarType(it):
			switch it.Size() {
			case 4, 8:
				return c.expr(n.AssignmentExpression, rvalue, t)
			default:
				panic(todo("%v: %v %s", n.Position(), t, cc.NodeSource(n)))
			}
		default:
			panic(todo("%v: %v %s", n.Position(), t, cc.NodeSource(n)))
		}
	}
}
