// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler. (WIP)
//
// Note: QBECC uses the host C compiler for finding system include files and
// for linking executables.
//
// # Status
//
// QBECC can now compile the first [TCC] test - and almost nothing else. But
// it's a working POC. Example session on linux/amd64.
//
//	jnml@e5-1650:~/tmp/qbecc$ ls -la
//	total 12
//	drwxr-xr-x  2 jnml jnml 4096 May 22 15:44 .
//	drwxr-xr-x 25 jnml jnml 4096 May 22 10:29 ..
//	-rw-r--r--  1 jnml jnml  231 May 22 13:05 00_assignment.c
//	jnml@e5-1650:~/tmp/qbecc$ cat 00_assignment.c
//	#include <stdio.h>
//
//	int main()
//	{
//	   int a;
//	   a = 42;
//	   printf("%d\n", a);
//
//	   int b = 64;
//	   printf("%d\n", b);
//
//	   int c = 12, d = 34;
//	   printf("%d, %d\n", c, d);
//
//	   return 0;
//	}
//
//	// vim: set expandtab ts=4 sw=3 sts=3 tw=80 :
//	jnml@e5-1650:~/tmp/qbecc$ qbecc 00_assignment.c
//	jnml@e5-1650:~/tmp/qbecc$ ll
//	total 20
//	-rw-r--r-- 1 jnml jnml   231 May 22 13:05 00_assignment.c
//	-rwxr-xr-x 1 jnml jnml 16024 May 22 15:44 a.out*
//	jnml@e5-1650:~/tmp/qbecc$ ./a.out
//	42
//	64
//	12, 34
//	jnml@e5-1650:~/tmp/qbecc$
//
// Producing the assembler file:
//
//	jnml@e5-1650:~/tmp/qbecc$ ls -l
//	total 4
//	-rw-r--r-- 1 jnml jnml 231 May 22 13:05 00_assignment.c
//	jnml@e5-1650:~/tmp/qbecc$ qbecc -S 00_assignment.c
//	jnml@e5-1650:~/tmp/qbecc$ ls -l
//	total 8
//	-rw-r--r-- 1 jnml jnml 231 May 22 13:05 00_assignment.c
//	-rw-r----- 1 jnml jnml 532 May 22 15:50 00_assignment.s
//	jnml@e5-1650:~/tmp/qbecc$ cat 00_assignment.s
//	.text
//	.balign 16
//	.globl main
//	main:
//		endbr64
//		pushq %rbp
//		movq %rsp, %rbp
//		movl $42, %esi
//		leaq .0(%rip), %rdi
//		movl $0, %eax
//		callq printf
//		movl $64, %esi
//		leaq .0(%rip), %rdi
//		movl $0, %eax
//		callq printf
//		movl $34, %edx
//		movl $12, %esi
//		leaq .1(%rip), %rdi
//		movl $0, %eax
//		callq printf
//		movl $0, %eax
//		leave
//		ret
//	.type main, @function
//	.size main, .-main
//	/* end function main */
//
//	.data
//	.balign 8
//	.0:
//		.ascii "%d\n\x00"
//	/* end data */
//
//	.data
//	.balign 8
//	.1:
//		.ascii "%d, %d\n\x00"
//	/* end data */
//
//	.section .note.GNU-stack,"",@progbits
//	jnml@e5-1650:~/tmp/qbecc$
//
// QBECC is not much code yet:
//
//	jnml@e5-1650:~/src/modernc.org/qbecc/lib$ sloc $(ls *.go | grep -v *_test.go)
//	  Language  Files  Code  Comment  Blank  Total
//	     Total      8  1019      230    169   1333
//	        Go      8  1019      230    169   1333
//	jnml@e5-1650:~/src/modernc.org/qbecc/lib$
//
// [QBE]: https://c9x.me/compile/
// [TCC]: https://bellard.org/tcc/
package qbecc // import "modernc.org/qbecc/lib"

import (
	_ "embed"
	"fmt"
	"io"
	"os"
	"os/exec"
	"runtime"
	"strings"

	"modernc.org/cc/v4"
	"modernc.org/opt"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

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

// Task represents a compilation job.
type Task struct {
	args       []string // from NewTask
	cfg        *cc.Config
	compiled   []*ctx
	errs       errList
	inputFiles []string
	options    *Options // from NewTask
	parallel   *parallel

	E         bool   // -E, stop after the preprocessing stage; do not run the compiler proper.
	S         bool   // -S, stop after the stage of compilation proper; do not assemble.
	c         bool   // -c, compile or assemble the source files, but do not link.
	o         string // -o=<file>, Place the primary output in file <file>.
	cc        string // --cc=<string>, C compiler to use for linking.
	goarch    string // --goarch=<string>, target GOARCH
	goos      string // --goos=<string>, target GOOS
	positions int    // --positions={base,full}, annotate SSA with source position info
	ssaHeader string // --ssa-header=<string>, injected into SSA
	target    string // --target=<qbe target string>, QBE target string, like amd64_sysv, ...
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
	set.Opt("-extended-errors", func(string) error { t.errs.extendedErrors = true; return nil })
	set.Opt("S", func(string) error { t.S = true; return nil })
	set.Opt("c", func(string) error { t.c = true; return nil })
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

	if t.target == "" {
		if t.target = qbeTargets[fmt.Sprintf("%s/%s", t.goos, t.goarch)]; t.target == "" {
			return fmt.Errorf("unsupported target: %q (--goos=%s --goarch=%s)", t.target, t.goos, t.goarch)
		}
	}

	if t.o != "" && len(t.inputFiles) > 1 && (t.c || t.S || t.E) {
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
