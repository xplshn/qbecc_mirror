// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

func (c *ctx) typ(n cc.Node, t cc.Type) string {
	switch t.Kind() {
	case cc.Int:
		switch t.Size() {
		case 4:
			return "w"
		default:
			panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
		}
	default:
		panic(todo("%v: %s %v", n.Position(), t, t.Kind()))
	}
}
