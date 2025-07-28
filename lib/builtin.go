// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"

	"modernc.org/cc/v4"
)

type args map[string]any

// %a -> %.n, %b -> %.n+1, ...
func (c *ctx) builtin(s string, args args) (r any) {
	f := c.fn
	m := map[string]string{}
	for s != "" {
		sigil := s[0]
		s = s[1:]
		switch sigil {
		case '@', '%':
			nm := ""
		loop:
			for s != "" {
				switch ch := s[0]; {
				case ch >= 'a' && ch <= 'z' ||
					ch >= 'A' && ch <= 'Z' ||
					ch >= '0' && ch <= '9' ||
					ch == '_':

					s = s[1:]
					nm += string(ch)
				default:
					break loop
				}
			}
			switch arg, ok := args[nm]; {
			case ok:
				c.w("%s", arg)
			default:
				nm2 := m[nm]
				if nm2 == "" {
					switch sigil {
					case '%':
						nm2 = fmt.Sprintf(".%v", f.id())
					default:
						nm2 = fmt.Sprintf(".%v", c.id())
					}
					m[nm] = nm2
				}
				c.w("%c%s", sigil, nm2)
				if nm == "ret" {
					r = "%" + nm2
				}
			}
		default:
			c.w("%c", sigil)
		}
	}
	return r
}

// int __builtin_clz(unsigned int x);
func (c *ctx) clz(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.UInt)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%ret =w copy 0
	%a =w and %n, 4294901760
	jnz %a, @nza, @za
@za
	%ret =w add %ret, 16
	%n =w shl %n, 16
@nza
	%a =w and %n, 4278190080
	jnz %a, @nza2, @za2
@za2
	%ret =w add %ret, 8
	%n =w shl %n, 8
@nza2
	%a =w and %n, 4026531840
	jnz %a, @nza3, @za3
@za3
	%ret =w add %ret, 4
	%n =w shl %n, 4
@nza3
	%a =w and %n, 3221225472
	jnz %a, @nza4, @za4
@za4
	%ret =w add %ret, 2
	%n =w shl %n, 2
@nza4
	%a =w and %n, 2147483648
	jnz %a, @nza5, @za5
@za5
	%ret =w add %ret, 1
@nza5
`, args{"n": c.temp("w copy %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __builtin_clzl(unsigned long x);
func (c *ctx) clzl(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	if c.ast.ULong.Size() == 32 {
		return c.clz(n, mode, t)
	}

	return c.clzll(n, mode, t)
}

// int __builtin_clzll(unsigned long long x);
func (c *ctx) clzll(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.ULongLong)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%ret =w copy 0
	%a =l and %n, 18446744069414584320
	jnz %a, @nza, @za
@za
	%ret =w add %ret, 32
	%n =l shl %n, 32
@nza
	%a =l and %n, 18446462598732840960
	jnz %a, @nza2, @za2
@za2
	%ret =w add %ret, 16
	%n =l shl %n, 16
@nza2
	%a =l and %n, 18374686479671623680
	jnz %a, @nza3, @za3
@za3
	%ret =w add %ret, 8
	%n =l shl %n, 8
@nza3
	%a =l and %n, 17293822569102704640
	jnz %a, @nza4, @za4
@za4
	%ret =w add %ret, 4
	%n =l shl %n, 4
@nza4
	%a =l and %n, 13835058055282163712
	jnz %a, @nza5, @za5
@za5
	%ret =w add %ret, 2
	%n =l shl %n, 2
@nza5
	%a =l and %n, 9223372036854775808
	jnz %a, @nza6, @za6
@za6
	%ret =w add %ret, 1
@nza6
`, args{"n": c.temp("l copy %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __builtin_ctz (unsigned int x);
func (c *ctx) ctz(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.UInt)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%ret =w copy 0
	%a =w and %n, 65535
	jnz %a, @nza, @za
@za
	%ret =w add %ret, 16
	%n =w shr %n, 16
@nza
	%a =w and %n, 255
	jnz %a, @nza2, @za2
@za2
	%ret =w add %ret, 8
	%n =w shr %n, 8
@nza2
	%a =w and %n, 15
	jnz %a, @nza3, @za3
@za3
	%ret =w add %ret, 4
	%n =w shr %n, 4
@nza3
	%a =w and %n, 3
	jnz %a, @nza4, @za4
@za4
	%ret =w add %ret, 2
	%n =w shr %n, 2
@nza4
	%a =w and %n, 1
	jnz %a, @nza5, @za5
@za5
	%ret =w add %ret, 1
@nza5
`, args{"n": c.temp("w copy %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __builtin_ctzl (unsigned long x);
func (c *ctx) ctzl(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	if c.ast.ULong.Size() == 32 {
		return c.ctz(n, mode, t)
	}

	return c.ctzll(n, mode, t)
}

// int __builtin_ctzll (unsigned long long);
func (c *ctx) ctzll(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.ULongLong)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%ret =w copy 0
	%a =l and %n, 4294967295
	jnz %a, @nza, @za
@za
	%ret =w add %ret, 32
	%n =l shr %n, 32
@nza
	%a =l and %n, 65535
	jnz %a, @nza2, @za2
@za2
	%ret =w add %ret, 16
	%n =l shr %n, 16
@nza2
	%a =l and %n, 255
	jnz %a, @nza3, @za3
@za3
	%ret =w add %ret, 8
	%n =l shr %n, 8
@nza3
	%a =l and %n, 15
	jnz %a, @nza4, @za4
@za4
	%ret =w add %ret, 4
	%n =l shr %n, 4
@nza4
	%a =l and %n, 3
	jnz %a, @nza5, @za5
@za5
	%ret =w add %ret, 2
	%n =l shr %n, 2
@nza5
	%a =l and %n, 1
	jnz %a, @nza6, @za6
@za6
	%ret =w add %ret, 1
@nza6
`, args{"n": c.temp("l copy %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __isfinitef(float x);
func (c *ctx) isfinitef(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.Float)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%exp =w shr %n, 23
	%exp =w and %exp, 255
	%ret =w cnew %exp, 255
`, args{"n": c.temp("w cast %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __isfinite(double x);
func (c *ctx) isfinite(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	e := c.expr(n, rvalue, c.ast.Double)
	switch mode {
	case rvalue:
		defer func() { r = c.convert(n, t, c.ast.Int, r) }()

		return c.builtin(`	%exp =l shr %n, 52
	%exp =l and %exp, 2047
	%ret =w cnel %exp, 2047
`, args{"n": c.temp("l cast %s\n", e)})
	default:
		panic(todo("%v: %v %s", n.Position(), mode, cc.NodeSource(n)))
	}
}

// int __isfinitel(long double x);
func (c *ctx) isfinitel(n cc.ExpressionNode, mode mode, t cc.Type) (r any) {
	return c.isfinite(n, mode, t)
}
