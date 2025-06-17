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

type local struct {
	renamed string

	isValue bool
}

// Function compile context
type fnCtx struct {
	locals  map[*cc.Declarator]*local
	returns cc.Type
	static  []*cc.InitDeclarator
}

func (f *fnCtx) registerLocal(d *cc.Declarator) (r *local) {
	if f.locals == nil {
		f.locals = map[*cc.Declarator]*local{}
	}
	if r = f.locals[d]; r == nil {
		r = &local{
			isValue: !d.AddressTaken(),
			renamed: fmt.Sprintf("%%%s.%d", d.Name(), len(f.locals)),
		}
		f.locals[d] = r
	}
	return r
}

// Translation unit compile context
type ctx struct {
	ast     *cc.AST
	buf     // QBE SSA
	file    *compilerFile
	fn      *fnCtx
	nextID  int
	strings map[string]string // value: name
	t       *Task

	failed bool
}

func (t *Task) newCtx(ast *cc.AST, file *compilerFile) *ctx {
	return &ctx{
		ast:  ast,
		file: file,
		t:    t,
	}
}

func (c *ctx) err(n cc.Node, s string, args ...any) {
	c.failed = true
	c.t.err(n, s, args...)
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
		c.w("data %s = { b %s }\n", c.strings[k], strconv.QuoteToASCII(k))
	}
	return true
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
	var v any
	if file.in != nil {
		v = file.in
	}
	return append(r, cc.Source{Name: file.name, Value: v}), nil
}

func (t *Task) asmFile(in string, c *ctx) (err error) {
	ssa := bytes.TrimSpace(c.b.Bytes())
	var enc bytes.Buffer
	if _, _, err := ace.Compress(&enc, bytes.NewBuffer(ssa)); err != nil {
		return err
	}

	strippedNm := stripExtCH(in)
	fn := strippedNm + ".ssa"
	var asm buf
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
	if err := libqbe.Main(t.target, fn, &c.b, &asm.b, nil); err != nil {
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
func (t *Task) compileOne(in *compilerFile) (r *ctx) {
	srcs, err := t.sourcesFor(in)
	if err != nil {
		t.err(fileNode(in.name), "%v", err)
		return
	}

	ast, err := cc.Translate(t.cfg, srcs)
	if err != nil {
		t.err(fileNode(in.name), "%v", err)
		return
	}

	r = t.newCtx(ast, in)
	r.w(t.ssaHeader)
	if !r.translationUnit(ast.TranslationUnit) {
		return
	}

	// trc("====\n%s", r.buf.b.Bytes())
	if err = t.asmFile(in.name, r); err != nil {
		t.err(fileNode(in.name), "%v", err)
		return
	}

	return r
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
				if t.compileOne(v).failed {
					fail.Store(true)
				}
			})
		case fileELF:
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
