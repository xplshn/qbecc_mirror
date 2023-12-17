// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc implements the qbecc command.
package qbecc // import "modernc.org/qbecc/lib"

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"modernc.org/cc/v4"
	"modernc.org/opt"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

// Options amend NewTask
//
// No options are currently defined.
type Options struct{}

// Task represents a compilation job.
type Task struct {
	D         []string // -D
	I         []string // -I
	O         string   // -O
	U         []string // -U
	args      []string
	cfg       *cc.Config
	defs      string // processed -D, -U
	errCnt    atomic.Int32
	errs      error
	errsMu    sync.Mutex
	goarch    string
	goos      string
	idirafter []string // -idirafter
	iquote    []string // -iquote
	isystem   []string // -isystem
	linkFiles []string // .c, .h, .o, .a
	o         string   // -o
	std       string   // -std
	stderr    io.Writer
	stdout    io.Writer

	ansi           bool // -ansi
	strictISOMode  bool // -ansi or stc=c90
	c              bool // -c
	extendedErrors bool // -fextended-errors
	nostdinc       bool // -nostdinc
}

// NewTask returns a newly created Task. args[0] is the command name.
//
// It's ok to pass nil 'opts'.
func NewTask(goos, goarch string, args []string, stdout, stderr io.Writer, opts *Options) (r *Task) {
	return &Task{
		args:   args,
		goarch: goarch,
		goos:   goos,
		stderr: stderr,
		stdout: stdout,
	}
}

func (t *Task) err(e error) {
	if e == nil {
		return
	}

	if t.errCnt.Add(1) <= 10 {
		t.errsMu.Lock()

		defer t.errsMu.Unlock()

		t.errs = errors.Join(t.errs, e)
	}
}

func (t *Task) errCount() int {
	return int(t.errCnt.Load())
}

func (t *Task) Main() (err error) {
	if dmesgs {
		dmesg("%v: ==== task.main enter %s CC=%q",
			origin(1), t.args, os.Getenv("CC"))
		defer func() {
			dmesg("%v: ==== exit: %v", origin(1), err)
		}()
	}

	var cfgArgs []string
	set := opt.NewSet()
	set.Arg("D", true, func(arg, val string) error { t.D = append(t.D, fmt.Sprintf("%s%s", arg, val)); return nil })
	set.Arg("I", true, func(arg, val string) error { t.I = append(t.I, val); return nil })
	set.Arg("O", true, func(arg, val string) error { t.O = fmt.Sprintf("%s%s", arg, val); return nil })
	set.Arg("U", true, func(arg, val string) error { t.U = append(t.U, fmt.Sprintf("%s%s", arg, val)); return nil })
	set.Arg("o", true, func(arg, val string) error { t.o = val; return nil })
	set.Arg("idirafter", true, func(arg, val string) error { t.idirafter = append(t.idirafter, val); return nil })
	set.Arg("iquote", true, func(arg, val string) error { t.iquote = append(t.iquote, val); return nil })
	set.Arg("isystem", true, func(arg, val string) error { t.isystem = append(t.isystem, val); return nil })
	set.Arg("std", true, func(arg, val string) error {
		t.std = fmt.Sprintf("%s=%s", arg, val)
		if val == "c90" {
			t.strictISOMode = true
		}
		return nil
	})
	set.Opt("ansi", func(arg string) error { t.ansi = true; t.strictISOMode = true; return nil })
	set.Opt("c", func(arg string) error { t.c = true; return nil })
	set.Opt("fextended-errors", func(arg string) error { t.extendedErrors = true; return nil })
	set.Opt("mlong-double-64", func(arg string) error { cfgArgs = append(cfgArgs, arg); return nil })
	set.Opt("nostdinc", func(arg string) error { t.nostdinc = true; cfgArgs = append(cfgArgs, arg); return nil })
	if err := set.Parse(t.args[1:], func(arg string) error {
		if strings.HasPrefix(arg, "-") {
			if dmesgs {
				dmesg("", errorf(false, "unexpected/unsupported option: %q", arg))
			}
			return errorf(false, "unexpected/unsupported option: %s", arg)
		}

		switch filepath.Ext(arg) {
		case ".a", ".c", ".h", ".o":
			t.linkFiles = append(t.linkFiles, arg)
			return nil
		}

		return errorf(false, "unexpected argument %s", arg)
	}); err != nil {
		return errorf(false, "parsing %v: %v", t.args[1:], err)
	}

	cfgArgs = append(cfgArgs, t.D...)
	cfgArgs = append(cfgArgs, t.U...)
	cfgArgs = append(cfgArgs,
		t.O,
		t.std,
	)

	ldflag := cc.LongDouble64Flag(t.goos, t.goarch)
	if ldflag != "" {
		cfgArgs = append(cfgArgs, ldflag)
	}

	if t.cfg, err = cc.NewConfig(t.goos, t.goarch, cfgArgs...); err != nil {
		return err
	}

	if ldflag == "" {
		if err = t.cfg.AdjustLongDouble(); err != nil {
			return err
		}
	}

	stdout, stderr, err := osexec(5*time.Second, t.cfg.CC, "-dumpmachine")
	if len(stderr) != 0 {
		err = errors.Join(err, fmt.Errorf("%s", stderr))
	}
	if err != nil {
		return errorf(t.extendedErrors, "%v", err)
	}

	out := strings.TrimSpace(string(stdout))
	a := strings.Split(out, "-")
	if len(a) < 2 {
		return errorf(t.extendedErrors, "cannot parse output of '%s -dumpmachine': %q", t.cfg.CC, out)
	}

	switch t.goarch {
	case "amd64":
		switch a[0] {
		case "x86_64":
			// ok
		default:
			return errorf(t.extendedErrors, "target architecture is %q but '%s -dumpmachine' reports %q (%q)", t.goarch, t.cfg.CC, a[0], out)
		}
	}
	switch t.goos {
	case "linux":
		switch a[1] {
		case "linux":
			// ok
		default:
			return errorf(t.extendedErrors, "target OS is %q but '%s -dumpmachine' reports %q (%q)", t.goos, t.cfg.CC, a[1], out)
		}
	}

	if t.nostdinc {
		t.cfg.HostIncludePaths = nil
		t.cfg.HostSysIncludePaths = nil
	}

	// --------------------------------------------------------------------
	// https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html
	//
	// Directories specified with -iquote apply only to the quote form of the
	// directive, #include "file". Directories specified with -I, -isystem, or
	// -idirafter apply to lookup for both the #include "file" and #include <file>
	// directives.
	//
	// You can specify any number or combination of these options on the command
	// line to search for header files in several directories. The lookup order is
	// as follows:

	t.cfg.IncludePaths = nil
	t.cfg.SysIncludePaths = nil

	// 1 For the quote form of the include directive, the directory of the current
	//   file is searched first.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, "")

	// 2 For the quote form of the include directive, the directories specified by
	//   -iquote options are searched in left-to-right order, as they appear on the
	//   command line.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.iquote...)

	// 3 Directories specified with -I options are scanned in left-to-right order.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.I...)
	t.cfg.SysIncludePaths = append(t.cfg.SysIncludePaths, t.I...)

	// 4 Directories specified with -isystem options are scanned in left-to-right
	//   order.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.isystem...)
	t.cfg.SysIncludePaths = append(t.cfg.SysIncludePaths, t.isystem...)

	// 5 Standard system directories are scanned.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.cfg.HostIncludePaths...)
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.cfg.HostSysIncludePaths...)
	t.cfg.SysIncludePaths = append(t.cfg.SysIncludePaths, t.cfg.HostIncludePaths...)
	t.cfg.SysIncludePaths = append(t.cfg.SysIncludePaths, t.cfg.HostSysIncludePaths...)

	// 6 Directories specified with -idirafter options are scanned in left-to-right
	//   order.
	t.cfg.IncludePaths = append(t.cfg.IncludePaths, t.idirafter...)
	t.cfg.SysIncludePaths = append(t.cfg.SysIncludePaths, t.idirafter...)
	// --------------------------------------------------------------------

	t.defs = t.buildDefs(t.D, t.U)

	for i, v := range t.linkFiles {
		switch e := filepath.Ext(v); e {
		case ".c":
			t.compile(v)
		default:
			panic(todo("", i, v, e))
		}
		if t.errCount() != 0 {
			break
		}
	}
	return t.errs
}

func (t *Task) buildDefs(D, U []string) string {
	var a []string
	for _, v := range D {
		v = v[len("-D"):]
		if i := strings.IndexByte(v, '='); i > 0 {
			a = append(a, fmt.Sprintf("#define %s %s", v[:i], v[i+1:]))
			continue
		}

		a = append(a, fmt.Sprintf("#define %s 1", v))
	}
	for _, v := range U {
		v = v[len("-U"):]
		a = append(a, fmt.Sprintf("#undef %s", v))
	}
	return strings.Join(a, "\n")
}

func (t *Task) compile(fn string) {
	ast, err := cc.Translate(t.cfg, t.sourcesFor(fn))
	if err != nil {
		t.err(err)
		return
	}

	_ = ast
	trc("%+v", t.cfg)
}

func (t *Task) sourcesFor(fn string) (r []cc.Source) {
	r = []cc.Source{
		{Name: "<predefined>", Value: t.cfg.Predefined},
		{Name: "<builtin>", Value: cc.Builtin},
	}
	if t.defs != "" {
		r = append(r, cc.Source{Name: "<command-line>", Value: t.defs})
	}
	return append(r, cc.Source{Name: fn})
}
