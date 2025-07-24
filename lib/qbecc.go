// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler.
//
// [QBE]: https://c9x.me/compile/
package qbecc // import "modernc.org/qbecc/lib"

//TODO use blit for small copies only
//TODO proper inlining
//TODO zero small values without memset

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

type fileType int

const (
	fileInvalid fileType = iota

	fileC       // .c
	fileELF     // a.out, ...
	fileH       // .h
	fileHostAsm // .s for as(1)
	fileLib     // .o, .so
	fileQbeSSA  // .ssa
)

const (
	ssaSection = ".qbecc_ssa"
)

var (
	gcc    string
	goos   = runtime.GOOS
	goarch = runtime.GOARCH
	target = fmt.Sprintf("%s/%s", goos, goarch)

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

// Task represents a compilation job.
type Task struct {
	args          []string // from NewTask
	cfg           *cc.Config
	compilerFiles []*compilerFile
	errs          errList
	linkerObjects []*linkerObject
	options       *Options // from NewTask
	parallel      *parallel
	wordSize      int64  // 32b: 4, 64b: 8
	wordTag       string // 32b: "w", 64b: "l"

	ansi      bool   // -ansi
	c         bool   // -c, compile or assemble the source files, but do not link.
	cc        string // --cc=<string>, C compiler to use for linking.
	cfgArgs   []string
	dumpSSA   bool     // --dump-ssa
	fnoAsm    bool     // -fno-asm
	goabi0    bool     // --goabi0, produce Go asm file.
	goarch    string   // --goarch=<string>, target GOARCH
	goos      string   // --goos=<string>, target GOOS
	idirafter []string // -idirafter
	iquote    []string // -iquote, #include "foo.h" search path
	isystem   []string // -isystem, #include <foo.h> search path
	o         string   // -o=<file>, Place the primary output in file <file>.
	optD      []string // -D
	optE      bool     // -E, stop after the preprocessing stage; do not run the compiler proper.
	optI      []string // -I, include files search path
	optO      string   // -O
	optS      bool     // -S, stop after the stage of compilation proper; do not assemble.
	optU      []string // -U
	positions int      // --positions={base,full}, annotate SSA with source position info
	ssaHeader string   // --ssa-header=<string>, injected into SSA
	std       string   // -std
	target    string   // --target=<string>, QBE target string, like amd64_sysv.
}

// NewTask returns a newly created Task. args[0] is the command name. For example
//
//	t := NewTask(nil, "linux", "amd64", "qbecc", "main.c")
//
// It's ok to pass nil 'opts'.
//
// See the associated [command] for documentation on flags and arguments passed
// in 'args'.
//
// [command]: https://pkg.go.dev/modernc.org/qbecc
func NewTask(options *Options, args ...string) (r *Task, err error) {
	if options, err = options.setDefaults(); err != nil {
		return nil, err
	}

	return &Task{
		args:    args,
		cc:      gcc,
		goarch:  goarch,
		goos:    goos,
		options: options,
	}, nil
}

func (t *Task) err(n cc.Node, s string, args ...any) {
	t.errs.err(n, s, args...)
}

func (t *Task) Main() (err error) {
	hasLC := false // -lc
	set := opt.NewSet()
	set.Arg("D", true, func(arg, val string) error { t.optD = append(t.optD, fmt.Sprintf("%s%s", arg, val)); return nil })
	set.Arg("I", true, func(arg, val string) error { t.optI = append(t.optI, val); return nil })
	set.Arg("O", true, func(arg, val string) error { t.optO = fmt.Sprintf("%s%s", arg, val); return nil })
	set.Arg("U", true, func(arg, val string) error { t.optU = append(t.optU, fmt.Sprintf("%s%s", arg, val)); return nil })
	set.Arg("idirafter", true, func(arg, val string) error { t.idirafter = append(t.idirafter, val); return nil })
	set.Arg("iquote", true, func(arg, val string) error { t.iquote = append(t.iquote, val); return nil })
	set.Arg("isystem", true, func(arg, val string) error { t.isystem = append(t.isystem, val); return nil })
	set.Arg("l", true, func(opt, arg string) error {
		if arg == "c" {
			hasLC = true
		}
		t.compilerFiles = append(t.compilerFiles, &compilerFile{name: arg, inType: fileLib, outType: fileLib})
		return nil
	})
	set.Arg("o", false, func(opt, arg string) error { t.o = arg; return nil })
	set.Arg("std", true, func(arg, val string) error { t.std = fmt.Sprintf("%s=%s", arg, val); return nil })
	set.Arg("-goarch", false, func(opt, arg string) error { t.goarch = arg; return nil })
	set.Arg("-goos", false, func(opt, arg string) error { t.goos = arg; return nil })
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

	set.Opt("-dump-ssa", func(string) error { t.dumpSSA = true; return nil })
	set.Opt("-extended-errors", func(string) error { t.errs.extendedErrors = true; return nil })
	set.Opt("-goabi0", func(string) error { t.goabi0 = true; return nil })
	set.Opt("-panic", func(arg string) error { t.errs.panic = true; return nil })
	set.Opt("E", func(string) error { t.optE = true; return nil })
	set.Opt("S", func(string) error { t.optS = true; return nil })
	set.Opt("ansi", func(arg string) error { t.ansi = true; return nil })
	set.Opt("c", func(string) error { t.c = true; return nil })
	set.Opt("fno-asm", func(arg string) error { t.fnoAsm = true; return nil })

	// Ignored
	set.Arg("MF", false, func(arg, val string) error { return nil })
	set.Arg("W", true, func(arg, val string) error { return nil }) // all '-W' prefixed flags are ignored
	set.Opt("MMD", func(arg string) error { return nil })
	set.Opt("g", func(arg string) error { return nil })

	if err := set.Parse(t.args[1:], func(arg string) error {
		switch {
		case strings.HasPrefix(arg, "-f"):
			// all '-f' prefixed flags are ignored
			return nil
		case strings.HasPrefix(arg, "-"):
			return fmt.Errorf("unexpected/unsupported option: %s", arg)
		}

		switch filepath.Ext(arg) {
		case ".c":
			t.compilerFiles = append(t.compilerFiles, &compilerFile{name: arg, inType: fileC})
			return nil
		case "":
			fallthrough
		default:
			t.compilerFiles = append(t.compilerFiles, &compilerFile{name: arg, inType: fileELF})
			return nil
		}

		return fmt.Errorf("unexpected argument %s", arg)
	}); err != nil {
		switch err.(type) {
		default:
			return fmt.Errorf("parsing argument %v: %v", t.args[1:], err)
		}
	}

	switch t.goarch {
	case "386", "arm":
		t.wordSize = 4
		t.wordTag = "w"
	default:
		t.wordSize = 8
		t.wordTag = "l"
	}

	if t.target == "" {
		if t.target = qbeTargets[fmt.Sprintf("%s/%s", t.goos, t.goarch)]; t.target == "" {
			return fmt.Errorf("unsupported target: %q (--goos=%s --goarch=%s)", t.target, t.goos, t.goarch)
		}
	}

	if t.o != "" && len(t.compilerFiles) > 1 && (t.c || t.optS || t.optE) {
		return fmt.Errorf("cannot specify -o with -c, -S or -E and multiple input files")
	}

	if !hasLC {
		t.compilerFiles = append(t.compilerFiles, &compilerFile{name: "c", inType: fileLib, outType: fileLib})
	}
	t.optD = append(t.optD, "-D__QBECC__")
	t.cfgArgs = append(t.cfgArgs, t.optD...)
	t.cfgArgs = append(t.cfgArgs, t.optU...)
	t.cfgArgs = append(t.cfgArgs,
		t.optO,
		t.std,
	)
	ldflag := cc.LongDouble64Flag(t.goos, t.goarch)
	if ldflag != "" {
		t.cfgArgs = append(t.cfgArgs, ldflag)
	}
	if t.ansi {
		t.cfgArgs = append(t.cfgArgs, "-ansi")
	}
	if t.fnoAsm {
		t.cfgArgs = append(t.cfgArgs, "-fno-asm")
	}

	cfg, err := cc.NewConfig(t.goos, t.goarch, t.cfgArgs...)
	if err != nil {
		return err
	}

	// Do not do this
	// cfg.UnsignedEnums = true

	t.cfg = cfg
	if ldflag == "" {
		if err = cfg.AdjustLongDouble(); err != nil {
			return err
		}
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

	cfg.IncludePaths = nil
	cfg.SysIncludePaths = nil

	// 1 For the quote form of the include directive, the directory of the current
	//   file is searched first.
	cfg.IncludePaths = append(cfg.IncludePaths, "")

	// 2 For the quote form of the include directive, the directories specified by
	//   -iquote options are searched in left-to-right order, as they appear on the
	//   command line.
	cfg.IncludePaths = append(cfg.IncludePaths, t.iquote...)

	// 3 Directories specified with -I options are scanned in left-to-right order.
	cfg.IncludePaths = append(cfg.IncludePaths, t.optI...)
	cfg.SysIncludePaths = append(cfg.SysIncludePaths, t.optI...)

	// 4 Directories specified with -isystem options are scanned in left-to-right
	//   order.
	//
	// More info from https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html
	//
	// -isystem dir
	//
	// Search dir for header files, after all directories specified by -I but
	// before the standard system directories. Mark it as a system directory, so
	// that it gets the same special treatment as is applied to the standard system
	// directories. If dir begins with =, then the = will be replaced by the
	// sysroot prefix; see --sysroot and -isysroot.
	cfg.IncludePaths = append(cfg.IncludePaths, t.isystem...)
	// ... but before the standard directories.
	cfg.SysIncludePaths = append(append([]string(nil), t.isystem...), cfg.SysIncludePaths...)

	// 5 Standard system directories are scanned.
	cfg.IncludePaths = append(cfg.IncludePaths, cfg.HostIncludePaths...)
	cfg.IncludePaths = append(cfg.IncludePaths, cfg.HostSysIncludePaths...)
	cfg.SysIncludePaths = append(cfg.SysIncludePaths, cfg.HostIncludePaths...)
	cfg.SysIncludePaths = append(cfg.SysIncludePaths, cfg.HostSysIncludePaths...)

	// 6 Directories specified with -idirafter options are scanned in left-to-right
	//   order.
	cfg.IncludePaths = append(cfg.IncludePaths, t.idirafter...)
	cfg.SysIncludePaths = append(cfg.SysIncludePaths, t.idirafter...)
	// --------------------------------------------------------------------
	// trc("IncludePaths=%v", cfg.IncludePaths)
	// trc("SysIncludePaths=%v", cfg.SysIncludePaths)

	n := t.options.GOMAXPROCS
	if t.optE {
		n = 1
	}
	t.parallel = newParallel(n)
	if !t.compile() {
		return t.errs.Err()
	}

	t.link()
	return t.errs.Err()
}
