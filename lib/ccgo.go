// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc implements the qbecc command.
package qbecc // import "modernc.org/qbecc/lib"

import (
	"io"
	"os"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

// Options amend NewTask
//
// No options are currently defined.
type Options struct{}

// Task represents a compilation job.
type Task struct {
	args []string
}

// NewTask returns a newly created Task. args[0] is the command name.
//
// It's ok to pass nil 'opts'.
func NewTask(goos, goarch string, args []string, stdout, stderr io.Writer, opts *Options) (r *Task) {
	panic(todo(""))
}

func (t *Task) Main() (err error) {
	if dmesgs {
		dmesg("%v: ==== task.main enter %s CC=%q",
			origin(1), t.args, os.Getenv("CC"))
		defer func() {
			dmesg("%v: ==== exit: %v", origin(1), err)
		}()
	}
	panic(todo(""))
}
