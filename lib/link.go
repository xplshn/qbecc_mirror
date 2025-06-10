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
	case t.abi0:
		t.linkABI0()
	default:
		if t.c {
			for _, v := range t.inputFiles {
				if v.outType != fileASM {
					continue
				}

				asm := v.out.(string)
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
		for _, v := range t.inputFiles {
			switch v.outType {
			case fileASM:
				fn := v.out.(string)
				args = append(args, fn)
				asm = append(asm, fn)
			default:
				panic(todo("%+v", v))
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

func (t *Task) linkABI0() {
	if t.goos != "linux" || t.goarch != "amd64" {
		panic(todo(""))
	}

	fn := t.o
	if fn == "" {
		fn = "a.s"
	}
	var ssa []byte
	for _, v := range t.inputFiles {
		switch x := v.out.(type) {
		case []byte:
			ssa = append(ssa, x...)
			ssa = append(ssa, '\n')
		default:
			panic(todo("%T", x))
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
