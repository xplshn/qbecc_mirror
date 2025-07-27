// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Command qbecc is a [QBE] based C compiler. (WIP)
//
// Note: QBECC uses the host C compiler for finding system include files and
// for linking executables.
//
// # Targets the plain C compiler supports
//
//	linux/amd64
//	linux/arm64
//	linux/riscv64
//
// # Targets supported using --goabi0
//
//	linux/amd64
//
// # Status
//
// QBECC can now compile the first [TCC] test - and basically nothing else. But
// it's a working POC. Example session on linux/amd64.
//
//	jnml@e5-1650:~/tmp/qbecc$ ls -la
//	total 12
//	drwxr-xr-x  2 jnml jnml 4096 Jun 10 11:58 .
//	drwxr-xr-x 26 jnml jnml 4096 Jun  2 11:25 ..
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
//	jnml@e5-1650:~/tmp/qbecc$ ls -la
//	total 32
//	drwxr-xr-x  2 jnml jnml  4096 Jun 10 11:58 .
//	drwxr-xr-x 26 jnml jnml  4096 Jun  2 11:25 ..
//	-rw-r--r--  1 jnml jnml   231 May 22 13:05 00_assignment.c
//	-rwxr-xr-x  1 jnml jnml 16416 Jun 10 11:58 a.out
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
//	-rw-r--r-- 1 jnml jnml  231 May 22 13:05 00_assignment.c
//	-rw-r----- 1 jnml jnml 1900 Jun 10 12:00 00_assignment.s
//	jnml@e5-1650:~/tmp/qbecc$ cat 00_assignment.s
//	.section .qbecc_ssa, "", @progbits
//	.global .qbecc_ssa_start
//	.global .qbecc_ssa_end
//	.global .qbecc_ssa_size
//	
//	qbecc_ssa_start:
//		.byte 0x65, 0x78, 0x70, 0x6f, 0x72, 0x74, 0x20, 0x66, 0x75, 0x6e, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x20
//		.byte 0x77, 0x20, 0x24, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x20, 0x7b, 0x0a, 0x40, 0x73, 0x74, 0x61
//		.byte 0x90, 0xb8, 0xc0, 0x28, 0x24, 0x95, 0x87, 0xd1, 0x01, 0xee, 0x0c, 0x6d, 0xee, 0x0f, 0x24, 0x1c
//		.byte 0xb9, 0xf4, 0xeb, 0xdb, 0xbf, 0x83, 0x43, 0x2d, 0x4c, 0x6c, 0x2d, 0x8d, 0x94, 0xdc, 0x1c, 0xaa
//		.byte 0xba, 0x33, 0x14, 0x7c, 0x17, 0x3a, 0x39, 0xe1, 0x2c, 0x2e, 0x2e, 0x2e, 0x2c, 0xa1, 0x97, 0xe0
//		.byte 0xa7, 0x19, 0x2b, 0x11, 0x71, 0x8e, 0xde, 0xe1, 0xb1, 0xa6, 0xee, 0xf6, 0xff, 0x07, 0x0f, 0x17
//		.byte 0x1f, 0x27, 0x2f, 0x37, 0x3d, 0x0e, 0xce, 0xd2, 0xce, 0x72, 0x56, 0x32, 0xe3, 0x2e, 0x83, 0x1c
//		.byte 0x62, 0x56, 0x42, 0xe3, 0x3e, 0x13, 0x3e, 0x2e, 0x3e, 0x4e, 0x5c, 0xad, 0x8c, 0xbc, 0xbc, 0xee
//		.byte 0xce, 0xec, 0xef, 0x3f, 0x5e, 0xa7, 0x26, 0x58, 0x5a, 0x27, 0xd0, 0xa0, 0xa6, 0x46, 0x19, 0xe9
//		.byte 0x1c, 0x6c, 0x8a, 0x89, 0x92, 0x06, 0x22, 0x02, 0x2e, 0xc2, 0xe3, 0x72, 0xe3, 0xc1, 0x81, 0x81
//		.byte 0x11, 0x07, 0xa3, 0xd5, 0xeb, 0xc6, 0x73, 0xd6, 0xf5, 0xfb, 0x3d, 0xbc, 0x62, 0xc2, 0x0f, 0x5f
//		.byte 0xb3, 0xdb, 0xee, 0x20, 0x7d
//	qbecc_ssa_end:
//	
//	.set qbecc_ssa_size, qbecc_ssa_end - qbecc_ssa_start
//	
//	.text
//	.balign 16
//	.globl main
//	main:
//		endbr64
//		pushq %rbp
//		movq %rsp, %rbp
//		movl $42, %esi
//		leaq .ts.0(%rip), %rdi
//		movl $0, %eax
//		callq printf
//		movl $64, %esi
//		leaq .ts.0(%rip), %rdi
//		movl $0, %eax
//		callq printf
//		movl $34, %edx
//		movl $12, %esi
//		leaq .ts.1(%rip), %rdi
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
//	.ts.0:
//		.ascii "%d\n\x00"
//	/* end data */
//	
//	.data
//	.balign 8
//	.ts.1:
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
//	     Total      8  1044      142    155   1256
//	        Go      8  1044      142    155   12
//	jnml@e5-1650:~/src/modernc.org/qbecc/lib$
//
// # CC compatible supported flags
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
// # -std=cxx: Select C standard
//
// Select the C standard to use, for example -std=c99.
//
// # QBECC specific flags
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
// # --keep-ssa: Store the IR in output files
//
// Preserve the IR in the object/executable files so they can be later used
// with --goabi0.
//
// Select Go target OS for cross compiling when/where supported.
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
// [ABI0]: https://tip.golang.org/doc/asm
// [QBE]: https://c9x.me/compile/
// [TCC]: https://bellard.org/tcc/
package main // import "modernc.org/qbecc"

import (
	"fmt"
	"os"

	"modernc.org/qbecc/lib"
)

func main() {
	t, err := qbecc.NewTask(&qbecc.Options{
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	}, os.Args...)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	if err = t.Main(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
