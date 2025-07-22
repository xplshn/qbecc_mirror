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
	"sync"
	"time"

	"modernc.org/gc/v3"
	"modernc.org/libqbe"
	"modernc.org/qbecc/lib/internal/parser"
)

var (
	gcCache       *gc.Cache
	libcCache     *linkerObject // 18.611s
	libcCacheErr  error
	onceLibcCache sync.Once
)

func init() {
	if c, err := gc.NewCache(1 << 24); err == nil {
		gcCache = c
	}
}

type symbolType int

const (
	symbolInvalid symbolType = iota
	symbolFunction
	symbolExportedFunction
	symbolData
	symbolExportedData
)

type refType int

const (
	refInvalid refType = iota
	refFunc
	refMem
	refData
)

// Linker input.
type linkerObject struct {
	compilerFile *compilerFile
	defines      map[string]symbolType // export function $foo() { ... }, export data $bar = { ... }
	signatures   map[string][]string   // "$myfunc": []{"tls *libc.TLS", "x int32"}
	task         *Task
	//TODO- types        map[string]int64 // name: size
}

func (t *Task) newLinkerObject(f *compilerFile) (r *linkerObject) {
	return &linkerObject{
		compilerFile: f,
		defines:      map[string]symbolType{},
		task:         t,
		//TODO- types:        map[string]int64{},
	}
}

func (l *linkerObject) ssaTyp(s string) string {
	switch s {
	case "w":
		return "int32"
	case "l":
		return "int64"
	case "s":
		return "float32"
	case "d":
		return "float64"
	case "sb":
		return "int8"
	case "ub":
		return "byte"
	case "sh":
		return "int16"
	case "uh":
		return "uint16"
	default:
		return "uintptr"
		//TODO- if sz, ok := l.types[s]; ok {
		//TODO- 	return fmt.Sprintf("[%v]byte", sz)
		//TODO- }

		//TODO- // all_test.go:441: GO COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/920726-1.c
		//TODO- panic(todo("", s))
	}
}

func isQBEExported(nm string) bool {
	return strings.HasPrefix(nm, "$") && !strings.HasPrefix(nm, "$.")
}

func (l *linkerObject) inspectSSA(ssa []byte, nm string) (ok bool) {
	defer func() {}()
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
			if isQBEExported(fn) {
				l.defines[fn[1:]] = st
			}
			a := []string{"tls *libc.TLS"}
			for _, v := range x.Params {
				switch x := v.(type) {
				case *parser.RegularParamNode:
					a = append(a, fmt.Sprintf("%s %s", x.Local.Src()[1:], l.ssaTyp(string(x.Type.Src()))))
				case *parser.VariadicMarkerNode:
					a = append(a, "__qbe_va_arg uintptr")
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
			if nm := string(x.Global.Src()); isQBEExported(nm) {
				l.defines[nm[1:]] = st
			}
		case *parser.TypeDefNode:
			// ok
		default:
			panic(todo("%T", x))
		}
	}
	return true
}

func (l *linkerObject) goabi0(w io.Writer, ssa []byte, nm string, externs map[string]*linkerObject) (ok bool) {
	ast, err := parser.Parse(ssa, nm, false)
	if err != nil {
		l.task.err(fileNode(nm), "%v", err)
		return false
	}

	rewritten := parser.RewriteSource(func(nm string) (r string) {
		switch nm { // Rename Go conflicts
		case "%g":
			return "%__qbe_g" // assembler reserved
		case "%map":
			return "%__qbe_map" // Go reserved
		case "%type":
			return "%__qbe_type" // Go reserved
		case "%var":
			return "%__qbe_var" // Go reserved
		}
		cname := nm[1:]
		// defer func() { trc("(nm=%s cname=%s)->%s", nm, cname, r) }()
		if !isQBEExported(nm) {
			return nm
		}

		if k, ok := l.defines[cname]; ok {
			switch k {
			case symbolExportedData, symbolExportedFunction:
				if cname == "main" {
					return nm
				}

				return "$Y" + cname
			default:
				return nm
			}
		}

		resolvedIn := externs[cname]
		if resolvedIn == nil {
			return nm
		}

		switch resolvedIn.compilerFile.outType {
		case fileLib: // -lc, -lm, -lfoo, ...
			importPath := fmt.Sprintf("modernc.org/lib%s", resolvedIn.compilerFile.name)
			switch resolvedIn.defines[cname] {
			case symbolExportedFunction:
				nm = fmt.Sprintf("$\"%s.Y%s\"", importPath, cname)
			case symbolExportedData:
				nm = fmt.Sprintf("$\"%s.X%s\"", importPath, cname)
			default:
				panic(todo("230: %v %v", cname, resolvedIn.defines[cname]))
			}
		default:
			panic(todo("228: %v %v %v", cname, resolvedIn.compilerFile.name, resolvedIn.compilerFile.outType))
		}

		nm = strings.ReplaceAll(nm, ".", "·")
		return strings.ReplaceAll(nm, "/", "\u2215")
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
				case fileHostAsm:
					// ok
				case fileLib:
					continue
				default:
					panic(todo("", cf.outType))
				}

				trc("", cf)
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
				// COMPILE FAIL: ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20000519-1.c
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
	externs := map[string]*linkerObject{} // cname: defined in
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
					if _, ok := externs[k]; !ok {
						externs[k] = lo
					}
				}
			}
		case fileLib:
			if err := lo.loadLib(); err != nil {
				t.err(fileNode(fmt.Sprintf("-l%s", lo.compilerFile.name)), "%v", err)
				return
			}
		default:
			panic(todo("", cf.outType))
		}
		for k := range lo.defines {
			if _, ok := externs[k]; !ok {
				externs[k] = lo
			}
		}
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
			if !lo.goabi0(w, cf.out.([]byte), cf.name, externs) {
				return
			}
		case fileLib:
			//TODO
		default:
			panic(todo("", cf.outType))
		}
	}
}

func (l *linkerObject) loadLib0(importPath string) (err error) {
	pkg, err := loadPackage(importPath)
	if err != nil {
		return err
	}

	pkg.Scope.Iterate(func(nm string, n gc.Node) (stop bool) {
		switch x := n.(type) {
		case *gc.FunctionDeclNode:
			if !strings.HasPrefix(nm, "Y") {
				break
			}

			p0 := x.Signature.Parameters.ParameterDeclList
			if p0 == nil {
				break
			}

			if strings.Contains(p0.Source(false), "*TLS") {
				l.defines[nm[1:]] = symbolExportedFunction
			}
		case *gc.VarSpecNode:
			if !strings.HasPrefix(nm, "X") {
				break
			}

			l.defines[nm[1:]] = symbolExportedData
		case
			*gc.AliasDeclNode,
			*gc.ConstSpecNode,
			*gc.TypeDefNode:

			// ok
		default:
			panic(todo("%T %s", x, nm))
		}
		return false
	})
	return nil
}

func (l *linkerObject) loadLib() (err error) {
	importPath := fmt.Sprintf("modernc.org/lib%s", l.compilerFile.name)
	if importPath == "modernc.org/libc" {
		onceLibcCache.Do(func() {
			if libcCacheErr = l.loadLib0(importPath); libcCacheErr == nil {
				libcCache = l
			}
		})
		if libcCacheErr != nil {
			return libcCacheErr
		}

		l.defines = libcCache.defines
		return nil
	}

	return l.loadLib0(importPath)
}

func loadPackage(importPath string) (pkg *gc.Package, err error) {
	var opts []gc.ConfigOption
	if gcCache != nil {
		opts = append(opts, gc.ConfigCache(gcCache))
	}
	cfg, err := gc.NewConfig(opts...)
	if err != nil {
		return nil, err
	}
	return cfg.NewPackage("", importPath, "", nil, false, gc.TypeCheckNone)
}
