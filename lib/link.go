// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"os"
	"path/filepath"
	"time"
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

	if t.c {
		for _, v := range t.compiled {
			if v.obj != "" || v.asm == "" {
				continue
			}

			fn := t.o
			if fn == "" {
				fn = stripExtS(v.asm) + ".o"
			}
			out, err := shell(time.Minute, t.cc, "-o", fn, "-c", v.asm)
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
	compiled := t.compiled
	for _, v := range t.inputFiles {
		switch filepath.Ext(v) {
		case ".c":
			ctx := compiled[0]
			compiled = compiled[1:]
			args = append(args, ctx.asm)
			asm = append(asm, ctx.asm)
		default:
			panic(todo("", v))
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
