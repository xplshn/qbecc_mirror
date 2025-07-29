//go:build ignore
	.file	"atomic.c"
	.text
	.type	__atomic_loadUint16, @function
__atomic_loadUint16:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movzwl	(%rax), %edx
	movq	-16(%rbp), %rax
	movw	%dx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	__atomic_loadUint16, .-__atomic_loadUint16
	.type	__atomic_loadUint32, @function
__atomic_loadUint32:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	movl	%edx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	__atomic_loadUint32, .-__atomic_loadUint32
	.type	__atomic_loadUint64, @function
__atomic_loadUint64:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	__atomic_loadUint64, .-__atomic_loadUint64
	.type	__atomic_loadUint8, @function
__atomic_loadUint8:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	__atomic_loadUint8, .-__atomic_loadUint8
	.type	__atomic_storeUint16, @function
__atomic_storeUint16:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-16(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	xchgw	(%rax), %dx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	__atomic_storeUint16, .-__atomic_storeUint16
	.type	__atomic_storeUint32, @function
__atomic_storeUint32:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-16(%rbp), %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	xchgl	(%rax), %edx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	__atomic_storeUint32, .-__atomic_storeUint32
	.type	__atomic_storeUint64, @function
__atomic_storeUint64:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	xchgq	(%rax), %rdx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	__atomic_storeUint64, .-__atomic_storeUint64
	.type	__atomic_storeUint8, @function
__atomic_storeUint8:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-8(%rbp), %rax
	xchgb	(%rax), %dl
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	__atomic_storeUint8, .-__atomic_storeUint8
	.type	__atomic_fetch_addUint16, @function
__atomic_fetch_addUint16:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movw	%ax, -12(%rbp)
	movzwl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	lock xaddw	%dx, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	__atomic_fetch_addUint16, .-__atomic_fetch_addUint16
	.type	__atomic_fetch_addUint32, @function
__atomic_fetch_addUint32:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	lock xaddl	%edx, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	__atomic_fetch_addUint32, .-__atomic_fetch_addUint32
	.type	__atomic_fetch_addUint64, @function
__atomic_fetch_addUint64:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	lock xaddq	%rdx, (%rax)
	movq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	__atomic_fetch_addUint64, .-__atomic_fetch_addUint64
	.type	__atomic_fetch_addUint8, @function
__atomic_fetch_addUint8:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movb	%al, -12(%rbp)
	movzbl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	lock xaddb	%dl, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	__atomic_fetch_addUint8, .-__atomic_fetch_addUint8
	.type	__atomic_fetch_andUint16, @function
__atomic_fetch_andUint16:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movw	%ax, -12(%rbp)
	movzwl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzwl	(%rdx), %eax
.L18:
	movl	%eax, %edi
	movl	%eax, %ecx
	andl	%esi, %ecx
	lock cmpxchgw	%cx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L18
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	__atomic_fetch_andUint16, .-__atomic_fetch_andUint16
	.type	__atomic_fetch_andUint32, @function
__atomic_fetch_andUint32:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	-8(%rbp), %rdx
	movl	(%rdx), %eax
.L21:
	movl	%eax, %esi
	movl	%eax, %ecx
	andl	-12(%rbp), %ecx
	lock cmpxchgl	%ecx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L21
	movl	%esi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	__atomic_fetch_andUint32, .-__atomic_fetch_andUint32
	.type	__atomic_fetch_andUint64, @function
__atomic_fetch_andUint64:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rdx
	movq	(%rdx), %rax
.L24:
	movq	%rax, %rsi
	movq	%rax, %rcx
	andq	-16(%rbp), %rcx
	lock cmpxchgq	%rcx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L24
	movq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	__atomic_fetch_andUint64, .-__atomic_fetch_andUint64
	.type	__atomic_fetch_andUint8, @function
__atomic_fetch_andUint8:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movb	%al, -12(%rbp)
	movzbl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzbl	(%rdx), %eax
.L27:
	movl	%eax, %edi
	movl	%eax, %ecx
	andl	%esi, %ecx
	lock cmpxchgb	%cl, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L27
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	__atomic_fetch_andUint8, .-__atomic_fetch_andUint8
	.type	__atomic_fetch_orUint16, @function
__atomic_fetch_orUint16:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movw	%ax, -12(%rbp)
	movzwl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzwl	(%rdx), %eax
.L30:
	movl	%eax, %edi
	movl	%eax, %ecx
	orl	%esi, %ecx
	lock cmpxchgw	%cx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L30
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	__atomic_fetch_orUint16, .-__atomic_fetch_orUint16
	.type	__atomic_fetch_orUint32, @function
__atomic_fetch_orUint32:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	-8(%rbp), %rdx
	movl	(%rdx), %eax
.L33:
	movl	%eax, %esi
	movl	%eax, %ecx
	orl	-12(%rbp), %ecx
	lock cmpxchgl	%ecx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L33
	movl	%esi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	__atomic_fetch_orUint32, .-__atomic_fetch_orUint32
	.type	__atomic_fetch_orUint64, @function
__atomic_fetch_orUint64:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rdx
	movq	(%rdx), %rax
.L36:
	movq	%rax, %rsi
	movq	%rax, %rcx
	orq	-16(%rbp), %rcx
	lock cmpxchgq	%rcx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L36
	movq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	__atomic_fetch_orUint64, .-__atomic_fetch_orUint64
	.type	__atomic_fetch_orUint8, @function
__atomic_fetch_orUint8:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movb	%al, -12(%rbp)
	movzbl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzbl	(%rdx), %eax
.L39:
	movl	%eax, %edi
	movl	%eax, %ecx
	orl	%esi, %ecx
	lock cmpxchgb	%cl, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L39
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	__atomic_fetch_orUint8, .-__atomic_fetch_orUint8
	.type	__atomic_fetch_subUint16, @function
__atomic_fetch_subUint16:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movw	%ax, -12(%rbp)
	movzwl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	negl	%edx
	lock xaddw	%dx, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	__atomic_fetch_subUint16, .-__atomic_fetch_subUint16
	.type	__atomic_fetch_subUint32, @function
__atomic_fetch_subUint32:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	negl	%edx
	lock xaddl	%edx, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	__atomic_fetch_subUint32, .-__atomic_fetch_subUint32
	.type	__atomic_fetch_subUint64, @function
__atomic_fetch_subUint64:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	negq	%rdx
	lock xaddq	%rdx, (%rax)
	movq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	__atomic_fetch_subUint64, .-__atomic_fetch_subUint64
	.type	__atomic_fetch_subUint8, @function
__atomic_fetch_subUint8:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movb	%al, -12(%rbp)
	movzbl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	negl	%edx
	lock xaddb	%dl, (%rax)
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	__atomic_fetch_subUint8, .-__atomic_fetch_subUint8
	.type	__atomic_fetch_xorUint16, @function
__atomic_fetch_xorUint16:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movw	%ax, -12(%rbp)
	movzwl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzwl	(%rdx), %eax
.L50:
	movl	%eax, %edi
	movl	%eax, %ecx
	xorl	%esi, %ecx
	lock cmpxchgw	%cx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L50
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	__atomic_fetch_xorUint16, .-__atomic_fetch_xorUint16
	.type	__atomic_fetch_xorUint32, @function
__atomic_fetch_xorUint32:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	-8(%rbp), %rdx
	movl	(%rdx), %eax
.L53:
	movl	%eax, %esi
	movl	%eax, %ecx
	xorl	-12(%rbp), %ecx
	lock cmpxchgl	%ecx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L53
	movl	%esi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	__atomic_fetch_xorUint32, .-__atomic_fetch_xorUint32
	.type	__atomic_fetch_xorUint64, @function
__atomic_fetch_xorUint64:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rdx
	movq	(%rdx), %rax
.L56:
	movq	%rax, %rsi
	movq	%rax, %rcx
	xorq	-16(%rbp), %rcx
	lock cmpxchgq	%rcx, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L56
	movq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	__atomic_fetch_xorUint64, .-__atomic_fetch_xorUint64
	.type	__atomic_fetch_xorUint8, @function
__atomic_fetch_xorUint8:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movl	%edx, -16(%rbp)
	movb	%al, -12(%rbp)
	movzbl	-12(%rbp), %esi
	movq	-8(%rbp), %rdx
	movzbl	(%rdx), %eax
.L59:
	movl	%eax, %edi
	movl	%eax, %ecx
	xorl	%esi, %ecx
	lock cmpxchgb	%cl, (%rdx)
	sete	%cl
	testb	%cl, %cl
	je	.L59
	movl	%edi, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	__atomic_fetch_xorUint8, .-__atomic_fetch_xorUint8
	.type	__atomic_exchangeUint16, @function
__atomic_exchangeUint16:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -28(%rbp)
	movq	-16(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	xchgw	(%rax), %dx
	movq	-24(%rbp), %rax
	movw	%dx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	__atomic_exchangeUint16, .-__atomic_exchangeUint16
	.type	__atomic_exchangeUint32, @function
__atomic_exchangeUint32:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -28(%rbp)
	movq	-16(%rbp), %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	xchgl	(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	__atomic_exchangeUint32, .-__atomic_exchangeUint32
	.type	__atomic_exchangeUint64, @function
__atomic_exchangeUint64:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -28(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	xchgq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	__atomic_exchangeUint64, .-__atomic_exchangeUint64
	.type	__atomic_exchangeUint8, @function
__atomic_exchangeUint8:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -28(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-8(%rbp), %rax
	xchgb	(%rax), %dl
	movq	-24(%rbp), %rax
	movb	%dl, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	__atomic_exchangeUint8, .-__atomic_exchangeUint8
	.type	__atomic_compare_exchangeUint16, @function
__atomic_compare_exchangeUint16:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, %eax
	movl	%r8d, -32(%rbp)
	movl	%r9d, -36(%rbp)
	movb	%al, -28(%rbp)
	movq	-24(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %ecx
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movzwl	(%rax), %eax
	lock cmpxchgw	%cx, (%rdx)
	movl	%eax, %ecx
	sete	%al
	testb	%al, %al
	jne	.L67
	movq	-16(%rbp), %rdx
	movw	%cx, (%rdx)
.L67:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	__atomic_compare_exchangeUint16, .-__atomic_compare_exchangeUint16
	.type	__atomic_compare_exchangeUint32, @function
__atomic_compare_exchangeUint32:
.LFB33:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, %eax
	movl	%r8d, -32(%rbp)
	movl	%r9d, -36(%rbp)
	movb	%al, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %ecx
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	lock cmpxchgl	%ecx, (%rdx)
	movl	%eax, %ecx
	sete	%al
	testb	%al, %al
	jne	.L70
	movq	-16(%rbp), %rdx
	movl	%ecx, (%rdx)
.L70:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	__atomic_compare_exchangeUint32, .-__atomic_compare_exchangeUint32
	.type	__atomic_compare_exchangeUint64, @function
__atomic_compare_exchangeUint64:
.LFB34:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, %eax
	movl	%r8d, -32(%rbp)
	movl	%r9d, -36(%rbp)
	movb	%al, -28(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rcx
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	lock cmpxchgq	%rcx, (%rdx)
	movq	%rax, %rcx
	sete	%al
	testb	%al, %al
	jne	.L73
	movq	-16(%rbp), %rdx
	movq	%rcx, (%rdx)
.L73:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	__atomic_compare_exchangeUint64, .-__atomic_compare_exchangeUint64
	.type	__atomic_compare_exchangeUint8, @function
__atomic_compare_exchangeUint8:
.LFB35:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, %eax
	movl	%r8d, -32(%rbp)
	movl	%r9d, -36(%rbp)
	movb	%al, -28(%rbp)
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %ecx
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	lock cmpxchgb	%cl, (%rdx)
	movl	%eax, %ecx
	sete	%al
	testb	%al, %al
	jne	.L76
	movq	-16(%rbp), %rdx
	movb	%cl, (%rdx)
.L76:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	__atomic_compare_exchangeUint8, .-__atomic_compare_exchangeUint8
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
