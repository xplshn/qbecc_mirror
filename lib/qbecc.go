// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package qbecc is a [QBE] based C compiler. (WIP)
//
// [QBE]: https://c9x.me/compile/
package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"io"
	"runtime"
	"strings"

	"modernc.org/cc/v4"
	"modernc.org/opt"
)

//  [0]: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

var (
	goos   = runtime.GOOS
	goarch = runtime.GOARCH
)

// Options amend NewTask.
//
// No options are currently defined.
type Options struct {
	Stderr io.Writer // Can be nil
	Stdout io.Writer // Can be nil
	GoArch string    // can be blank
	GoOs   string    // can be blank
}

func (o *Options) setDefaults() *Options {
	if o.Stdout == nil {
		o.Stdout = io.Discard
	}
	if o.Stderr == nil {
		o.Stderr = io.Discard
	}
	if o.GoOs == "" {
		o.GoOs = goos
	}
	if o.GoArch == "" {
		o.GoArch = goarch
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

func sourcesFor(cfg *cc.Config, fn string, t *Task) (r []cc.Source, err error) {
	r = []cc.Source{
		{Name: "<predefined>", Value: cfg.Predefined + `
//TODO(jnml) get rid of this in cc/v4
int __predefined_declarator;

#ifndef __extension__
#define __extension__
#endif

#ifdef __SIZE_TYPE__
typedef __SIZE_TYPE__ __predefined_size_t;
#endif

#ifdef __WCHAR_TYPE__
typedef __WCHAR_TYPE__ __predefined_wchar_t;
#endif

#ifdef __PTRDIFF_TYPE__
typedef __PTRDIFF_TYPE__ __predefined_ptrdiff_t;
#endif

#ifndef __FUNCTION__
#define __FUNCTION__ __func__
#endif

#ifndef __PRETTY_FUNCTION__
#define __PRETTY_FUNCTION__ __func__
#endif
`},
		{Name: "<builtin>", Value: `
// https://c9x.me/compile/doc/il-v1.2.html#Variadic
//
// However, it is possible to conservatively use the maximum size and alignment
// required by all the targets.
//
//	type :valist = align 8 { 24 }  # For amd64_sysv
//	type :valist = align 8 { 32 }  # For arm64
//	type :valist = align 8 { 8 }   # For rv64
#define __GNUC_VA_LIST

#if defined(__amd64__) || defined(__x86_64__) || defined(_M_X64)
typedef long long int __builtin_va_list[3];
#elif defined(__aarch64__) || defined(_M_ARM64) || defined(__ARM_ARCH_ISA_A64)
typedef long long int __builtin_va_list[4];
#elif (defined(__riscv) && __riscv_xlen == 64) || defined(__riscv64)
typedef long long int __builtin_va_list[1];
#endif

typedef __builtin_va_list __gnuc_va_list;

#ifndef __builtin_va_arg
#define __builtin_va_arg __builtin_va_arg
#define __builtin_va_arg(va, type) (*(type*)__builtin_va_arg(va))
#endif

#ifndef __builtin_types_compatible_p
#define __builtin_types_compatible_p(t1, t2) __builtin_types_compatible_p((t1){}, (t2){})
#endif

#ifndef __builtin_offsetof
#define __builtin_offsetof(type, member) ((__SIZE_TYPE__)&(((type*)0)->member))
#endif
`},
	}
	return append(r, cc.Source{Name: fn}), nil
}
