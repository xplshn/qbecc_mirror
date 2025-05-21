// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"path/filepath"

	"modernc.org/cc/v4"
)

// fn is .c or .h
func (t *Task) sourcesFor(fn string) (r []cc.Source, err error) {
	r = []cc.Source{
		{Name: "<predefined>", Value: t.cfg.Predefined + predefined},
		{Name: "<builtin>", Value: builtin},
	}
	return append(r, cc.Source{Name: fn}), nil
}

func (t *Task) compile() {
	defer t.recover()

	var ctxs []*ctx
	for _, v := range t.inputFiles {
		switch filepath.Ext(v) {
		case ".c", ".h":
			t.parallel.exec(func() {
				ctxs = append(ctxs, t.compileOne(v))
			})
		default:
			t.err(nil, "unexpected file type: %s", v)
			return
		}
	}
	t.parallel.wait()
}

// fn is .c or .h, returns QBE SSA
func (t *Task) compileOne(fn string) (r *ctx) {
	srcs, err := t.sourcesFor(fn)
	if err != nil {
		t.err(nil, "%v", err)
		return
	}

	ast, err := cc.Translate(t.cfg, srcs)
	if err != nil {
		t.err(nil, "%v", err)
		return
	}

	r = t.newCtx(ast)
	r.w(t.options.SSAHeader)
	r.translationUnit(ast.TranslationUnit)
	//trc("\n%s", r.b.Bytes())
	return r
}

// Translation unit compile context
type ctx struct {
	ast *cc.AST
	buf
	fn *fnCtx
	t  *Task
}

func (t *Task) newCtx(ast *cc.AST) *ctx {
	return &ctx{
		ast: ast,
		t:   t,
	}
}

func (c *ctx) err(n cc.Node, s string, args ...any) {
	c.t.err(n, s, args...)
}

func (c *ctx) translationUnit(n *cc.TranslationUnit) {
	return //TODO-
	for ; n != nil; n = n.TranslationUnit {
		c.externalDeclaration(n.ExternalDeclaration)
	}
}

func (c *ctx) pos(n cc.Node) {
	if n != nil {
		c.w("# %v:\n", n.Position())
	}
}
