// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler. (WIP)
//
// [QBE]: https://c9x.me/compile/
package qbecc // import "modernc.org/qbecc/lib"

import (
	_ "embed"
	"fmt"
	"io"
	"os"
	"os/exec"
	"runtime"
	"strings"

	"modernc.org/opt"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

var (
	gcc    string
	goos   = runtime.GOOS
	goarch = runtime.GOARCH

	//go:embed predefined.h
	predefined string
	//go:embed builtin.h
	builtin string
)

func init() {
	for _, s := range []string{os.Getenv("CC"), "cc", "gcc", "clang"} {
		if s, err := exec.LookPath(s); err == nil {
			gcc = s
			break
		}
	}
}

// Options amend NewTask.
//
// No options are currently defined.
type Options struct {
	Stderr     io.Writer // Can be nil, defaults to os.Stderr
	Stdout     io.Writer // Can be nil, defaults to os.Stdout
	GoArch     string    // can be blank, defaults to runtime.GOARCH
	GoOs       string    // can be blank, defaults to runtime.GOOS
	GOMAXPROCS int       // can be zero, defaults to runtime.NumCPU
}

func (o *Options) setDefaults() *Options {
	if o.Stdout == nil {
		o.Stdout = os.Stdout
	}
	if o.Stderr == nil {
		o.Stderr = os.Stderr
	}
	if o.GoOs == "" {
		o.GoOs = runtime.GOOS
	}
	if o.GoArch == "" {
		o.GoArch = runtime.GOARCH
	}
	if o.GOMAXPROCS == 0 {
		o.GOMAXPROCS = runtime.NumCPU()
	}
	return o
}

// Task represents a compilation job.
type Task struct {
	args       []string // from NewTask
	inputFiles []string
	options    *Options // from NewTask
}

// NewTask returns a newly created Task. args[0] is the command name. For example
//
//	t := NewTask(nil, "linux", "amd64", "qbecc", "main.c")
//
// It's ok to pass nil 'opts'.
func NewTask(options *Options, args ...string) (r *Task) {
	if options == nil {
		options = &Options{}
	}
	r = &Task{
		args:    args,
		options: options.setDefaults(),
	}
	return r
}

func (t *Task) Main() (err error) {
	set := opt.NewSet()
	if err := set.Parse(t.args[1:], func(arg string) error {
		if strings.HasPrefix(arg, "-") {
			return fmt.Errorf("unexpected/unsupported option: %s", arg)
		}

		switch {
		case strings.HasSuffix(arg, ".c"):
			t.inputFiles = append(t.inputFiles, arg)
			return nil
		}

		return fmt.Errorf("unexpected argument %s", arg)
	}); err != nil {
		switch err.(type) {
		default:
			return fmt.Errorf("parsing argument %v: %v", t.args[1:], err)
		}
	}

	return nil
}
