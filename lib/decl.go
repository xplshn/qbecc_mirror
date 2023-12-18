// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

func (t *Task) compile(fn string) {
	ast, err := cc.Translate(t.cfg, t.sourcesFor(fn))
	if err != nil {
		t.err(err)
		return
	}

	for list := ast.TranslationUnit; list != nil; list = list.TranslationUnit {
		switch ed := list.ExternalDeclaration; ed.Case {
		case cc.ExternalDeclarationFuncDef:
			t.functionDefinition(ed.FunctionDefinition)
		case cc.ExternalDeclarationDecl:
			t.declaration(ed.Declaration)
		default:
			panic(todo("%v: %v\n%s", ed.Position(), ed.Case, cc.NodeSource(ed)))
		}
	}
}

func (t *Task) declaration(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl:
		for list := n.InitDeclaratorList; list != nil; list = list.InitDeclaratorList {
			t.initDeclarator(list.InitDeclarator)
		}
	default:
		panic(todo("%v: %v\n%s", n.Position(), n.Case, cc.NodeSource(n)))
	}
}

func (t *Task) initDeclarator(n *cc.InitDeclarator) {
	d := n.Declarator
	switch {
	case d.IsTypename():
		return
	case d.Type().Kind() == cc.Function: // function prototype
		return
	case d.IsExtern():
		return
	}

	trc("%s %s %s", n.Declarator.Name(), cc.NodeSource(n), n.Declarator.Type())
}

func (t *Task) functionDefinition(n *cc.FunctionDefinition) {
	trc("", n.Declarator.Name())
}
