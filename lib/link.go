// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bytes"
	"os"
	"time"

	"modernc.org/libqbe"
)

// Linker input.
type linkerObject struct {
	compilerFile *compilerFile
}

func newLinkerObject(f *compilerFile) (r *linkerObject) {
	return &linkerObject{compilerFile: f}
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
				case fileTypeHostAsm:
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
			case fileTypeHostAsm:
				fn := cf.out.(string)
				args = append(args, fn)
				asm = append(asm, fn)
			default:
				panic(todo("", cf.outType))
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
	var ssa []byte
	for _, lo := range t.linkerObjects {
		cf := lo.compilerFile
		switch cf.outType {
		case fileTypeQbeSSA:
			ssa = append(ssa, cf.out.([]byte)...)
			ssa = append(ssa, '\n')
		default:
			panic(todo("", cf.outType))
		}
	}

	var w bytes.Buffer
	if err := libqbe.Main("amd64_goabi0", fn, bytes.NewReader(ssa), &w, nil); err != nil {
		t.err(fileNode(fn), "producing Go ABI0 assember: %v", err)
		return
	}

	if err := os.WriteFile(fn, w.Bytes(), 0660); err != nil {
		t.err(fileNode(fn), "saving assembler: %v", err)
	}
}
