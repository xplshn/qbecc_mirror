// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler. (WIP)
//
// See the associated [command] for documentation on flags and arguments.
//
// [command]: https://pkg.go.dev/modernc.org/qbecc
package qbecc // import "modernc.org/qbecc/lib"

import (
	_ "embed"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"

	"modernc.org/cc/v4"
	"modernc.org/opt"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

const (
	ssaSection = ".qbecc_ssa"
)

var (
	gcc    string
	goos   = runtime.GOOS
	goarch = runtime.GOARCH

	qbeTargets = map[string]string{
		"darwin/amd64":  "amd64_apple",
		"darwin/arm64":  "arm64_apple",
		"freebsd/amd64": "amd64_sysv",
		"freebsd/arm64": "arm64",
		"linux/amd64":   "amd64_sysv",
		"linux/arm64":   "arm64",
		"linux/riscv64": "rv64",
	}

	//go:embed predefined.h
	predefined string
	//go:embed builtin.h
	builtin string
)

func init() {
	for _, s := range []string{"cc", "gcc", "clang"} {
		if s, err := exec.LookPath(s); err == nil {
			gcc = s
			break
		}
	}
}

const (
	_ = iota
	posBase
	posFull
)

// Options amend NewTask.
type Options struct {
	Stderr     io.Writer // Can be nil, defaults to os.Stderr
	Stdout     io.Writer // Can be nil, defaults to os.Stdout
	GOMAXPROCS int       // can be zero, defaults to runtime.GOMAXPROCS(0)
}

func (o *Options) setDefaults() (r *Options, err error) {
	if o == nil {
		o = &Options{}
	}
	if o.Stdout == nil {
		o.Stdout = os.Stdout
	}
	if o.Stderr == nil {
		o.Stderr = os.Stderr
	}
	if o.GOMAXPROCS == 0 {
		o.GOMAXPROCS = runtime.GOMAXPROCS(0)
	}
	return o, nil
}

const (
	fileZero = iota
	fileC
	fileH
	fileELF
	fileASM
	fileSSA
)

type file struct {
	inType  int    // file*
	in      []byte // nil: read from disk
	name    string
	out     any // string: disk file name
	outType int // file*
}

// Task represents a compilation job.
type Task struct {
	args       []string // from NewTask
	cfg        *cc.Config
	compiled   []*ctx
	errs       errList
	inputFiles []*file
	options    *Options // from NewTask
	parallel   *parallel

	optE      bool   // -E, stop after the preprocessing stage; do not run the compiler proper.
	optS      bool   // -S, stop after the stage of compilation proper; do not assemble.
	c         bool   // -c, compile or assemble the source files, but do not link.
	o         string // -o=<file>, Place the primary output in file <file>.
	abi0      bool   // --abi0, produce Go asm file.
	cc        string // --cc=<string>, C compiler to use for linking.
	goarch    string // --goarch=<string>, target GOARCH
	goos      string // --goos=<string>, target GOOS
	positions int    // --positions={base,full}, annotate SSA with source position info
	ssaHeader string // --ssa-header=<string>, injected into SSA
	target    string // --target=<string>, QBE target string, like amd64_sysv.
}

// NewTask returns a newly created Task. args[0] is the command name. For example
//
//	t := NewTask(nil, "linux", "amd64", "qbecc", "main.c")
//
// It's ok to pass nil 'opts'.
func NewTask(options *Options, args ...string) (r *Task, err error) {
	if options, err = options.setDefaults(); err != nil {
		return nil, err
	}

	return &Task{
		args:     args,
		cc:       gcc,
		goarch:   goarch,
		goos:     goos,
		options:  options,
		parallel: newParallel(options.GOMAXPROCS),
	}, nil
}

func (t *Task) err(n cc.Node, s string, args ...any) {
	t.errs.err(n, s, args...)
}

func (t *Task) Main() (err error) {
	set := opt.NewSet()
	set.Arg("-goarch", false, func(opt, arg string) error { t.goarch = arg; return nil })
	set.Arg("-goos", false, func(opt, arg string) error { t.goos = arg; return nil })
	set.Arg("o", false, func(opt, arg string) error { t.o = arg; return nil })
	set.Arg("-positions", false, func(opt, arg string) error {
		switch arg {
		case "base":
			t.positions = posBase
		case "full":
			t.positions = posFull
		}
		return nil
	})
	set.Arg("-ssa-header", false, func(opt, arg string) error { t.ssaHeader = arg; return nil })
	set.Arg("-target", false, func(opt, arg string) error { t.target = arg; return nil })
	set.Opt("-abi0", func(string) error { t.abi0 = true; return nil })
	set.Opt("-extended-errors", func(string) error { t.errs.extendedErrors = true; return nil })
	set.Opt("S", func(string) error { t.optS = true; return nil })
	set.Opt("c", func(string) error { t.c = true; return nil })
	if err := set.Parse(t.args[1:], func(arg string) error {
		if strings.HasPrefix(arg, "-") {
			return fmt.Errorf("unexpected/unsupported option: %s", arg)
		}

		switch filepath.Ext(arg) {
		case ".c":
			t.inputFiles = append(t.inputFiles, &file{name: arg, inType: fileC})
			return nil
		case "":
			fallthrough
		default:
			t.inputFiles = append(t.inputFiles, &file{name: arg, inType: fileELF})
			return nil
		}

		return fmt.Errorf("unexpected argument %s", arg)
	}); err != nil {
		switch err.(type) {
		default:
			return fmt.Errorf("parsing argument %v: %v", t.args[1:], err)
		}
	}

	if t.target == "" {
		if t.target = qbeTargets[fmt.Sprintf("%s/%s", t.goos, t.goarch)]; t.target == "" {
			return fmt.Errorf("unsupported target: %q (--goos=%s --goarch=%s)", t.target, t.goos, t.goarch)
		}
	}

	if t.o != "" && len(t.inputFiles) > 1 && (t.c || t.optS || t.optE) {
		return fmt.Errorf("cannot specify -o with -c, -S or -E and multiple input files")
	}

	if t.cfg, err = cc.NewConfig(t.goos, t.goarch); err != nil {
		return err
	}

	if !t.compile() {
		return t.errs.Err()
	}

	t.link()
	return t.errs.Err()
}
