// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Command qbecc is a [QBE] based C compiler. (WIP)
//
// Note: QBECC uses the host C compiler for finding system include files and
// for linking executables.
//
// # C targets (beta quality)
//
//	linux/amd64
//
// This target passes all tests.
//
// # C targets (alfa quality)
//
//	linux/arm64
//	linux/riscv64
//
// These targets passes some tests.
//
// # Go ABI0 targets (pre-alfa quality, undocumented)
//
//	linux/amd64
//
// This target passes some tests, but still needs some major changes.
//
// # Compiler flags: CC compatible
//
// These flags are recognized. Some are passed to the host C compiler for
// configuration. Some are used by QBECC, and many others are ignored. Passing
// a flag not listed in this documentation results in an error.
//
// # -D: Define macro
//
// -D foo is the same as
//
//	#define foo 1
//
// and -D foo=bar is the same as
//
//	# define foo bar
//
// # -E: Preprocess
//
// Stop after the preprocessing stage; do not run the compiler proper. 
//
// # -I <dir>: Include directory
//
// Add the directory dir to the list of directories to be searched for header files.
//
// # -MF <file>: preprocessor directive
//
// Like -M but do not mention header files that are found in system header
// directories, nor header files that are included, directly or indirectly,
// from such a header. Ignored.
//
// # -MMD: preprocessor directive
//
// Like -MD except mention only user header files, not system header files. Ignored.
//
// # -O <n>: Optimization
//
// Select optimization level.
//
// # -S: Keep assembler code
//
// Stop after the stage of compilation proper; do not assemble.
//
// # -U: Undefine macro
//
// Cancel any previous definition of name, either built in or provided with a -D option.
//
// # -W*: Configure warnings
//
// Enables extra warning flags. Ignored.
//
// # -ansi: Use ANSI C
//
// Select the ANSI C language standard.
//
// # -c: Do not link
//
// Compile or assemble the source files, but do not link. Ignored with --abi0.
//
// # -fno-asm: Disable asm keyword
//
// Do not recognize asm, inline or typeof as a keyword, so that code can use these words as identifiers. 
//
// # -f*: Other compiler flags
//
// All other -f* flags are ignored.
//
// # -g: Debugging info
//
// Produce debugging information. Ignored.
//
// # -idirafter <dir>: Include directory
//
// Add the directory dir at the end of the list of directories to be searched
// for header files during preprocessing.
//
// # -iquote <dir>: Include "foo.h" directory
//
// Add the directory dir to the list of directories to be searched for the
// #include "foo.h" directive.
//
// # -isystem <dir>: Include <foo.h> directory
//
// Add the directory dir to the list of directories to be searched for both
// #include "foo.h" and #include <bar.h> directives.
//
// # -l <foo>: Link with libfoo
//
// Search the library named library when linking.
//
// # -o <file>: Output file name
//
// Place the primary output in file <file>.
//
// # -rdynamic: linker flag
//
// Pass the flag -export-dynamic to the ELF linker, on targets that support it. Ignored.
//
// # -std=cxx: Select C standard
//
// Select the C standard to use, for example -std=c99.
//
// # Compiler flags: QBECC specific
//
// These flags are used only by QBECC.
//
// # --cc=<string>: Select host C compiler
//
// Name the C compiler to use for system headers discovery and linking.
//
// # --dump-ssa: Output SSA
//
// Output SSA to stderr.
//
// # --extended-errors: Turn on multi line errors
//
// Without this flag only the first line of errors are reported.
//
// # --goabi0: Target Go assembler
//
// Produce Go [ABI0] assembler code.
//
// # --goarch <string>: target GOARCH
//
// Select Go target architecture for cross compiling when/where supported.
//
// # --goos <string>: target GOOS
//
// Select Go target OS for cross compiling when/where supported.
//
// # --keep-ssa: Store the IR in output files
//
// Preserve the IR in the object/executable files so they can be later used
// with --goabi0.
//
// # --positions {base,full}: Line number info
//
// Annotate SSA with source positions.
//
// # --ssa-header <string>: Set SSA header
//
// The string is injected into the SSA verbatim.
//
// # --target <string>: QBE target
//
// The argument must be a valid QBE target for cross compiling when/where
// supported. For example
//
//	--target=amd64_sysv.
//
// # --unsigned-enums: GCC compatible enum signedness
//
// The signedndess of enum types is implementation defined. Some non-portable C
// code depends on GCC-specific enum signedness rules. This flag may help in
// compiling such code.
//
// # QBECCFLAGS
//
// This environment variable is used to pass a comma separated list of options
// or option=value. For example:
//
//	QBECCFLAGS=--keep-ssa qbecc main.c
//
// is the same as
//
//	qbecc main.c --keep-ssa
//
// [ABI0]: https://tip.golang.org/doc/asm
// [QBE]: https://c9x.me/compile/
// [TCC]: https://bellard.org/tcc/
package main // import "modernc.org/qbecc"

import (
	"fmt"
	"os"
	"strings"

	"modernc.org/qbecc/lib"
)

const (
	qbeccEnvVar = "QBECCFLAGS"
)

func main() {
	args := append([]string(nil), os.Args...)
	if s := os.Getenv(qbeccEnvVar); s != "" {
		args = append(args, strings.Split(s, ",")...)
	}
	t, err := qbecc.NewTask(&qbecc.Options{
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	}, args...)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	if err = t.Main(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
