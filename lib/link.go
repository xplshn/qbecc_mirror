// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
	"time"

	"modernc.org/libqbe"
	"modernc.org/qbecc/lib/internal/parser"
)

type symbolType int

const (
	symbolInvalid symbolType = iota
	symbolFunction
	symbolExportedFunction
	symbolData
	symbolExportedData
)

// Linker input.
type linkerObject struct {
	compilerFile *compilerFile
	defines      map[string]symbolType // export function $foo() { ... }, export data $bar = { ... }
	references   map[string]struct{}   // call $printf, store $foo, load $bar
	signatures   map[string][]string   // "$myfunc": []{"tls *libc.TLS", "x int32"}
	task         *Task
}

func (t *Task) newLinkerObject(f *compilerFile) (r *linkerObject) {
	return &linkerObject{
		compilerFile: f,
		defines:      map[string]symbolType{},
		references:   map[string]struct{}{},
		task:         t,
	}
}

func (l *linkerObject) ssaTyp(s string) string {
	switch s {
	case "w":
		return "int32"
	case "l":
		return "int64"
	default:
		panic(todo("", s))
	}
}

func (l *linkerObject) inspectSSA(ssa []byte, nm string) (ok bool) {
	l.signatures = map[string][]string{}
	ast, err := parser.Parse(ssa, nm, false)
	if err != nil {
		l.task.err(fileNode(nm), "%v", err)
		return false
	}

	for _, v := range ast.Defs {
		switch x := v.(type) {
		case *parser.FuncDefNode:
			st := symbolFunction
			if x.Export.IsValid() {
				st = symbolExportedFunction
			}
			fn := string(x.Global.Src())
			l.defines[fn] = st
			a := []string{"tls *libc.TLS"}
			for _, v := range x.Params {
				switch x := v.(type) {
				case *parser.RegularParamNode:
					a = append(a, fmt.Sprintf("%s %s", x.Local.Src()[1:], l.ssaTyp(string(x.Type.Src()))))
				default:
					panic(todo("%T", x))
				}
			}
			switch {
			case fn == "$main":
				if len(a) < 2 {
					a = append(a, "argc int32")
				}
				if len(a) < 3 {
					a = append(a, "argv uintptr")
				}
				if b := strings.Split(a[2], " "); b[1] != "uintptr" {
					a[2] = b[0] + " uintptr"
				}
				a = append(a, "int32")
			default:
				switch {
				case x.ABIType.IsValid():
					a = append(a, l.ssaTyp(string(x.ABIType.Src())))
				default:
					a = append(a, "")
				}
			}
			l.signatures[fn[1:]] = a
			for _, v := range x.Blocks {
				for _, w := range v.Insts {
					var ref parser.Node
					switch x := w.(type) {
					case *parser.CallNode:
						ref = x.Val
					case *parser.LoadNode:
						ref = x.Val
					case *parser.StoreNode:
						ref = x.Dst
					default:
						continue
					}

					switch x := ref.(type) {
					case *parser.Tok:
						l.references[string(x.Src())] = struct{}{}
					default:
						panic(todo("%T", x))
					}
				}
			}
		case *parser.DataDefNode:
			st := symbolData
			if x.Linkage.IsValid() {
				switch ln := string(x.Linkage.Src()); ln {
				case "export":
					st = symbolExportedData
				default:
					panic(todo("%q", ln))
				}
			}
			l.defines[string(x.Global.Src())] = st
			for _, v := range x.Items {
				switch y := v.(type) {
				case *parser.Global:
					l.references[string(y.Name.Src())] = struct{}{}
				}
			}
		default:
			panic(todo("%T", x))
		}
	}
	return true
}

func (l *linkerObject) goabi0(w io.Writer, ssa []byte, nm string, externs map[string]string) (ok bool) {
	ast, err := parser.Parse(ssa, nm, false)
	if err != nil {
		l.task.err(fileNode(nm), "%v", err)
		return false
	}

	rewritten := parser.RewriteSource(func(nm string) (r string) {
		// defer func() { trc("nm=%s r=%s", nm, r)}()
		if !strings.HasPrefix(nm, "$") {
			return nm
		}

		if _, ok := l.defines[nm]; ok {
			if !strings.HasPrefix(nm, "$.") {
				nm = "$." + nm[1:]
			}
			return nm
		}

		new := fmt.Sprintf("$\"%s.Y%s\"", externs[nm], nm[1:])
		new = strings.ReplaceAll(new, ".", "·")
		return strings.ReplaceAll(new, "/", "\u2215")
	}, ast.Defs...)
	var o libqbe.Options
	if l.task.dumpSSA {
		o.DumpGoABI0SSA = true
	}
	if err := libqbe.Main("amd64_goabi0", nm, strings.NewReader(rewritten), w, &o); err != nil {
		l.task.err(fileNode(nm), "producing Go ABI0 assember: %v", err)
		return false
	}

	return true
}

// -c
// -S
// -E
//
// If any of these options is used, then the linker is not run.
func (t *Task) link() {
	if t.optS || t.optE {
		return
	}

	defer t.recover(nil)

	switch {
	case t.goabi0:
		t.linkGoABI0()
	default:
		if t.c {
			for _, lo := range t.linkerObjects {
				cf := lo.compilerFile
				switch cf.outType {
				case fileHostAsm, fileLib:
					// ok
				default:
					panic(todo("", cf.outType))
				}

				asm := cf.out.(string)
				fn := t.o
				if fn == "" {
					fn = stripExtS(asm) + ".o"
				}
				out, err := shell(time.Minute, t.cc, "-o", fn, "-c", asm)
				if err != nil {
					t.err(nil, "%v %s", err, out)
					return
				}
			}
			return
		}

		fn := t.o
		if fn == "" {
			fn = "a.out"
		}
		args := []string{"-o", fn}
		var asm []string
		for _, lo := range t.linkerObjects {
			cf := lo.compilerFile
			switch cf.outType {
			case fileHostAsm:
				fn := cf.out.(string)
				args = append(args, fn)
				asm = append(asm, fn)
			case fileLib:
				args = append(args, "-l", cf.name)
			default:
				panic(todo("", cf.outType, cf.name))
			}
		}

		defer func() {
			for _, v := range asm {
				os.Remove(v)
			}
		}()

		out, err := shell(time.Minute, t.cc, args...)
		if err != nil {
			t.err(nil, "%v %s", err, out)
		}
	}
}

func (t *Task) linkGoABI0() {
	if t.goos != "linux" || t.goarch != "amd64" {
		panic(todo(""))
	}

	fn := t.o
	if fn == "" {
		fn = "a.s"
	}
	exported := map[string]*linkerObject{} // $what: where
	undefined := map[string]string{}       // $what: "example.com/foo", ie. rewrite $what to "$example.com/foo.Ywhat"
	for _, lo := range t.linkerObjects {
		cf := lo.compilerFile
		switch cf.outType {
		case fileQbeSSA:
			if !lo.inspectSSA(cf.out.([]byte), cf.name) {
				return
			}

			for k, v := range lo.defines {
				switch v {
				case symbolExportedData, symbolExportedFunction:
					if _, ok := exported[k]; !ok {
						exported[k] = lo
					}
				}
			}
			for k := range lo.references {
				undefined[k] = ""
			}
		default:
			panic(todo("", cf.outType))
		}
	}

	for k := range exported {
		delete(undefined, k)
	}
	for k := range undefined {
		undefined[k] = "modernc.org/libc" //TODO support linking above libc
	}
	f, err := os.Create(fn)
	if err != nil {
		t.err(fileNode(fn), "%v", err)
		return
	}

	defer func() {
		if err := f.Close(); err != nil {
			t.err(fileNode(fn), "%v", err)
		}
	}()

	w := bufio.NewWriter(f)

	defer func() {
		if err := w.Flush(); err != nil {
			t.err(fileNode(fn), "%v", err)
		}
	}()

	for _, lo := range t.linkerObjects {
		cf := lo.compilerFile
		switch cf.outType {
		case fileQbeSSA:
			if !lo.goabi0(w, cf.out.([]byte), cf.name, undefined) {
				return
			}
		default:
			panic(todo("", cf.outType))
		}
	}
}
