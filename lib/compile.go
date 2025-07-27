// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bytes"
	"debug/elf"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"sync/atomic"

	"modernc.org/ace/lib"
	"modernc.org/cc/v4"
	"modernc.org/libqbe"
)

// Compiler input.
type compilerFile struct {
	inType  fileType
	in      []byte // nil: read from disk
	name    string
	out     any // string: disk file name
	outType fileType
}

// Translation unit compile context
type ctx struct {
	ast              *cc.AST
	buf              // QBE SSA
	file             *compilerFile
	fn               *fnCtx
	inlineFns        map[*cc.Declarator]*cc.FunctionDefinition
	nextID           int
	strings          map[string]string // value: name
	t                *Task
	typeID2Name      map[string]string // id: name
	typesByID        map[string]*qtype // id: qtype
	typesByName      map[string]*qtype // name: qtype
	typesInDeclOrder []string          // name: qtype
	unsupportedTypes map[cc.Type]bool
	variables        variables
	wordSize         int64
	wordTag          string

	failed bool
}

func (t *Task) newCtx(ast *cc.AST, file *compilerFile) (r *ctx) {
	r = &ctx{
		ast:         ast,
		file:        file,
		inlineFns:   map[*cc.Declarator]*cc.FunctionDefinition{},
		t:           t,
		typeID2Name: map[string]string{},
		typesByID:   map[string]*qtype{},
		typesByName: map[string]*qtype{},
		wordSize:    t.wordSize,
		wordTag:     t.wordTag,
	}
	for _, v := range ast.Scope.Nodes {
		for _, w := range v {
			switch x := w.(type) {
			case *cc.Declarator:
				if x.IsTypename() { // typedef int i;
					break
				}

				if r.isUnsupportedType(x.Type()) && !x.IsExtern() {
					r.err(x, "unsupported type")
				}
				r.variables.register(x, nil, r, 0)
			}
		}
	}
	for n := ast.TranslationUnit; n != nil; n = n.TranslationUnit {
		switch ed := n.ExternalDeclaration; ed.Case {
		case cc.ExternalDeclarationDecl: // Declaration
			switch decl := ed.Declaration; decl.Case {
			case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
				switch {
				case decl.InitDeclaratorList == nil:
					if decl.DeclarationSpecifiers != nil {
						r.registerQType(decl, "", decl.DeclarationSpecifiers.Type())
					}
				default:
					nm := ""
					d := decl.InitDeclaratorList.InitDeclarator.Declarator
					if d.IsTypename() {
						nm = d.Name()
					}
					r.registerQType(decl, nm, decl.DeclarationSpecifiers.Type())
				}
			case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
				r.registerQType(decl, "", decl.Declarator.Type())
			}
		}
	}
	return r
}

func (c *ctx) registerQType(n cc.Node, nm string, t cc.Type) {
	if nm == "" {
		nm = fmt.Sprintf("__qbe_type%v", c.id())
	}
	for {
		switch x := t.Undecay().(type) {
		case *cc.ArrayType:
			t = x.Elem()
			continue
		case *cc.PointerType:
			t = x.Elem()
			continue
		case *cc.StructType:
			qt := c.newQtype(n, t)
			id := qt.id()
			if c.typesByID[id] == nil {
				c.typesByID[id] = &qt
				c.typesByName[nm] = &qt
				c.typesInDeclOrder = append(c.typesInDeclOrder, nm)
				c.typeID2Name[id] = nm
			}
		case *cc.UnionType:
			qt := c.newQtype(n, t)
			id := qt.id()
			if c.typesByID[id] == nil {
				c.typesByID[id] = &qt
				c.typesByName[nm] = &qt
				c.typesInDeclOrder = append(c.typesInDeclOrder, nm)
				c.typeID2Name[id] = nm
			}
		}
		return
	}
}

func (c *ctx) isVLA(t cc.Type) (r bool) {
	switch x := t.Undecay().(type) {
	case *cc.ArrayType:
		if x.SizeExpression() != nil && x.SizeExpression().Value() == nil {
			return true
		}
	}
	return false
}

func (c *ctx) isUnsupportedType(t cc.Type) (r bool) {
	r, ok := c.unsupportedTypes[t]
	if ok {
		return r
	}

	switch x := t.(type) {
	case *cc.ArrayType:
		r = x.Len() < 0 || c.isUnsupportedType(x.Elem()) || c.isVLA(x)
	case *cc.StructType:
		for i := 0; i < x.NumFields(); i++ {
			f := x.FieldByIndex(i)
			if f.IsFlexibleArrayMember() {
				if c.isUnsupportedType(f.Type().(*cc.ArrayType).Elem()) {
					r = true
					break
				}

				continue
			}

			if c.isUnsupportedType(f.Type()) {
				r = true
				break
			}
		}
	case *cc.UnionType:
		for i := 0; i < x.NumFields(); i++ {
			if c.isUnsupportedType(x.FieldByIndex(i).Type()) {
				r = true
				break
			}
		}
	default:
		if t.VectorSize() > 0 {
			r = true
		}
	}
	if c.unsupportedTypes == nil {
		c.unsupportedTypes = map[cc.Type]bool{}
	}
	if t.Align() < 0 || t.Align() > 8 || t.Size() < 0 {
		r = true
	}
	c.unsupportedTypes[t] = r
	return r
}

func (c *ctx) sizeof(n cc.Node, t cc.Type) int64 {
	if c.isUnsupportedType(t) {
		if n != nil {
			c.err(n, "unsupported type")
			return 1
		}
	}

	return t.Size()
}

func (c *ctx) err(n cc.Node, s string, args ...any) {
	c.failed = true
	c.t.err(n, s, args...)
}

// define a new temp var, return its name
func (c *ctx) temp(s string, args ...any) (r string) {
	var id int
	switch {
	case c.fn != nil:
		id = c.fn.id()
	default:
		id = c.id()
	}
	r = fmt.Sprintf("%%.%v", id)
	c.w("\t%s =", r)
	c.w(s, args...)
	return r
}

func (c *ctx) variable(n cc.Node) (d *cc.Declarator, v variable) {
	// defer func() {
	// 	trc("%v: %s %T -> %p %v (fn=%p)", n.Position(), cc.NodeSource(n), n, d, v, c.fn)
	// }()
	switch x := n.(type) {
	case *cc.Declarator:
		d = x
	case cc.ExpressionNode:
		if d = c.declaratorOf(x); d != nil {
			n = d
		}
	case *cc.JumpStatement:
		return d, c.fn.variables[n]
	default:
		panic(todo("%T", x))
	}
	switch {
	case c.fn != nil:
		return d, c.fn.variables[n]
	default:
		return d, c.variables[n]
	}
}

func (c *ctx) translationUnit(n *cc.TranslationUnit) (ok bool) {
	for ; n != nil; n = n.TranslationUnit {
		c.externalDeclaration(n.ExternalDeclaration)
	}
	if c.failed {
		return false
	}

	var a []string
	for k := range c.strings {
		a = append(a, k)
	}
	sort.Strings(a)
	c.w("\n")
	for _, k := range a {
		c.w("data %s = align 1 { %s }\n", c.strings[k], c.safeString(k))
	}
	return true
}

func (c *ctx) safeString(s string) (r string) {
	var parts []string
	for i := 0; i < len(s); i++ {
		parts = append(parts, fmt.Sprintf("b %v", s[i]))
	}
	return strings.Join(parts, ", ")
}

func (c *ctx) pos(n cc.Node) {
	if n != nil {
		switch c.t.positions {
		case posBase:
			p := n.Position()
			p.Filename = filepath.Base(p.Filename)
			c.w("# %v:\n", p)
		case posFull:
			c.w("# %v:\n", n.Position())
		}
	}
}

func (c *ctx) id() (r int) {
	r = c.nextID
	c.nextID++
	return r
}

func (c *ctx) addString(s string) (r string) {
	if c.strings == nil {
		c.strings = map[string]string{}
	}
	if r = c.strings[s]; r == "" {
		r = fmt.Sprintf("$.ts.%d", c.id())
		c.strings[s] = r
	}
	return r
}

// inputTypeC, inputTypeH
func (t *Task) sourcesFor(file *compilerFile) (r []cc.Source, err error) {
	r = []cc.Source{
		{Name: "<predefined>", Value: t.cfg.Predefined + predefined},
		{Name: "<builtin>", Value: builtin},
	}
	if len(t.optD)+len(t.optU) != 0 {
		r = append(r, cc.Source{Name: "<command-line>", Value: buildDefs(t.optD, t.optU)})
	}
	var v any
	if file.in != nil {
		v = file.in
	}
	return append(r, cc.Source{Name: file.name, Value: v}), nil
}

var (
	__builtin_ = []byte("$__builtin_")
	dlr        = []byte{'$'}
)

func (t *Task) asmFile(in string, c *ctx) (err error) {
	ssa := bytes.TrimSpace(c.b.Bytes())
	strippedNm := stripExtCH(in)
	fn := strippedNm + ".ssa"
	var asm buf
	if t.keepSSA {
		var enc bytes.Buffer
		if _, _, err := ace.Compress(&enc, bytes.NewBuffer(ssa)); err != nil {
			return err
		}

		asm.w(".section %s, \"\", @progbits\n", ssaSection)
		asm.w(".global .%s_start\n", ssaSection)
		asm.w(".global .%s_end\n", ssaSection)
		asm.w(".global .%s_size\n\n", ssaSection)
		asm.w("%s_start:\n", ssaSection)
		b := enc.Bytes()
		asm.w("\t.ascii \"%x\\x00\"\n", len(b))
		for len(b) != 0 {
			n := min(16, len(b))
			asm.w("\t.byte ")
			for i, v := range b[:n] {
				if i != 0 {
					asm.w(", ")
				}
				asm.w("%#02x", v)
			}
			asm.w("\n")
			b = b[n:]
		}
		asm.w("%s_end:\n", ssaSection)
		asm.w("\n.set %s_size, %[1]s_end - %[1]s_start\n\n", ssaSection)
	}
	cb := c.b.Bytes()
	cb = bytes.ReplaceAll(cb, __builtin_, dlr)
	if err := libqbe.Main(t.target, fn, bytes.NewReader(cb), &asm.b, nil); err != nil {
		return err
	}

	fn = strippedNm + ".s"
	if err = os.WriteFile(fn, asm.b.Bytes(), 0660); err != nil {
		return err
	}

	c.file.out = fn
	c.file.outType = fileHostAsm
	return nil
}

// inputTypeC, inputTypeH
func (t *Task) compileOne(in *compilerFile) bool {
	srcs, err := t.sourcesFor(in)
	if err != nil {
		t.err(fileNode(in.name), "%v", err)
		return false
	}

	if t.optE {
		if err := cc.Preprocess(t.cfg, srcs, t.options.Stderr); err != nil {
			t.err(fileNode(in.name), "%v", err)
		}
		return false
	}

	ast, err := cc.Translate(t.cfg, srcs)
	if err != nil {
		t.err(fileNode(in.name), "%v", err)
		return false
	}

	r := t.newCtx(ast, in)
	r.w(t.ssaHeader)
	r.emitTypes()
	if !r.translationUnit(ast.TranslationUnit) {
		return false
	}

	if t.dumpSSA {
		fmt.Fprintf(os.Stderr, "==== SSA\n%s", r.buf.b.Bytes())
	}
	if err = t.asmFile(in.name, r); err != nil {
		t.err(fileNode(in.name), "%v", err)
		return false
	}

	return !r.failed
}

func (c *ctx) emitTypes() {
	for _, v := range c.typesInDeclOrder {
		c.emitType(v)
	}
}

func (c *ctx) emitType(nm string) {
	t := *c.typesByName[nm]
	if len(t) == 0 {
		return
	}

	c.w("type :%s = {\n", nm)
	for _, f := range t {
		switch {
		case f.count != 1:
			c.w("\t%s %v,\n", f.tag, f.count)
		default:
			c.w("\t%s,\n", f.tag)
		}
	}
	c.w("}\n\n")
}

func (t *Task) compile() (ok bool) {
	var fail atomic.Bool

	defer t.recover(&fail)

	for _, v := range t.compilerFiles {
		if fail.Load() {
			break
		}

		t.linkerObjects = append(t.linkerObjects, t.newLinkerObject(v))
		switch v.inType {
		case fileC, fileH:
			t.parallel.exec(func() {
				defer t.recover(&fail)
				if !t.compileOne(v) {
					fail.Store(true)
				}
			})
		case fileELF:
			if t.optE {
				break
			}

			if !t.goabi0 {
				v.outType = fileELF
				break
			}

			t.parallel.exec(func() {
				ssa, err := t.ssaFromELF(v.name)
				if err != nil {
					t.err(fileNode(v.name), err.Error())
					fail.Store(true)
					return
				}

				var a []byte
				for _, w := range ssa {
					a = append(a, w...)
				}
				v.out = a
				v.outType = fileQbeSSA
			})
		case fileLib:
			// pass through
		default:
			t.err(fileNode(v.name), "unexpected file type")
			fail.Store(true)
		}
	}
	t.parallel.wait()
	return !fail.Load()
}

func (t *Task) ssaFromELF(fn string) (b [][]byte, err error) {
	f, err := elf.Open(fn)
	if err != nil {
		return nil, fmt.Errorf("error opening ELF file: %v", err)
	}

	defer f.Close()

	section := f.Section(ssaSection)
	if section == nil {
		return nil, fmt.Errorf("%v: section %s not found in", fn, ssaSection)
	}

	r := section.Open()
	if r == nil {
		return nil, fmt.Errorf("%v: could not open %s section for reading", fn, ssaSection)
	}

	data, err := io.ReadAll(r)
	if err != nil {
		return nil, fmt.Errorf("%v: error reading %s section content: %v", fn, ssaSection, err)
	}

	for len(data) != 0 {
		z := bytes.IndexByte(data, 0)
		if z < 0 {
			return nil, fmt.Errorf("%v: error parsing %s section content: %v", fn, ssaSection, err)
		}

		s := string(data[:z])
		data = data[z+1:]
		n, err := strconv.ParseUint(s, 16, 31)
		if err != nil {
			return nil, fmt.Errorf("%v: %s: error parsing hex value %q: %v", fn, ssaSection, s, err)
		}

		var w bytes.Buffer
		if _, _, err := ace.Decompress(&w, bytes.NewReader(data[:n])); err != nil {
			return nil, fmt.Errorf("%v: %s: error decompressing SSA: %v", fn, ssaSection, err)
		}

		data = data[n:]
		b = append(b, w.Bytes())
	}
	return b, nil
}
