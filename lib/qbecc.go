// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler. (WIP)
//
// [QBE]: https://c9x.me/compile/
package qbecc // import "modernc.org/qbecc/lib"

import (
	"io"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

// Options amend NewTask.
//
// No options are currently defined.
type Options struct {
	Stdout io.Writer // Can be nil
	Stderr io.Writer // Can be nil
}

// Task represents a compilation job.
type Task struct {
	args    []string // from NewTask
	goarch  string   // from NewTask
	goos    string   // from NewTask
	options *Options // from NewTask
}

// NewTask returns a newly created Task. args[0] is the command name. For example
//
//	t := NewTask(nil, "linux", "amd64", "qbecc", "main.c")
//
// It's ok to pass nil 'opts'.
func NewTask(options *Options, goos, goarch string, args ...string) (r *Task) {
	if options == nil {
		options = &Options{}
	}
	if options.Stdout == nil {
		options.Stdout = io.Discard
	}
	if options.Stderr == nil {
		options.Stderr = io.Discard
	}
	r = &Task{
		args:    args,
		goarch:  goarch,
		goos:    goos,
		options: options,
	}
	return r
}

func (t *Task) Main() (err error) {
	return nil //TODO
}
