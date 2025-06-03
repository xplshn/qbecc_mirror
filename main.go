// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Command qbecc is a [QBE] based C compiler. (WIP)
//
// Note: QBECC uses the host C compiler for finding system include files and
// for linking executables.
//
// # Supported targets
//
//	linux/amd64
//	linux/arm64
//	linux/riscv64
//
// # Status
//
// QBECC can now compile the first [TCC] test - and basically nothing else. But
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
//	-rw-r--r-- 1 jnml jnml  231 May 22 13:05 00_assignment.c
//	-rw-r----- 1 jnml jnml 1234 May 22 17:40 00_assignment.s
//	jnml@e5-1650:~/tmp/qbecc$ cat 00_assignment.s
//	.section .qbecc_ssa, "", @progbits
//	.global .qbecc_ssa_start
//	.global .qbecc_ssa_end
//	.global .qbecc_ssa_size
//
//	qbecc_ssa_start:
//		.ascii "export function w $main() {\n"
//		.ascii "@start.0\n"
//		.ascii "\t%a.0 =w copy 0\n"
//		.ascii "\t%a.0 =w copy 42\n"
//		.ascii "\tcall $printf(l $.0,...,w %a.0,)\n"
//		.ascii "\t%b.1 =w copy 64\n"
//		.ascii "\tcall $printf(l $.0,...,w %b.1,)\n"
//		.ascii "\t%c.2 =w copy 12\n"
//		.ascii "\t%d.3 =w copy 34\n"
//		.ascii "\tcall $printf(l $.1,...,w %c.2,w %d.3,)\n"
//		.ascii "\tret 0\n"
//		.ascii "}\n"
//		.ascii "\n"
//		.ascii "data $.0 = { b \"%d\\n\\x00\" }\n"
//		.ascii "data $.1 = { b \"%d, %d\\n\\x00\" }\n"
//		.ascii "\n"
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
//	     Total      8  1029      257    174   1375
//	        Go      8  1029      257    174   1375
//	jnml@e5-1650:~/src/modernc.org/qbecc/lib$
//
// # Flags
//
//	-S, stop after the stage of compilation proper; do not assemble.
//	-c, compile or assemble the source files, but do not link.
//	-o=<file>, Place the primary output in file <file>.
//	--cc=<string>, C compiler to use for linking.
//	--goarch=<string>, target GOARCH
//	--goos=<string>, target GOOS
//	--positions={base,full}, annotate SSA with source position info
//	--ssa-header=<string>, injected into SSA
//	--target=<string>, QBE target string, like amd64_sysv.
//
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
