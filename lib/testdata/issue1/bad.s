.text
.balign 16
"platform_main_begin":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldp	x29, x30, [sp], 16
	ret
.type "platform_main_begin", @function
.size "platform_main_begin", .-"platform_main_begin"

.text
.balign 16
"platform_main_end":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w1, w0
	adrp	x0, ".ts.5"
	add	x0, x0, #:lo12:".ts.5"
	bl	"printf"
	ldp	x29, x30, [sp], 16
	ret
.type "platform_main_end", @function
.size "platform_main_end", .-"platform_main_end"

.text
.balign 16
"safe_unary_minus_func_int8_t_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w0, w0
	neg	w0, w0
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_int8_t_s", @function
.size "safe_unary_minus_func_int8_t_s", .-"safe_unary_minus_func_int8_t_s"

.text
.balign 16
"safe_add_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w0, w0
	sxtb	w1, w1
	add	w0, w0, w1
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_int8_t_s_s", @function
.size "safe_add_func_int8_t_s_s", .-"safe_add_func_int8_t_s_s"

.text
.balign 16
"safe_sub_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w0, w0
	sxtb	w1, w1
	sub	w0, w0, w1
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_int8_t_s_s", @function
.size "safe_sub_func_int8_t_s_s", .-"safe_sub_func_int8_t_s_s"

.text
.balign 16
"safe_mul_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w0, w0
	sxtb	w1, w1
	mul	w0, w0, w1
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_int8_t_s_s", @function
.size "safe_mul_func_int8_t_s_s", .-"safe_mul_func_int8_t_s_s"

.text
.balign 16
"safe_mod_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w1, w1
	cmp	w1, #0
	cset	w3, eq
	sxtb	w2, w0
	cmp	w3, #0
	bne	.L15
	cmn	w2, #128
	cset	w3, eq
	cmp	w3, #0
	beq	.L15
	cmn	w1, #1
	cset	w3, eq
.L15:
	cmp	w3, #0
	bne	.L18
	mov	w0, w2
	sdiv	w17, w0, w1
	msub	w0, w17, w1, w0
	sxtb	w0, w0
.L18:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_int8_t_s_s", @function
.size "safe_mod_func_int8_t_s_s", .-"safe_mod_func_int8_t_s_s"

.text
.balign 16
"safe_div_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w1, w1
	cmp	w1, #0
	cset	w3, eq
	sxtb	w2, w0
	cmp	w3, #0
	bne	.L22
	cmn	w2, #128
	cset	w3, eq
	cmp	w3, #0
	beq	.L22
	cmn	w1, #1
	cset	w3, eq
.L22:
	cmp	w3, #0
	bne	.L25
	mov	w0, w2
	sdiv	w0, w0, w1
	sxtb	w0, w0
.L25:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_int8_t_s_s", @function
.size "safe_div_func_int8_t_s_s", .-"safe_div_func_int8_t_s_s"

.text
.balign 16
"safe_lshift_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w2, w0
	sxtb	w0, w0
	cmp	w0, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L28
	cmp	w1, #0
	cset	w3, lt
.L28:
	cmp	w3, #0
	bne	.L30
	cmp	w1, #32
	cset	w3, ge
.L30:
	cmp	w3, #0
	bne	.L32
	mov	w3, #127
	asr	w3, w3, w1
	cmp	w0, w3
	cset	w3, gt
.L32:
	cmp	w3, #0
	bne	.L34
	lsl	w0, w0, w1
	sxtb	w0, w0
	b	.L35
.L34:
	mov	w0, w2
.L35:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int8_t_s_s", @function
.size "safe_lshift_func_int8_t_s_s", .-"safe_lshift_func_int8_t_s_s"

.text
.balign 16
"safe_lshift_func_int8_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w2, w0
	sxtb	w0, w0
	cmp	w0, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L38
	cmp	w1, #32
	cset	w3, cs
.L38:
	cmp	w3, #0
	bne	.L40
	mov	w3, #127
	asr	w3, w3, w1
	cmp	w0, w3
	cset	w3, gt
.L40:
	cmp	w3, #0
	bne	.L42
	lsl	w0, w0, w1
	sxtb	w0, w0
	b	.L43
.L42:
	mov	w0, w2
.L43:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int8_t_s_u", @function
.size "safe_lshift_func_int8_t_s_u", .-"safe_lshift_func_int8_t_s_u"

.text
.balign 16
"safe_rshift_func_int8_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w2, w0
	cmp	w2, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L46
	cmp	w1, #0
	cset	w3, lt
.L46:
	cmp	w3, #0
	bne	.L48
	cmp	w1, #32
	cset	w3, ge
.L48:
	cmp	w3, #0
	bne	.L51
	mov	w0, w2
	asr	w0, w0, w1
	sxtb	w0, w0
.L51:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int8_t_s_s", @function
.size "safe_rshift_func_int8_t_s_s", .-"safe_rshift_func_int8_t_s_s"

.text
.balign 16
"safe_rshift_func_int8_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxtb	w2, w0
	cmp	w2, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L54
	cmp	w1, #32
	cset	w3, cs
.L54:
	cmp	w3, #0
	bne	.L57
	mov	w0, w2
	asr	w0, w0, w1
	sxtb	w0, w0
.L57:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int8_t_s_u", @function
.size "safe_rshift_func_int8_t_s_u", .-"safe_rshift_func_int8_t_s_u"

.text
.balign 16
"safe_unary_minus_func_int16_t_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w0, w0
	neg	w0, w0
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_int16_t_s", @function
.size "safe_unary_minus_func_int16_t_s", .-"safe_unary_minus_func_int16_t_s"

.text
.balign 16
"safe_add_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w0, w0
	sxth	w1, w1
	add	w0, w0, w1
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_int16_t_s_s", @function
.size "safe_add_func_int16_t_s_s", .-"safe_add_func_int16_t_s_s"

.text
.balign 16
"safe_sub_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w0, w0
	sxth	w1, w1
	sub	w0, w0, w1
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_int16_t_s_s", @function
.size "safe_sub_func_int16_t_s_s", .-"safe_sub_func_int16_t_s_s"

.text
.balign 16
"safe_mul_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w0, w0
	sxth	w1, w1
	mul	w0, w0, w1
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_int16_t_s_s", @function
.size "safe_mul_func_int16_t_s_s", .-"safe_mul_func_int16_t_s_s"

.text
.balign 16
"safe_mod_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w1, w1
	cmp	w1, #0
	cset	w3, eq
	sxth	w2, w0
	cmp	w3, #0
	bne	.L69
	cmn	w2, #8, lsl #12
	cset	w3, eq
	cmp	w3, #0
	beq	.L69
	cmn	w1, #1
	cset	w3, eq
.L69:
	cmp	w3, #0
	bne	.L72
	mov	w0, w2
	sdiv	w17, w0, w1
	msub	w0, w17, w1, w0
	sxth	w0, w0
.L72:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_int16_t_s_s", @function
.size "safe_mod_func_int16_t_s_s", .-"safe_mod_func_int16_t_s_s"

.text
.balign 16
"safe_div_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w1, w1
	cmp	w1, #0
	cset	w3, eq
	sxth	w2, w0
	cmp	w3, #0
	bne	.L76
	cmn	w2, #8, lsl #12
	cset	w3, eq
	cmp	w3, #0
	beq	.L76
	cmn	w1, #1
	cset	w3, eq
.L76:
	cmp	w3, #0
	bne	.L79
	mov	w0, w2
	sdiv	w0, w0, w1
	sxth	w0, w0
.L79:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_int16_t_s_s", @function
.size "safe_div_func_int16_t_s_s", .-"safe_div_func_int16_t_s_s"

.text
.balign 16
"safe_lshift_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w2, w0
	sxth	w0, w0
	cmp	w0, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L82
	cmp	w1, #0
	cset	w3, lt
.L82:
	cmp	w3, #0
	bne	.L84
	cmp	w1, #32
	cset	w3, ge
.L84:
	cmp	w3, #0
	bne	.L86
	mov	w3, #32767
	asr	w3, w3, w1
	cmp	w0, w3
	cset	w3, gt
.L86:
	cmp	w3, #0
	bne	.L88
	lsl	w0, w0, w1
	sxth	w0, w0
	b	.L89
.L88:
	mov	w0, w2
.L89:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int16_t_s_s", @function
.size "safe_lshift_func_int16_t_s_s", .-"safe_lshift_func_int16_t_s_s"

.text
.balign 16
"safe_lshift_func_int16_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w2, w0
	sxth	w0, w0
	cmp	w0, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L92
	cmp	w1, #32
	cset	w3, cs
.L92:
	cmp	w3, #0
	bne	.L94
	mov	w3, #32767
	asr	w3, w3, w1
	cmp	w0, w3
	cset	w3, gt
.L94:
	cmp	w3, #0
	bne	.L96
	lsl	w0, w0, w1
	sxth	w0, w0
	b	.L97
.L96:
	mov	w0, w2
.L97:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int16_t_s_u", @function
.size "safe_lshift_func_int16_t_s_u", .-"safe_lshift_func_int16_t_s_u"

.text
.balign 16
"safe_rshift_func_int16_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w2, w0
	cmp	w2, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L100
	cmp	w1, #0
	cset	w3, lt
.L100:
	cmp	w3, #0
	bne	.L102
	cmp	w1, #32
	cset	w3, ge
.L102:
	cmp	w3, #0
	bne	.L105
	mov	w0, w2
	asr	w0, w0, w1
	sxth	w0, w0
.L105:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int16_t_s_s", @function
.size "safe_rshift_func_int16_t_s_s", .-"safe_rshift_func_int16_t_s_s"

.text
.balign 16
"safe_rshift_func_int16_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sxth	w2, w0
	cmp	w2, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L108
	cmp	w1, #32
	cset	w3, cs
.L108:
	cmp	w3, #0
	bne	.L111
	mov	w0, w2
	asr	w0, w0, w1
	sxth	w0, w0
.L111:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int16_t_s_u", @function
.size "safe_rshift_func_int16_t_s_u", .-"safe_rshift_func_int16_t_s_u"

.text
.balign 16
"safe_unary_minus_func_int32_t_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w1, #-2147483648
	cmp	w0, w1
	beq	.L114
	neg	w0, w0
.L114:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_int32_t_s", @function
.size "safe_unary_minus_func_int32_t_s", .-"safe_unary_minus_func_int32_t_s"

.text
.balign 16
"safe_add_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, gt
	cmp	w2, #0
	beq	.L117
	cmp	w1, #0
	cset	w2, gt
.L117:
	cmp	w2, #0
	beq	.L119
	mov	w2, #2147483647
	sub	w2, w2, w1
	cmp	w0, w2
	cset	w2, gt
.L119:
	cmp	w2, #0
	bne	.L124
	cmp	w0, #0
	cset	w2, lt
	cmp	w2, #0
	beq	.L122
	cmp	w1, #0
	cset	w2, lt
.L122:
	cmp	w2, #0
	beq	.L124
	mov	w2, #-2147483648
	sub	w2, w2, w1
	cmp	w0, w2
	cset	w2, lt
.L124:
	cmp	w2, #0
	bne	.L126
	add	w0, w0, w1
.L126:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_int32_t_s_s", @function
.size "safe_add_func_int32_t_s_s", .-"safe_add_func_int32_t_s_s"

.text
.balign 16
"safe_sub_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	eor	w2, w0, w1
	mov	w3, #-2147483648
	and	w3, w2, w3
	eor	w3, w0, w3
	sub	w3, w3, w1
	eor	w3, w1, w3
	and	w2, w2, w3
	cmp	w2, #0
	blt	.L129
	sub	w0, w0, w1
.L129:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_int32_t_s_s", @function
.size "safe_sub_func_int32_t_s_s", .-"safe_sub_func_int32_t_s_s"

.text
.balign 16
"safe_mul_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, gt
	cmp	w1, #0
	mov	w3, w2
	cset	w2, gt
	cmp	w3, #0
	bne	.L132
	mov	w4, w3
	b	.L133
.L132:
	mov	w4, w2
.L133:
	cmp	w4, #0
	bne	.L135
	mov	w17, w2
	mov	w2, w4
	mov	w4, w17
	b	.L136
.L135:
	mov	w4, #2147483647
	sdiv	w4, w4, w1
	cmp	w0, w4
	mov	w4, w2
	cset	w2, gt
.L136:
	cmp	w1, #0
	mov	w5, w2
	cset	w2, le
	cmp	w5, #0
	bne	.L142
	cmp	w0, #0
	ble	.L139
	mov	w3, w2
.L139:
	cmp	w3, #0
	beq	.L141
	mov	w3, #-2147483648
	sdiv	w3, w3, w0
	cmp	w1, w3
	cset	w3, lt
.L141:
	mov	w5, w3
.L142:
	cmp	w0, #0
	cset	w3, le
	cmp	w5, #0
	bne	.L147
	cmp	w0, #0
	ble	.L145
	mov	w4, w3
.L145:
	cmp	w4, #0
	beq	.L148
	mov	w4, #-2147483648
	sdiv	w4, w4, w1
	cmp	w0, w4
	cset	w4, lt
	b	.L148
.L147:
	mov	w4, w5
.L148:
	cmp	w4, #0
	bne	.L155
	cmp	w0, #0
	ble	.L151
	mov	w2, w3
.L151:
	cmp	w2, #0
	beq	.L153
	cmp	w0, #0
	cset	w2, ne
.L153:
	cmp	w2, #0
	beq	.L156
	mov	w2, #2147483647
	sdiv	w2, w2, w0
	cmp	w1, w2
	cset	w2, lt
	b	.L156
.L155:
	mov	w2, w4
.L156:
	cmp	w2, #0
	bne	.L158
	mul	w0, w0, w1
.L158:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_int32_t_s_s", @function
.size "safe_mul_func_int32_t_s_s", .-"safe_mul_func_int32_t_s_s"

.text
.balign 16
"safe_mod_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, eq
	cmp	w2, #0
	bne	.L162
	mov	w2, #-2147483648
	cmp	w0, w2
	cset	w2, eq
	cmp	w2, #0
	beq	.L162
	cmn	w1, #1
	cset	w2, eq
.L162:
	cmp	w2, #0
	bne	.L164
	sdiv	w17, w0, w1
	msub	w0, w17, w1, w0
.L164:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_int32_t_s_s", @function
.size "safe_mod_func_int32_t_s_s", .-"safe_mod_func_int32_t_s_s"

.text
.balign 16
"safe_div_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, eq
	cmp	w2, #0
	bne	.L168
	mov	w2, #-2147483648
	cmp	w0, w2
	cset	w2, eq
	cmp	w2, #0
	beq	.L168
	cmn	w1, #1
	cset	w2, eq
.L168:
	cmp	w2, #0
	bne	.L170
	sdiv	w0, w0, w1
.L170:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_int32_t_s_s", @function
.size "safe_div_func_int32_t_s_s", .-"safe_div_func_int32_t_s_s"

.text
.balign 16
"safe_lshift_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L173
	cmp	w1, #0
	cset	w2, lt
.L173:
	cmp	w2, #0
	bne	.L175
	cmp	w1, #32
	cset	w2, ge
.L175:
	cmp	w2, #0
	bne	.L177
	mov	w2, #2147483647
	asr	w2, w2, w1
	cmp	w0, w2
	cset	w2, gt
.L177:
	cmp	w2, #0
	bne	.L179
	lsl	w0, w0, w1
.L179:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int32_t_s_s", @function
.size "safe_lshift_func_int32_t_s_s", .-"safe_lshift_func_int32_t_s_s"

.text
.balign 16
"safe_lshift_func_int32_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L182
	cmp	w1, #32
	cset	w2, cs
.L182:
	cmp	w2, #0
	bne	.L184
	mov	w2, #2147483647
	asr	w2, w2, w1
	cmp	w0, w2
	cset	w2, gt
.L184:
	cmp	w2, #0
	bne	.L186
	lsl	w0, w0, w1
.L186:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int32_t_s_u", @function
.size "safe_lshift_func_int32_t_s_u", .-"safe_lshift_func_int32_t_s_u"

.text
.balign 16
"safe_rshift_func_int32_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L189
	cmp	w1, #0
	cset	w2, lt
.L189:
	cmp	w2, #0
	bne	.L191
	cmp	w1, #32
	cset	w2, ge
.L191:
	cmp	w2, #0
	bne	.L193
	asr	w0, w0, w1
.L193:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int32_t_s_s", @function
.size "safe_rshift_func_int32_t_s_s", .-"safe_rshift_func_int32_t_s_s"

.text
.balign 16
"safe_rshift_func_int32_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L196
	cmp	w1, #32
	cset	w2, cs
.L196:
	cmp	w2, #0
	bne	.L198
	asr	w0, w0, w1
.L198:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int32_t_s_u", @function
.size "safe_rshift_func_int32_t_s_u", .-"safe_rshift_func_int32_t_s_u"

.text
.balign 16
"safe_unary_minus_func_int64_t_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	x1, #-9223372036854775808
	cmp	x0, x1
	beq	.L201
	neg	x0, x0
.L201:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_int64_t_s", @function
.size "safe_unary_minus_func_int64_t_s", .-"safe_unary_minus_func_int64_t_s"

.text
.balign 16
"safe_add_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, gt
	cmp	w2, #0
	beq	.L204
	cmp	x1, #0
	cset	w2, gt
.L204:
	cmp	w2, #0
	beq	.L206
	mov	x2, #9223372036854775807
	sub	x2, x2, x1
	cmp	x0, x2
	cset	w2, gt
.L206:
	cmp	w2, #0
	bne	.L211
	cmp	x0, #0
	cset	w2, lt
	cmp	w2, #0
	beq	.L209
	cmp	x1, #0
	cset	w2, lt
.L209:
	cmp	w2, #0
	beq	.L211
	mov	x2, #-9223372036854775808
	sub	x2, x2, x1
	cmp	x0, x2
	cset	w2, lt
.L211:
	cmp	w2, #0
	bne	.L213
	add	x0, x0, x1
.L213:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_int64_t_s_s", @function
.size "safe_add_func_int64_t_s_s", .-"safe_add_func_int64_t_s_s"

.text
.balign 16
"safe_sub_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	eor	x2, x0, x1
	mov	x3, #-9223372036854775808
	and	x3, x2, x3
	eor	x3, x0, x3
	sub	x3, x3, x1
	eor	x3, x1, x3
	and	x2, x2, x3
	cmp	x2, #0
	blt	.L216
	sub	x0, x0, x1
.L216:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_int64_t_s_s", @function
.size "safe_sub_func_int64_t_s_s", .-"safe_sub_func_int64_t_s_s"

.text
.balign 16
"safe_mul_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, gt
	cmp	x1, #0
	mov	w3, w2
	cset	w2, gt
	cmp	w3, #0
	bne	.L219
	mov	w4, w3
	b	.L220
.L219:
	mov	w4, w2
.L220:
	cmp	w4, #0
	bne	.L222
	mov	w17, w2
	mov	w2, w4
	mov	w4, w17
	b	.L223
.L222:
	mov	x4, #9223372036854775807
	sdiv	x4, x4, x1
	cmp	x0, x4
	mov	w4, w2
	cset	w2, gt
.L223:
	cmp	x1, #0
	mov	w5, w2
	cset	w2, le
	cmp	w5, #0
	bne	.L229
	cmp	x0, #0
	ble	.L226
	mov	w3, w2
.L226:
	cmp	w3, #0
	beq	.L228
	mov	x3, #-9223372036854775808
	sdiv	x3, x3, x0
	cmp	x1, x3
	cset	w3, lt
.L228:
	mov	w5, w3
.L229:
	cmp	x0, #0
	cset	w3, le
	cmp	w5, #0
	bne	.L234
	cmp	x0, #0
	ble	.L232
	mov	w4, w3
.L232:
	cmp	w4, #0
	beq	.L235
	mov	x4, #-9223372036854775808
	sdiv	x4, x4, x1
	cmp	x0, x4
	cset	w4, lt
	b	.L235
.L234:
	mov	w4, w5
.L235:
	cmp	w4, #0
	bne	.L242
	cmp	x0, #0
	ble	.L238
	mov	w2, w3
.L238:
	cmp	w2, #0
	beq	.L240
	cmp	x0, #0
	cset	w2, ne
.L240:
	cmp	w2, #0
	beq	.L243
	mov	x2, #9223372036854775807
	sdiv	x2, x2, x0
	cmp	x1, x2
	cset	w2, lt
	b	.L243
.L242:
	mov	w2, w4
.L243:
	cmp	w2, #0
	bne	.L245
	mul	x0, x0, x1
.L245:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_int64_t_s_s", @function
.size "safe_mul_func_int64_t_s_s", .-"safe_mul_func_int64_t_s_s"

.text
.balign 16
"safe_mod_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x1, #0
	cset	w2, eq
	cmp	w2, #0
	bne	.L249
	mov	x2, #-9223372036854775808
	cmp	x0, x2
	cset	w2, eq
	cmp	w2, #0
	beq	.L249
	cmn	x1, #1
	cset	w2, eq
.L249:
	cmp	w2, #0
	bne	.L251
	sdiv	x17, x0, x1
	msub	x0, x17, x1, x0
.L251:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_int64_t_s_s", @function
.size "safe_mod_func_int64_t_s_s", .-"safe_mod_func_int64_t_s_s"

.text
.balign 16
"safe_div_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x1, #0
	cset	w2, eq
	cmp	w2, #0
	bne	.L255
	mov	x2, #-9223372036854775808
	cmp	x0, x2
	cset	w2, eq
	cmp	w2, #0
	beq	.L255
	cmn	x1, #1
	cset	w2, eq
.L255:
	cmp	w2, #0
	bne	.L257
	sdiv	x0, x0, x1
.L257:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_int64_t_s_s", @function
.size "safe_div_func_int64_t_s_s", .-"safe_div_func_int64_t_s_s"

.text
.balign 16
"safe_lshift_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L260
	cmp	w1, #0
	cset	w2, lt
.L260:
	cmp	w2, #0
	bne	.L262
	cmp	w1, #32
	cset	w2, ge
.L262:
	cmp	w2, #0
	bne	.L264
	mov	x2, #9223372036854775807
	asr	x2, x2, x1
	cmp	x0, x2
	cset	w2, gt
.L264:
	cmp	w2, #0
	bne	.L266
	lsl	x0, x0, x1
.L266:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int64_t_s_s", @function
.size "safe_lshift_func_int64_t_s_s", .-"safe_lshift_func_int64_t_s_s"

.text
.balign 16
"safe_lshift_func_int64_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L269
	cmp	w1, #32
	cset	w2, cs
.L269:
	cmp	w2, #0
	bne	.L271
	mov	x2, #9223372036854775807
	asr	x2, x2, x1
	cmp	x0, x2
	cset	w2, gt
.L271:
	cmp	w2, #0
	bne	.L273
	lsl	x0, x0, x1
.L273:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_int64_t_s_u", @function
.size "safe_lshift_func_int64_t_s_u", .-"safe_lshift_func_int64_t_s_u"

.text
.balign 16
"safe_rshift_func_int64_t_s_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L276
	cmp	w1, #0
	cset	w2, lt
.L276:
	cmp	w2, #0
	bne	.L278
	cmp	w1, #32
	cset	w2, ge
.L278:
	cmp	w2, #0
	bne	.L280
	asr	x0, x0, x1
.L280:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int64_t_s_s", @function
.size "safe_rshift_func_int64_t_s_s", .-"safe_rshift_func_int64_t_s_s"

.text
.balign 16
"safe_rshift_func_int64_t_s_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x0, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L283
	cmp	w1, #32
	cset	w2, cs
.L283:
	cmp	w2, #0
	bne	.L285
	asr	x0, x0, x1
.L285:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_int64_t_s_u", @function
.size "safe_rshift_func_int64_t_s_u", .-"safe_rshift_func_int64_t_s_u"

.text
.balign 16
"safe_unary_minus_func_uint8_t_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w0, w0
	neg	w0, w0
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_uint8_t_u", @function
.size "safe_unary_minus_func_uint8_t_u", .-"safe_unary_minus_func_uint8_t_u"

.text
.balign 16
"safe_add_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w0, w0
	uxtb	w1, w1
	add	w0, w0, w1
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_uint8_t_u_u", @function
.size "safe_add_func_uint8_t_u_u", .-"safe_add_func_uint8_t_u_u"

.text
.balign 16
"safe_sub_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w0, w0
	uxtb	w1, w1
	sub	w0, w0, w1
	sxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_uint8_t_u_u", @function
.size "safe_sub_func_uint8_t_u_u", .-"safe_sub_func_uint8_t_u_u"

.text
.balign 16
"safe_mul_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w0, w0
	uxtb	w1, w1
	mul	w0, w0, w1
	uxtb	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_uint8_t_u_u", @function
.size "safe_mul_func_uint8_t_u_u", .-"safe_mul_func_uint8_t_u_u"

.text
.balign 16
"safe_mod_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w1, w1
	cmp	w1, #0
	beq	.L296
	uxtb	w0, w0
	sdiv	w17, w0, w1
	msub	w0, w17, w1, w0
	sxtb	w0, w0
.L296:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_uint8_t_u_u", @function
.size "safe_mod_func_uint8_t_u_u", .-"safe_mod_func_uint8_t_u_u"

.text
.balign 16
"safe_div_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxtb	w1, w1
	cmp	w1, #0
	beq	.L299
	uxtb	w0, w0
	sdiv	w0, w0, w1
	sxtb	w0, w0
.L299:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_uint8_t_u_u", @function
.size "safe_div_func_uint8_t_u_u", .-"safe_div_func_uint8_t_u_u"

.text
.balign 16
"safe_lshift_func_uint8_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L302
	cmp	w1, #32
	cset	w3, ge
.L302:
	uxtb	w2, w0
	cmp	w3, #0
	bne	.L304
	mov	w3, #255
	asr	w3, w3, w1
	cmp	w2, w3
	cset	w3, gt
.L304:
	cmp	w3, #0
	bne	.L307
	mov	w0, w2
	lsl	w0, w0, w1
	sxtb	w0, w0
.L307:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint8_t_u_s", @function
.size "safe_lshift_func_uint8_t_u_s", .-"safe_lshift_func_uint8_t_u_s"

.text
.balign 16
"safe_lshift_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	cset	w3, cs
	uxtb	w2, w0
	cmp	w3, #0
	bne	.L310
	mov	w3, #255
	asr	w3, w3, w1
	cmp	w2, w3
	cset	w3, gt
.L310:
	cmp	w3, #0
	bne	.L313
	mov	w0, w2
	lsl	w0, w0, w1
	sxtb	w0, w0
.L313:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint8_t_u_u", @function
.size "safe_lshift_func_uint8_t_u_u", .-"safe_lshift_func_uint8_t_u_u"

.text
.balign 16
"safe_rshift_func_uint8_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L316
	cmp	w1, #32
	cset	w2, ge
.L316:
	cmp	w2, #0
	bne	.L318
	uxtb	w0, w0
	asr	w0, w0, w1
	sxtb	w0, w0
.L318:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint8_t_u_s", @function
.size "safe_rshift_func_uint8_t_u_s", .-"safe_rshift_func_uint8_t_u_s"

.text
.balign 16
"safe_rshift_func_uint8_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	bcs	.L321
	uxtb	w0, w0
	asr	w0, w0, w1
	sxtb	w0, w0
.L321:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint8_t_u_u", @function
.size "safe_rshift_func_uint8_t_u_u", .-"safe_rshift_func_uint8_t_u_u"

.text
.balign 16
"safe_unary_minus_func_uint16_t_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w0, w0
	neg	w0, w0
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_uint16_t_u", @function
.size "safe_unary_minus_func_uint16_t_u", .-"safe_unary_minus_func_uint16_t_u"

.text
.balign 16
"safe_add_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w0, w0
	uxth	w1, w1
	add	w0, w0, w1
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_uint16_t_u_u", @function
.size "safe_add_func_uint16_t_u_u", .-"safe_add_func_uint16_t_u_u"

.text
.balign 16
"safe_sub_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w0, w0
	uxth	w1, w1
	sub	w0, w0, w1
	sxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_uint16_t_u_u", @function
.size "safe_sub_func_uint16_t_u_u", .-"safe_sub_func_uint16_t_u_u"

.text
.balign 16
"safe_mul_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w0, w0
	uxth	w1, w1
	mul	w0, w0, w1
	uxth	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_uint16_t_u_u", @function
.size "safe_mul_func_uint16_t_u_u", .-"safe_mul_func_uint16_t_u_u"

.text
.balign 16
"safe_mod_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w1, w1
	cmp	w1, #0
	beq	.L332
	uxth	w0, w0
	sdiv	w17, w0, w1
	msub	w0, w17, w1, w0
	sxth	w0, w0
.L332:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_uint16_t_u_u", @function
.size "safe_mod_func_uint16_t_u_u", .-"safe_mod_func_uint16_t_u_u"

.text
.balign 16
"safe_div_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	uxth	w1, w1
	cmp	w1, #0
	beq	.L335
	uxth	w0, w0
	sdiv	w0, w0, w1
	sxth	w0, w0
.L335:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_uint16_t_u_u", @function
.size "safe_div_func_uint16_t_u_u", .-"safe_div_func_uint16_t_u_u"

.text
.balign 16
"safe_lshift_func_uint16_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w3, lt
	cmp	w3, #0
	bne	.L338
	cmp	w1, #32
	cset	w3, ge
.L338:
	uxth	w2, w0
	cmp	w3, #0
	bne	.L340
	mov	w3, #65535
	asr	w3, w3, w1
	cmp	w2, w3
	cset	w3, gt
.L340:
	cmp	w3, #0
	bne	.L343
	mov	w0, w2
	lsl	w0, w0, w1
	sxth	w0, w0
.L343:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint16_t_u_s", @function
.size "safe_lshift_func_uint16_t_u_s", .-"safe_lshift_func_uint16_t_u_s"

.text
.balign 16
"safe_lshift_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	cset	w3, cs
	uxth	w2, w0
	cmp	w3, #0
	bne	.L346
	mov	w3, #65535
	asr	w3, w3, w1
	cmp	w2, w3
	cset	w3, gt
.L346:
	cmp	w3, #0
	bne	.L349
	mov	w0, w2
	lsl	w0, w0, w1
	sxth	w0, w0
.L349:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint16_t_u_u", @function
.size "safe_lshift_func_uint16_t_u_u", .-"safe_lshift_func_uint16_t_u_u"

.text
.balign 16
"safe_rshift_func_uint16_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L352
	cmp	w1, #32
	cset	w2, ge
.L352:
	cmp	w2, #0
	bne	.L354
	uxth	w0, w0
	asr	w0, w0, w1
	sxth	w0, w0
.L354:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint16_t_u_s", @function
.size "safe_rshift_func_uint16_t_u_s", .-"safe_rshift_func_uint16_t_u_s"

.text
.balign 16
"safe_rshift_func_uint16_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	bcs	.L357
	uxth	w0, w0
	asr	w0, w0, w1
	sxth	w0, w0
.L357:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint16_t_u_u", @function
.size "safe_rshift_func_uint16_t_u_u", .-"safe_rshift_func_uint16_t_u_u"

.text
.balign 16
"safe_unary_minus_func_uint32_t_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	neg	w0, w0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_uint32_t_u", @function
.size "safe_unary_minus_func_uint32_t_u", .-"safe_unary_minus_func_uint32_t_u"

.text
.balign 16
"safe_add_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	add	w0, w0, w1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_uint32_t_u_u", @function
.size "safe_add_func_uint32_t_u_u", .-"safe_add_func_uint32_t_u_u"

.text
.balign 16
"safe_sub_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sub	w0, w0, w1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_uint32_t_u_u", @function
.size "safe_sub_func_uint32_t_u_u", .-"safe_sub_func_uint32_t_u_u"

.text
.balign 16
"safe_mul_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mul	w0, w0, w1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_uint32_t_u_u", @function
.size "safe_mul_func_uint32_t_u_u", .-"safe_mul_func_uint32_t_u_u"

.text
.balign 16
"safe_mod_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	beq	.L368
	udiv	w17, w0, w1
	msub	w0, w17, w1, w0
.L368:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_uint32_t_u_u", @function
.size "safe_mod_func_uint32_t_u_u", .-"safe_mod_func_uint32_t_u_u"

.text
.balign 16
"safe_div_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	beq	.L371
	udiv	w0, w0, w1
.L371:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_uint32_t_u_u", @function
.size "safe_div_func_uint32_t_u_u", .-"safe_div_func_uint32_t_u_u"

.text
.balign 16
"safe_lshift_func_uint32_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L374
	cmp	w1, #32
	cset	w2, ge
.L374:
	cmp	w2, #0
	bne	.L376
	mov	w2, #-1
	lsr	w2, w2, w1
	cmp	w0, w2
	cset	w2, hi
.L376:
	cmp	w2, #0
	bne	.L378
	lsl	w0, w0, w1
.L378:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint32_t_u_s", @function
.size "safe_lshift_func_uint32_t_u_s", .-"safe_lshift_func_uint32_t_u_s"

.text
.balign 16
"safe_lshift_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	cset	w2, cs
	cmp	w2, #0
	bne	.L381
	mov	w2, #-1
	lsr	w2, w2, w1
	cmp	w0, w2
	cset	w2, hi
.L381:
	cmp	w2, #0
	bne	.L383
	lsl	w0, w0, w1
.L383:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint32_t_u_u", @function
.size "safe_lshift_func_uint32_t_u_u", .-"safe_lshift_func_uint32_t_u_u"

.text
.balign 16
"safe_rshift_func_uint32_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L386
	cmp	w1, #32
	cset	w2, ge
.L386:
	cmp	w2, #0
	bne	.L388
	lsr	w0, w0, w1
.L388:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint32_t_u_s", @function
.size "safe_rshift_func_uint32_t_u_s", .-"safe_rshift_func_uint32_t_u_s"

.text
.balign 16
"safe_rshift_func_uint32_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	bcs	.L391
	lsr	w0, w0, w1
.L391:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint32_t_u_u", @function
.size "safe_rshift_func_uint32_t_u_u", .-"safe_rshift_func_uint32_t_u_u"

.text
.balign 16
"safe_unary_minus_func_uint64_t_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	neg	x0, x0
	ldp	x29, x30, [sp], 16
	ret
.type "safe_unary_minus_func_uint64_t_u", @function
.size "safe_unary_minus_func_uint64_t_u", .-"safe_unary_minus_func_uint64_t_u"

.text
.balign 16
"safe_add_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	add	x0, x0, x1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_add_func_uint64_t_u_u", @function
.size "safe_add_func_uint64_t_u_u", .-"safe_add_func_uint64_t_u_u"

.text
.balign 16
"safe_sub_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	sub	x0, x0, x1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_sub_func_uint64_t_u_u", @function
.size "safe_sub_func_uint64_t_u_u", .-"safe_sub_func_uint64_t_u_u"

.text
.balign 16
"safe_mul_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mul	x0, x0, x1
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mul_func_uint64_t_u_u", @function
.size "safe_mul_func_uint64_t_u_u", .-"safe_mul_func_uint64_t_u_u"

.text
.balign 16
"safe_mod_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x1, #0
	beq	.L402
	udiv	x17, x0, x1
	msub	x0, x17, x1, x0
.L402:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_mod_func_uint64_t_u_u", @function
.size "safe_mod_func_uint64_t_u_u", .-"safe_mod_func_uint64_t_u_u"

.text
.balign 16
"safe_div_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	x1, #0
	beq	.L405
	udiv	x0, x0, x1
.L405:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_div_func_uint64_t_u_u", @function
.size "safe_div_func_uint64_t_u_u", .-"safe_div_func_uint64_t_u_u"

.text
.balign 16
"safe_lshift_func_uint64_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L408
	cmp	w1, #32
	cset	w2, ge
.L408:
	cmp	w2, #0
	bne	.L410
	mov	x2, #-1
	lsr	x2, x2, x1
	cmp	x0, x2
	cset	w2, hi
.L410:
	cmp	w2, #0
	bne	.L412
	lsl	x0, x0, x1
.L412:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint64_t_u_s", @function
.size "safe_lshift_func_uint64_t_u_s", .-"safe_lshift_func_uint64_t_u_s"

.text
.balign 16
"safe_lshift_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	cset	w2, cs
	cmp	w2, #0
	bne	.L415
	mov	x2, #-1
	lsr	x2, x2, x1
	cmp	x0, x2
	cset	w2, hi
.L415:
	cmp	w2, #0
	bne	.L417
	lsl	x0, x0, x1
.L417:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_lshift_func_uint64_t_u_u", @function
.size "safe_lshift_func_uint64_t_u_u", .-"safe_lshift_func_uint64_t_u_u"

.text
.balign 16
"safe_rshift_func_uint64_t_u_s":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #0
	cset	w2, lt
	cmp	w2, #0
	bne	.L420
	cmp	w1, #32
	cset	w2, ge
.L420:
	cmp	w2, #0
	bne	.L422
	lsr	x0, x0, x1
.L422:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint64_t_u_s", @function
.size "safe_rshift_func_uint64_t_u_s", .-"safe_rshift_func_uint64_t_u_s"

.text
.balign 16
"safe_rshift_func_uint64_t_u_u":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cmp	w1, #32
	bcs	.L425
	lsr	x0, x0, x1
.L425:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_rshift_func_uint64_t_u_u", @function
.size "safe_rshift_func_uint64_t_u_u", .-"safe_rshift_func_uint64_t_u_u"

.text
.balign 16
"safe_add_func_float_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp1"
	add	x0, x0, #:lo12:".Lfp1"
	fmov	s8, s0
	ldr	s0, [x0]
	fmul	s0, s8, s0
	adrp	x0, ".Lfp1"
	add	x0, x0, #:lo12:".Lfp1"
	fmov	s9, s1
	ldr	s1, [x0]
	fmul	s1, s9, s1
	fadd	s0, s0, s1
	bl	"fabsf"
	fmov	s1, s9
	fmov	s2, s0
	fmov	s0, s8
	adrp	x0, ".Lfp0"
	add	x0, x0, #:lo12:".Lfp0"
	ldr	s3, [x0]
	fcmpe	s2, s3
	bgt	.L428
	fadd	s0, s0, s1
.L428:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_add_func_float_f_f", @function
.size "safe_add_func_float_f_f", .-"safe_add_func_float_f_f"

.text
.balign 16
"safe_sub_func_float_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp1"
	add	x0, x0, #:lo12:".Lfp1"
	fmov	s8, s0
	ldr	s0, [x0]
	fmul	s0, s8, s0
	adrp	x0, ".Lfp1"
	add	x0, x0, #:lo12:".Lfp1"
	fmov	s9, s1
	ldr	s1, [x0]
	fmul	s1, s9, s1
	fsub	s0, s0, s1
	bl	"fabsf"
	fmov	s1, s9
	fmov	s2, s0
	fmov	s0, s8
	adrp	x0, ".Lfp0"
	add	x0, x0, #:lo12:".Lfp0"
	ldr	s3, [x0]
	fcmpe	s2, s3
	bgt	.L431
	fsub	s0, s0, s1
.L431:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_sub_func_float_f_f", @function
.size "safe_sub_func_float_f_f", .-"safe_sub_func_float_f_f"

.text
.balign 16
"safe_mul_func_float_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp4"
	add	x0, x0, #:lo12:".Lfp4"
	fmov	s8, s0
	ldr	s0, [x0]
	fmul	s0, s8, s0
	adrp	x0, ".Lfp3"
	add	x0, x0, #:lo12:".Lfp3"
	fmov	s9, s1
	ldr	s1, [x0]
	fmul	s1, s9, s1
	fmul	s0, s0, s1
	bl	"fabsf"
	fmov	s1, s9
	fmov	s2, s0
	fmov	s0, s8
	adrp	x0, ".Lfp2"
	add	x0, x0, #:lo12:".Lfp2"
	ldr	s3, [x0]
	fcmpe	s2, s3
	bgt	.L434
	fmul	s0, s0, s1
.L434:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_mul_func_float_f_f", @function
.size "safe_mul_func_float_f_f", .-"safe_mul_func_float_f_f"

.text
.balign 16
"safe_div_func_float_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	fmov	s9, s1
	fmov	s8, s0
	fmov	s0, s9
	bl	"fabsf"
	fmov	s1, s9
	fmov	s2, s0
	fmov	s0, s8
	adrp	x0, ".Lfp5"
	add	x0, x0, #:lo12:".Lfp5"
	ldr	s3, [x0]
	fcmpe	s2, s3
	cset	w0, mi
	cmp	w0, #0
	beq	.L438
	adrp	x0, ".Lfp6"
	add	x0, x0, #:lo12:".Lfp6"
	ldr	s2, [x0]
	fcmpe	s1, s2
	cset	w0, eq
	cmp	w0, #0
	bne	.L438
	adrp	x0, ".Lfp9"
	add	x0, x0, #:lo12:".Lfp9"
	fmov	s8, s0
	ldr	s0, [x0]
	fmul	s0, s8, s0
	adrp	x0, ".Lfp8"
	add	x0, x0, #:lo12:".Lfp8"
	fmov	s9, s1
	ldr	s1, [x0]
	fmul	s1, s9, s1
	fdiv	s0, s0, s1
	bl	"fabsf"
	fmov	s1, s9
	fmov	s2, s0
	fmov	s0, s8
	adrp	x0, ".Lfp7"
	add	x0, x0, #:lo12:".Lfp7"
	ldr	s3, [x0]
	fcmpe	s2, s3
	cset	w0, gt
.L438:
	cmp	w0, #0
	bne	.L440
	fdiv	s0, s0, s1
.L440:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_div_func_float_f_f", @function
.size "safe_div_func_float_f_f", .-"safe_div_func_float_f_f"

.text
.balign 16
"safe_add_func_double_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp11"
	add	x0, x0, #:lo12:".Lfp11"
	fmov	d8, d0
	ldr	d0, [x0]
	fmul	d0, d8, d0
	adrp	x0, ".Lfp11"
	add	x0, x0, #:lo12:".Lfp11"
	fmov	d9, d1
	ldr	d1, [x0]
	fmul	d1, d9, d1
	fadd	d0, d0, d1
	bl	"fabs"
	fmov	d1, d9
	fmov	d2, d0
	fmov	d0, d8
	adrp	x0, ".Lfp10"
	add	x0, x0, #:lo12:".Lfp10"
	ldr	d3, [x0]
	fcmpe	d2, d3
	bgt	.L443
	fadd	d0, d0, d1
.L443:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_add_func_double_f_f", @function
.size "safe_add_func_double_f_f", .-"safe_add_func_double_f_f"

.text
.balign 16
"safe_sub_func_double_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp11"
	add	x0, x0, #:lo12:".Lfp11"
	fmov	d8, d0
	ldr	d0, [x0]
	fmul	d0, d8, d0
	adrp	x0, ".Lfp11"
	add	x0, x0, #:lo12:".Lfp11"
	fmov	d9, d1
	ldr	d1, [x0]
	fmul	d1, d9, d1
	fsub	d0, d0, d1
	bl	"fabs"
	fmov	d1, d9
	fmov	d2, d0
	fmov	d0, d8
	adrp	x0, ".Lfp10"
	add	x0, x0, #:lo12:".Lfp10"
	ldr	d3, [x0]
	fcmpe	d2, d3
	bgt	.L446
	fsub	d0, d0, d1
.L446:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_sub_func_double_f_f", @function
.size "safe_sub_func_double_f_f", .-"safe_sub_func_double_f_f"

.text
.balign 16
"safe_mul_func_double_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	adrp	x0, ".Lfp14"
	add	x0, x0, #:lo12:".Lfp14"
	fmov	d8, d0
	ldr	d0, [x0]
	fmul	d0, d8, d0
	adrp	x0, ".Lfp13"
	add	x0, x0, #:lo12:".Lfp13"
	fmov	d9, d1
	ldr	d1, [x0]
	fmul	d1, d9, d1
	fmul	d0, d0, d1
	bl	"fabs"
	fmov	d1, d9
	fmov	d2, d0
	fmov	d0, d8
	adrp	x0, ".Lfp12"
	add	x0, x0, #:lo12:".Lfp12"
	ldr	d3, [x0]
	fcmpe	d2, d3
	bgt	.L449
	fmul	d0, d0, d1
.L449:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_mul_func_double_f_f", @function
.size "safe_mul_func_double_f_f", .-"safe_mul_func_double_f_f"

.text
.balign 16
"safe_div_func_double_f_f":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	d8, [x29, 24]
	str	d9, [x29, 16]
	fmov	d9, d1
	fmov	d8, d0
	fmov	d0, d9
	bl	"fabs"
	fmov	d1, d9
	fmov	d2, d0
	fmov	d0, d8
	adrp	x0, ".Lfp15"
	add	x0, x0, #:lo12:".Lfp15"
	ldr	d3, [x0]
	fcmpe	d2, d3
	cset	w0, mi
	cmp	w0, #0
	beq	.L453
	adrp	x0, ".Lfp16"
	add	x0, x0, #:lo12:".Lfp16"
	ldr	d2, [x0]
	fcmpe	d1, d2
	cset	w0, eq
	cmp	w0, #0
	bne	.L453
	adrp	x0, ".Lfp19"
	add	x0, x0, #:lo12:".Lfp19"
	fmov	d8, d0
	ldr	d0, [x0]
	fmul	d0, d8, d0
	adrp	x0, ".Lfp18"
	add	x0, x0, #:lo12:".Lfp18"
	fmov	d9, d1
	ldr	d1, [x0]
	fmul	d1, d9, d1
	fdiv	d0, d0, d1
	bl	"fabs"
	fmov	d1, d9
	fmov	d2, d0
	fmov	d0, d8
	adrp	x0, ".Lfp17"
	add	x0, x0, #:lo12:".Lfp17"
	ldr	d3, [x0]
	fcmpe	d2, d3
	cset	w0, gt
.L453:
	cmp	w0, #0
	bne	.L455
	fdiv	d0, d0, d1
.L455:
	ldr	d8, [x29, 24]
	ldr	d9, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "safe_div_func_double_f_f", @function
.size "safe_div_func_double_f_f", .-"safe_div_func_double_f_f"

.text
.balign 16
"safe_convert_func_float_to_int32_t":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	adrp	x0, ".Lfp20"
	add	x0, x0, #:lo12:".Lfp20"
	ldr	s1, [x0]
	fcmpe	s0, s1
	cset	w0, ls
	cmp	w0, #0
	bne	.L458
	adrp	x0, ".Lfp21"
	add	x0, x0, #:lo12:".Lfp21"
	ldr	s1, [x0]
	fcmpe	s0, s1
	cset	w0, ge
.L458:
	cmp	w0, #0
	bne	.L460
	fcvtzs	w0, s0
	b	.L461
.L460:
	mov	w0, #2147483647
.L461:
	ldp	x29, x30, [sp], 16
	ret
.type "safe_convert_func_float_to_int32_t", @function
.size "safe_convert_func_float_to_int32_t", .-"safe_convert_func_float_to_int32_t"

.bss
.balign 4
"crc32_tab":
	.fill 1024,1,0

.data
.balign 4
"crc32_context":
	.int 4294967295

.text
.balign 16
"crc32_gentab":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w0, #0
.L464:
	cmp	w0, #256
	bge	.L473
	mov	w2, w0
	mov	w1, #8
.L466:
	cmp	w1, #0
	ble	.L470
	mov	w3, #1
	and	w3, w0, w3
	mov	w4, #1
	lsr	w0, w0, w4
	cmp	w3, #0
	beq	.L469
	mov	w3, #33568
	movk	w3, #0xedb8, lsl #16
	eor	w0, w0, w3
.L469:
	mov	w3, #1
	sub	w1, w1, w3
	b	.L466
.L470:
	mov	w1, w0
	mov	w0, w2
	sxtw	x2, w0
	mov	x3, #4
	mul	x2, x2, x3
	adrp	x3, "crc32_tab"
	add	x3, x3, #:lo12:"crc32_tab"
	add	x2, x2, x3
	str	w1, [x2]
	mov	w2, w0
	mov	w0, #1
	add	w0, w2, w0
	b	.L464
.L473:
	ldp	x29, x30, [sp], 16
	ret
.type "crc32_gentab", @function
.size "crc32_gentab", .-"crc32_gentab"

.text
.balign 16
"crc32_byte":
	hint	#34
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	w2, w0
	adrp	x0, "crc32_context"
	add	x0, x0, #:lo12:"crc32_context"
	ldr	w1, [x0]
	mov	w0, #8
	lsr	w0, w1, w0
	uxtb	w2, w2
	eor	w1, w1, w2
	mov	w2, #255
	and	w1, w1, w2
	mov	w1, w1
	mov	x2, #4
	mul	x1, x1, x2
	adrp	x2, "crc32_tab"
	add	x2, x2, #:lo12:"crc32_tab"
	add	x1, x1, x2
	ldr	w1, [x1]
	eor	w0, w0, w1
	adrp	x1, "crc32_context"
	add	x1, x1, #:lo12:"crc32_context"
	str	w0, [x1]
	ldp	x29, x30, [sp], 16
	ret
.type "crc32_byte", @function
.size "crc32_byte", .-"crc32_byte"

.text
.balign 16
"crc32_8bytes":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [x29, 24]
	mov	x19, x0
	mov	x0, #255
	and	x0, x19, x0
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #8
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #16
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #24
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #32
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #40
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	x19, x0
	mov	w0, #48
	lsr	x0, x19, x0
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	mov	x0, x19
	mov	w1, #56
	lsr	x0, x0, x1
	mov	x1, #255
	and	x0, x0, x1
	uxtb	w0, w0
	bl	"crc32_byte"
	ldr	x19, [x29, 24]
	ldp	x29, x30, [sp], 32
	ret
.type "crc32_8bytes", @function
.size "crc32_8bytes", .-"crc32_8bytes"

.text
.balign 16
"transparent_crc":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [x29, 24]
	str	x20, [x29, 16]
	mov	w20, w2
	mov	x19, x1
	bl	"crc32_8bytes"
	mov	w2, w20
	mov	x1, x19
	cmp	w2, #0
	beq	.L480
	adrp	x0, "crc32_context"
	add	x0, x0, #:lo12:"crc32_context"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x2, #4294967295
	eor	x2, x0, x2
	adrp	x0, ".ts.670"
	add	x0, x0, #:lo12:".ts.670"
	bl	"printf"
.L480:
	ldr	x19, [x29, 24]
	ldr	x20, [x29, 16]
	ldp	x29, x30, [sp], 32
	ret
.type "transparent_crc", @function
.size "transparent_crc", .-"transparent_crc"

.text
.balign 16
"transparent_crc_bytes":
	hint	#34
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	str	x19, [x29, 56]
	str	x20, [x29, 48]
	str	x21, [x29, 40]
	str	x22, [x29, 32]
	str	x23, [x29, 24]
	mov	w23, w3
	mov	w21, w1
	mov	x1, x2
	mov	x22, x1
	mov	w19, #0
.L483:
	cmp	w19, w21
	bge	.L487
	mov	x20, x0
	sxtw	x0, w19
	add	x0, x20, x0
	ldrb	w0, [x0]
	bl	"crc32_byte"
	mov	w3, w23
	mov	x2, x22
	mov	w1, w21
	mov	x0, x20
	mov	w4, #1
	add	w19, w19, w4
	mov	w23, w3
	mov	x22, x2
	mov	w21, w1
	b	.L483
.L487:
	mov	x1, x22
	cmp	w23, #0
	beq	.L490
	adrp	x0, "crc32_context"
	add	x0, x0, #:lo12:"crc32_context"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x2, #4294967295
	eor	x2, x0, x2
	adrp	x0, ".ts.670"
	add	x0, x0, #:lo12:".ts.670"
	bl	"printf"
.L490:
	ldr	x19, [x29, 56]
	ldr	x20, [x29, 48]
	ldr	x21, [x29, 40]
	ldr	x22, [x29, 32]
	ldr	x23, [x29, 24]
	ldp	x29, x30, [sp], 64
	ret
.type "transparent_crc_bytes", @function
.size "transparent_crc_bytes", .-"transparent_crc_bytes"

.bss
.balign 8
"__undefined":
	.fill 8,1,0

.data
.balign 1
"g_17":
	.byte 0

.data
.balign 8
"g_26":
	.quad -5

.data
.balign 1
"g_31":
	.byte 79

.data
.balign 4
"g_33":
	.int 399629419

.data
.balign 8
"g_35":
	.quad 6839983711369756120

.data
.balign 4
"g_59":
	.int 5

.data
.balign 8
"g_67":
	.quad 0

.data
.balign 4
"g_75":
	.int 1049626

.data
.balign 1
"g_90":
	.byte 246

.data
.balign 2
"g_92":
	.short 2
	.short 2
	.short 2
	.short 2
	.short 2

.data
.balign 4
"g_100":
	.int 4294967295

.data
.balign 2
"g_117":
	.short 8
	.short 8

.data
.balign 1
"g_119":
	.byte 9

.data
.balign 8
"g_121":
	.quad 0

.data
.balign 8
"g_120":
	.quad "g_121"+0

.data
.balign 1
"g_124":
	.byte 0

.data
.balign 4
"g_125":
	.int 2606454688

.data
.balign 1
"g_127":
	.byte 222

.data
.balign 8
"g_130":
	.quad -5433961034463807206

.data
.balign 8
"g_132":
	.quad 0

.data
.balign 8
"g_143":
	.quad 0

.data
.balign 8
"g_147":
	.quad "g_31"+0

.data
.balign 8
"g_146":
	.quad "g_147"+0

.data
.balign 8
"g_157":
	.quad 0

.data
.balign 4
"g_187":
	.int 2445552821

.data
.balign 8
"g_188":
	.quad -4

.data
.balign 8
"g_190":
	.quad 1

.data
.balign 8
"g_200":
	.quad "g_59"+0

.data
.balign 8
"g_199":
	.quad "g_200"+0

.data
.balign 8
"g_295":
	.quad 0

.data
.balign 2
"g_313":
	.short 1

.data
.balign 4
"g_317":
	.int 4294967288
	.int 4294967288
	.int 1
	.int 4294967288
	.int 4294967288
	.int 1
	.int 4294967288
	.int 4294967288
	.int 1
	.int 4294967288

.data
.balign 4
"g_343":
	.int 0

.data
.balign 4
"g_413":
	.int 1078726053
	.int 2058412056
	.int 1078726053
	.int 3075035868
	.int 3075035868
	.int 3075035868
	.int 1078726053
	.int 2058412056
	.int 1078726053
	.int 3075035868
	.int 3075035868
	.int 3075035868
	.int 1078726053
	.int 2058412056
	.int 1078726053
	.int 3075035868
	.int 3075035868
	.int 3075035868

.data
.balign 8
"g_436":
	.quad -1
	.quad 8149909225831898296
	.quad 8247257873965805516
	.quad -3782116023284562800
	.quad 2278741884795844314
	.quad -584102496128733531
	.quad 1573687365461176721
	.quad -563164781584072118
	.quad -563164781584072118
	.quad -3782116023284562800
	.quad 5346226203707137349
	.quad 1
	.quad 8149909225831898296
	.quad 1
	.quad 2
	.quad 1
	.quad -1
	.quad -2343047362314450832
	.quad 8247257873965805516
	.quad -2343047362314450832
	.quad 3
	.quad 5346226203707137349
	.quad -1
	.quad -6072363028360169450
	.quad 1
	.quad -2343047362314450832
	.quad -9
	.quad 9
	.quad -6072363028360169450
	.quad -9
	.quad -204948553513539929
	.quad -6502972733306038039
	.quad 1
	.quad -563164781584072118
	.quad -1
	.quad -9
	.quad -563164781584072118
	.quad -6502972733306038039
	.quad 2
	.quad -584102496128733531
	.quad -2343047362314450832
	.quad 1
	.quad 8247257873965805516
	.quad 1
	.quad -2343047362314450832
	.quad 9
	.quad -6502972733306038039
	.quad -6502972733306038039
	.quad 9
	.quad -1
	.quad -2343047362314450832
	.quad 8149909225831898296
	.quad -9
	.quad 1
	.quad 8247257873965805516
	.quad -6072363028360169450
	.quad 2
	.quad 9
	.quad -6072363028360169450
	.quad -9
	.quad -204948553513539929
	.quad -6502972733306038039
	.quad 1
	.quad 1
	.quad -2343047362314450832
	.quad -9
	.quad -584102496128733531
	.quad -1
	.quad -9
	.quad 2278741884795844314
	.quad 3
	.quad -6072363028360169450

.data
.balign 8
"g_476":
	.quad 0

.data
.balign 8
"g_475":
	.quad "g_476"+0

.data
.balign 8
"g_648":
	.quad "g_132"+0

.data
.balign 8
"g_647":
	.quad "g_648"+0

.data
.balign 8
"g_646":
	.quad "g_647"+0

.data
.balign 4
"g_702":
	.int 2267407495

.data
.balign 1
"g_704":
	.byte 248

.data
.balign 8
"g_747":
	.quad 1253068560313094630

.data
.balign 4
"g_771":
	.int 3709189150

.data
.balign 8
"g_858":
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_317"+0
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_33"+0
	.quad "g_317"+4
	.quad "g_317"+0
	.quad "g_33"+0
	.quad 0
	.quad 0
	.quad 0
	.quad "g_33"+0
	.quad "g_317"+0
	.quad "g_317"+4
	.quad "g_33"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_317"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_33"+0
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_33"+0
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_33"+0
	.quad "g_317"+0
	.quad "g_187"+0
	.quad "g_317"+24
	.quad "g_33"+0
	.quad "g_317"+4
	.quad "g_317"+0
	.quad "g_33"+0
	.quad 0
	.quad 0
	.quad 0
	.quad "g_33"+0
	.quad "g_317"+0
	.quad "g_317"+4
	.quad "g_33"+0
	.quad "g_317"+24
	.quad "g_187"+0
	.quad "g_317"+0

.data
.balign 2
"g_887":
	.short 281474976710655

.data
.balign 8
"g_896":
	.quad "g_125"+0

.data
.balign 8
"g_895":
	.quad "g_896"+0

.data
.balign 8
"g_894":
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0
	.quad "g_895"+0

.data
.balign 8
"g_941":
	.quad 0

.data
.balign 8
"g_940":
	.quad "g_941"+0

.data
.balign 8
"g_985":
	.quad 0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+4
	.quad "g_92"+6
	.quad "g_92"+8
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad 0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+4
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+6
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+4
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad 0
	.quad 0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+6
	.quad "g_92"+2
	.quad "g_92"+4
	.quad 0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+0
	.quad "g_92"+4
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+6
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+6
	.quad 0
	.quad 0
	.quad "g_92"+6
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+6
	.quad "g_313"+0
	.quad "g_92"+2
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+0
	.quad 0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+4
	.quad "g_92"+6
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+0
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+6
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad 0
	.quad 0
	.quad "g_92"+6
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+0
	.quad "g_92"+8
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad 0
	.quad 0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+4
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+0
	.quad "g_92"+2
	.quad 0
	.quad "g_313"+0
	.quad 0
	.quad 0
	.quad "g_92"+0
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+0
	.quad "g_313"+0
	.quad "g_92"+8
	.quad "g_92"+8
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad 0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad 0
	.quad "g_313"+0
	.quad 0
	.quad "g_92"+6
	.quad "g_92"+0
	.quad "g_313"+0
	.quad 0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_313"+0
	.quad 0
	.quad 0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+8
	.quad "g_92"+4
	.quad "g_92"+2
	.quad "g_92"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+0
	.quad "g_92"+2
	.quad 0
	.quad 0
	.quad "g_92"+0
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_92"+2
	.quad "g_313"+0
	.quad "g_92"+6
	.quad "g_92"+8
	.quad "g_92"+2
	.quad 0
	.quad 0

.data
.balign 8
"g_984":
	.quad "g_985"+512

.data
.balign 4
"g_1049":
	.int 1936149578

.data
.balign 2
"g_1081":
	.short 43792

.data
.balign 4
"g_1219":
	.int 5
	.int 5
	.int 5
	.int 5
	.int 5
	.int 5
	.int 5
	.int 5
	.int 5

.data
.balign 8
"g_1223":
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad 0
	.quad 0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad 0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad 0
	.quad 0
	.quad "g_75"+0
	.quad 0
	.quad 0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad "g_75"+0
	.quad 0
	.quad "g_75"+0

.data
.balign 8
"g_1222":
	.quad "g_1223"+48
	.quad "g_1223"+80
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+240
	.quad 0
	.quad "g_1223"+48
	.quad "g_1223"+152
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+184
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+296
	.quad "g_1223"+248
	.quad "g_1223"+48
	.quad "g_1223"+64
	.quad 0
	.quad "g_1223"+224
	.quad "g_1223"+48
	.quad "g_1223"+296
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+48
	.quad "g_1223"+0
	.quad "g_1223"+48
	.quad "g_1223"+192
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+64
	.quad "g_1223"+152
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+240
	.quad "g_1223"+48
	.quad "g_1223"+0
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+296
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+240
	.quad "g_1223"+296
	.quad "g_1223"+48
	.quad "g_1223"+80
	.quad 0
	.quad 0
	.quad "g_1223"+240
	.quad "g_1223"+248
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+0
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+184
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+192
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+48
	.quad "g_1223"+80
	.quad "g_1223"+0
	.quad "g_1223"+48
	.quad 0
	.quad "g_1223"+48

.data
.balign 4
"g_1270":
	.int 36482767

.data
.balign 8
"g_1304":
	.quad 1

.data
.balign 4
"g_1326":
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920
	.int 3995837920

.data
.balign 8
"g_1522":
	.quad "g_120"+0

.data
.balign 4
"g_1523":
	.int 3396065206
	.int 6
	.int 1
	.int 3396065206
	.int 6
	.int 4294967286
	.int 0
	.int 0
	.int 1
	.int 0
	.int 0
	.int 4294967286
	.int 6
	.int 3396065206
	.int 1
	.int 6
	.int 3396065206
	.int 4294967286
	.int 3396065206
	.int 6
	.int 1
	.int 3396065206
	.int 6
	.int 4294967286

.data
.balign 8
"g_1525":
	.quad "g_199"+0

.data
.balign 8
"g_1524":
	.quad "g_1525"+0

.data
.balign 4
"g_1713":
	.int 1
	.int 1
	.int 1
	.int 1
	.int 1
	.int 1
	.int 1

.data
.balign 8
"g_1748":
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0
	.quad "g_1525"+0

.data
.balign 8
"g_1760":
	.quad "g_124"+0

.data
.balign 4
"g_1802":
	.int 1556303880

.data
.balign 8
"g_1832":
	.quad 0

.data
.balign 4
"g_1877":
	.int 8

.data
.balign 8
"g_1912":
	.quad "g_146"+0

.data
.balign 8
"g_1911":
	.quad "g_1912"+0

.data
.balign 8
"g_1965":
	.quad 4

.data
.balign 8
"g_2159":
	.quad 0

.data
.balign 8
"g_2158":
	.quad "g_2159"+0

.data
.balign 4
"g_2183":
	.int 1971600216

.data
.balign 2
"g_2422":
	.short 54267

.data
.balign 8
"g_2497":
	.quad "g_984"+0

.data
.balign 4
"g_2684":
	.int 0

.data
.balign 8
"g_2719":
	.quad "g_75"+0

.data
.balign 8
"g_2725":
	.quad -1

.text
.balign 16
"func_1":
	hint	#34
	sub	sp, sp, #1520
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	str	x19, [x29, 1528]
	str	x20, [x29, 1520]
	str	x21, [x29, 1512]
	str	x22, [x29, 1504]
	str	x23, [x29, 1496]
	str	x24, [x29, 1488]
	str	x25, [x29, 1480]
	str	x26, [x29, 1472]
	mov	x2, #140
	adrp	x1, .ci681
	add	x1, x1, #:lo12:.ci681
	add	x0, x29, #24
	bl	memcpy
	mov	x1, #140
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #-1
	strh	w0, [x1]
	mov	x1, #144
	add	x0, x29, #24
	add	x20, x0, x1
	mov	x2, #4
	mov	w1, #0
	mov	x0, x20
	bl	memset
	ldr	w0, [x20]
	mov	w1, #-4194304
	and	w0, w0, w1
	mov	w1, #4194302
	orr	w0, w0, w1
	str	w0, [x20]
	mov	x1, #152
	add	x0, x29, #24
	add	x19, x0, x1
	mov	x2, #168
	mov	w1, #0
	mov	x0, x19
	bl	memset
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x19]
	mov	x1, #168
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #184
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #200
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #208
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #216
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #224
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #232
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #240
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #248
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #256
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #264
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #280
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #296
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #312
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	str	x0, [x1]
	mov	x1, #320
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x2, #36
	adrp	x1, .ci682
	add	x1, x1, #:lo12:.ci682
	bl	memcpy
	adrp	x0, "g_17"
	add	x0, x0, #:lo12:"g_17"
	ldrb	w1, [x0]
	mov	w0, #1
	bl	"safe_div_func_int8_t_s_s"
	mov	w26, w0
	adrp	x0, "g_26"
	add	x0, x0, #:lo12:"g_26"
	ldr	x0, [x0]
	mov	x1, #1
	add	x0, x0, x1
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x0, [x1]
	bl	"func_23"
	mov	x1, #28
	add	x0, x29, #24
	add	x25, x0, x1
	adrp	x0, "g_199"
	add	x0, x0, #:lo12:"g_199"
	ldr	x0, [x0]
	ldr	x1, [x0]
	adrp	x2, "g_1219"+28
	add	x2, x2, #:lo12:"g_1219"+28
	adrp	x0, "g_1219"
	add	x0, x0, #:lo12:"g_1219"
	cmp	x0, x2
	cset	w19, ls
	adrp	x2, "g_1219"+28
	add	x2, x2, #:lo12:"g_1219"+28
	adrp	x0, "g_1219"+32
	add	x0, x0, #:lo12:"g_1219"+32
	cmp	x0, x2
	cset	w23, cs
	str	w23, [x29, 1460]
	adrp	x2, "g_1222"+504
	add	x2, x2, #:lo12:"g_1222"+504
	adrp	x0, "g_1222"+512
	add	x0, x0, #:lo12:"g_1222"+512
	cmp	x0, x2
	cset	w0, ne
	str	w0, [x29, 1456]
	adrp	x2, "g_895"
	add	x2, x2, #:lo12:"g_895"
	cmp	x2, #0
	cset	w2, ne
	sxtw	x2, w2
	cmp	x2, #0
	cset	w2, gt
	sxtw	x22, w2
	mov	x2, #1
	orr	x21, x22, x2
	cmp	x21, #4
	cmp	x1, #0
	beq	.L494
	mov	x2, #28
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	cmp	w1, #0
	bne	.L494
	mov	x2, #140
	add	x1, x29, #24
	add	x1, x1, x2
	ldrsh	w1, [x1]
	cmp	w1, #0
.L494:
	mov	w24, w0
	adrp	x0, "g_117"+2
	add	x0, x0, #:lo12:"g_117"+2
	ldrsh	w0, [x0]
	mov	x2, #28
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	orr	w0, w0, w1
	sxtb	w0, w0
	mov	x2, #28
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtb	w1, w1
	bl	"safe_add_func_uint8_t_u_u"
	uxtb	w0, w0
	mov	x2, #28
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxth	w1, w1
	bl	"safe_sub_func_uint16_t_u_u"
	mov	w0, w24
	mov	x2, #28
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtb	w1, w1
	mov	w24, w0
	mov	w0, #1
	bl	"safe_mul_func_int8_t_s_s"
	mov	w0, w24
	mov	x2, #1
	mov	x1, #0
	add	x1, x25, x1
	ldr	x1, [x1]
	mov	w24, w0
	mov	w0, #1
	bl	"func_19"
	mov	x1, x0
	mov	w0, w24
	mov	x3, #0
	add	x2, x29, #16
	add	x2, x2, x3
	str	x1, [x2]
	mov	x2, #0
	add	x1, x29, #16
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x3, #0
	adrp	x2, "g_75"
	add	x2, x2, #:lo12:"g_75"
	add	x2, x2, x3
	str	w1, [x2]
	adrp	x1, "g_896"
	add	x1, x1, #:lo12:"g_896"
	ldr	x1, [x1]
	ldr	w2, [x1]
	mov	w24, w0
	sxtb	w0, w26
	mov	w4, #1
	mov	x1, #0
	add	x1, x25, x1
	ldr	x3, [x1]
	mov	x5, #0
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	add	x1, x1, x5
	ldr	x1, [x1]
	bl	"func_8"
	adrp	x1, "g_92"+2
	add	x1, x1, #:lo12:"g_92"+2
	strh	w0, [x1]
	uxth	w0, w0
	mov	w1, #11
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	w1, w0
	mov	w0, w24
	uxth	w1, w1
	adrp	x2, "g_1523"
	add	x2, x2, #:lo12:"g_1523"
	ldr	w2, [x2]
	cmp	w1, w2
	mov	w24, w0
	cset	w0, hi
	sxtw	x0, w0
	mov	x1, #14
	bl	"func_3"
	mov	w1, w0
	mov	w0, w24
	sxtb	x1, w1
	mov	x2, #61705
	cmp	x1, x2
	bne	.L534
	mov	x20, x22
	mov	x1, #1260
	add	x0, x29, #24
	add	x19, x0, x1
	mov	w0, #13410
	movk	w0, #0x88d7, lsl #16
	str	w0, [x19]
	mov	x1, #1280
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #-3
	str	w0, [x1]
	mov	x1, #1264
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #0
.L498:
	cmp	w0, #2
	bge	.L501
	sxtw	x2, w0
	mov	x3, #8
	mul	x2, x2, x3
	add	x3, x1, x2
	adrp	x2, "g_1713"+24
	add	x2, x2, #:lo12:"g_1713"+24
	str	x2, [x3]
	mov	w2, #1
	add	w0, w0, w2
	b	.L498
.L501:
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	ldr	x0, [x0]
	ldr	x1, [x0]
	mov	w0, #14
	str	w0, [x1]
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldrb	w0, [x0]
	mov	x2, #1260
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_mul_func_uint8_t_u_u"
	uxtb	w0, w0
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	beq	.L503
	mov	w0, #1
.L503:
	sxtw	x0, w0
	cmp	x0, #4
	cset	w22, eq
	mov	w1, #4
	mov	w0, #4
	bl	"safe_mul_func_int8_t_s_s"
	sxtb	w0, w0
	cmp	w22, w0
	cset	w0, le
	mov	x2, #144
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w2, w1, w2
	mov	w3, #10
	asr	w2, w2, w3
	cmp	w0, w2
	cset	w0, eq
	mov	w2, #-4194304
	and	w1, w1, w2
	orr	w0, w0, w1
	mov	x2, #144
	add	x1, x29, #24
	add	x1, x1, x2
	str	w0, [x1]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxtb	w0, w0
	mov	x2, #140
	add	x1, x29, #24
	add	x1, x1, x2
	ldrsh	w1, [x1]
	bl	"safe_rshift_func_int8_t_s_u"
	sxtb	x0, w0
	cmp	x0, #15
	cset	w0, hi
	sxtw	x0, w0
	mov	x1, #252
	and	x0, x0, x1
	sxth	w0, w0
	mov	w1, #8
	bl	"safe_rshift_func_int16_t_s_s"
	sxth	w0, w0
	adrp	x1, "g_317"+36
	add	x1, x1, #:lo12:"g_317"+36
	ldr	w1, [x1]
	cmp	w0, w1
	mov	w1, #14
	mov	w0, #1
	bl	"safe_lshift_func_int8_t_s_u"
	sxtb	x0, w0
	cmp	x0, #198
	cset	w0, eq
	adrp	x1, "g_1713"+24
	add	x1, x1, #:lo12:"g_1713"+24
	str	w0, [x1]
	cmp	x21, #4
	mov	w1, #-2436
	mov	w0, #16900
	bl	"safe_mul_func_uint16_t_u_u"
	uxth	w0, w0
	cmp	w0, #0
	bne	.L508
	mov	x1, #140
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #4
	strh	w0, [x1]
	mov	x1, #1416
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x2, #0
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x0, x2
	str	w1, [x2]
	mov	x1, #0
	add	x0, x0, x1
	ldr	x0, [x0]
	b	.L577
.L508:
	mov	x1, #1288
	add	x0, x29, #24
	add	x3, x0, x1
	mov	x1, #1408
	add	x0, x29, #24
	add	x1, x0, x1
	mov	x0, #0
	str	x0, [x1]
	mov	w2, #0
.L510:
	cmp	w2, #5
	bge	.L517
	sxtw	x0, w2
	mov	x1, #24
	mul	x0, x0, x1
	add	x1, x3, x0
	mov	w0, #0
.L513:
	cmp	w0, #3
	bge	.L516
	sxtw	x4, w0
	mov	x5, #8
	mul	x4, x4, x5
	add	x4, x1, x4
	str	x19, [x4]
	mov	w4, #1
	add	w0, w0, w4
	b	.L513
.L516:
	mov	w0, #1
	add	w2, w2, w0
	b	.L510
.L517:
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x1, [x0]
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #1352
	add	x0, x29, #24
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #1408
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	x0, [x0]
	mov	x2, #1408
	add	x1, x29, #24
	add	x1, x1, x2
	str	x0, [x1]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	adrp	x1, "g_1219"
	add	x1, x1, #:lo12:"g_1219"
	cmp	x0, x1
	cset	w1, cs
	cmp	w1, #0
	bne	.L520
	mov	w0, w1
	b	.L521
.L520:
	adrp	x1, "g_1219"+32
	add	x1, x1, #:lo12:"g_1219"+32
	cmp	x0, x1
	cset	w0, ls
.L521:
	cmp	w0, #0
	bne	.L523
	adrp	x3, ".__func__.680"
	add	x3, x3, #:lo12:".__func__.680"
	mov	w2, #249
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.794"
	add	x0, x0, #:lo12:".ts.794"
	bl	"__assert_fail"
.L523:
	adrp	x0, "g_295"
	add	x0, x0, #:lo12:"g_295"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, eq
	cmp	w1, #0
	bne	.L525
	adrp	x1, "g_1522"
	add	x1, x1, #:lo12:"g_1522"
	cmp	x0, x1
	cset	w0, eq
	b	.L526
.L525:
	mov	w0, w1
.L526:
	cmp	w0, #0
	bne	.L528
	adrp	x3, ".__func__.680"
	add	x3, x3, #:lo12:".__func__.680"
	mov	w2, #251
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.801"
	add	x0, x0, #:lo12:".ts.801"
	bl	"__assert_fail"
.L528:
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, eq
	cmp	w1, #0
	bne	.L530
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	cmp	x0, x1
	cset	w0, eq
	b	.L531
.L530:
	mov	w0, w1
.L531:
	cmp	w0, #0
	bne	.L533
	adrp	x3, ".__func__.680"
	add	x3, x3, #:lo12:".__func__.680"
	mov	w2, #252
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.808"
	add	x0, x0, #:lo12:".ts.808"
	bl	"__assert_fail"
.L533:
	mov	x1, #1424
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x2, #0
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x0, x2
	str	w1, [x2]
	mov	x1, #0
	add	x0, x0, x1
	ldr	x0, [x0]
	b	.L577
.L534:
	mov	w21, w19
	mov	w19, w23
	mov	x2, #364
	add	x1, x29, #24
	mov	w24, w19
	add	x19, x1, x2
	mov	x2, #720
	adrp	x1, .ci690
	add	x1, x1, #:lo12:.ci690
	mov	w22, w0
	mov	x0, x19
	bl	memcpy
	mov	w0, w22
	mov	x2, #400
	add	x1, x29, #24
	add	x1, x1, x2
	adrp	x2, "g_120"
	add	x2, x2, #:lo12:"g_120"
	ldr	x2, [x2]
	ldr	x3, [x2]
	mov	w2, #48503
	movk	w2, #0xeb08, lsl #16
	str	w2, [x3]
	ldr	w2, [x1]
	mov	w3, #48503
	movk	w3, #0xeb08, lsl #16
	eor	w23, w2, w3
	str	w23, [x1]
	adrp	x1, "g_646"
	add	x1, x1, #:lo12:"g_646"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	cmp	x1, #1
	cset	w2, ne
	cmp	w2, #0
	bne	.L539
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w25, [x0]
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x1, [x0]
	ldrb	w22, [x1]
	mov	w0, #1
	add	w0, w22, w0
	strb	w0, [x1]
	adrp	x0, "g_2158"
	add	x0, x0, #:lo12:"g_2158"
	ldr	x1, [x0]
	ldr	x0, [x1]
	ldr	x1, [x1]
	cmp	x0, x1
	cset	w0, ne
	sxtw	x26, w0
	sxtw	x0, w23
	mov	x1, #400
	mov	x24, x0
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtb	w0, w0
	mov	x2, #400
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	adrp	x2, "g_704"
	add	x2, x2, #:lo12:"g_704"
	strb	w1, [x2]
	uxtb	w1, w1
	bl	"safe_rshift_func_uint8_t_u_u"
	mov	w1, #254
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w0
	mov	x0, x24
	ldr	w24, [x29, 1460]
	sxtb	x1, w1
	bl	"safe_div_func_uint64_t_u_u"
	mov	x1, x0
	ldr	w0, [x29, 1456]
	cmp	x26, x1
	mov	w26, w0
	cset	w0, cc
	sxtw	x0, w0
	adrp	x1, "g_648"
	add	x1, x1, #:lo12:"g_648"
	ldr	x1, [x1]
	ldr	x1, [x1]
	bl	"safe_mod_func_int64_t_s_s"
	mov	w0, w26
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	ldr	x1, [x1]
	uxth	w1, w1
	mov	w26, w0
	mov	w0, #26234
	bl	"safe_mod_func_int16_t_s_s"
	mov	w1, w0
	mov	w0, w26
	sxth	w1, w1
	cmp	w1, #0
	cset	w1, ne
	cmp	w1, #0
	beq	.L538
	mov	w1, #1
.L538:
	adrp	x2, "g_17"
	add	x2, x2, #:lo12:"g_17"
	strb	w1, [x2]
	uxtb	w1, w1
	cmp	x1, #0
	mov	w26, w0
	cset	w0, ge
	sxtw	x0, w0
	bl	"safe_unary_minus_func_int64_t_s"
	mov	w0, w26
	adrp	x1, "g_647"
	add	x1, x1, #:lo12:"g_647"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	mov	x2, #3606
	movk	x2, #0xe086, lsl #16
	movk	x2, #0xa7ea, lsl #32
	movk	x2, #0xa29d, lsl #48
	eor	x1, x1, x2
	cmp	w25, #0
	cset	w2, ne
	mov	w3, #1
	eor	w2, w2, w3
	eor	w2, w2, w22
	sxtw	x2, w2
	and	x1, x1, x2
	cmp	x1, #0
	mov	w22, w0
	cset	w0, ne
	b	.L540
.L539:
	mov	w22, w0
	mov	w0, w2
.L540:
	mov	w1, #52521
	movk	w1, #0x18e0, lsl #16
	bl	"safe_add_func_int32_t_s_s"
	cmp	w0, #0
	bne	.L557
	mov	w19, w24
	mov	w20, w21
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x21, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	ldr	w0, [x0]
	mov	w24, w0
	adrp	x0, "g_1523"+80
	add	x0, x0, #:lo12:"g_1523"+80
	ldr	w0, [x0]
	uxth	w0, w0
	mov	w1, #6567
	bl	"safe_mul_func_int16_t_s_s"
	mov	w1, w0
	mov	w0, w24
	sxth	w1, w1
	mov	w2, #-1
	eor	w1, w1, w2
	bl	"safe_div_func_int32_t_s_s"
	sxtw	x0, w0
	sxtb	w1, w23
	mov	x23, x0
	mov	w0, #-64
	bl	"safe_sub_func_uint8_t_u_u"
	mov	w1, w0
	mov	x0, x23
	uxtb	w1, w1
	bl	"safe_mod_func_int64_t_s_s"
	mov	w0, w22
	adrp	x1, "g_1219"+28
	add	x1, x1, #:lo12:"g_1219"+28
	str	x1, [x21]
	adrp	x2, "g_143"
	add	x2, x2, #:lo12:"g_143"
	adrp	x1, "g_1219"+28
	add	x1, x1, #:lo12:"g_1219"+28
	str	x1, [x2]
	adrp	x2, "g_1219"+28
	add	x2, x2, #:lo12:"g_1219"+28
	adrp	x1, "g_1219"
	add	x1, x1, #:lo12:"g_1219"
	cmp	x1, x2
	bls	.L544
	mov	w19, w20
.L544:
	cmp	w19, #0
	bne	.L546
	adrp	x3, ".__func__.680"
	add	x3, x3, #:lo12:".__func__.680"
	mov	w2, #195
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	w19, w0
	adrp	x0, ".ts.736"
	add	x0, x0, #:lo12:".ts.736"
	bl	"__assert_fail"
	mov	w0, w19
.L546:
	adrp	x1, "g_143"
	add	x1, x1, #:lo12:"g_143"
	ldr	x1, [x1]
	adrp	x2, "g_1219"
	add	x2, x2, #:lo12:"g_1219"
	cmp	x1, x2
	cset	w2, cs
	cmp	w2, #0
	beq	.L548
	adrp	x2, "g_1219"+32
	add	x2, x2, #:lo12:"g_1219"+32
	cmp	x1, x2
	cset	w2, ls
.L548:
	cmp	w2, #0
	bne	.L550
	cmp	x1, #0
	cset	w1, eq
	b	.L551
.L550:
	mov	w1, w2
.L551:
	cmp	w1, #0
	bne	.L553
	adrp	x3, ".__func__.680"
	add	x3, x3, #:lo12:".__func__.680"
	mov	w2, #198
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	w19, w0
	adrp	x0, ".ts.746"
	add	x0, x0, #:lo12:".ts.746"
	bl	"__assert_fail"
	mov	w0, w19
.L553:
	adrp	x1, "g_647"
	add	x1, x1, #:lo12:"g_647"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x2, [x1]
	mov	x3, #33010
	movk	x3, #0x614f, lsl #16
	movk	x3, #0xaaf9, lsl #32
	movk	x3, #0x7115, lsl #48
	and	x19, x2, x3
	str	x19, [x1]
	mov	x1, #144
	mov	w20, w0
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
	mov	w1, #-1
	bl	"safe_mod_func_int16_t_s_s"
	mov	w0, w20
	mov	w20, w0
	adrp	x0, "g_413"
	add	x0, x0, #:lo12:"g_413"
	ldr	w0, [x0]
	uxth	w0, w0
	mov	x2, #140
	add	x1, x29, #24
	add	x1, x1, x2
	ldrsh	w1, [x1]
	bl	"safe_mod_func_int16_t_s_s"
	mov	w21, w0
	mov	w0, w20
	adrp	x1, "g_147"
	add	x1, x1, #:lo12:"g_147"
	ldr	x20, [x1]
	adrp	x1, "g_92"+2
	add	x1, x1, #:lo12:"g_92"+2
	ldrh	w1, [x1]
	uxth	w1, w1
	mov	x2, #65535
	eor	x1, x1, x2
	uxth	w1, w1
	adrp	x2, "g_92"+2
	add	x2, x2, #:lo12:"g_92"+2
	strh	w1, [x2]
	bl	"safe_mul_func_int16_t_s_s"
	mov	w1, w0
	mov	w0, w21
	sxth	w1, w1
	cmp	w1, #0
	cset	w2, ne
	cmp	w2, #0
	bne	.L556
	adrp	x1, "g_2684"
	add	x1, x1, #:lo12:"g_2684"
	ldr	w1, [x1]
	cmp	w1, #0
	cset	w2, ne
	cmp	w2, #0
	beq	.L556
	adrp	x1, "g_1760"
	add	x1, x1, #:lo12:"g_1760"
	ldr	x1, [x1]
	ldrsb	w1, [x1]
	cmp	w1, #0
	cset	w2, ne
.L556:
	strb	w2, [x20]
	adrp	x1, "g_704"
	add	x1, x1, #:lo12:"g_704"
	strb	w2, [x1]
	mov	x3, #28
	add	x1, x29, #24
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	w3, #-4194304
	and	w1, w1, w3
	orr	w1, w1, w2
	mov	x3, #28
	add	x2, x29, #24
	add	x2, x2, x3
	str	w1, [x2]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtw	x1, w1
	cmp	x1, #7
	cset	w1, cc
	sxtw	x1, w1
	mov	x2, #4294967288
	cmp	x1, x2
	cset	w1, ne
	bl	"safe_add_func_uint16_t_u_u"
	uxth	w0, w0
	mov	x1, #40911
	movk	x1, #0xfd01, lsl #16
	movk	x1, #0x1481, lsl #32
	movk	x1, #0x8e36, lsl #48
	and	x0, x0, x1
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	ldr	x1, [x1]
	cmp	x0, x1
	cset	w0, ls
	mov	w1, #22285
	bl	"safe_sub_func_int16_t_s_s"
	sxtb	w0, w0
	mov	w1, #5
	bl	"safe_rshift_func_int8_t_s_s"
	sxtb	w0, w0
	adrp	x1, "g_1760"
	add	x1, x1, #:lo12:"g_1760"
	ldr	x1, [x1]
	ldrsb	w1, [x1]
	cmp	w0, w1
	cset	w0, ne
	mov	w1, #10
	bl	"safe_rshift_func_uint16_t_u_s"
	uxth	w0, w0
	mov	x1, #64298
	movk	x1, #0x243b, lsl #16
	cmp	x0, x1
	cset	w0, ne
	adrp	x1, "g_117"+2
	add	x1, x1, #:lo12:"g_117"+2
	ldrsh	w1, [x1]
	cmp	w0, w1
	cset	w0, le
	sxtw	x0, w0
	adrp	x1, "g_1219"+28
	add	x1, x1, #:lo12:"g_1219"+28
	ldr	w1, [x1]
	sxtw	x1, w1
	bl	"safe_div_func_int64_t_s_s"
	mov	x1, #28
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxtw	x0, w0
	cmp	x19, x0
	cset	w0, lt
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	ldr	w1, [x1]
	eor	w0, w0, w1
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	str	w0, [x1]
	mov	x1, #1256
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x2, #0
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x0, x2
	str	w1, [x2]
	mov	x1, #0
	add	x0, x0, x1
	ldr	x0, [x0]
	b	.L577
.L557:
	mov	x1, #1084
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #0
.L559:
	cmp	w0, #3
	bge	.L562
	sxtw	x2, w0
	mov	x3, #4
	mul	x2, x2, x3
	add	x3, x2, x1
	mov	w2, #47911
	movk	w2, #0x4ff5, lsl #16
	str	w2, [x3]
	mov	w2, #1
	add	w0, w0, w2
	b	.L559
.L562:
	adrp	x1, "g_1802"
	add	x1, x1, #:lo12:"g_1802"
	mov	w0, #-8
	str	w0, [x1]
	adrp	x1, "g_1877"
	add	x1, x1, #:lo12:"g_1877"
	mov	w0, #0
	str	w0, [x1]
	mov	w0, #0
.L565:
	cmp	w0, #10
	bcs	.L576
	adrp	x1, "g_1965"
	add	x1, x1, #:lo12:"g_1965"
	mov	x0, #0
	str	x0, [x1]
	mov	x0, #0
.L568:
	cmp	x0, #9
	bge	.L575
	adrp	x1, "g_747"
	add	x1, x1, #:lo12:"g_747"
	mov	x0, #0
	str	x0, [x1]
	mov	x0, #0
.L571:
	cmp	x0, #2
	bge	.L574
	mov	x1, x0
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x2, #72
	mul	x0, x0, x2
	add	x0, x19, x0
	adrp	x2, "g_1965"
	add	x2, x2, #:lo12:"g_1965"
	ldr	x2, [x2]
	mov	x3, #8
	mul	x2, x2, x3
	add	x0, x0, x2
	mov	x2, #4
	mul	x1, x1, x2
	add	x1, x0, x1
	mov	w0, #12112
	movk	w0, #0x13fe, lsl #16
	str	w0, [x1]
	adrp	x0, "g_747"
	add	x0, x0, #:lo12:"g_747"
	ldr	x0, [x0]
	mov	x1, #1
	add	x0, x0, x1
	adrp	x1, "g_747"
	add	x1, x1, #:lo12:"g_747"
	str	x0, [x1]
	b	.L571
.L574:
	adrp	x0, "g_1965"
	add	x0, x0, #:lo12:"g_1965"
	ldr	x0, [x0]
	mov	x1, #1
	add	x0, x0, x1
	adrp	x1, "g_1965"
	add	x1, x1, #:lo12:"g_1965"
	str	x0, [x1]
	b	.L568
.L575:
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w0, [x0]
	mov	w1, #1
	add	w0, w0, w1
	adrp	x1, "g_1877"
	add	x1, x1, #:lo12:"g_1877"
	str	w0, [x1]
	b	.L565
.L576:
	mov	x1, #1096
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x1, #0
	add	x1, x20, x1
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x0, x2
	str	w1, [x2]
	mov	x1, #0
	add	x0, x0, x1
	ldr	x0, [x0]
.L577:
	ldr	x19, [x29, 1528]
	ldr	x20, [x29, 1520]
	ldr	x21, [x29, 1512]
	ldr	x22, [x29, 1504]
	ldr	x23, [x29, 1496]
	ldr	x24, [x29, 1488]
	ldr	x25, [x29, 1480]
	ldr	x26, [x29, 1472]
	ldp	x29, x30, [sp], 16
	add	sp, sp, #1520
	ret
.type "func_1", @function
.size "func_1", .-"func_1"

.data
.balign 1
".__func__.680":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 49
	.byte 0

.data
.balign 4
.ci681:
	.int 0
	.int 4194303
	.int 2005562
	.int 0
	.int 2005562
	.int 0
	.int 0
	.int 1
	.int 977326
	.int 4194302
	.int 65548
	.int 4194302
	.int 2005562
	.int 2005562
	.int 4194302
	.int 4194302
	.int 4194303
	.int 65548
	.int 4194302
	.int 2005562
	.int 977326
	.int 4194302
	.int 1
	.int 4194302
	.int 977326
	.int 65548
	.int 0
	.int 4194303
	.int 2005562
	.int 0
	.int 977326
	.int 4194303
	.int 4194303
	.int 977326
	.int 2005562

.data
.balign 2
.ci682:
	.short 1
	.short 1
	.short 1
	.short 1
	.short 1
	.short 1
	.short 1
	.short 1
	.short 1
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655
	.short 281474976710655

.data
.balign 4
.ci690:
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 79039923
	.int 4294967289
	.int 6
	.int 0
	.int 4294967295
	.int 1402662008
	.int 1402662008
	.int 4294967295
	.int 0
	.int 6
	.int 4294967289
	.int 79039923
	.int 1402662008
	.int 2465719204
	.int 79039923
	.int 0
	.int 2466025489
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 79039923
	.int 4294967289
	.int 6
	.int 0
	.int 4294967295
	.int 1402662008
	.int 1402662008
	.int 4294967295
	.int 0
	.int 6
	.int 4294967289
	.int 79039923
	.int 1402662008
	.int 2465719204
	.int 79039923
	.int 0
	.int 2466025489
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 79039923
	.int 4294967289
	.int 6
	.int 0
	.int 4294967295
	.int 1402662008
	.int 1402662008
	.int 4294967295
	.int 0
	.int 6
	.int 4294967289
	.int 79039923
	.int 1402662008
	.int 2465719204
	.int 79039923
	.int 0
	.int 2466025489
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 79039923
	.int 4294967289
	.int 6
	.int 0
	.int 4294967295
	.int 1402662008
	.int 1402662008
	.int 4294967295
	.int 0
	.int 6
	.int 4294967289
	.int 79039923
	.int 1402662008
	.int 2465719204
	.int 79039923
	.int 0
	.int 2466025489
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 79039923
	.int 4294967289
	.int 6
	.int 0
	.int 4294967295
	.int 1402662008
	.int 1402662008
	.int 4294967295
	.int 0
	.int 6
	.int 4294967289
	.int 79039923
	.int 1402662008
	.int 2465719204
	.int 79039923
	.int 0
	.int 2466025489
	.int 0
	.int 79039923
	.int 2465719204
	.int 1402662008
	.int 2466025489
	.int 4294967290
	.int 326486380
	.int 4294967295
	.int 3210634189
	.int 1220672196
	.int 1220672196
	.int 3210634189
	.int 4294967295
	.int 326486380
	.int 4294967290
	.int 2466025489
	.int 1220672196
	.int 1285914323
	.int 2466025489
	.int 4294967295
	.int 3331072254
	.int 4294967295
	.int 2466025489
	.int 1285914323
	.int 1220672196
	.int 2466025489
	.int 4294967290
	.int 326486380
	.int 4294967295
	.int 3210634189
	.int 1220672196
	.int 1220672196
	.int 3210634189
	.int 4294967295
	.int 326486380
	.int 4294967290
	.int 2466025489
	.int 1220672196
	.int 1285914323
	.int 2466025489
	.int 4294967295
	.int 3331072254
	.int 4294967295
	.int 2466025489
	.int 1285914323
	.int 1220672196
	.int 2466025489
	.int 4294967290
	.int 326486380
	.int 4294967295
	.int 3210634189
	.int 1220672196
	.int 1220672196
	.int 3210634189
	.int 4294967295
	.int 326486380
	.int 4294967290
	.int 2466025489
	.int 1220672196
	.int 1285914323
	.int 2466025489
	.int 4294967295
	.int 3331072254
	.int 4294967295
	.int 2466025489
	.int 1285914323
	.int 1220672196
	.int 2466025489
	.int 4294967290
	.int 326486380
	.int 4294967295
	.int 3210634189
	.int 1220672196
	.int 1220672196
	.int 3210634189

.text
.balign 16
"func_3":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [x29, 24]
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	ldr	x2, [x1]
	adrp	x1, "g_1219"+24
	add	x1, x1, #:lo12:"g_1219"+24
	str	x1, [x2]
	adrp	x1, "g_121"
	add	x1, x1, #:lo12:"g_121"
	ldr	x1, [x1]
	adrp	x2, "g_1219"
	add	x2, x2, #:lo12:"g_1219"
	cmp	x1, x2
	cset	w2, cs
	cmp	w2, #0
	bne	.L580
	mov	w1, w2
	b	.L581
.L580:
	adrp	x2, "g_1219"+32
	add	x2, x2, #:lo12:"g_1219"+32
	cmp	x1, x2
	cset	w1, ls
.L581:
	cmp	w1, #0
	bne	.L583
	adrp	x3, ".__func__.811"
	add	x3, x3, #:lo12:".__func__.811"
	mov	w2, #268
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x19, x0
	adrp	x0, ".ts.794"
	add	x0, x0, #:lo12:".ts.794"
	bl	"__assert_fail"
	mov	x0, x19
.L583:
	sxtb	w0, w0
	ldr	x19, [x29, 24]
	ldp	x29, x30, [sp], 32
	ret
.type "func_3", @function
.size "func_3", .-"func_3"

.data
.balign 1
".__func__.811":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 51
	.byte 0

.text
.balign 16
"func_8":
	hint	#34
	mov	x16, #17872
	sub	sp, sp, x16
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	str	x19, [x29, 17880]
	str	x20, [x29, 17872]
	str	x21, [x29, 17864]
	str	x22, [x29, 17856]
	str	x23, [x29, 17848]
	str	x24, [x29, 17840]
	str	x25, [x29, 17832]
	str	x26, [x29, 17824]
	str	x27, [x29, 17816]
	str	x28, [x29, 17808]
	mov	x17, x4
	mov	x4, x0
	mov	x0, x17
	mov	x17, x3
	mov	x3, x4
	mov	x4, x17
	mov	x17, x1
	mov	x1, x3
	mov	x3, x17
	mov	x17, #17204
	add	x17, x29, x17
	str	w0, [x17]
	mov	x17, #17516
	add	x17, x29, x17
	str	w2, [x17]
	mov	x6, #0
	add	x5, x29, #72
	add	x5, x5, x6
	str	x4, [x5]
	mov	x5, #0
	add	x4, x29, #64
	add	x4, x4, x5
	str	x3, [x4]
	mov	x4, #7676
	add	x3, x29, #80
	add	x24, x3, x4
	str	x24, [x29, 17128]
	str	w1, [x24]
	mov	x3, #6756
	add	x1, x29, #80
	add	x19, x1, x3
	str	x19, [x29, 17656]
	mov	x3, #0
	add	x1, x29, #64
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	x3, #0
	add	x3, x19, x3
	str	w1, [x3]
	mov	x3, #7660
	add	x1, x29, #80
	add	x20, x1, x3
	str	x20, [x29, 17400]
	mov	x3, #0
	add	x1, x29, #72
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	x3, #0
	add	x3, x20, x3
	str	w1, [x3]
	mov	w22, w2
	mov	x2, #1920
	mov	w1, #0
	mov	w21, w0
	add	x0, x29, #80
	bl	memset
	mov	w2, w22
	mov	w0, w21
	add	x3, x29, #80
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #16
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #32
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #48
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #56
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #64
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #72
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #80
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #88
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #96
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #104
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #120
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #152
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #168
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #176
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #184
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #200
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #208
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #240
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #248
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #256
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #272
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #280
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #288
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #296
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #304
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #312
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #328
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #336
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #344
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #352
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #360
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #368
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #376
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #392
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #400
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #408
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #424
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #440
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #456
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #464
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #472
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #480
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #488
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #496
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #504
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #512
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #528
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #560
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #576
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #584
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #592
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #608
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #616
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #648
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #656
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #664
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #680
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #688
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #696
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #704
	add	x1, x29, #80
	add	x13, x1, x3
	str	x13, [x29, 17288]
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x13]
	mov	x3, #712
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #720
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #736
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #744
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #752
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #760
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #768
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #776
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #784
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #800
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #808
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #816
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #824
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #832
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #840
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #848
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #856
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #864
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #872
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #888
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #896
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #912
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #920
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #936
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #944
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #960
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #968
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #984
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #992
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1016
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1048
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1056
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1064
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1072
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1080
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1088
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1096
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1104
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1112
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1120
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1128
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1144
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1152
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1160
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1168
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1176
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1184
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1192
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1200
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1208
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1216
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1224
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1232
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1240
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1248
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1256
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1264
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1272
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1280
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1296
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1304
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1320
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1328
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1344
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1352
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1368
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1376
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1392
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1400
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1424
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1456
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1464
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1472
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1480
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1488
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1496
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1504
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1512
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1520
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1528
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1536
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1552
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1560
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1568
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1576
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1584
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1592
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1600
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1608
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1616
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1624
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1632
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1640
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1648
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1656
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1664
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1672
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1680
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1688
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1704
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1712
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1728
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1736
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1752
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1760
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1776
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1784
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1800
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1808
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1832
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #1864
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1872
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1880
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #1888
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1896
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1904
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1912
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1920
	add	x1, x29, #80
	add	x21, x1, x3
	mov	w23, w2
	mov	x2, #1920
	mov	w1, #0
	mov	w22, w0
	mov	x0, x21
	bl	memset
	mov	w2, w23
	mov	w0, w22
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x21]
	mov	x3, #1928
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #1936
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1944
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1960
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1968
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #1976
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #1984
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #1992
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2000
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2008
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2024
	add	x1, x29, #80
	add	x16, x1, x3
	str	x16, [x29, 17312]
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x16]
	mov	x3, #2032
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2040
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2048
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2056
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2072
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2080
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2088
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2096
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2104
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2112
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2120
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2128
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2144
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2152
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2160
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2176
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2184
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2192
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2200
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2208
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2216
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2232
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2240
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2248
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2256
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2264
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2272
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2280
	add	x1, x29, #80
	add	x12, x1, x3
	str	x12, [x29, 17376]
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x12]
	mov	x3, #2288
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2296
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2304
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2312
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2320
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2328
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2336
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2344
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2360
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2368
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2384
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2392
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2408
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2416
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2424
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2432
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2440
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2448
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2456
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2464
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2472
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2480
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2488
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2496
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2504
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2512
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2520
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2528
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2536
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2544
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2552
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2560
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2568
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2576
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2584
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2592
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2600
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2608
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2616
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2624
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2632
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2640
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2648
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2656
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2664
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2680
	add	x1, x29, #80
	add	x14, x1, x3
	str	x14, [x29, 17296]
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x14]
	mov	x3, #2696
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2704
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2712
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2728
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2736
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2744
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2752
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2760
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2768
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2776
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2784
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2792
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2800
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2808
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2816
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2824
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2832
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2840
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2848
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2856
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2864
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #2872
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2880
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2888
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2896
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2904
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #2912
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2920
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2928
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2936
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2944
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2952
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #2960
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2968
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #2976
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #2984
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #2992
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3008
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3016
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3024
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3032
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3040
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3048
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3056
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3064
	add	x1, x29, #80
	add	x15, x1, x3
	str	x15, [x29, 17304]
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x15]
	mov	x3, #3072
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3080
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #3088
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3096
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3104
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3112
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3120
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3128
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3136
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3144
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3152
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3160
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3176
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3184
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3192
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3200
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3208
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3216
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3224
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3232
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3240
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3248
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #3256
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3264
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3272
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3280
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3288
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3296
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3304
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3312
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3328
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3336
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3344
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #3352
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3360
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3368
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3376
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3384
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3392
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3400
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3408
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3416
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3432
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #3440
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3448
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3456
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3464
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3472
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3480
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3488
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3496
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3504
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3512
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3520
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3536
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3544
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3552
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3560
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3568
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3576
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3584
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3592
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3600
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3608
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3616
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3624
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3632
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3648
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3656
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3664
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3672
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3680
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3688
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3696
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x1, [x3]
	mov	x3, #3704
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x1, [x3]
	mov	x3, #3712
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3720
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3728
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3736
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3744
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3752
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3760
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3768
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3776
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3784
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3792
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3800
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x1, [x3]
	mov	x3, #3808
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3816
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	str	x1, [x3]
	mov	x3, #3824
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	str	x1, [x3]
	mov	x3, #3832
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x1, [x3]
	mov	x3, #3840
	add	x1, x29, #80
	add	x3, x1, x3
	mov	w1, #15221
	movk	w1, #0x78ec, lsl #16
	str	w1, [x3]
	mov	x3, #3848
	add	x1, x29, #80
	add	x25, x1, x3
	str	x25, [x29, 17248]
	adrp	x1, "g_985"+512
	add	x1, x1, #:lo12:"g_985"+512
	str	x1, [x25]
	mov	x3, #3856
	add	x1, x29, #80
	add	x21, x1, x3
	mov	w23, w2
	mov	x2, #96
	mov	w1, #0
	mov	w22, w0
	mov	x0, x21
	bl	memset
	mov	w2, w23
	mov	w0, w22
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x21]
	mov	x3, #3864
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3872
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3880
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3888
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3896
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3904
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3912
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3920
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3928
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3936
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3944
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	str	x1, [x3]
	mov	x3, #3952
	add	x1, x29, #80
	mov	x26, x20
	add	x20, x1, x3
	str	x20, [x29, 16928]
	mov	w22, w2
	mov	x2, #336
	adrp	x1, .ci821
	add	x1, x1, #:lo12:.ci821
	mov	w21, w0
	mov	x0, x20
	bl	memcpy
	mov	w2, w22
	mov	w0, w21
	mov	x3, #4288
	add	x1, x29, #80
	add	x3, x1, x3
	mov	w1, #11610
	movk	w1, #0x8b04, lsl #16
	str	w1, [x3]
	mov	x3, #4688
	add	x1, x29, #80
	add	x3, x1, x3
	str	x3, [x29, 17496]
	mov	w1, #92
	strb	w1, [x3]
	mov	x3, #4696
	add	x1, x29, #80
	add	x23, x1, x3
	str	x23, [x29, 17392]
	adrp	x1, "g_476"
	add	x1, x1, #:lo12:"g_476"
	str	x1, [x23]
	mov	x3, #4704
	add	x1, x29, #80
	add	x3, x1, x3
	str	x3, [x29, 17792]
	mov	w22, w2
	mov	x2, #4
	mov	w1, #0
	mov	w21, w0
	mov	x0, x3
	bl	memset
	mov	w2, w22
	mov	w0, w21
	ldr	x3, [x29, 17792]
	ldr	w1, [x3]
	mov	w4, #-4194304
	and	w1, w1, w4
	mov	w4, #19031
	movk	w4, #0x19, lsl #16
	orr	w1, w1, w4
	str	w1, [x3]
	mov	x1, #4708
	mov	w21, w0
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w22, w2
	mov	x2, #42
	adrp	x1, .ci822
	add	x1, x1, #:lo12:.ci822
	bl	memcpy
	mov	w2, w22
	mov	w0, w21
	mov	x1, #4750
	mov	w21, w0
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w22, w2
	mov	x2, #50
	adrp	x1, .ci823
	add	x1, x1, #:lo12:.ci823
	bl	memcpy
	mov	w2, w22
	mov	w0, w21
	mov	x3, #4800
	add	x1, x29, #80
	add	x1, x1, x3
	str	x1, [x29, 17776]
	mov	w3, #38958
	movk	w3, #0x4443, lsl #16
	str	w3, [x1]
	mov	x3, #4808
	add	x1, x29, #80
	add	x4, x1, x3
	str	x4, [x29, 17784]
	mov	w22, w2
	mov	x2, #160
	mov	w1, #0
	mov	w21, w0
	mov	x0, x4
	bl	memset
	mov	w2, w22
	mov	w0, w21
	ldr	x4, [x29, 17784]
	ldr	x1, [x29, 17776]
	adrp	x3, "g_1802"
	add	x3, x3, #:lo12:"g_1802"
	str	x3, [x4]
	mov	x4, #4824
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4832
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4848
	add	x3, x29, #80
	add	x4, x3, x4
	adrp	x3, "g_1802"
	add	x3, x3, #:lo12:"g_1802"
	str	x3, [x4]
	mov	x4, #4864
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4872
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4888
	add	x3, x29, #80
	add	x4, x3, x4
	adrp	x3, "g_1802"
	add	x3, x3, #:lo12:"g_1802"
	str	x3, [x4]
	mov	x4, #4904
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4912
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4928
	add	x3, x29, #80
	add	x4, x3, x4
	adrp	x3, "g_1802"
	add	x3, x3, #:lo12:"g_1802"
	str	x3, [x4]
	mov	x4, #4944
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x4, #4952
	add	x3, x29, #80
	add	x3, x3, x4
	str	x1, [x3]
	mov	x1, #4968
	mov	w21, w0
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w22, w2
	mov	x2, #96
	adrp	x1, .ci824
	add	x1, x1, #:lo12:.ci824
	bl	memcpy
	mov	x11, x25
	mov	w2, w22
	mov	w0, w21
	ldr	x3, [x29, 17496]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	adrp	x1, "g_1713"+24
	add	x1, x1, #:lo12:"g_1713"+24
	cmp	x1, #0
	cset	w10, ne
	mov	x17, #17336
	add	x17, x29, x17
	str	w10, [x17]
	adrp	x1, "g_647"
	add	x1, x1, #:lo12:"g_647"
	cmp	x1, #0
	cset	w9, ne
	mov	x17, #17576
	add	x17, x29, x17
	str	w9, [x17]
	adrp	x1, "g_895"
	add	x1, x1, #:lo12:"g_895"
	cmp	x1, #0
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	cmp	x1, #0
	cset	w28, eq
	mov	x17, #17744
	add	x17, x29, x17
	str	w28, [x17]
	mov	x4, #4296
	add	x1, x29, #80
	add	x25, x1, x4
	str	x25, [x29, 17544]
	adrp	x1, "g_896"
	add	x1, x1, #:lo12:"g_896"
	cmp	x1, #0
	cset	w1, ne
	mov	x17, #17384
	add	x17, x29, x17
	str	w1, [x17]
	adrp	x5, "g_985"+512
	add	x5, x5, #:lo12:"g_985"+512
	adrp	x4, "g_985"+16
	add	x4, x4, #:lo12:"g_985"+16
	cmp	x4, x5
	cset	w4, eq
	mov	x17, #17240
	add	x17, x29, x17
	str	w4, [x17]
	adrp	x5, "g_1877"
	add	x5, x5, #:lo12:"g_1877"
	cmp	x5, #0
	cset	w21, ne
	mov	x17, #17340
	add	x17, x29, x17
	str	w21, [x17]
	adrp	x6, "g_1713"+24
	add	x6, x6, #:lo12:"g_1713"+24
	adrp	x5, "g_1713"+4
	add	x5, x5, #:lo12:"g_1713"+4
	cmp	x5, x6
	cset	w7, eq
	mov	x17, #17352
	add	x17, x29, x17
	str	w7, [x17]
	mov	x8, x19
	mov	w27, w4
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w22, w28
	mov	w4, w0
	mov	w0, #0
.L587:
	cmp	w0, #9
	bge	.L590
	sxtw	x5, w0
	mov	x6, #8
	mul	x5, x5, x6
	add	x6, x5, x24
	adrp	x5, "g_1525"
	add	x5, x5, #:lo12:"g_1525"
	str	x5, [x6]
	mov	w5, #1
	add	w0, w0, w5
	b	.L587
.L590:
	mov	x19, x8
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x26
	mov	x26, x17
	mov	w28, w22
	mov	w0, w4
	mov	w4, w27
	mov	x6, #4368
	add	x5, x29, #80
	add	x27, x5, x6
	str	x27, [x29, 17136]
	mov	x8, x19
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w22, w28
	mov	x17, x27
	mov	x27, x0
	mov	x0, x17
	mov	x17, x4
	mov	x4, x27
	mov	x27, x17
	mov	w6, #0
.L593:
	cmp	w6, #4
	bge	.L601
	sxtw	x5, w6
	mov	x19, #80
	mul	x5, x5, x19
	add	x5, x0, x5
	mov	w19, w1
	mov	x1, x3
	mov	w3, #0
.L596:
	cmp	w3, #10
	bge	.L599
	sxtw	x28, w3
	mov	x30, #8
	mul	x28, x28, x30
	add	x30, x5, x28
	mov	x28, #0
	str	x28, [x30]
	mov	w28, #1
	add	w3, w3, w28
	b	.L596
.L599:
	mov	x3, x1
	mov	w1, w19
	mov	w5, #1
	add	w6, w6, w5
	b	.L593
.L601:
	mov	x19, x8
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x26
	mov	x26, x17
	mov	w28, w22
	mov	x17, x27
	mov	x27, x4
	mov	x4, x17
	mov	x17, x0
	mov	x0, x27
	mov	x27, x17
	mov	x6, #5064
	add	x5, x29, #80
	add	x6, x5, x6
	mov	x8, x19
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w22, w28
	mov	x17, x27
	mov	x27, x0
	mov	x0, x17
	mov	x17, x4
	mov	x4, x27
	mov	x27, x17
	mov	w5, #0
.L604:
	cmp	w5, #5
	bge	.L607
	sxtw	x19, w5
	mov	x28, #8
	mul	x19, x19, x28
	add	x28, x6, x19
	adrp	x19, "g_941"
	add	x19, x19, #:lo12:"g_941"
	str	x19, [x28]
	mov	w19, #1
	add	w5, w5, w19
	b	.L604
.L607:
	mov	x19, x8
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x26
	mov	x26, x17
	mov	w28, w22
	mov	x17, x27
	mov	x27, x4
	mov	x4, x17
	mov	x17, x0
	mov	x0, x27
	mov	x27, x17
	mov	x6, #5104
	add	x5, x29, #80
	add	x7, x5, x6
	mov	x8, x19
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w22, w28
	mov	x17, x27
	mov	x27, x0
	mov	x0, x17
	mov	x17, x4
	mov	x4, x27
	mov	x27, x17
	mov	w6, #0
.L610:
	cmp	w6, #2
	bge	.L618
	sxtw	x5, w6
	mov	x19, #10
	mul	x5, x5, x19
	add	x5, x7, x5
	mov	w19, w1
	mov	x1, x3
	mov	w3, #0
.L613:
	cmp	w3, #10
	bge	.L616
	sxtw	x28, w3
	add	x30, x5, x28
	mov	w28, #56
	strb	w28, [x30]
	mov	w28, #1
	add	w3, w3, w28
	b	.L613
.L616:
	mov	x3, x1
	mov	w1, w19
	mov	w5, #1
	add	w6, w6, w5
	b	.L610
.L618:
	mov	x26, x25
	mov	x19, x8
	mov	x25, x24
	mov	x24, x21
	mov	x1, #5128
	add	x0, x29, #80
	add	x22, x0, x1
	mov	w21, w2
	mov	x2, #56
	mov	w1, #0
	mov	x0, x22
	bl	memset
	mov	w2, w21
	mov	x1, #5136
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	str	x0, [x1]
	mov	x1, #5144
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	str	x0, [x1]
	mov	x1, #5160
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	str	x0, [x1]
	mov	x1, #5168
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	str	x0, [x1]
	mov	x1, #5184
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #42146
	movk	w0, #0xd999, lsl #16
	str	w0, [x1]
	mov	x1, #5192
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w21, w2
	mov	x2, #1536
	mov	w1, #0
	bl	memset
	mov	w2, w21
	mov	x17, #17352
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x17, #17340
	add	x17, x29, x17
	ldr	w21, [x17]
	mov	x17, #17240
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x17, #17384
	add	x17, x29, x17
	ldr	w1, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #17744
	add	x17, x29, x17
	ldr	w28, [x17]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x27, [x29, 17136]
	ldr	x3, [x29, 17496]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	mov	w4, w0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x6, #5200
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5208
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5216
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5224
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #5232
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #5240
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5264
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5272
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5296
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5304
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #5312
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5320
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5328
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5336
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5352
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5368
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #5376
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5384
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5392
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5400
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #5408
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5416
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5432
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5440
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5464
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5472
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #5480
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5488
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5496
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5504
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5512
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5520
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5536
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5544
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5552
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5560
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #5568
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #5576
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5600
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5608
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5632
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5640
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #5648
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5656
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5664
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5672
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5688
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5704
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #5712
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5720
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5728
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5736
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #5744
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5752
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5768
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5776
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5800
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5808
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #5816
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5824
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #5832
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5840
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5848
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5856
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5872
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5880
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5888
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5896
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #5904
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #5912
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5936
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5944
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #5968
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #5976
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #5984
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #5992
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6000
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6008
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6024
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6040
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #6048
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6056
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6064
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6072
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #6080
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6088
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6104
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6112
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6136
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6144
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #6152
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6160
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6168
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6176
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6184
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6192
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6208
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6216
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6224
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6232
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #6240
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #6248
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #6272
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6280
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6304
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #6312
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #6320
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6328
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6336
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6344
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6360
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6376
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #6384
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6392
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6400
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6408
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #6416
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6424
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6440
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6448
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6472
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6480
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+264
	add	x5, x5, #:lo12:"g_1223"+264
	str	x5, [x6]
	mov	x6, #6488
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6496
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6504
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6512
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6520
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+104
	add	x5, x5, #:lo12:"g_1223"+104
	str	x5, [x6]
	mov	x6, #6536
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6544
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #6552
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #6568
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6584
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #6592
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6600
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+144
	add	x5, x5, #:lo12:"g_1223"+144
	str	x5, [x6]
	mov	x6, #6616
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+160
	add	x5, x5, #:lo12:"g_1223"+160
	str	x5, [x6]
	mov	x6, #6624
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6632
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6640
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+304
	add	x5, x5, #:lo12:"g_1223"+304
	str	x5, [x6]
	mov	x6, #6656
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6664
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+160
	add	x5, x5, #:lo12:"g_1223"+160
	str	x5, [x6]
	mov	x6, #6672
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6680
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+96
	add	x5, x5, #:lo12:"g_1223"+96
	str	x5, [x6]
	mov	x6, #6688
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6696
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+8
	add	x5, x5, #:lo12:"g_1223"+8
	str	x5, [x6]
	mov	x6, #6704
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+136
	add	x5, x5, #:lo12:"g_1223"+136
	str	x5, [x6]
	mov	x6, #6712
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6720
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_1223"+48
	add	x5, x5, #:lo12:"g_1223"+48
	str	x5, [x6]
	mov	x6, #6728
	add	x5, x29, #80
	add	x6, x5, x6
	mov	x8, x19
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	x19, x22
	mov	x17, x27
	mov	x27, x0
	mov	x0, x17
	mov	x17, x4
	mov	x4, x27
	mov	x27, x17
	mov	w5, #0
.L621:
	mov	w22, w28
	cmp	w5, #7
	bge	.L625
	sxtw	x28, w5
	mov	x30, #4
	mul	x28, x28, x30
	add	x30, x6, x28
	mov	w28, w22
	mov	w22, #34302
	movk	w22, #0xc751, lsl #16
	str	w22, [x30]
	mov	x22, x8
	mov	w8, #1
	add	w5, w5, w8
	mov	x8, x22
	b	.L621
.L625:
	mov	x26, x25
	mov	x25, x24
	mov	x24, x21
	mov	x22, x19
	mov	x19, x8
	mov	w0, w4
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxth	w2, w1
	mov	x17, #17768
	add	x17, x29, x17
	str	w2, [x17]
	adrp	x1, "g_117"
	add	x1, x1, #:lo12:"g_117"
	strh	w2, [x1]
	mov	x2, #5184
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	cmn	w1, #3
	cset	w1, ls
	mov	x17, #17772
	add	x17, x29, x17
	str	w1, [x17]
	mov	x2, #1304
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	x1, [x1]
	mov	x3, #1096
	add	x2, x29, #80
	add	x2, x2, x3
	str	x1, [x2]
	mov	x3, #2680
	add	x2, x29, #80
	add	x2, x2, x3
	ldr	x2, [x2]
	cmp	x1, x2
	cset	w1, eq
	adrp	x2, "g_92"+2
	add	x2, x2, #:lo12:"g_92"+2
	ldrh	w2, [x2]
	mov	w3, #-1
	eor	w2, w2, w3
	and	w1, w1, w2
	sxtw	x1, w1
	mov	x2, #183
	and	x1, x1, x2
	sxtb	w1, w1
	mov	w21, w0
	mov	w0, #1
	bl	"safe_div_func_uint8_t_u_u"
	mov	w2, w0
	mov	w0, w21
	mov	x17, #17772
	add	x17, x29, x17
	ldr	w1, [x17]
	uxtb	w2, w2
	cmp	w1, w2
	mov	w21, w0
	cset	w0, lt
	uxtb	w27, w21
	mov	x17, #16960
	add	x17, x29, x17
	str	w27, [x17]
	mov	w1, w27
	bl	"safe_sub_func_int16_t_s_s"
	mov	x17, #17768
	add	x17, x29, x17
	ldr	w0, [x17]
	adrp	x1, "g_313"
	add	x1, x1, #:lo12:"g_313"
	ldrh	w1, [x1]
	mov	w2, #0
	and	w1, w1, w2
	adrp	x2, "g_313"
	add	x2, x2, #:lo12:"g_313"
	strh	w1, [x2]
	bl	"safe_lshift_func_int16_t_s_u"
	mov	x8, x19
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #-2
	eor	w0, w0, w1
	mov	x2, #3840
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #5184
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x2, #4072
	add	x1, x29, #80
	add	x28, x1, x2
	str	x28, [x29, 16968]
	mov	x2, #4132
	add	x1, x29, #80
	mov	x21, x8
	add	x8, x1, x2
	str	x8, [x29, 17536]
	cmp	w27, #0
	cset	w7, ne
	mov	x17, #17272
	add	x17, x29, x17
	str	w7, [x17]
	mov	x2, #4472
	add	x1, x29, #80
	add	x19, x1, x2
	str	x19, [x29, 17120]
	mov	x2, #4284
	add	x1, x29, #80
	add	x1, x1, x2
	str	x1, [x29, 16976]
	cmp	w0, #0
	bne	.L717
	mov	x21, x26
	mov	x1, #9816
	add	x0, x29, #80
	add	x3, x0, x1
	str	x3, [x29, 17760]
	mov	x2, #64
	mov	w1, #0
	mov	x0, x3
	bl	memset
	ldr	x3, [x29, 17760]
	adrp	x0, "g_1223"+256
	add	x0, x0, #:lo12:"g_1223"+256
	str	x0, [x3]
	mov	x1, #9824
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+280
	add	x0, x0, #:lo12:"g_1223"+280
	str	x0, [x1]
	mov	x1, #9832
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+256
	add	x0, x0, #:lo12:"g_1223"+256
	str	x0, [x1]
	mov	x1, #9840
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+256
	add	x0, x0, #:lo12:"g_1223"+256
	str	x0, [x1]
	mov	x1, #9848
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+280
	add	x0, x0, #:lo12:"g_1223"+280
	str	x0, [x1]
	mov	x1, #9856
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+256
	add	x0, x0, #:lo12:"g_1223"+256
	str	x0, [x1]
	mov	x1, #9864
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+256
	add	x0, x0, #:lo12:"g_1223"+256
	str	x0, [x1]
	mov	x1, #9872
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1223"+280
	add	x0, x0, #:lo12:"g_1223"+280
	str	x0, [x1]
	mov	x1, #9880
	add	x0, x29, #80
	add	x3, x0, x1
	str	x3, [x29, 17752]
	mov	x2, #2016
	mov	w1, #0
	mov	x0, x3
	bl	memset
	ldr	x3, [x29, 17752]
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x3]
	mov	x1, #9888
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9896
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9904
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9912
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9920
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9936
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9944
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9960
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9968
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9976
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9984
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #9992
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10000
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10008
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10016
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10024
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10032
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10040
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10056
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10064
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10072
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10080
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10088
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10096
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10104
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10120
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10128
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10136
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10144
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10152
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10160
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10168
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10176
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10200
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10208
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10224
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10232
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10248
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10256
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10272
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10288
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10304
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10312
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10320
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10328
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10336
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10344
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10352
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10360
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10376
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10384
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10392
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10400
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10408
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10416
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10424
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10432
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10440
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10448
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10456
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10464
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10472
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10480
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10488
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10504
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10512
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10536
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10560
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10568
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10576
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10584
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10592
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10600
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10608
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10616
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10624
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10632
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10640
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10648
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10664
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10680
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10688
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10696
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10704
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10720
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10728
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10736
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10752
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10760
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10768
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10776
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10784
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10792
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10800
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10808
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10816
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10824
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10840
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10848
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10856
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10872
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10880
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10888
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10896
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10904
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10912
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10920
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10928
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10936
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10944
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10952
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10960
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #10992
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11008
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11016
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11024
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11032
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11064
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11072
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11088
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11096
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11104
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11112
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11120
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11128
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11136
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11144
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11152
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11160
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11176
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11184
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11192
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11200
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11208
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11216
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11224
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11232
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11240
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11256
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11264
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11272
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11280
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11288
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11296
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11304
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11320
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11328
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11336
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11344
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11352
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11360
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11368
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11376
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11384
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11392
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11400
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11408
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11424
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11432
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11440
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11448
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11456
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11464
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11472
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11480
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11488
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11496
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11504
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11512
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11520
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11536
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11544
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11552
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11568
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11576
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11584
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11600
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11616
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11624
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11632
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11640
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11648
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11656
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11680
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11688
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11696
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11712
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11736
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11744
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11752
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11760
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11768
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11776
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11792
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11800
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11816
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11824
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11832
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11840
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11848
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11856
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11872
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11880
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x1, #11888
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	str	x0, [x1]
	mov	x17, x21
	mov	x21, x25
	mov	x25, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w2, #0
.L630:
	mov	x17, #17748
	add	x17, x29, x17
	str	w2, [x17]
	cmp	w2, #19
	bne	.L646
	adrp	x1, "g_119"
	add	x1, x1, #:lo12:"g_119"
	mov	w0, #6
	strb	w0, [x1]
	mov	w0, #6
.L633:
	sxtb	w0, w0
	cmp	w0, #1
	blt	.L642
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x0, [x1]
	cmp	x0, #0
	beq	.L640
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w0, #0
	cset	w1, ne
	cmp	w1, #0
	beq	.L637
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	sxtb	x0, w0
	mov	x1, #8
	mul	x0, x0, x1
	add	x0, x22, x0
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, ne
	mov	w0, #1
	bl	"safe_add_func_int32_t_s_s"
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxtw	x0, w0
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	ldr	x1, [x1]
	mov	x2, #1
	add	x1, x1, x2
	adrp	x2, "g_35"
	add	x2, x2, #:lo12:"g_35"
	str	x1, [x2]
	cmp	x1, #0
	cset	w1, ne
	sxtw	x1, w1
	bl	"safe_add_func_int64_t_s_s"
	cmp	x0, #0
	cset	w1, ne
.L637:
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	w0, [x0]
	eor	w0, w0, w1
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L639
	mov	w0, #1
.L639:
	sxtw	x0, w0
	mov	x1, #48939
	movk	x1, #0x223c, lsl #16
	movk	x1, #0xf45d, lsl #32
	movk	x1, #0x391a, lsl #48
	and	x0, x0, x1
	cmp	x0, #1
.L640:
	adrp	x1, "g_187"
	add	x1, x1, #:lo12:"g_187"
	mov	w0, #64976
	movk	w0, #0x2a68, lsl #16
	str	w0, [x1]
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	mov	w1, #-1
	eor	w0, w0, w1
	mov	w1, #16665
	movk	w1, #0x5281, lsl #16
	bl	"safe_mod_func_uint32_t_u_u"
	adrp	x1, "g_187"
	add	x1, x1, #:lo12:"g_187"
	str	w0, [x1]
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	mov	w1, #1
	sub	w0, w0, w1
	sxtb	w0, w0
	adrp	x1, "g_119"
	add	x1, x1, #:lo12:"g_119"
	strb	w0, [x1]
	b	.L633
.L642:
	mov	x17, #17748
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	w1, #5
	mov	w0, w2
	bl	"safe_add_func_uint16_t_u_u"
	uxth	w2, w0
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	b	.L630
.L646:
	mov	x17, #17748
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x25
	mov	x25, x21
	mov	x21, x17
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17744
	add	x17, x29, x17
	ldr	w22, [x17]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x8, [x29, 17536]
	ldr	x28, [x29, 16968]
	ldr	x26, [x29, 17136]
	ldr	x3, [x29, 17496]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x5, #11896
	add	x4, x29, #80
	add	x5, x4, x5
	mov	x17, x21
	mov	x21, x25
	mov	x25, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w4, w0
	mov	x0, x26
	mov	w6, #0
.L649:
	cmp	w6, #17
	bgt	.L659
	mov	x9, x3
	mov	w3, #0
.L651:
	cmp	w3, #2
	bge	.L654
	sxtw	x26, w3
	mov	x30, #8
	mul	x26, x26, x30
	add	x30, x5, x26
	adrp	x26, "g_1222"+336
	add	x26, x26, #:lo12:"g_1222"+336
	str	x26, [x30]
	mov	w26, #1
	add	w3, w3, w26
	b	.L651
.L654:
	mov	x3, x9
	mov	x26, #9864
	add	x9, x29, #80
	add	x9, x9, x26
	ldr	x9, [x9]
	mov	x30, #5960
	add	x26, x29, #80
	add	x26, x26, x30
	str	x9, [x26]
	cmp	w27, #0
	bne	.L658
	mov	x26, #7660
	add	x9, x29, #80
	add	x9, x9, x26
	ldr	w9, [x9]
	mov	w26, #10
	lsl	w9, w9, w26
	mov	w26, #10
	asr	w9, w9, w26
	cmp	w9, #0
	mov	w9, #1
	add	w6, w6, w9
	b	.L649
.L658:
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x25
	mov	x25, x21
	mov	x21, x17
	b	.L660
.L659:
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x25
	mov	x25, x21
	mov	x21, x17
.L660:
	mov	x3, #6756
	add	x0, x29, #80
	add	x0, x0, x3
	ldr	w0, [x0]
	mov	w3, #10
	lsl	w0, w0, w3
	mov	w3, #10
	asr	w0, w0, w3
	adrp	x3, "g_413"+16
	add	x3, x3, #:lo12:"g_413"+16
	ldr	w3, [x3]
	cmp	w0, w3
	beq	.L705
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	cmp	x0, #0
	bne	.L668
	adrp	x0, "g_1326"+28
	add	x0, x0, #:lo12:"g_1326"+28
	ldr	w1, [x0]
	mov	x17, #17724
	add	x17, x29, x17
	str	w1, [x17]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x2, #4288
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	cmp	w1, #0
	cset	w2, ne
	cmp	w2, #0
	beq	.L664
	mov	w2, #1
.L664:
	mov	x17, #17716
	add	x17, x29, x17
	str	w2, [x17]
	cmp	w0, w2
	cset	w0, ne
	mov	x17, #17736
	add	x17, x29, x17
	str	w0, [x17]
	mov	x1, #10984
	add	x0, x29, #80
	add	x1, x0, x1
	ldr	x0, [x1]
	str	x0, [x1]
	adrp	x1, "g_1522"
	add	x1, x1, #:lo12:"g_1522"
	cmp	x0, x1
	cset	w2, eq
	mov	x17, #17740
	add	x17, x29, x17
	str	w2, [x17]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	x1, #28354
	cmp	x0, x1
	cset	w0, ge
	sxtw	x0, w0
	mov	x1, #47589
	movk	x1, #0x897d, lsl #16
	movk	x1, #0xa5d7, lsl #32
	movk	x1, #0x40e0, lsl #48
	cmp	x0, x1
	cset	w0, ge
	adrp	x1, "g_313"
	add	x1, x1, #:lo12:"g_313"
	ldrh	w1, [x1]
	and	w0, w0, w1
	adrp	x1, "g_313"
	add	x1, x1, #:lo12:"g_313"
	strh	w0, [x1]
	mov	w1, #11
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	w3, w0
	mov	x17, #17740
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17736
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x17, #17724
	add	x17, x29, x17
	ldr	w1, [x17]
	uxth	w3, w3
	cmp	w2, w3
	cset	w2, ne
	cmp	w0, w2
	cset	w0, gt
	mov	w1, w1
	cmp	x1, #0
	cset	w1, ne
	cmp	w0, w1
	cset	w0, ne
	mov	w1, #0
	and	w22, w0, w1
	mov	x17, #17720
	add	x17, x29, x17
	str	w22, [x17]
	sxtw	x0, w22
	mov	x1, #251
	orr	x0, x0, x1
	cmp	x0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L666
	mov	w0, #1
.L666:
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	adrp	x2, "g_120"
	add	x2, x2, #:lo12:"g_120"
	ldr	x2, [x2]
	ldr	x2, [x2]
	mov	x4, #6756
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	mov	w4, #10
	lsl	w3, w3, w4
	mov	w4, #10
	asr	w3, w3, w4
	adrp	x4, "g_895"
	add	x4, x4, #:lo12:"g_895"
	ldr	x4, [x4]
	ldr	x4, [x4]
	ldr	w4, [x4]
	bl	"func_47"
	mov	x8, x0
	mov	x17, #17716
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17720
	add	x17, x29, x17
	ldr	w22, [x17]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	str	x8, [x29, 17728]
	cmp	x8, #0
	beq	.L682
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #530
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1032"
	add	x0, x0, #:lo12:".ts.1032"
	bl	"__assert_fail"
	mov	x17, #17716
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x1, [x29, 16976]
	ldr	x8, [x29, 17728]
	mov	x17, #17720
	add	x17, x29, x17
	ldr	w22, [x17]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	b	.L682
.L668:
	mov	x1, #11912
	add	x0, x29, #80
	add	x1, x0, x1
	mov	x0, #0
	str	x0, [x1]
	mov	x0, #0
	str	x0, [x1]
	cmp	w2, #0
	cset	w23, ne
	mov	x21, x24
	mov	w20, #2
.L670:
	cmp	w20, #8
	bgt	.L679
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	ldr	x24, [x0]
	mov	x1, #4072
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtb	w0, w0
	mov	w25, w2
	mov	x2, #5184
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_mod_func_int8_t_s_s"
	mov	w2, w25
	sxtb	w0, w0
	cmp	w0, #0
	beq	.L677
	cmp	w2, #0
	bne	.L674
	mov	w25, w23
	b	.L676
.L674:
	sxtw	x0, w20
	mov	x1, #6
	eor	x0, x0, x1
	sxtb	w0, w0
	mov	w26, w0
	sxth	w0, w20
	mov	x3, #7676
	add	x1, x29, #80
	add	x1, x1, x3
	ldr	w1, [x1]
	sxtw	x1, w1
	mov	x3, #7
	orr	x1, x1, x3
	mov	x3, #48939
	movk	x3, #0x223c, lsl #16
	movk	x3, #0xf45d, lsl #32
	movk	x3, #0x391a, lsl #48
	and	x1, x1, x3
	adrp	x3, "g_313"
	add	x3, x3, #:lo12:"g_313"
	ldrh	w3, [x3]
	uxth	w3, w3
	eor	x1, x1, x3
	uxth	w1, w1
	mov	w25, w2
	adrp	x2, "g_313"
	add	x2, x2, #:lo12:"g_313"
	strh	w1, [x2]
	mov	w1, #-4617
	bl	"safe_sub_func_uint16_t_u_u"
	mov	w1, w0
	mov	w0, w26
	uxtb	w1, w1
	bl	"safe_add_func_int8_t_s_s"
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w1, [x0]
	mov	w0, #0
	bl	"safe_lshift_func_uint8_t_u_s"
	adrp	x1, "g_147"
	add	x1, x1, #:lo12:"g_147"
	ldr	x1, [x1]
	ldrb	w1, [x1]
	bl	"safe_rshift_func_uint8_t_u_u"
	mov	w2, w25
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxtw	x0, w0
	cmp	x0, #0
	mov	w25, #1
.L676:
	cmp	w20, w25
	cset	w0, gt
	sxtw	x0, w0
	mov	x1, #47856
	movk	x1, #0x506c, lsl #16
	movk	x1, #0x3b1c, lsl #32
	movk	x1, #0x685f, lsl #48
	cmp	x0, x1
.L677:
	mov	x0, #0
	str	x0, [x24]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	orr	w0, w22, w0
	mov	x3, #7676
	add	x1, x29, #80
	add	x1, x1, x3
	str	w0, [x1]
	mov	w0, #1
	add	w20, w20, w0
	b	.L670
.L679:
	mov	x24, x21
	ldr	x21, [x29, 17400]
	ldr	x25, [x29, 17544]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x8, [x29, 17536]
	ldr	x28, [x29, 16968]
	ldr	x23, [x29, 17392]
	ldr	x20, [x29, 16928]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x4, #6756
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	mov	w4, #10
	lsl	w3, w3, w4
	mov	w4, #10
	asr	w3, w3, w4
	mov	x5, #7676
	add	x4, x29, #80
	add	x4, x4, x5
	str	w3, [x4]
	mov	x4, #4472
	add	x3, x29, #80
	add	x4, x3, x4
	adrp	x3, "g_894"
	add	x3, x3, #:lo12:"g_894"
	str	x3, [x4]
	mov	w22, #0
.L682:
	mov	x17, #17700
	add	x17, x29, x17
	str	w2, [x17]
	str	x8, [x29, 17704]
	mov	x17, #17712
	add	x17, x29, x17
	str	w22, [x17]
	cmp	x8, #0
	cset	w3, eq
	cmp	w3, #0
	bne	.L685
	cmp	x8, x20
	cset	w3, cs
	cmp	w3, #0
	beq	.L685
	cmp	x8, x1
	cset	w3, ls
.L685:
	cmp	w3, #0
	bne	.L687
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #534
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1041"
	add	x0, x0, #:lo12:".ts.1041"
	bl	"__assert_fail"
	mov	x17, #17700
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x8, [x29, 17704]
	mov	x17, #17712
	add	x17, x29, x17
	ldr	w22, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
.L687:
	mov	x4, #5184
	add	x3, x29, #80
	add	x4, x3, x4
	mov	w3, #0
	str	w3, [x4]
	mov	w3, #0
	cmp	w3, #28
	beq	.L693
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	ldr	x0, [x0]
	str	x24, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x24
	beq	.L692
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #571
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	x17, #17700
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x8, [x29, 17704]
	ldr	x1, [x29, 16976]
.L692:
	mov	x22, x21
	b	.L708
.L693:
	mov	w24, w22
	mov	x23, x21
	mov	w20, w0
	mov	x1, #11920
	add	x0, x29, #80
	add	x21, x0, x1
	mov	w19, w2
	mov	x2, #16
	adrp	x1, .ci1046
	add	x1, x1, #:lo12:.ci1046
	mov	x0, x21
	bl	memcpy
	mov	w2, w19
	mov	x1, #11936
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w22, w2
	mov	x2, #28
	adrp	x1, .ci1047
	add	x1, x1, #:lo12:.ci1047
	bl	memcpy
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x19, [x0]
	adrp	x1, "g_117"+2
	add	x1, x1, #:lo12:"g_117"+2
	mov	w0, #-26594
	strh	w0, [x1]
	mov	w1, #1
	mov	w0, #65532
	bl	"safe_sub_func_uint16_t_u_u"
	mov	w2, w22
	uxth	w0, w0
	mov	x1, #59417
	movk	x1, #0xd7aa, lsl #16
	cmp	x0, x1
	cset	w0, eq
	ldr	w1, [x21]
	mov	x3, #3840
	mov	w22, w2
	add	x2, x29, #80
	add	x2, x2, x3
	str	w1, [x2]
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	w2, w22
	uxth	w0, w0
	orr	w0, w0, w27
	sxtw	x0, w0
	adrp	x3, "g_190"
	add	x3, x3, #:lo12:"g_190"
	mov	x1, #5706
	movk	x1, #0x3171, lsl #16
	movk	x1, #0x687f, lsl #32
	movk	x1, #0xa9a8, lsl #48
	str	x1, [x3]
	mov	x1, #5706
	movk	x1, #0x3171, lsl #16
	movk	x1, #0x687f, lsl #32
	movk	x1, #0xa9a8, lsl #48
	cmp	x0, x1
	cset	w0, cs
	str	w0, [x21]
	adrp	x1, "g_646"
	add	x1, x1, #:lo12:"g_646"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	mov	x3, #59740
	movk	x3, #0x81, lsl #16
	movk	x3, #0x32b3, lsl #32
	movk	x3, #0xdac7, lsl #48
	cmp	x1, x3
	mov	w22, w0
	cset	w0, ne
	mov	x3, #11948
	add	x1, x29, #80
	add	x21, x1, x3
	mov	x3, #6756
	add	x1, x29, #80
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	w3, #10
	lsl	w1, w1, w3
	mov	w3, #10
	asr	w1, w1, w3
	mov	w25, w2
	sxtw	x2, w1
	mov	x1, #0
	add	x1, x21, x1
	ldr	x1, [x1]
	bl	"func_19"
	mov	w2, w25
	mov	x1, x0
	mov	w0, w22
	mov	x4, #0
	add	x3, x29, #56
	add	x3, x3, x4
	str	x1, [x3]
	mov	x3, #0
	add	x1, x29, #56
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	x3, #0
	add	x3, x23, x3
	str	w1, [x3]
	mov	w22, w2
	sxtw	x2, w24
	mov	x1, #0
	add	x1, x23, x1
	ldr	x1, [x1]
	bl	"func_19"
	mov	w2, w22
	mov	x1, x0
	mov	w0, w20
	mov	x3, #0
	mov	w22, w2
	add	x2, x29, #48
	add	x2, x2, x3
	str	x1, [x2]
	mov	w1, #-1
	mov	w20, w0
	mov	w0, w27
	bl	"safe_add_func_int16_t_s_s"
	mov	w1, w0
	mov	w0, w20
	mov	w20, w0
	mov	w0, #-26594
	bl	"safe_add_func_int16_t_s_s"
	mov	w2, w22
	mov	w1, w0
	mov	w0, w20
	sxth	w1, w1
	cmp	w1, w2
	mov	w20, w0
	cset	w0, cs
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	ldr	x1, [x1]
	ldr	x2, [x1]
	ldr	w1, [x21]
	mov	w3, #10
	lsl	w1, w1, w3
	mov	w3, #10
	asr	w3, w1, w3
	mov	w4, #20841
	movk	w4, #0xa2cc, lsl #16
	mov	w1, w20
	bl	"func_47"
	str	x0, [x19]
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	mov	w0, #-30
	strb	w0, [x1]
	mov	x1, #11980
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #-30
.L696:
	sxtb	w0, w0
	cmp	w0, #11
	bne	.L703
	mov	w0, #0
.L698:
	cmp	w0, #3
	bge	.L701
	sxtw	x2, w0
	mov	x3, #4
	mul	x2, x2, x3
	add	x3, x1, x2
	mov	w2, #50145
	movk	w2, #0xee05, lsl #16
	str	w2, [x3]
	mov	w2, #1
	add	w0, w0, w2
	b	.L698
.L701:
	adrp	x2, "g_295"
	add	x2, x2, #:lo12:"g_295"
	mov	x0, #0
	str	x0, [x2]
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	ldrsb	w0, [x0]
	mov	w2, #1
	add	w0, w0, w2
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	strb	w0, [x2]
	b	.L696
.L703:
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	mov	w0, #0
	strb	w0, [x1]
	mov	w0, #5
	b	.L1124
.L705:
	mov	x22, x21
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	ldr	x0, [x0]
	str	x24, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x24
	beq	.L708
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w21, w2
	mov	w2, #497
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	w2, w21
	ldr	x1, [x29, 16976]
	ldr	x8, [x29, 17536]
	ldr	x28, [x29, 16968]
.L708:
	mov	x17, #17696
	add	x17, x29, x17
	str	w2, [x17]
	str	x8, [x29, 17688]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x24
	beq	.L710
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #574
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	x17, #17696
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x8, [x29, 17688]
	ldr	x1, [x29, 16976]
.L710:
	cmp	x8, #0
	cset	w0, eq
	cmp	w0, #0
	bne	.L713
	cmp	x8, x20
	cset	w0, cs
	cmp	w0, #0
	beq	.L713
	cmp	x8, x1
	cset	w0, ls
.L713:
	cmp	w0, #0
	bne	.L715
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #576
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1041"
	add	x0, x0, #:lo12:".ts.1041"
	bl	"__assert_fail"
	mov	x17, #17696
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x8, [x29, 17688]
	ldr	x1, [x29, 16976]
.L715:
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x3, [x0]
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	w0, [x0]
	str	w0, [x3]
	mov	x4, #4288
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	eor	w0, w0, w3
	mov	x4, #4288
	add	x3, x29, #80
	add	x3, x3, x4
	str	w0, [x3]
	mov	x26, x22
	mov	x6, #0
	b	.L802
.L717:
	mov	x22, x26
	mov	x1, #6760
	add	x0, x29, #80
	add	x5, x0, x1
	str	x5, [x29, 17680]
	mov	x2, #896
	mov	w1, #0
	mov	x0, x5
	bl	memset
	mov	x8, x21
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x5, [x29, 17680]
	mov	x21, x8
	ldr	x8, [x29, 17536]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x3, [x29, 17496]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	mov	x26, x0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #6768
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6776
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6784
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6792
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6800
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6808
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6816
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #6824
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6832
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6840
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6848
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6856
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6864
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6872
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #6880
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6888
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6896
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6904
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6912
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6920
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6928
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #6936
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6944
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6952
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6960
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #6968
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #6976
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #6984
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #6992
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7000
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7008
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7016
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7024
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7032
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7040
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7048
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7056
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7064
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7072
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7080
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7088
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7096
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7104
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7112
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7120
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7128
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7136
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7144
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7152
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7160
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7168
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7176
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7184
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7192
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7200
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7208
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7216
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7224
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7232
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7240
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7248
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7256
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7264
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7272
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7280
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7288
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7296
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7304
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7312
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7320
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7328
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7336
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7344
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7352
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7360
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7368
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7376
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7384
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7392
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7400
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7408
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7416
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7424
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7432
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7440
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7448
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7456
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7464
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7472
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7480
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7488
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7496
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7504
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7512
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7520
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7528
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7536
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7544
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7552
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7560
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7568
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7576
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7584
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7592
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7600
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+24
	add	x4, x4, #:lo12:"g_317"+24
	str	x4, [x5]
	mov	x5, #7608
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7616
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7624
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7632
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_317"+36
	add	x4, x4, #:lo12:"g_317"+36
	str	x4, [x5]
	mov	x5, #7640
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	x4, [x5]
	mov	x5, #7648
	add	x4, x29, #80
	add	x5, x4, x5
	adrp	x4, "g_1219"+20
	add	x4, x4, #:lo12:"g_1219"+20
	str	x4, [x5]
	mov	x5, #7656
	add	x4, x29, #80
	add	x6, x4, x5
	mov	x17, x22
	mov	x22, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x22
	mov	x22, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w4, w0
	mov	x0, x26
	mov	w5, #0
.L720:
	cmp	w5, #1
	bge	.L723
	sxtw	x26, w5
	mov	x30, #4
	mul	x26, x26, x30
	add	x30, x26, x6
	mov	w26, #0
	str	w26, [x30]
	mov	w26, #1
	add	w5, w5, w26
	b	.L720
.L723:
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x22
	mov	x22, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x22
	mov	x22, x17
	adrp	x1, "g_887"
	add	x1, x1, #:lo12:"g_887"
	mov	w0, #0
	strh	w0, [x1]
	adrp	x1, "g_127"
	add	x1, x1, #:lo12:"g_127"
	mov	w0, #-3
	strb	w0, [x1]
	uxth	w1, w2
	mov	x17, #17620
	add	x17, x29, x17
	str	w1, [x17]
	uxth	w0, w1
	mov	x1, #27236
	movk	x1, #0xd2ee, lsl #16
	movk	x1, #0x154, lsl #32
	movk	x1, #0x6e38, lsl #48
	orr	x0, x0, x1
	sxth	w14, w0
	mov	x17, #17640
	add	x17, x29, x17
	str	w14, [x17]
	mov	x1, #7672
	add	x0, x29, #80
	add	x13, x0, x1
	str	x13, [x29, 17632]
	mov	x1, #7680
	add	x0, x29, #80
	add	x11, x0, x1
	str	x11, [x29, 17664]
	mov	x1, #7760
	add	x0, x29, #80
	add	x15, x0, x1
	str	x15, [x29, 17648]
	mov	x1, #7824
	add	x0, x29, #80
	add	x26, x0, x1
	mov	x17, x22
	mov	x22, x25
	mov	x25, x17
	mov	x17, x21
	mov	x21, x22
	mov	x22, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	x17, #0
	str	x17, [x29, 17528]
	mov	w17, #1
	mov	x17, #17616
	add	x17, x29, x17
	str	w17, [x17]
	mov	w0, #-3
.L727:
	uxtb	w0, w0
	cmp	w0, #17
	ble	.L759
	mov	w1, #1
	adrp	x0, ".ts.881"
	add	x0, x0, #:lo12:".ts.881"
	bl	"printf"
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w12, [x17]
	mov	x17, #17640
	add	x17, x29, x17
	ldr	w14, [x17]
	adrp	x0, "g_313"
	add	x0, x0, #:lo12:"g_313"
	strh	w12, [x0]
	mov	w1, #1
	mov	w0, w14
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w12, [x17]
	uxth	w0, w0
	mov	x17, #17644
	add	x17, x29, x17
	str	w0, [x17]
	adrp	x0, "g_896"
	add	x0, x0, #:lo12:"g_896"
	ldr	x0, [x0]
	ldr	w0, [x0]
	mov	x17, #17672
	add	x17, x29, x17
	str	w0, [x17]
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
	mov	x17, #17676
	add	x17, x29, x17
	str	w0, [x17]
	mov	x2, #7097
	movk	x2, #0xe9c9, lsl #16
	mov	x0, #0
	add	x0, x25, x0
	ldr	x1, [x0]
	mov	w0, w12
	bl	"func_19"
	mov	x1, x0
	ldr	x13, [x29, 17632]
	mov	x17, #17676
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x3, #0
	add	x2, x29, #24
	add	x2, x2, x3
	str	x1, [x2]
	mov	x2, #0
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x13, x2
	str	w1, [x2]
	mov	x2, #7097
	movk	x2, #0xe9c9, lsl #16
	mov	x1, #0
	add	x1, x13, x1
	ldr	x1, [x1]
	bl	"func_19"
	mov	x1, x0
	mov	x17, #17672
	add	x17, x29, x17
	ldr	w0, [x17]
	mov	x3, #0
	add	x2, x29, #16
	add	x2, x2, x3
	str	x1, [x2]
	mov	w1, #60527
	movk	w1, #0xaa96, lsl #16
	bl	"safe_div_func_uint32_t_u_u"
	uxth	w0, w0
	mov	w1, #-1
	bl	"safe_lshift_func_uint16_t_u_u"
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	uxtb	w0, w0
	mov	w1, w4
	bl	"safe_add_func_uint8_t_u_u"
	mov	w1, #31
	bl	"safe_mul_func_uint8_t_u_u"
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w1, w0
	mov	w0, #1
	bl	"safe_mul_func_int16_t_s_s"
	sxth	w0, w0
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	and	w0, w0, w1
	sxtb	w1, w0
	mov	w0, #1
	bl	"safe_add_func_uint8_t_u_u"
	mov	w1, w0
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17644
	add	x17, x29, x17
	ldr	w0, [x17]
	uxtb	w1, w1
	cmp	w1, w2
	cset	w1, eq
	mov	w2, #-1
	orr	w1, w1, w2
	eor	w0, w0, w1
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w0, gt
	mov	w1, #1
	bl	"safe_lshift_func_uint8_t_u_u"
	mov	x17, #17616
	add	x17, x29, x17
	ldr	w5, [x17]
	ldr	x11, [x29, 17664]
	uxtb	w0, w0
	cmp	w0, #0
	bne	.L746
	mov	w1, w5
	adrp	x0, ".ts.881"
	add	x0, x0, #:lo12:".ts.881"
	bl	"printf"
	ldr	x15, [x29, 17648]
	mov	x2, #64
	adrp	x1, .ci891
	add	x1, x1, #:lo12:.ci891
	mov	x0, x15
	bl	memcpy
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x2, [x0]
	ldrb	w1, [x2]
	mov	w0, #1
	add	w0, w1, w0
	strb	w0, [x2]
	mov	w0, #-86
	bl	"safe_add_func_int8_t_s_s"
	mov	x8, x22
	mov	w3, w0
	ldr	x6, [x29, 17528]
	mov	x17, #17616
	add	x17, x29, x17
	ldr	w5, [x17]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w12, [x17]
	ldr	x15, [x29, 17648]
	ldr	x11, [x29, 17664]
	ldr	x13, [x29, 17632]
	mov	x17, #17640
	add	x17, x29, x17
	ldr	w14, [x17]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	sxtb	w3, w3
	mov	x22, #5184
	add	x16, x29, #80
	add	x16, x16, x22
	str	w3, [x16]
	mov	x22, #7676
	add	x16, x29, #80
	add	x16, x16, x22
	ldr	w16, [x16]
	eor	w3, w3, w16
	mov	x22, #7676
	add	x16, x29, #80
	add	x16, x16, x22
	str	w3, [x16]
	mov	w3, #0
.L731:
	mov	x22, x6
	cmp	w3, #1
	blt	.L745
	mov	x6, x22
	mov	x22, x0
	mov	w0, #0
.L733:
	cmp	w0, #6
	bge	.L736
	sxtw	x16, w0
	mov	x30, #8
	mul	x16, x16, x30
	add	x30, x26, x16
	adrp	x16, "g_75"
	add	x16, x16, #:lo12:"g_75"
	str	x16, [x30]
	mov	w16, #1
	add	w0, w0, w16
	b	.L733
.L736:
	mov	x22, x6
	mov	w20, w5
	mov	w19, w3
	mov	x23, x8
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w0, #0
	bne	.L744
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x0, [x0]
	ldrb	w0, [x0]
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #0
	and	w1, w1, w2
	cmp	w0, w1
	cset	w0, ne
	adrp	x1, "g_648"
	add	x1, x1, #:lo12:"g_648"
	ldr	x1, [x1]
	ldr	x2, [x1]
	mov	x1, #0
	add	x1, x23, x1
	ldr	x1, [x1]
	bl	"func_19"
	mov	w3, w19
	mov	x2, #0
	add	x1, x29, #32
	add	x1, x1, x2
	str	x0, [x1]
	mov	x1, #0
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x1, #0
	add	x1, x25, x1
	str	w0, [x1]
	mov	x1, #0
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x1, #0
	add	x1, x23, x1
	str	w0, [x1]
	sxtw	x0, w3
	mov	x1, #13551
	cmp	x0, x1
	cset	w1, lt
	cmp	w1, #1
	cset	w1, lt
	sxtw	x1, w1
	mov	x2, #59796
	cmp	x1, x2
	mov	x2, #7424
	add	x1, x29, #80
	add	x1, x1, x2
	str	x21, [x1]
	mov	x2, #3920
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	x1, [x1]
	adrp	x2, "g_146"
	add	x2, x2, #:lo12:"g_146"
	ldr	x2, [x2]
	ldr	x2, [x2]
	cmp	x1, x2
	cset	w1, eq
	sxtw	x24, w1
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	mov	x19, x0
	mov	w0, #1
	bl	"safe_lshift_func_uint8_t_u_u"
	uxtb	w0, w0
	mov	w1, #11
	bl	"safe_rshift_func_int16_t_s_u"
	sxth	x0, w0
	mov	x1, #34525
	movk	x1, #0x11fd, lsl #16
	orr	x0, x0, x1
	and	x0, x24, x0
	mov	x2, #5184
	add	x1, x29, #80
	add	x2, x1, x2
	mov	w1, #1
	str	w1, [x2]
	mov	x1, #1
	and	x0, x0, x1
	mov	w1, #1
	bl	"safe_mod_func_uint32_t_u_u"
	mov	w1, w0
	mov	x0, x19
	cmp	w1, #0
	cset	w19, ne
	cmp	w19, #0
	bne	.L741
	adrp	x1, "g_648"
	add	x1, x1, #:lo12:"g_648"
	ldr	x1, [x1]
	ldr	x1, [x1]
	cmn	x1, #1
	cset	w19, eq
.L741:
	mov	x1, #2
	bl	"safe_add_func_uint64_t_u_u"
	mov	x8, x23
	mov	x6, x22
	mov	w5, w20
	mov	x3, x0
	orr	w5, w5, w19
	mov	x0, #1
	sub	x6, x6, x0
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x24, [x29, 17544]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x19, [x29, 17120]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w12, [x17]
	ldr	x15, [x29, 17648]
	ldr	x11, [x29, 17664]
	ldr	x13, [x29, 17632]
	mov	x17, #17640
	add	x17, x29, x17
	ldr	w14, [x17]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x23, [x29, 17392]
	ldr	x20, [x29, 16928]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	b	.L731
.L744:
	mov	w5, w20
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w19, [x17]
	ldr	x24, [x29, 17664]
	b	.L756
.L745:
	mov	w19, w2
	mov	x23, x8
	mov	x24, x11
	b	.L756
.L746:
	mov	x24, x11
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	mov	x0, #0
	str	x0, [x1]
	mov	x25, x24
	mov	w22, #-1
	mov	x0, #0
.L749:
	cmp	x0, #12
	bne	.L754
	mov	x2, #80
	mov	w1, #0
	mov	x0, x25
	bl	memset
	mov	x1, #7680
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7688
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7696
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7704
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7712
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7720
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7728
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7736
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7744
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7752
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+28
	add	x0, x0, #:lo12:"g_1219"+28
	str	x0, [x1]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w1, [x0]
	mov	x2, #7660
	add	x0, x29, #80
	add	x0, x0, x2
	ldr	w0, [x0]
	mov	w2, #10
	lsl	w2, w0, w2
	mov	w3, #10
	asr	w2, w2, w3
	orr	w1, w1, w2
	mov	w2, #-4194304
	and	w0, w0, w2
	mov	w2, #4194303
	and	w1, w1, w2
	orr	w0, w0, w1
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w24, [x0]
	adrp	x0, "g_1304"
	add	x0, x0, #:lo12:"g_1304"
	ldr	x0, [x0]
	mov	w1, #4
	bl	"safe_add_func_uint32_t_u_u"
	mov	x11, x25
	mov	w0, w0
	adrp	x1, "g_1304"
	add	x1, x1, #:lo12:"g_1304"
	str	x0, [x1]
	eor	w22, w24, w22
	mov	x25, x11
	b	.L749
.L754:
	ldr	x6, [x29, 17528]
	mov	x17, #17616
	add	x17, x29, x17
	ldr	w5, [x17]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w19, [x17]
	ldr	x23, [x29, 17656]
	mov	x24, x25
	ldr	x25, [x29, 17400]
	mov	x22, x6
.L756:
	mov	w20, w5
	adrp	x0, "g_127"
	add	x0, x0, #:lo12:"g_127"
	ldrb	w0, [x0]
	mov	w1, #7
	bl	"safe_add_func_uint32_t_u_u"
	mov	x11, x24
	mov	x8, x23
	mov	x6, x22
	mov	w5, w20
	mov	w2, w19
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w12, [x17]
	ldr	x15, [x29, 17648]
	ldr	x13, [x29, 17632]
	mov	x17, #17640
	add	x17, x29, x17
	ldr	w14, [x17]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	uxtb	w0, w0
	adrp	x1, "g_127"
	add	x1, x1, #:lo12:"g_127"
	strb	w0, [x1]
	mov	x22, x8
	ldr	x24, [x29, 17544]
	ldr	x19, [x29, 17120]
	ldr	x23, [x29, 17392]
	ldr	x20, [x29, 16928]
	str	x6, [x29, 17528]
	mov	x17, #17616
	add	x17, x29, x17
	str	w5, [x17]
	b	.L727
.L759:
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x26, x25
	mov	x25, x24
	mov	x24, x21
	mov	x21, x22
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	str	x0, [x29, 17608]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x17, #17604
	add	x17, x29, x17
	str	w0, [x17]
	mov	x1, #4072
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtb	w0, w0
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	strb	w0, [x1]
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x0, [x0]
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	x1, #1
	eor	x0, x0, x1
	str	x0, [x29, 17624]
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w1, w0, w1
	mov	w0, w2
	bl	"safe_div_func_uint32_t_u_u"
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	orr	w0, w0, w1
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	and	w0, w0, w1
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w0, hi
	adrp	x1, "g_895"
	add	x1, x1, #:lo12:"g_895"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w0, ne
	mov	x2, #7656
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	uxtb	w1, w1
	bl	"safe_mod_func_uint8_t_u_u"
	uxtb	w0, w0
	adrp	x1, "g_1219"+12
	add	x1, x1, #:lo12:"g_1219"+12
	ldr	w1, [x1]
	sxth	w1, w1
	bl	"safe_mul_func_uint16_t_u_u"
	mov	x17, #17620
	add	x17, x29, x17
	ldr	w1, [x17]
	bl	"safe_mul_func_int16_t_s_s"
	mov	x8, x21
	mov	w1, w0
	mov	x17, #17616
	add	x17, x29, x17
	ldr	w21, [x17]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x0, [x29, 17624]
	sxth	x1, w1
	cmp	x0, x1
	cset	w22, lt
	cmp	w22, #0
	beq	.L762
	mov	w7, w22
.L762:
	adrp	x0, "g_313"
	add	x0, x0, #:lo12:"g_313"
	ldrh	w0, [x0]
	eor	w0, w0, w7
	sxth	w0, w0
	adrp	x1, "g_313"
	add	x1, x1, #:lo12:"g_313"
	strh	w0, [x1]
	uxth	w0, w0
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtw	x2, w1
	mov	x1, #0
	add	x1, x8, x1
	ldr	x1, [x1]
	bl	"func_19"
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x2, #0
	add	x1, x29, #40
	add	x1, x1, x2
	str	x0, [x1]
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	mov	w1, #-1
	eor	w0, w0, w1
	cmp	w0, #0
	cset	w22, ne
	cmp	w22, #0
	beq	.L764
	mov	w7, w22
.L764:
	sxtw	x0, w7
	cmp	x0, #0
	cset	w0, ge
	mov	x2, #4288
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	mov	w1, w27
	bl	"safe_add_func_int16_t_s_s"
	mov	w1, #24311
	bl	"safe_mul_func_int16_t_s_s"
	mov	w1, w0
	mov	x17, #17604
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x0, [x29, 17608]
	sxth	w1, w1
	cmp	w1, w27
	cset	w1, eq
	orr	w1, w1, w2
	mov	x3, #4224
	add	x2, x29, #80
	add	x2, x2, x3
	str	w1, [x2]
	str	x24, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x24
	beq	.L766
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #422
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	w5, w21
	b	.L767
.L766:
	mov	w5, w21
.L767:
	mov	x1, #3840
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #4
	str	w0, [x1]
	mov	x1, #7888
	add	x0, x29, #80
	add	x8, x0, x1
	str	x8, [x29, 17568]
	mov	x1, #8672
	add	x0, x29, #80
	add	x21, x0, x1
	str	x21, [x29, 17552]
	mov	x1, #9808
	add	x0, x29, #80
	add	x22, x0, x1
	str	x22, [x29, 17560]
	sxtw	x5, w5
	str	x5, [x29, 17584]
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	w0, #4
.L769:
	cmp	w0, #1
	blt	.L796
	mov	x2, #1920
	mov	w1, #0
	mov	x0, x8
	bl	memset
	mov	x3, x22
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x5, [x29, 17584]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x8, [x29, 17568]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	mov	x22, #7888
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7896
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7904
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7912
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7920
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7928
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7936
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7944
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7952
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7960
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7968
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7984
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #7992
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8000
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8008
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8016
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8024
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8032
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8040
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8048
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8056
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8064
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8080
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8088
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8096
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8104
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8112
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8120
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8128
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8152
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8160
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8176
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8184
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8192
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8200
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8208
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8216
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8240
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8248
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8272
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8280
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8288
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8296
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8304
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8312
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8320
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8328
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8336
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8344
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8352
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8360
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8368
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8376
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8384
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8392
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8400
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8416
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8424
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8432
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8440
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8448
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8456
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8464
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8472
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8480
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8488
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8496
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8512
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8520
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8544
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8552
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8560
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8576
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8584
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8592
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8600
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8608
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8616
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8624
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8632
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8648
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8656
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8672
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8680
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8688
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8696
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8704
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8712
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8720
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8736
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8744
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8752
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8760
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8776
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8784
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8792
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8800
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8808
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8816
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8824
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8832
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8840
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8848
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8856
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8864
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8872
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8880
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8888
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8896
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8904
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8920
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8928
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8936
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8944
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8952
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8960
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8968
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8976
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8984
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #8992
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9000
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9008
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9016
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9024
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9032
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9048
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9056
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9064
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9072
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9080
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9088
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9096
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9104
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9112
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9120
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9128
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9136
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9144
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9160
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9168
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9176
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9184
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9200
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9208
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9232
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9240
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9248
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9264
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9272
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9280
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9312
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9320
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9336
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9344
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9352
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9360
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9368
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9384
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9392
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9400
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9408
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9416
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9424
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9432
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9440
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9448
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9456
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9464
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9472
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9480
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9488
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9496
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9504
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9512
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9528
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9544
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9552
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9560
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9568
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9576
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9584
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9592
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9608
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9616
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9632
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9640
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9648
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9664
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9672
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9680
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9688
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9696
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9704
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9712
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9720
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9728
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9736
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9744
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9752
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9760
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9768
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9776
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9784
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9792
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, #9800
	add	x16, x29, #80
	add	x22, x16, x22
	adrp	x16, "g_120"
	add	x16, x16, #:lo12:"g_120"
	str	x16, [x22]
	mov	x22, x0
	mov	w0, #0
.L772:
	cmp	w0, #1
	bge	.L775
	sxtw	x16, w0
	mov	x30, #8
	mul	x16, x16, x30
	add	x16, x3, x16
	str	x26, [x16]
	mov	w16, #1
	add	w0, w0, w16
	b	.L772
.L775:
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #1
	add	w0, w0, w1
	sxtw	x0, w0
	mov	x1, #4
	mul	x0, x0, x1
	adrp	x1, "g_1326"
	add	x1, x1, #:lo12:"g_1326"
	add	x0, x0, x1
	ldr	w1, [x0]
	mov	x4, #6756
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	w0, [x0]
	mov	w4, #10
	lsl	w4, w0, w4
	mov	w5, #10
	asr	w4, w4, w5
	eor	w1, w1, w4
	mov	w4, #-4194304
	and	w0, w0, w4
	mov	w4, #4194303
	and	w1, w1, w4
	orr	w1, w0, w1
	mov	x4, #6756
	add	x0, x29, #80
	add	x0, x0, x4
	str	w1, [x0]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	ldr	x22, [x0]
	str	x22, [x29, 17592]
	adrp	x0, "g_317"+24
	add	x0, x0, #:lo12:"g_317"+24
	ldr	w0, [x0]
	mov	x17, #17580
	add	x17, x29, x17
	str	w0, [x17]
	mov	x4, #7660
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	w0, [x0]
	mov	x17, #17600
	add	x17, x29, x17
	str	w0, [x17]
	mov	x4, #8800
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	x0, [x0]
	adrp	x4, "g_1522"
	add	x4, x4, #:lo12:"g_1522"
	str	x0, [x4]
	cmp	x0, #0
	cset	w0, eq
	cmp	w0, #0
	bne	.L777
	mov	x22, x3
	b	.L778
.L777:
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w0, eq
	cmp	w0, w27
	cset	w0, ge
	sxtw	x0, w0
	cmp	x0, #0
	cset	w0, eq
	mov	w4, #10
	lsl	w1, w1, w4
	mov	x22, x3
	mov	w3, #10
	asr	w1, w1, w3
	cmp	w0, w1
	cset	w0, ne
.L778:
	orr	w0, w2, w0
	mov	w0, w0
	cmn	x0, #7
	cset	w0, gt
	cmp	w0, w27
	cset	w0, ge
	adrp	x1, "g_1523"+80
	add	x1, x1, #:lo12:"g_1523"+80
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w1, eq
	mov	w0, w9
	bl	"safe_mul_func_uint8_t_u_u"
	mov	w1, #253
	bl	"safe_mod_func_uint8_t_u_u"
	mov	w1, #-7
	bl	"safe_mul_func_int8_t_s_s"
	mov	x3, x22
	mov	w1, w0
	mov	x17, #17600
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17580
	add	x17, x29, x17
	ldr	w0, [x17]
	sxtb	w1, w1
	mov	w4, #10
	lsl	w2, w2, w4
	mov	x22, x3
	mov	w3, #10
	asr	w2, w2, w3
	cmp	w0, w2
	cset	w0, ne
	bl	"safe_rshift_func_int16_t_s_s"
	mov	x3, x22
	mov	w16, w0
	ldr	x22, [x29, 17592]
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x5, [x29, 17584]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x8, [x29, 17568]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	sxth	x16, w16
	cmn	x16, #1
	cset	w16, eq
	ldr	w30, [x22]
	and	w16, w16, w30
	str	w16, [x22]
	adrp	x16, "g_1524"
	add	x16, x16, #:lo12:"g_1524"
	ldr	x22, [x16]
	mov	x30, #4296
	add	x16, x29, #80
	add	x30, x16, x30
	ldr	x16, [x29, 17312]
	str	x22, [x30]
	adrp	x30, "g_35"
	add	x30, x30, #:lo12:"g_35"
	mov	x22, #0
	str	x22, [x30]
	mov	x22, x0
	mov	x0, #0
.L780:
	cmp	x0, #4
	bhi	.L794
	adrp	x30, "g_119"
	add	x30, x30, #:lo12:"g_119"
	mov	w0, #0
	strb	w0, [x30]
	mov	w0, #0
.L783:
	sxtb	w30, w0
	cmp	w30, #9
	bge	.L786
	sxtb	x0, w0
	mov	x30, #4
	mul	x0, x0, x30
	adrp	x30, "g_1326"
	add	x30, x30, #:lo12:"g_1326"
	add	x30, x0, x30
	mov	w0, #8810
	movk	w0, #0x8b49, lsl #16
	str	w0, [x30]
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	mov	w30, #1
	add	w0, w0, w30
	sxtb	w0, w0
	adrp	x30, "g_119"
	add	x30, x30, #:lo12:"g_119"
	strb	w0, [x30]
	b	.L783
.L786:
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x1, [x0]
	ldrb	w0, [x1]
	strb	w0, [x1]
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtw	x22, w1
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	mov	x3, #5184
	add	x2, x29, #80
	add	x2, x2, x3
	ldr	w2, [x2]
	cmp	w1, w2
	cset	w27, ne
	mov	x1, #4288
	mov	w26, w0
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxth	w0, w0
	mov	w1, #195
	bl	"safe_mul_func_int16_t_s_s"
	ldr	x25, [x29, 17400]
	sxth	w0, w0
	eor	w0, w27, w0
	mov	x2, #5184
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	sxtw	x0, w0
	mov	x1, #19148
	movk	x1, #0x5317, lsl #16
	movk	x1, #0x451b, lsl #32
	movk	x1, #0x5d78, lsl #48
	bl	"safe_sub_func_uint64_t_u_u"
	mov	x1, x0
	mov	w0, w26
	ldr	x5, [x29, 17584]
	and	x27, x22, x1
	mov	x1, #63765
	movk	x1, #0xbf6e, lsl #16
	movk	x1, #0x47b2, lsl #32
	movk	x1, #0x7c22, lsl #48
	mov	w22, w0
	mov	x0, x5
	bl	"safe_sub_func_int64_t_s_s"
	ldr	x26, [x29, 17552]
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	ldrsb	w1, [x1]
	sxtb	x1, w1
	and	x0, x0, x1
	sxtb	w0, w0
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	strb	w0, [x1]
	sxtb	x0, w0
	orr	x0, x27, x0
	mov	x1, #195
	bl	"safe_div_func_int64_t_s_s"
	mov	w1, #-5
	bl	"safe_sub_func_uint32_t_u_u"
	mov	w0, w22
	ldr	x3, [x29, 17560]
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	mov	x22, x3
	asr	w3, w1, w2
	adrp	x1, "g_896"
	add	x1, x1, #:lo12:"g_896"
	ldr	x1, [x1]
	ldr	w4, [x1]
	mov	x2, x21
	mov	w1, #-61
	bl	"func_47"
	mov	x3, x22
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x5, [x29, 17584]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x8, [x29, 17568]
	ldr	x28, [x29, 16968]
	ldr	x22, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	mov	x30, #7424
	add	x16, x29, #80
	add	x30, x16, x30
	ldr	x16, [x29, 17312]
	str	x0, [x30]
	mov	x30, #4072
	add	x0, x29, #80
	add	x0, x0, x30
	ldr	w0, [x0]
	cmp	w0, #0
	bne	.L794
	adrp	x30, "g_157"
	add	x30, x30, #:lo12:"g_157"
	mov	x0, #1
	str	x0, [x30]
	mov	x0, #1
.L789:
	cmp	x0, #4
	bhi	.L792
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	str	x21, [x0]
	adrp	x0, "g_157"
	add	x0, x0, #:lo12:"g_157"
	ldr	x0, [x0]
	mov	x30, #1
	add	x0, x0, x30
	adrp	x30, "g_157"
	add	x30, x30, #:lo12:"g_157"
	str	x0, [x30]
	b	.L789
.L792:
	adrp	x0, "g_35"
	add	x0, x0, #:lo12:"g_35"
	ldr	x0, [x0]
	mov	x1, #1
	add	x0, x0, x1
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	str	x0, [x1]
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x25, [x29, 17400]
	ldr	x24, [x29, 17544]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	mov	x17, #17576
	add	x17, x29, x17
	ldr	w9, [x17]
	ldr	x3, [x29, 17560]
	ldr	x26, [x29, 17552]
	ldr	x8, [x29, 17568]
	ldr	x28, [x29, 16968]
	ldr	x22, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	b	.L780
.L794:
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #1
	sub	w0, w0, w1
	mov	x4, #3840
	add	x1, x29, #80
	add	x1, x1, x4
	str	w0, [x1]
	ldr	x25, [x29, 17400]
	ldr	x24, [x29, 17544]
	ldr	x19, [x29, 17120]
	mov	x22, x3
	ldr	x23, [x29, 17392]
	ldr	x20, [x29, 16928]
	b	.L769
.L796:
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x26, x25
	mov	x25, x24
	mov	x24, x21
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x8, [x29, 17536]
	ldr	x28, [x29, 16968]
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w3, eq
	cmp	w3, #0
	bne	.L799
	adrp	x3, "g_120"
	add	x3, x3, #:lo12:"g_120"
	cmp	x0, x3
	cset	w0, eq
	b	.L800
.L799:
	mov	w0, w3
.L800:
	cmp	w0, #0
	bne	.L802
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #452
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.808"
	add	x0, x0, #:lo12:".ts.808"
	bl	"__assert_fail"
	ldr	x6, [x29, 17528]
	mov	x17, #17516
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x1, [x29, 16976]
	ldr	x8, [x29, 17536]
.L802:
	mov	x17, #17512
	add	x17, x29, x17
	str	w2, [x17]
	str	x6, [x29, 17504]
	str	x8, [x29, 17520]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x24
	beq	.L804
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #580
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	x17, #17512
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x6, [x29, 17504]
	ldr	x8, [x29, 17520]
	ldr	x1, [x29, 16976]
.L804:
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w3, eq
	cmp	w3, #0
	bne	.L806
	adrp	x3, "g_120"
	add	x3, x3, #:lo12:"g_120"
	cmp	x0, x3
	cset	w0, eq
	b	.L807
.L806:
	mov	w0, w3
.L807:
	cmp	w0, #0
	bne	.L809
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #581
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.808"
	add	x0, x0, #:lo12:".ts.808"
	bl	"__assert_fail"
	mov	x17, #17512
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x6, [x29, 17504]
	ldr	x8, [x29, 17520]
	ldr	x1, [x29, 16976]
.L809:
	cmp	x8, #0
	cset	w0, eq
	cmp	w0, #0
	bne	.L812
	cmp	x8, x20
	cset	w0, cs
	cmp	w0, #0
	beq	.L812
	cmp	x8, x1
	cset	w0, ls
.L812:
	cmp	w0, #0
	bne	.L814
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #583
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1041"
	add	x0, x0, #:lo12:".ts.1041"
	bl	"__assert_fail"
	mov	x17, #17512
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x6, [x29, 17504]
.L814:
	str	x6, [x29, 17368]
	mov	x17, #17456
	add	x17, x29, x17
	str	w2, [x17]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, eq
	cmp	w1, #0
	bne	.L817
	cmp	x0, x24
	cset	w0, eq
	b	.L818
.L817:
	mov	w0, w1
.L818:
	cmp	w0, #0
	bne	.L820
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #608
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1124"
	add	x0, x0, #:lo12:".ts.1124"
	bl	"__assert_fail"
	mov	x17, #17456
	add	x17, x29, x17
	ldr	w2, [x17]
.L820:
	adrp	x0, "g_1522"
	add	x0, x0, #:lo12:"g_1522"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, eq
	cmp	w1, #0
	bne	.L822
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	cmp	x0, x1
	cset	w0, eq
	b	.L823
.L822:
	mov	w0, w1
.L823:
	cmp	w0, #0
	bne	.L825
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #609
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.808"
	add	x0, x0, #:lo12:".ts.808"
	bl	"__assert_fail"
	mov	x17, #17456
	add	x17, x29, x17
	ldr	w2, [x17]
.L825:
	mov	x1, #4688
	add	x0, x29, #80
	add	x0, x0, x1
	ldrb	w0, [x0]
	mov	x17, #17472
	add	x17, x29, x17
	str	w0, [x17]
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x17, #17476
	add	x17, x29, x17
	str	w0, [x17]
	adrp	x0, "g_647"
	add	x0, x0, #:lo12:"g_647"
	ldr	x0, [x0]
	ldr	x1, [x0]
	str	x1, [x29, 17480]
	adrp	x0, "g_896"
	add	x0, x0, #:lo12:"g_896"
	ldr	x1, [x0]
	mov	w0, #-1
	str	w0, [x1]
	mov	x1, #3960
	add	x0, x29, #80
	add	x1, x0, x1
	str	x1, [x29, 17488]
	mov	x1, #4072
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	cmp	w0, w2
	cset	w0, cs
	adrp	x1, "g_1081"
	add	x1, x1, #:lo12:"g_1081"
	ldrsh	w1, [x1]
	bl	"safe_mul_func_uint16_t_u_u"
	ldr	x3, [x29, 17496]
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	cmp	x3, x0
	cset	w0, eq
	sxtw	x0, w0
	mov	x1, #12537
	movk	x1, #0xb8c7, lsl #16
	movk	x1, #0x67a2, lsl #32
	movk	x1, #0xe110, lsl #48
	eor	x0, x0, x1
	uxtb	w0, w0
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_add_func_int8_t_s_s"
	mov	w1, #240
	bl	"safe_mul_func_int8_t_s_s"
	sxtb	x0, w0
	mov	x1, #16101
	cmp	x0, x1
	cset	w0, lt
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_mul_func_uint8_t_u_u"
	ldr	x1, [x29, 17488]
	uxtb	w0, w0
	str	w0, [x1]
	mov	w1, #12
	bl	"safe_lshift_func_uint16_t_u_s"
	ldr	x1, [x29, 17480]
	uxth	w0, w0
	mov	x2, #23744
	movk	x2, #0x3929, lsl #16
	and	x0, x0, x2
	cmp	x0, #167
	cset	w0, hi
	sxtw	x0, w0
	ldr	x2, [x1]
	eor	x0, x0, x2
	str	x0, [x1]
	mov	x2, #4288
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtw	x1, w1
	bl	"safe_add_func_int64_t_s_s"
	mov	x17, #17476
	add	x17, x29, x17
	ldr	w0, [x17]
	adrp	x1, "g_17"
	add	x1, x1, #:lo12:"g_17"
	ldrb	w1, [x1]
	cmp	w1, #0
	cset	w1, ne
	cmp	w1, #0
	bne	.L827
	mov	w1, #1
.L827:
	sxtw	x1, w1
	sxtw	x0, w0
	bl	"safe_sub_func_uint64_t_u_u"
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtw	x1, w1
	cmp	x0, x1
	cset	w1, cc
	mov	w0, #0
	bl	"safe_mul_func_uint16_t_u_u"
	uxth	w0, w0
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	bl	"safe_mod_func_uint32_t_u_u"
	mov	w1, w0
	mov	x17, #17472
	add	x17, x29, x17
	ldr	w0, [x17]
	cmp	w1, #0
	cset	w1, ne
	cmp	w1, #0
	bne	.L829
	mov	w1, #1
.L829:
	bl	"safe_sub_func_int16_t_s_s"
	mov	x17, #17456
	add	x17, x29, x17
	ldr	w2, [x17]
	sxth	w0, w0
	mov	w1, #-3
	and	w0, w0, w1
	mov	w0, w0
	mov	x1, #4629
	movk	x1, #0x7c07, lsl #16
	cmp	x0, x1
	cset	w0, eq
	sxtw	x0, w0
	cmp	x0, #2
	cset	w8, cc
	mov	x17, #17460
	add	x17, x29, x17
	str	w8, [x17]
	sxtw	x0, w8
	mov	x1, #56638
	movk	x1, #0x9563, lsl #16
	movk	x1, #0xfe1b, lsl #32
	movk	x1, #0x793c, lsl #48
	cmp	x0, x1
	cset	w0, ge
	sxtw	x0, w0
	mov	w1, w2
	bl	"safe_div_func_int64_t_s_s"
	mov	x1, #65533
	movk	x1, #0xffff, lsl #16
	cmp	x0, x1
	cset	w0, ne
	mov	w1, #0
	bl	"safe_sub_func_int16_t_s_s"
	bl	"safe_unary_minus_func_uint16_t_u"
	mov	w1, w0
	mov	x17, #17472
	add	x17, x29, x17
	ldr	w0, [x17]
	uxth	w1, w1
	bl	"safe_lshift_func_int8_t_s_s"
	sxtb	w0, w0
	cmp	w0, #0
	bne	.L1123
	mov	x1, #12384
	add	x0, x29, #80
	add	x3, x0, x1
	str	x3, [x29, 17112]
	mov	w0, #29382
	movk	w0, #0x9262, lsl #16
	str	w0, [x3]
	mov	x1, #12388
	add	x0, x29, #80
	add	x0, x0, x1
	mov	x2, #40
	adrp	x1, .ci1140
	add	x1, x1, #:lo12:.ci1140
	bl	memcpy
	mov	x1, #12448
	add	x0, x29, #80
	add	x3, x0, x1
	str	x3, [x29, 17464]
	mov	x2, #144
	mov	w1, #0
	mov	x0, x3
	bl	memset
	ldr	x3, [x29, 17464]
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x3]
	mov	x1, #12456
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12464
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12472
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12480
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12488
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12496
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12504
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12512
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12520
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12528
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12536
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12544
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12552
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12560
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12568
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12576
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12584
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_985"+512
	add	x0, x0, #:lo12:"g_985"+512
	str	x0, [x1]
	mov	x1, #12592
	add	x0, x29, #80
	add	x9, x0, x1
	str	x9, [x29, 17448]
	mov	x2, #4
	mov	w1, #0
	mov	x0, x9
	bl	memset
	mov	x17, #17456
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x6, [x29, 17368]
	mov	x17, #17384
	add	x17, x29, x17
	ldr	w1, [x17]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	ldr	x9, [x29, 17448]
	ldr	x3, [x29, 17112]
	mov	x17, #17460
	add	x17, x29, x17
	ldr	w8, [x17]
	mov	w4, w1
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x0, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w21, [x17]
	ldr	w5, [x9]
	mov	w22, #-4194304
	and	w5, w5, w22
	mov	w22, w10
	mov	w10, #4194303
	orr	w5, w5, w10
	str	w5, [x9]
	mov	x9, #12352
	add	x5, x29, #80
	add	x9, x5, x9
	str	x9, [x29, 17264]
	mov	w10, w22
	mov	x22, x3
	mov	w3, w4
	mov	w4, w21
	mov	x21, x24
	mov	x24, x25
	mov	x25, x26
	mov	w5, #0
.L832:
	cmp	w5, #4
	bge	.L835
	sxtw	x26, w5
	mov	x30, #8
	mul	x26, x26, x30
	add	x30, x26, x9
	mov	x26, #0
	str	x26, [x30]
	mov	w26, #1
	add	w5, w5, w26
	b	.L832
.L835:
	mov	x26, x25
	mov	x25, x24
	mov	x24, x21
	mov	x3, x22
	mov	w22, w10
	mov	w21, w4
	mov	x5, #12432
	add	x4, x29, #80
	add	x5, x4, x5
	mov	w10, w22
	mov	x22, x3
	mov	w4, w21
	mov	x21, x24
	mov	x24, x25
	mov	x25, x26
	mov	w3, #0
.L838:
	cmp	w3, #2
	bge	.L841
	sxtw	x26, w3
	mov	x30, #8
	mul	x26, x26, x30
	add	x30, x26, x5
	mov	x26, #0
	str	x26, [x30]
	mov	w26, #1
	add	w3, w3, w26
	b	.L838
.L841:
	mov	x26, x25
	mov	x25, x24
	mov	x24, x21
	mov	w22, w10
	mov	w21, w4
	adrp	x4, "g_747"
	add	x4, x4, #:lo12:"g_747"
	mov	x3, #0
	str	x3, [x4]
	mov	x4, #12600
	add	x3, x29, #80
	add	x4, x3, x4
	mov	x5, #12616
	add	x3, x29, #80
	add	x3, x3, x5
	mov	x6, #12656
	add	x5, x29, #80
	add	x15, x5, x6
	str	x15, [x29, 17408]
	mov	x6, #4304
	add	x5, x29, #80
	add	x5, x5, x6
	str	x5, [x29, 17416]
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	x17, x25
	mov	x25, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x25
	mov	x25, x17
	mov	x17, x4
	mov	x4, x26
	mov	x26, x17
	mov	w6, #0
	mov	x16, #0
.L844:
	mov	w10, w22
	mov	x17, #17444
	add	x17, x29, x17
	str	w2, [x17]
	mov	x17, #17388
	add	x17, x29, x17
	str	w8, [x17]
	mov	x17, #17244
	add	x17, x29, x17
	str	w6, [x17]
	cmp	x16, #22
	bge	.L869
	mov	x22, #12596
	add	x16, x29, #80
	add	x16, x16, x22
	mov	x22, x3
	mov	w3, #0
	str	w3, [x16]
	mov	x3, x22
	mov	x22, x0
	mov	w0, #0
.L847:
	cmp	w0, #2
	bge	.L850
	sxtw	x16, w0
	mov	x30, #8
	mul	x16, x16, x30
	add	x30, x26, x16
	adrp	x16, "g_317"+24
	add	x16, x16, #:lo12:"g_317"+24
	str	x16, [x30]
	mov	w16, #1
	add	w0, w0, w16
	b	.L847
.L850:
	mov	x22, x3
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
	mov	w1, #13
	bl	"safe_rshift_func_int16_t_s_s"
	mov	x3, x22
	mov	x17, #17444
	add	x17, x29, x17
	ldr	w2, [x17]
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x1, #65036
	eor	x0, x0, x1
	str	x0, [x29, 17432]
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	w1, [x0]
	mov	x22, x3
	mov	w3, #1
	add	w1, w1, w3
	mov	x17, #17428
	add	x17, x29, x17
	str	w1, [x17]
	str	w1, [x0]
	mov	w0, #1
	sub	w2, w2, w0
	mov	x17, #17424
	add	x17, x29, x17
	str	w2, [x17]
	mov	x1, #12596
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x17, #17440
	add	x17, x29, x17
	str	w0, [x17]
	mov	x1, #12352
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	x0, [x0]
	mov	x2, #4472
	add	x1, x29, #80
	add	x2, x1, x2
	adrp	x1, "g_894"+64
	add	x1, x1, #:lo12:"g_894"+64
	str	x1, [x2]
	adrp	x1, "g_894"+64
	add	x1, x1, #:lo12:"g_894"+64
	cmp	x0, x1
	cset	w0, eq
	sxtw	x0, w0
	mov	x1, #185
	and	x0, x0, x1
	mov	x2, #4072
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtw	x1, w1
	and	x0, x0, x1
	mov	x2, #4072
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldrb	w0, [x0]
	mov	w1, #6
	bl	"safe_rshift_func_uint8_t_u_u"
	mov	w1, w0
	mov	x17, #17440
	add	x17, x29, x17
	ldr	w0, [x17]
	uxtb	w1, w1
	bl	"safe_div_func_int32_t_s_s"
	mov	x17, #17424
	add	x17, x29, x17
	ldr	w2, [x17]
	sxtw	x0, w0
	mov	x1, #38260
	movk	x1, #0xf320, lsl #16
	movk	x1, #0xb0d6, lsl #32
	movk	x1, #0x8db6, lsl #48
	eor	x0, x0, x1
	uxth	w0, w0
	adrp	x1, "g_887"
	add	x1, x1, #:lo12:"g_887"
	strh	w0, [x1]
	sxth	w0, w0
	adrp	x1, "g_117"+2
	add	x1, x1, #:lo12:"g_117"+2
	strh	w0, [x1]
	mov	x1, #4704
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w2, w0
	cset	w1, cc
	mov	w0, #44
	bl	"safe_add_func_uint8_t_u_u"
	mov	x3, x22
	mov	w2, w0
	mov	x17, #17428
	add	x17, x29, x17
	ldr	w1, [x17]
	ldr	x0, [x29, 17432]
	uxtb	w2, w2
	mov	x4, #12596
	mov	x22, x3
	add	x3, x29, #80
	add	x3, x3, x4
	str	w2, [x3]
	cmp	w1, w2
	cset	w1, ls
	sxtw	x1, w1
	mov	x2, #40180
	movk	x2, #0x9bb6, lsl #16
	cmp	x1, x2
	cset	w1, le
	sxtw	x1, w1
	orr	x0, x0, x1
	mov	x1, #25040
	movk	x1, #0xcf3d, lsl #16
	movk	x1, #0x467b, lsl #32
	movk	x1, #0xfed4, lsl #48
	bl	"safe_add_func_int64_t_s_s"
	mov	x3, x22
	mov	x16, x0
	mov	x17, #17424
	add	x17, x29, x17
	ldr	w2, [x17]
	mov	x17, #17388
	add	x17, x29, x17
	ldr	w8, [x17]
	mov	x17, #17244
	add	x17, x29, x17
	ldr	w6, [x17]
	ldr	x5, [x29, 17416]
	ldr	x15, [x29, 17408]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w10, [x17]
	ldr	x9, [x29, 17264]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x11, [x29, 17248]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	cmp	x16, #0
	cset	w16, ne
	cmp	w16, #0
	bne	.L853
	mov	w16, #1
.L853:
	mov	x30, #6756
	mov	x22, x5
	add	x5, x29, #80
	add	x5, x5, x30
	ldr	w5, [x5]
	mov	w30, #-4194304
	and	w5, w5, w30
	orr	w5, w5, w16
	mov	x30, #6756
	add	x16, x29, #80
	add	x16, x16, x30
	str	w5, [x16]
	mov	w16, #10
	lsl	w5, w5, w16
	mov	w16, #10
	asr	w5, w5, w16
	cmp	w5, #0
	bne	.L861
	mov	w25, w8
	mov	w23, w6
	mov	x20, x3
	mov	w19, w2
	mov	x2, #384
	mov	w1, #0
	mov	x0, x15
	bl	memset
	mov	x3, x20
	mov	w2, w19
	mov	x1, #12656
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12664
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12688
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12696
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12704
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12712
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12720
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12728
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12736
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12744
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12752
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12760
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12776
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12784
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12792
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12800
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12816
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12832
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12840
	add	x0, x29, #80
	add	x0, x0, x1
	str	x22, [x0]
	mov	x1, #12856
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12864
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12872
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12880
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12888
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12896
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12904
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #12912
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12920
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12928
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12952
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12960
	add	x0, x29, #80
	add	x0, x0, x1
	str	x22, [x0]
	mov	x1, #12976
	add	x0, x29, #80
	add	x0, x0, x1
	str	x22, [x0]
	mov	x1, #12984
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #12992
	add	x0, x29, #80
	add	x0, x0, x1
	str	x24, [x0]
	mov	x1, #13008
	add	x0, x29, #80
	add	x0, x0, x1
	str	x22, [x0]
	mov	x1, #13016
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #13024
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	str	x0, [x1]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x20, x3
	mov	x3, #4072
	add	x1, x29, #80
	add	x1, x1, x3
	ldr	w1, [x1]
	eor	w0, w0, w1
	mov	w19, w2
	mov	x2, #4072
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	adrp	x1, "g_771"
	add	x1, x1, #:lo12:"g_771"
	mov	w0, #0
	str	w0, [x1]
	mov	x1, #3840
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxth	w0, w0
	mov	w1, #10
	bl	"safe_rshift_func_int16_t_s_u"
	mov	w8, w25
	mov	w6, w23
	mov	x3, x20
	mov	w2, w19
	ldr	x15, [x29, 17408]
	adrp	x1, "g_1524"
	add	x1, x1, #:lo12:"g_1524"
	adrp	x0, "g_1525"
	add	x0, x0, #:lo12:"g_1525"
	str	x0, [x1]
	adrp	x1, "g_1748"+112
	add	x1, x1, #:lo12:"g_1748"+112
	adrp	x0, "g_1525"
	add	x0, x0, #:lo12:"g_1525"
	str	x0, [x1]
	mov	x1, #4296
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	x0, [x0]
	adrp	x1, "g_1525"
	add	x1, x1, #:lo12:"g_1525"
	cmp	x0, x1
	cset	w0, ne
	sxtw	x0, w0
	sxtw	x1, w8
	mov	x4, #65
	movk	x4, #0x8677, lsl #16
	movk	x4, #0x380c, lsl #32
	movk	x4, #0xf3ea, lsl #48
	eor	x8, x1, x4
	sxtw	x1, w8
	adrp	x4, "g_157"
	add	x4, x4, #:lo12:"g_157"
	str	x1, [x4]
	cmp	x0, x1
	cset	w0, cs
	orr	w6, w0, w6
	mov	w25, w8
	mov	w23, w6
	mov	x1, #4730
	add	x0, x29, #80
	add	x0, x0, x1
	ldrh	w0, [x0]
	mov	w1, #1
	add	w0, w0, w1
	mov	x4, #4730
	add	x1, x29, #80
	add	x1, x1, x4
	strh	w0, [x1]
	adrp	x0, "g_1760"
	add	x0, x0, #:lo12:"g_1760"
	ldr	x0, [x0]
	mov	x4, #4696
	add	x1, x29, #80
	add	x1, x1, x4
	ldr	x1, [x1]
	ldr	x1, [x1]
	cmp	x0, x1
	cset	w0, eq
	mov	x4, #3840
	add	x1, x29, #80
	add	x1, x1, x4
	ldr	w1, [x1]
	eor	w0, w0, w1
	mov	x4, #3840
	add	x1, x29, #80
	add	x1, x1, x4
	str	w0, [x1]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	str	x21, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x21
	beq	.L860
	mov	x20, x3
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w19, w2
	mov	w2, #702
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	w8, w25
	mov	w6, w23
	mov	x5, x22
	mov	x3, x20
	mov	w2, w19
	ldr	x15, [x29, 17408]
	b	.L867
.L860:
	mov	w8, w25
	mov	w6, w23
	mov	x5, x22
	b	.L867
.L861:
	mov	x5, x22
	mov	x22, x0
	mov	w0, #0
.L863:
	cmp	w0, #5
	bge	.L866
	sxtw	x16, w0
	mov	x30, #8
	mul	x16, x16, x30
	add	x30, x3, x16
	adrp	x16, "g_295"
	add	x16, x16, #:lo12:"g_295"
	str	x16, [x30]
	mov	w16, #1
	add	w0, w0, w16
	b	.L863
.L866:
	mov	x1, #12596
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	x1, #1
	orr	x0, x0, x1
	mov	x4, #12596
	add	x1, x29, #80
	add	x1, x1, x4
	str	w0, [x1]
.L867:
	adrp	x0, "g_747"
	add	x0, x0, #:lo12:"g_747"
	ldr	x0, [x0]
	mov	x1, #1
	add	x0, x0, x1
	adrp	x1, "g_747"
	add	x1, x1, #:lo12:"g_747"
	str	x0, [x1]
	ldr	x25, [x29, 17400]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w22, [x17]
	ldr	x9, [x29, 17264]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x19, [x29, 17120]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x28, [x29, 16968]
	ldr	x23, [x29, 17392]
	ldr	x20, [x29, 16928]
	ldr	x11, [x29, 17248]
	ldr	x14, [x29, 17296]
	ldr	x12, [x29, 17376]
	ldr	x13, [x29, 17288]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w4, [x17]
	mov	x16, x0
	ldr	x0, [x29, 17136]
	b	.L844
.L869:
	ldr	x6, [x29, 17368]
	mov	x26, x25
	mov	x24, x21
	mov	x17, #16964
	add	x17, x29, x17
	str	w2, [x17]
	adrp	x0, "g_295"
	add	x0, x0, #:lo12:"g_295"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w1, eq
	cmp	w1, #0
	bne	.L872
	adrp	x1, "g_1522"
	add	x1, x1, #:lo12:"g_1522"
	cmp	x0, x1
	cset	w0, eq
	b	.L873
.L872:
	mov	w0, w1
.L873:
	cmp	w0, #0
	bne	.L875
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w21, w2
	mov	w2, #705
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.801"
	add	x0, x0, #:lo12:".ts.801"
	bl	"__assert_fail"
	ldr	x6, [x29, 17368]
	b	.L876
.L875:
	mov	w21, w2
.L876:
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	beq	.L878
	mov	w1, #13
	mov	w0, #27605
	bl	"safe_lshift_func_uint16_t_u_s"
	mov	w2, w21
	uxth	w0, w0
	orr	w0, w0, w2
	uxth	w0, w0
	adrp	x1, "g_59"
	add	x1, x1, #:lo12:"g_59"
	ldr	w1, [x1]
	mov	w1, w1
	cmn	x1, #4
	cset	w1, ge
	sxtw	x1, w1
	mov	w21, w2
	mov	x2, #164
	and	x1, x1, x2
	sxth	w1, w1
	bl	"safe_mul_func_int16_t_s_s"
	sxth	x0, w0
	mov	x1, #219
	orr	x1, x0, x1
	mov	w0, #3
	bl	"safe_lshift_func_uint16_t_u_u"
	uxth	w0, w0
	cmp	w21, w0
	cset	w0, ls
	adrp	x1, "g_147"
	add	x1, x1, #:lo12:"g_147"
	ldr	x1, [x1]
	ldrb	w1, [x1]
	bl	"safe_mul_func_int8_t_s_s"
	mov	w2, w21
	sxtb	w0, w0
	mov	w21, w2
	mov	x2, #4730
	add	x1, x29, #80
	add	x1, x1, x2
	ldrh	w1, [x1]
	bl	"safe_sub_func_int32_t_s_s"
	mov	w2, w21
	ldr	x6, [x29, 17368]
	mov	x17, #17384
	add	x17, x29, x17
	ldr	w1, [x17]
	mov	x3, #7660
	add	x0, x29, #80
	add	x0, x0, x3
	ldr	w0, [x0]
	mov	w3, #10
	lsl	w0, w0, w3
	mov	w21, w2
	mov	w2, #10
	asr	w0, w0, w2
	orr	w0, w1, w0
	adrp	x1, "g_896"
	add	x1, x1, #:lo12:"g_896"
	ldr	x1, [x1]
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w0, hi
.L878:
	cmp	w0, #0
	bne	.L880
	cmp	x6, #0
	cset	w0, ne
.L880:
	mov	w1, #2
	bl	"safe_rshift_func_uint8_t_u_s"
	uxtb	w0, w0
	adrp	x1, "g_646"
	add	x1, x1, #:lo12:"g_646"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	bl	"safe_sub_func_uint64_t_u_u"
	mov	w2, w21
	ldr	x1, [x29, 16976]
	ldr	x0, [x29, 17136]
	ldr	x22, [x29, 17376]
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w21, [x17]
	mov	x4, #6756
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	mov	w4, #10
	lsl	w3, w3, w4
	mov	w4, #10
	asr	w3, w3, w4
	mov	x5, #12384
	add	x4, x29, #80
	add	x4, x4, x5
	ldr	w4, [x4]
	cmp	w3, w4
	cset	w3, lt
	mov	x5, #4576
	add	x4, x29, #80
	add	x25, x4, x5
	str	x25, [x29, 17168]
	mov	x5, #4680
	add	x4, x29, #80
	add	x4, x4, x5
	str	x4, [x29, 17096]
	uxtb	w4, w21
	str	x4, [x29, 16984]
	cmp	w3, #1
	bne	.L966
	mov	x4, #14916
	add	x3, x29, #80
	add	x23, x3, x4
	str	x23, [x29, 17344]
	mov	w3, #54128
	movk	w3, #0x940f, lsl #16
	str	w3, [x23]
	mov	w3, #0
	cmn	w3, #21
	bne	.L959
	adrp	x3, "g_1760"
	add	x3, x3, #:lo12:"g_1760"
	ldr	x4, [x3]
	str	x4, [x29, 17360]
	mov	x3, #7676
	mov	w23, w2
	add	x2, x29, #80
	add	x2, x2, x3
	ldr	w3, [x2]
	mov	x17, #17356
	add	x17, x29, x17
	str	w3, [x17]
	mov	x22, x1
	mov	w1, w21
	mov	x21, x0
	mov	w0, #196
	bl	"safe_add_func_int8_t_s_s"
	mov	x1, x22
	mov	w2, w0
	mov	x0, x21
	sxtb	w2, w2
	mov	x4, #4800
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	cmp	w2, w3
	mov	x21, x0
	cset	w0, ne
	mov	x22, x1
	mov	w1, w23
	bl	"safe_add_func_uint32_t_u_u"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x6, [x29, 17368]
	mov	x17, #17356
	add	x17, x29, x17
	ldr	w3, [x17]
	adrp	x4, "g_1523"+80
	add	x4, x4, #:lo12:"g_1523"+80
	ldr	w4, [x4]
	cmp	w3, w4
	cset	w3, hi
	cmp	w3, #0
	bne	.L886
	mov	w3, #1
.L886:
	cmp	w3, w2
	cset	w3, hi
	sxtw	x3, w3
	adrp	x4, "g_1965"
	add	x4, x4, #:lo12:"g_1965"
	str	x3, [x4]
	mov	x5, #7676
	add	x4, x29, #80
	add	x4, x4, x5
	ldr	w4, [x4]
	sxtw	x4, w4
	cmp	x3, x4
	cset	w3, gt
	cmp	w3, #0
	bne	.L888
	adrp	x3, "g_33"
	add	x3, x3, #:lo12:"g_33"
	ldr	w3, [x3]
	cmp	w3, #0
	mov	w23, w2
	cset	w2, ne
	b	.L889
.L888:
	mov	w23, w2
	mov	w2, w3
.L889:
	cmp	w2, #0
	mov	x21, x0
	uxth	w0, w6
	mov	x22, x1
	mov	w1, #9
	bl	"safe_mul_func_int16_t_s_s"
	mov	w1, w0
	mov	x0, x21
	sxth	x1, w1
	mov	x21, x0
	mov	x0, #12532
	movk	x0, #0x84d0, lsl #16
	movk	x0, #0x2836, lsl #32
	movk	x0, #0xf088, lsl #48
	bl	"safe_mod_func_uint64_t_u_u"
	mov	w2, w23
	mov	x1, x22
	mov	x3, x0
	mov	x0, x21
	ldr	x4, [x29, 17360]
	mov	x17, #17352
	add	x17, x29, x17
	ldr	w7, [x17]
	cmp	x3, #0
	adrp	x3, "g_17"
	add	x3, x3, #:lo12:"g_17"
	ldrb	w3, [x3]
	cmp	w3, #0
	cset	w3, ne
	cmp	w3, #0
	beq	.L893
	mov	w3, #1
.L893:
	strb	w3, [x4]
	cmp	w3, w2
	cset	w3, ls
	cmp	w7, w3
	mov	w23, w2
	cset	w2, gt
	cmp	w27, w2
	mov	x21, x0
	cset	w0, ne
	mov	x22, x1
	mov	w1, #3
	bl	"safe_add_func_int32_t_s_s"
	mov	x1, x22
	sxtb	w0, w0
	mov	x22, x1
	adrp	x1, "g_1911"
	add	x1, x1, #:lo12:"g_1911"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldrb	w1, [x1]
	bl	"safe_sub_func_uint8_t_u_u"
	mov	w2, w23
	mov	x1, x22
	mov	w3, w0
	mov	x0, x21
	uxtb	w3, w3
	cmp	x3, #5
	mov	x21, x0
	cset	w0, eq
	sxtw	x0, w0
	mov	w23, w2
	mov	x2, #12532
	movk	x2, #0x84d0, lsl #16
	movk	x2, #0x2836, lsl #32
	movk	x2, #0xf088, lsl #48
	orr	x0, x0, x2
	uxtb	w0, w0
	mov	x22, x1
	mov	w1, #108
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w0
	mov	x0, x21
	sxtb	w1, w1
	and	w1, w1, w23
	mov	w1, w1
	mov	x21, x0
	mov	x0, #1
	bl	"safe_div_func_int64_t_s_s"
	mov	w2, w23
	mov	x1, x22
	mov	x5, x0
	mov	x0, x21
	mov	x17, #17340
	add	x17, x29, x17
	ldr	w21, [x17]
	ldr	x23, [x29, 17344]
	ldr	x4, [x29, 16984]
	ldr	x3, [x29, 17096]
	mov	x17, #17336
	add	x17, x29, x17
	ldr	w22, [x17]
	ldr	x26, [x29, 17112]
	ldr	x25, [x29, 17168]
	cmp	x5, #0
	bne	.L925
	mov	x6, #14920
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_67"
	add	x5, x5, #:lo12:"g_67"
	str	x5, [x6]
	mov	x6, #14928
	add	x5, x29, #80
	add	x5, x5, x6
	mov	x8, x4
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	w4, #0
.L896:
	cmp	w4, #1
	bge	.L899
	sxtw	x6, w4
	mov	x7, #8
	mul	x6, x6, x7
	add	x7, x5, x6
	mov	x6, #0
	str	x6, [x7]
	mov	w6, #1
	add	w4, w4, w6
	b	.L896
.L899:
	mov	x4, x8
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x21
	mov	x21, x17
	mov	x6, #7676
	add	x5, x29, #80
	add	x5, x5, x6
	ldr	w5, [x5]
	mov	x7, #14916
	add	x6, x29, #80
	add	x7, x6, x7
	mov	w6, #184
	movk	w6, #0xab82, lsl #16
	str	w6, [x7]
	cmp	w5, #0
	cset	w6, ne
	mov	x7, #6756
	add	x5, x29, #80
	add	x5, x5, x7
	ldr	w5, [x5]
	mov	w7, #10
	lsl	w7, w5, w7
	mov	w8, #10
	asr	w7, w7, w8
	eor	w6, w6, w7
	mov	w7, #-4194304
	and	w5, w5, w7
	mov	w7, #4194303
	and	w6, w6, w7
	orr	w5, w5, w6
	mov	x7, #6756
	add	x6, x29, #80
	add	x6, x6, x7
	str	w5, [x6]
	mov	x6, #14920
	add	x5, x29, #80
	add	x6, x5, x6
	adrp	x5, "g_67"
	add	x5, x5, #:lo12:"g_67"
	str	x5, [x6]
	adrp	x6, "g_188"
	add	x6, x6, #:lo12:"g_188"
	mov	x5, #0
	str	x5, [x6]
	mov	x8, x4
	mov	x17, x21
	mov	x21, x26
	mov	x26, x17
	mov	x17, x24
	mov	x24, x21
	mov	x21, x17
	mov	x4, #0
.L902:
	cmp	x4, #7
	bge	.L914
	mov	x5, #6756
	add	x4, x29, #80
	add	x5, x4, x5
	mov	w4, #0
	str	w4, [x5]
	mov	x22, x0
	mov	w0, #0
.L905:
	cmp	w0, #6
	bcs	.L912
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	mov	w0, #0
	str	w0, [x4]
	mov	w0, #0
.L908:
	cmp	w0, #2
	bge	.L911
	mov	w4, w0
	adrp	x0, "g_188"
	add	x0, x0, #:lo12:"g_188"
	ldr	x0, [x0]
	mov	x5, #48
	mul	x0, x0, x5
	add	x0, x20, x0
	mov	x6, #6756
	add	x5, x29, #80
	add	x5, x5, x6
	ldr	w5, [x5]
	mov	w5, w5
	mov	x6, #8
	mul	x5, x5, x6
	add	x0, x0, x5
	sxtw	x4, w4
	mov	x5, #4
	mul	x4, x4, x5
	add	x4, x0, x4
	mov	w0, #14525
	movk	w0, #0x36e2, lsl #16
	str	w0, [x4]
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	mov	w4, #1
	add	w0, w0, w4
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	w0, [x4]
	b	.L908
.L911:
	mov	x4, #6756
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	w0, [x0]
	mov	w4, #1
	add	w0, w0, w4
	mov	x5, #6756
	add	x4, x29, #80
	add	x4, x4, x5
	str	w0, [x4]
	b	.L905
.L912:
	mov	x0, x22
	adrp	x4, "g_188"
	add	x4, x4, #:lo12:"g_188"
	ldr	x4, [x4]
	mov	x5, #1
	add	x4, x4, x5
	adrp	x5, "g_188"
	add	x5, x5, #:lo12:"g_188"
	str	x4, [x5]
	b	.L902
.L914:
	mov	x17, x21
	mov	x21, x24
	mov	x24, x17
	mov	x17, x26
	mov	x26, x21
	mov	x21, x17
	adrp	x5, "g_702"
	add	x5, x5, #:lo12:"g_702"
	mov	w4, #0
	str	w4, [x5]
	mov	w4, #0
	cmp	w4, #3
	bhi	.L944
	mov	w0, w21
	mov	x2, #14936
	add	x1, x29, #80
	add	x19, x1, x2
	mov	x2, #56
	mov	w1, #0
	mov	w20, w0
	mov	x0, x19
	bl	memset
	mov	w0, w20
	str	x23, [x19]
	mov	x2, #14944
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	mov	x2, #14952
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	mov	x2, #14960
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	mov	x2, #14968
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	mov	x2, #14976
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	mov	x2, #14984
	add	x1, x29, #80
	add	x1, x1, x2
	str	x23, [x1]
	adrp	x1, "g_1912"
	add	x1, x1, #:lo12:"g_1912"
	ldr	x1, [x1]
	ldr	x2, [x1]
	adrp	x1, "g_1911"
	add	x1, x1, #:lo12:"g_1911"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	str	x1, [x2]
	cmp	x1, #0
	cset	w19, eq
	cmp	w19, #0
	bne	.L922
	mov	w19, #1
.L922:
	mov	w20, w19
	mov	w1, #-3
	mov	w19, w0
	mov	w0, #-13
	bl	"safe_mul_func_int8_t_s_s"
	mov	w17, w0
	mov	w0, w19
	mov	w19, w17
	mov	w1, #17260
	movk	w1, #0x21ab, lsl #16
	bl	"safe_div_func_int32_t_s_s"
	sxtw	x0, w0
	adrp	x1, "g_647"
	add	x1, x1, #:lo12:"g_647"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	bl	"safe_add_func_int64_t_s_s"
	mov	w0, w20
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxtw	x1, w1
	mov	w20, w0
	mov	x0, #60635
	movk	x0, #0xa834, lsl #16
	movk	x0, #0x46a9, lsl #32
	movk	x0, #0xd332, lsl #48
	bl	"safe_div_func_int64_t_s_s"
	sxth	w0, w0
	mov	x2, #6756
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxth	w1, w1
	bl	"safe_mul_func_int16_t_s_s"
	mov	w1, w0
	mov	w0, w20
	sxth	x1, w1
	mov	w20, w0
	mov	x0, #65532
	bl	"safe_div_func_uint64_t_u_u"
	mov	x1, x0
	mov	w0, w20
	cmp	x1, #0
	mov	w20, w0
	cset	w0, ne
	cmp	w0, #0
	beq	.L924
	mov	w0, #1
.L924:
	and	w0, w27, w0
	sxtw	x0, w0
	adrp	x1, "g_647"
	add	x1, x1, #:lo12:"g_647"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	bl	"safe_add_func_uint64_t_u_u"
	mov	w0, w20
	mov	w20, w0
	adrp	x0, "g_647"
	add	x0, x0, #:lo12:"g_647"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x0, [x0]
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtw	x1, w1
	bl	"safe_mod_func_int64_t_s_s"
	mov	x2, x0
	mov	w0, w20
	sxtb	x1, w19
	cmp	x1, x2
	mov	w19, w0
	cset	w0, gt
	mov	w1, w27
	bl	"safe_div_func_uint32_t_u_u"
	mov	w1, w0
	mov	w0, w19
	cmp	w27, w1
	mov	w19, w0
	cset	w0, eq
	mov	w1, #31703
	movk	w1, #0xff31, lsl #16
	bl	"safe_sub_func_int32_t_s_s"
	mov	w1, w0
	mov	w0, w19
	bl	"safe_lshift_func_uint16_t_u_s"
	uxtb	w0, w0
	mov	w1, #5
	bl	"safe_lshift_func_int8_t_s_s"
	sxtb	w0, w0
	mov	x2, #3840
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	and	w0, w0, w1
	mov	x2, #3840
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
	b	.L1124
.L925:
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x3, [x0]
	mov	x4, #3964
	add	x0, x29, #80
	add	x0, x0, x4
	str	x0, [x3]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, x20
	cset	w3, cs
	cmp	w3, #0
	bne	.L927
	mov	w0, w3
	b	.L928
.L927:
	cmp	x0, x1
	cset	w0, ls
.L928:
	cmp	w0, #0
	bne	.L930
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w21, w2
	mov	w2, #827
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1359"
	add	x0, x0, #:lo12:".ts.1359"
	bl	"__assert_fail"
	mov	w2, w21
.L930:
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	ldr	x21, [x0]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	str	x0, [x29, 17328]
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	mov	w23, w2
	mov	x2, #4172
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	bl	"safe_div_func_uint32_t_u_u"
	uxth	w0, w0
	mov	w1, #0
	bl	"safe_rshift_func_int16_t_s_u"
	mov	x17, #17276
	add	x17, x29, x17
	str	w0, [x17]
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	ldrsh	w0, [x0]
	mov	w1, #14
	bl	"safe_rshift_func_int16_t_s_s"
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	eor	w0, w27, w0
	sxtb	w1, w0
	mov	w0, #2
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w0
	mov	w0, #-1
	bl	"safe_add_func_int8_t_s_s"
	mov	w1, w27
	mov	w0, #-107
	bl	"safe_rshift_func_int8_t_s_s"
	sxtb	w0, w0
	mov	w1, w23
	bl	"safe_lshift_func_int16_t_s_u"
	mov	w1, #2
	bl	"safe_lshift_func_uint16_t_u_u"
	uxth	w0, w0
	cmn	x0, #1
	cset	w0, ne
	mov	w1, #-57
	bl	"safe_div_func_uint8_t_u_u"
	mov	w1, w0
	mov	x17, #17276
	add	x17, x29, x17
	ldr	w0, [x17]
	uxtb	w1, w1
	and	w1, w27, w1
	bl	"safe_sub_func_uint16_t_u_u"
	uxth	w0, w0
	adrp	x1, "g_190"
	add	x1, x1, #:lo12:"g_190"
	str	x0, [x1]
	mov	x1, #0
	bl	"safe_div_func_uint64_t_u_u"
	uxtb	w0, w0
	mov	w1, #3
	bl	"safe_lshift_func_uint8_t_u_u"
	uxtb	w1, w0
	mov	w0, #-88
	bl	"safe_lshift_func_uint8_t_u_u"
	mov	w1, w0
	ldr	x0, [x29, 17328]
	uxtb	w1, w1
	bl	"safe_add_func_int64_t_s_s"
	mov	x1, #24627
	movk	x1, #0x816e, lsl #16
	cmp	x0, x1
	cset	w0, lt
	adrp	x1, "g_895"
	add	x1, x1, #:lo12:"g_895"
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	w1, [x1]
	bl	"safe_sub_func_int32_t_s_s"
	mov	w2, w23
	sxth	w0, w0
	mov	x3, #7660
	add	x1, x29, #80
	add	x1, x1, x3
	ldr	w1, [x1]
	mov	w3, #10
	lsl	w1, w1, w3
	mov	w23, w2
	mov	w2, #10
	asr	w1, w1, w2
	sxth	w1, w1
	bl	"safe_add_func_uint16_t_u_u"
	mov	w2, w23
	uxth	w0, w0
	str	w0, [x21]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	str	x26, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x26, x0
	beq	.L932
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w21, w2
	mov	w2, #831
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1364"
	add	x0, x0, #:lo12:".ts.1364"
	bl	"__assert_fail"
	mov	w10, w22
	mov	w2, w21
	b	.L933
.L932:
	mov	w10, w22
.L933:
	adrp	x1, "g_127"
	add	x1, x1, #:lo12:"g_127"
	mov	w0, #0
	strb	w0, [x1]
	sxth	w0, w2
	cmp	w0, #0
	cset	w22, ne
	mov	x21, x24
	mov	w0, #0
.L935:
	mov	w24, w10
	uxtb	w0, w0
	cmp	w0, #3
	bgt	.L943
	adrp	x0, "g_647"
	add	x0, x0, #:lo12:"g_647"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x25, [x0]
	mov	x1, #4800
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #5
	str	w0, [x1]
	adrp	x0, "g_1713"+24
	add	x0, x0, #:lo12:"g_1713"+24
	cmp	x0, #0
	bne	.L938
	mov	w23, w2
	mov	w10, w24
	b	.L941
.L938:
	adrp	x0, "g_984"
	add	x0, x0, #:lo12:"g_984"
	ldr	x0, [x0]
	ldr	x0, [x0]
	mov	w23, w2
	mov	x2, #3848
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	x1, [x1]
	cmp	x1, #0
	cmp	x0, #0
	cset	w0, ne
	sxtw	x0, w0
	mov	x1, #-1
	bl	"safe_add_func_uint64_t_u_u"
	mov	w10, w22
.L941:
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w1, [x0]
	mov	w0, w10
	bl	"safe_mod_func_int32_t_s_s"
	mov	w1, w0
	cmp	x25, #5
	cset	w0, ne
	bl	"safe_sub_func_int32_t_s_s"
	sxtb	w0, w0
	mov	w1, #3
	bl	"safe_lshift_func_int8_t_s_s"
	mov	w10, w24
	mov	w2, w23
	adrp	x1, "g_1965"
	add	x1, x1, #:lo12:"g_1965"
	mov	x0, #3
	str	x0, [x1]
	adrp	x0, "g_127"
	add	x0, x0, #:lo12:"g_127"
	ldrb	w0, [x0]
	mov	w1, #1
	add	w0, w0, w1
	sxtb	w0, w0
	adrp	x1, "g_127"
	add	x1, x1, #:lo12:"g_127"
	strb	w0, [x1]
	b	.L935
.L943:
	mov	x24, x21
	ldr	x3, [x29, 17096]
	ldr	x26, [x29, 17112]
	ldr	x1, [x29, 16976]
	ldr	x25, [x29, 17168]
	ldr	x0, [x29, 17136]
.L944:
	adrp	x4, "g_121"
	add	x4, x4, #:lo12:"g_121"
	ldr	x4, [x4]
	cmp	x4, #0
	cset	w5, eq
	cmp	w5, #0
	bne	.L946
	cmp	x4, x24
	cset	w5, eq
.L946:
	cmp	w5, #0
	bne	.L948
	cmp	x26, x4
	cset	w4, eq
	b	.L949
.L948:
	mov	w4, w5
.L949:
	cmp	w4, #0
	bne	.L951
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #888
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1436"
	add	x0, x0, #:lo12:".ts.1436"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x3, [x29, 17096]
.L951:
	adrp	x4, "g_120"
	add	x4, x4, #:lo12:"g_120"
	ldr	x4, [x4]
	ldr	x28, [x4]
	cmp	x28, #0
	cset	w4, eq
	cmp	w4, #0
	bne	.L953
	cmp	x28, x24
	cset	w4, eq
.L953:
	cmp	w4, #0
	bne	.L955
	cmp	x26, x28
	mov	x5, x3
	cset	w3, eq
	b	.L956
.L955:
	mov	x5, x3
	mov	w3, w4
.L956:
	cmp	w3, #0
	bne	.L958
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #891
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1445"
	add	x0, x0, #:lo12:".ts.1445"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x5, [x29, 17096]
	ldr	x25, [x29, 17168]
.L958:
	mov	x3, x5
	b	.L1027
.L959:
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	mov	x0, #0
	str	x0, [x1]
	mov	x1, #7676
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #0
	str	w0, [x1]
	mov	w0, #0
.L962:
	cmn	w0, #25
	bne	.L965
	adrp	x0, "g_1911"
	add	x0, x0, #:lo12:"g_1911"
	ldr	x0, [x0]
	adrp	x1, "g_1911"
	add	x1, x1, #:lo12:"g_1911"
	str	x0, [x1]
	adrp	x1, "g_1912"
	add	x1, x1, #:lo12:"g_1912"
	cmp	x0, x1
	cset	w0, ne
	mov	x2, #12392
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #1
	sub	w0, w0, w1
	mov	x2, #7676
	add	x1, x29, #80
	add	x1, x1, x2
	str	w0, [x1]
	b	.L962
.L965:
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
	b	.L1124
.L966:
	mov	x1, #13040
	add	x0, x29, #80
	add	x0, x0, x1
	str	x0, [x29, 17320]
	mov	w21, w2
	mov	x2, #280
	mov	w1, #0
	bl	memset
	mov	x12, x22
	mov	w2, w21
	ldr	x0, [x29, 17320]
	ldr	x15, [x29, 17304]
	ldr	x14, [x29, 17296]
	ldr	x16, [x29, 17312]
	ldr	x13, [x29, 17288]
	str	x15, [x0]
	mov	x1, #13048
	add	x0, x29, #80
	add	x0, x0, x1
	str	x14, [x0]
	mov	x1, #13056
	add	x0, x29, #80
	add	x0, x0, x1
	str	x14, [x0]
	mov	x1, #13064
	add	x0, x29, #80
	add	x0, x0, x1
	str	x15, [x0]
	mov	x1, #13072
	add	x0, x29, #80
	add	x0, x0, x1
	str	x12, [x0]
	mov	x1, #13080
	add	x0, x29, #80
	add	x1, x0, x1
	mov	x3, #976
	add	x0, x29, #80
	add	x0, x0, x3
	str	x0, [x1]
	mov	x3, #13088
	add	x1, x29, #80
	add	x1, x1, x3
	str	x15, [x1]
	mov	x3, #13096
	add	x1, x29, #80
	add	x1, x1, x3
	str	x14, [x1]
	mov	x3, #13104
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13112
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13120
	add	x1, x29, #80
	add	x1, x1, x3
	str	x16, [x1]
	mov	x3, #13128
	add	x1, x29, #80
	add	x1, x1, x3
	str	x15, [x1]
	mov	x3, #13136
	add	x1, x29, #80
	add	x1, x1, x3
	str	x16, [x1]
	mov	x3, #13144
	add	x1, x29, #80
	add	x1, x1, x3
	str	x12, [x1]
	mov	x3, #13152
	add	x1, x29, #80
	add	x1, x1, x3
	str	x15, [x1]
	mov	x3, #13160
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13168
	add	x1, x29, #80
	add	x1, x1, x3
	str	x14, [x1]
	mov	x3, #13176
	add	x1, x29, #80
	add	x1, x1, x3
	str	x12, [x1]
	mov	x3, #13184
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13192
	add	x1, x29, #80
	add	x1, x1, x3
	str	x12, [x1]
	mov	x3, #13200
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13208
	add	x1, x29, #80
	add	x1, x1, x3
	str	x13, [x1]
	mov	x3, #13216
	add	x1, x29, #80
	add	x1, x1, x3
	str	x14, [x1]
	mov	x3, #13224
	add	x1, x29, #80
	add	x1, x1, x3
	str	x15, [x1]
	mov	x3, #13232
	add	x1, x29, #80
	add	x1, x1, x3
	str	x0, [x1]
	mov	x3, #13240
	add	x1, x29, #80
	add	x1, x1, x3
	str	x16, [x1]
	mov	x3, #13248
	add	x1, x29, #80
	add	x1, x1, x3
	str	x0, [x1]
	mov	x3, #13256
	add	x1, x29, #80
	add	x1, x1, x3
	str	x12, [x1]
	mov	x3, #13264
	add	x1, x29, #80
	add	x1, x1, x3
	str	x12, [x1]
	mov	x3, #13272
	add	x1, x29, #80
	add	x1, x1, x3
	str	x0, [x1]
	mov	x3, #13280
	add	x1, x29, #80
	add	x1, x1, x3
	str	x0, [x1]
	mov	x3, #13288
	add	x1, x29, #80
	add	x1, x1, x3
	str	x14, [x1]
	mov	x3, #13296
	add	x1, x29, #80
	add	x1, x1, x3
	str	x16, [x1]
	mov	x3, #13304
	add	x1, x29, #80
	add	x1, x1, x3
	str	x0, [x1]
	mov	x1, #13312
	add	x0, x29, #80
	add	x0, x0, x1
	str	x12, [x0]
	mov	x1, #13320
	add	x0, x29, #80
	add	x21, x0, x1
	mov	w22, w2
	mov	x2, #72
	mov	w1, #0
	mov	x0, x21
	bl	memset
	mov	w2, w22
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x21]
	mov	x1, #13328
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+4
	add	x0, x0, #:lo12:"g_1219"+4
	str	x0, [x1]
	mov	x1, #13336
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x1]
	mov	x1, #13344
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+4
	add	x0, x0, #:lo12:"g_1219"+4
	str	x0, [x1]
	mov	x1, #13352
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x1]
	mov	x1, #13360
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+4
	add	x0, x0, #:lo12:"g_1219"+4
	str	x0, [x1]
	mov	x1, #13368
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x1]
	mov	x1, #13376
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_1219"+4
	add	x0, x0, #:lo12:"g_1219"+4
	str	x0, [x1]
	mov	x1, #13384
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x1]
	mov	x1, #13392
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w21, w2
	mov	x2, #128
	adrp	x1, .ci1218
	add	x1, x1, #:lo12:.ci1218
	bl	memcpy
	mov	w2, w21
	mov	x1, #13520
	add	x0, x29, #80
	add	x22, x0, x1
	adrp	x0, "g_1760"
	add	x0, x0, #:lo12:"g_1760"
	str	x0, [x22]
	mov	x1, #13528
	add	x0, x29, #80
	add	x0, x0, x1
	str	x0, [x29, 17280]
	mov	w21, w2
	mov	x2, #64
	mov	w1, #0
	bl	memset
	mov	w2, w21
	mov	x17, #17244
	add	x17, x29, x17
	ldr	w3, [x17]
	ldr	x0, [x29, 17280]
	ldr	x9, [x29, 17264]
	ldr	x1, [x29, 16976]
	mov	x17, #17272
	add	x17, x29, x17
	ldr	w7, [x17]
	ldr	x28, [x29, 16968]
	ldr	x25, [x29, 17168]
	str	x9, [x0]
	mov	x4, #13536
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x4, #13544
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x4, #13552
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x4, #13560
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x4, #13568
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x4, #13576
	add	x0, x29, #80
	add	x0, x0, x4
	str	x9, [x0]
	mov	x21, x1
	mov	x1, #13584
	add	x0, x29, #80
	add	x0, x0, x1
	str	x9, [x0]
	adrp	x0, "g_1802"
	add	x0, x0, #:lo12:"g_1802"
	ldr	w0, [x0]
	cmp	w0, #0
	bne	.L992
	mov	w23, w3
	mov	x1, #14600
	add	x0, x29, #80
	add	x0, x0, x1
	str	x0, [x29, 17256]
	mov	w22, w2
	mov	x2, #64
	mov	w1, #0
	bl	memset
	mov	w2, w22
	ldr	x0, [x29, 17256]
	ldr	x11, [x29, 17248]
	str	x11, [x0]
	mov	x1, #14608
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14616
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14624
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14632
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14640
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14648
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14656
	add	x0, x29, #80
	add	x0, x0, x1
	str	x11, [x0]
	mov	x1, #14664
	add	x0, x29, #80
	add	x0, x0, x1
	mov	w22, w2
	mov	x2, #252
	adrp	x1, .ci1249
	add	x1, x1, #:lo12:.ci1249
	bl	memcpy
	mov	w2, w22
	mov	x17, #17240
	add	x17, x29, x17
	ldr	w0, [x17]
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	ldr	x7, [x1]
	str	x7, [x29, 17232]
	mov	x3, #12440
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_985"+512
	add	x1, x1, #:lo12:"g_985"+512
	str	x1, [x3]
	mov	x3, #12584
	add	x1, x29, #80
	add	x3, x1, x3
	adrp	x1, "g_985"+512
	add	x1, x1, #:lo12:"g_985"+512
	str	x1, [x3]
	mov	w22, w2
	mov	x2, #12392
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	eor	w1, w0, w1
	mov	x17, #17200
	add	x17, x29, x17
	str	w1, [x17]
	mov	w6, w1
	mov	x1, #12392
	add	x0, x29, #80
	add	x0, x0, x1
	str	w6, [x0]
	sxth	w0, w6
	mov	w1, #1
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	w2, w0
	ldr	x7, [x29, 17232]
	ldr	x4, [x29, 16984]
	mov	x17, #17200
	add	x17, x29, x17
	ldr	w6, [x17]
	ldr	x5, [x29, 17096]
	ldr	x26, [x29, 17112]
	ldr	x25, [x29, 17168]
	ldr	x0, [x29, 17136]
	mov	x1, x0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	uxth	w2, w2
	cmp	w2, #0
	bne	.L973
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	w0, [x0]
	bl	"safe_unary_minus_func_uint32_t_u"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	beq	.L972
	adrp	x0, "g_648"
	add	x0, x0, #:lo12:"g_648"
	ldr	x4, [x0]
	ldr	x0, [x4]
	mov	x5, #42983
	movk	x5, #0xac42, lsl #16
	movk	x5, #0x89c4, lsl #32
	movk	x5, #0x5d83, lsl #48
	eor	x0, x0, x5
	str	x0, [x4]
	mov	x4, #4072
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	x4, #-1
	orr	x0, x0, x4
	mov	x5, #4072
	add	x4, x29, #80
	add	x4, x4, x5
	str	w0, [x4]
	sxtw	x0, w0
	mov	x4, #12069
	movk	x4, #0x4b95, lsl #16
	movk	x4, #0xaa5c, lsl #32
	movk	x4, #0x7f94, lsl #48
	cmp	x0, x4
	cset	w0, le
	cmp	w0, #0
	bne	.L972
	mov	w0, #0
.L972:
	mov	x4, #6756
	mov	x21, x1
	add	x1, x29, #80
	add	x1, x1, x4
	ldr	w1, [x1]
	mov	w23, w3
	mov	w3, #10
	lsl	w1, w1, w3
	mov	w22, w2
	mov	w2, #10
	asr	w1, w1, w2
	bl	"safe_add_func_int32_t_s_s"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	mov	w23, w3
	mov	x3, #7676
	add	x0, x29, #80
	add	x0, x0, x3
	ldr	w0, [x0]
	mov	w22, w2
	mov	w2, #57043
	movk	w2, #0xc87f, lsl #16
	cmp	w0, w2
	cset	w0, lt
	mov	x21, x1
	mov	w1, #57227
	movk	w1, #0xce9a, lsl #16
	bl	"safe_mod_func_int32_t_s_s"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	ldr	x7, [x29, 17232]
	ldr	x4, [x29, 16984]
	mov	x17, #17200
	add	x17, x29, x17
	ldr	w6, [x17]
	ldr	x5, [x29, 17096]
	ldr	x26, [x29, 17112]
	ldr	x25, [x29, 17168]
	ldr	x0, [x29, 17136]
	mov	x21, x0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	b	.L974
.L973:
	mov	w2, w22
	mov	w3, w23
	mov	x17, x21
	mov	x21, x1
	mov	x1, x17
.L974:
	str	x24, [x7]
	adrp	x7, "g_121"
	add	x7, x7, #:lo12:"g_121"
	ldr	x7, [x7]
	cmp	x7, x24
	beq	.L976
	mov	w23, w3
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w22, w2
	mov	w2, #763
	mov	x21, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.919"
	add	x0, x0, #:lo12:".ts.919"
	bl	"__assert_fail"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	ldr	x4, [x29, 16984]
	mov	x17, #17200
	add	x17, x29, x17
	ldr	w6, [x17]
	ldr	x5, [x29, 17096]
	ldr	x26, [x29, 17112]
	ldr	x25, [x29, 17168]
	ldr	x0, [x29, 17136]
	mov	x21, x0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
.L976:
	adrp	x8, "g_130"
	add	x8, x8, #:lo12:"g_130"
	mov	x7, #-17
	str	x7, [x8]
	mov	x8, x4
	mov	w7, w6
	mov	w6, w3
	mov	x3, x5
	mov	w4, w0
	mov	x0, x21
	mov	x21, x24
	mov	x24, x26
	mov	x5, #-17
.L978:
	cmp	x5, #55
	bhi	.L982
	mov	x10, #7676
	add	x9, x29, #80
	add	x9, x9, x10
	ldr	w9, [x9]
	cmp	w9, #0
	bne	.L981
	mov	x9, #1
	add	x5, x5, x9
	adrp	x9, "g_130"
	add	x9, x9, #:lo12:"g_130"
	str	x5, [x9]
	b	.L978
.L981:
	mov	w3, w6
	mov	x24, x21
	b	.L983
.L982:
	mov	w3, w6
	mov	x24, x21
.L983:
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x4, [x0]
	str	x4, [x29, 17192]
	adrp	x0, "g_1524"
	add	x0, x0, #:lo12:"g_1524"
	ldr	x0, [x0]
	ldr	x0, [x0]
	mov	w23, w3
	ldr	x3, [x0]
	str	x3, [x29, 17208]
	adrp	x0, "g_1760"
	add	x0, x0, #:lo12:"g_1760"
	ldr	x0, [x0]
	str	x0, [x29, 17216]
	mov	x0, #1
	sub	x0, x5, x0
	mov	w22, w2
	adrp	x2, "g_130"
	add	x2, x2, #:lo12:"g_130"
	str	x0, [x2]
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w0, [x0]
	mov	x21, x1
	uxth	w1, w0
	mov	w0, w27
	bl	"safe_div_func_uint16_t_u_u"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	mov	x4, #7660
	add	x0, x29, #80
	add	x0, x0, x4
	ldr	w0, [x0]
	mov	w4, #10
	lsl	w0, w0, w4
	mov	w4, #10
	asr	w0, w0, w4
	cmp	w0, #0
	cset	w0, gt
	mov	x4, #4576
	mov	w23, w3
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	x3, [x3]
	mov	x5, #12352
	add	x4, x29, #80
	add	x4, x4, x5
	str	x3, [x4]
	cmp	x3, #0
	mov	w22, w2
	cset	w2, eq
	cmp	w0, w2
	cset	w0, le
	sxtw	x0, w0
	str	x0, [x29, 17224]
	mov	x21, x1
	mov	w1, #5
	mov	w0, #240
	bl	"safe_lshift_func_int8_t_s_u"
	mov	w1, w0
	ldr	x0, [x29, 17224]
	sxtb	x1, w1
	bl	"safe_mod_func_uint64_t_u_u"
	mov	x1, x21
	mov	x2, x0
	mov	x17, #17204
	add	x17, x29, x17
	ldr	w0, [x17]
	cmp	x2, #0
	mov	x21, x1
	mov	w1, #251
	bl	"safe_add_func_uint8_t_u_u"
	mov	x1, x21
	mov	x21, x1
	uxtb	w1, w22
	bl	"safe_div_func_uint8_t_u_u"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	mov	w22, w2
	ldr	x2, [x29, 17216]
	uxtb	w0, w0
	adrp	x4, "g_647"
	add	x4, x4, #:lo12:"g_647"
	ldr	x4, [x4]
	ldr	x4, [x4]
	ldr	x4, [x4]
	and	x0, x0, x4
	mov	w23, w3
	ldrsb	w3, [x2]
	sxtb	x3, w3
	eor	x0, x0, x3
	sxtb	w0, w0
	strb	w0, [x2]
	mov	x21, x1
	mov	w1, #-28
	bl	"safe_div_func_int8_t_s_s"
	mov	x1, x21
	sxtb	w0, w0
	mov	x21, x1
	adrp	x1, "g_317"+24
	add	x1, x1, #:lo12:"g_317"+24
	ldr	w1, [x1]
	bl	"safe_lshift_func_int16_t_s_u"
	mov	w3, w23
	mov	w2, w22
	mov	x1, x21
	ldr	x21, [x29, 17136]
	sxtb	w0, w0
	mov	x4, #7660
	mov	x22, x1
	add	x1, x29, #80
	add	x1, x1, x4
	ldr	w1, [x1]
	mov	w4, #10
	lsl	w1, w1, w4
	mov	w4, #10
	asr	w1, w1, w4
	sxtb	w1, w1
	mov	w23, w2
	adrp	x2, "g_120"
	add	x2, x2, #:lo12:"g_120"
	ldr	x2, [x2]
	ldr	x2, [x2]
	mov	x5, #6756
	add	x4, x29, #80
	add	x4, x4, x5
	ldr	w4, [x4]
	mov	w5, #10
	lsl	w4, w4, w5
	mov	w5, #10
	asr	w4, w4, w5
	bl	"func_47"
	mov	x1, x22
	mov	x2, x0
	mov	x0, x21
	ldr	x3, [x29, 17208]
	str	x2, [x3]
	cmp	x2, #0
	mov	x21, x0
	cset	w0, ne
	sxtw	x0, w0
	mov	x22, x1
	mov	x1, #-2
	bl	"safe_mod_func_int64_t_s_s"
	mov	w2, w23
	mov	x1, x22
	sxtb	w0, w0
	mov	w23, w2
	mov	x2, #4288
	mov	x22, x1
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_mul_func_uint8_t_u_u"
	mov	w2, w23
	mov	x1, x22
	mov	w3, w0
	mov	x0, x21
	mov	x22, x1
	mov	x17, #17200
	add	x17, x29, x17
	ldr	w1, [x17]
	uxtb	w3, w3
	cmp	w3, w2
	mov	w23, w2
	mov	x2, #4730
	mov	x21, x0
	add	x0, x29, #80
	add	x0, x0, x2
	ldrh	w0, [x0]
	uxtb	w0, w0
	bl	"safe_rshift_func_int8_t_s_u"
	mov	w2, w23
	mov	x1, x22
	mov	w3, w0
	mov	x0, x21
	ldr	x4, [x29, 17192]
	sxtb	w3, w3
	str	w3, [x4]
	adrp	x3, "g_200"
	add	x3, x3, #:lo12:"g_200"
	ldr	x3, [x3]
	cmp	x3, x24
	beq	.L987
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #772
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1277"
	add	x0, x0, #:lo12:".ts.1277"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
.L987:
	mov	w23, w2
	adrp	x2, "g_647"
	add	x2, x2, #:lo12:"g_647"
	ldr	x2, [x2]
	ldr	x2, [x2]
	str	x2, [x29, 17176]
	mov	x22, x1
	mov	w1, #14
	mov	x21, x0
	mov	w0, #8130
	bl	"safe_lshift_func_int16_t_s_u"
	mov	w2, w23
	mov	x1, x22
	mov	x17, #17156
	add	x17, x29, x17
	str	w0, [x17]
	mov	x0, x21
	adrp	x3, "g_1525"
	add	x3, x3, #:lo12:"g_1525"
	ldr	x3, [x3]
	ldr	x3, [x3]
	ldr	x3, [x3]
	str	x3, [x29, 17184]
	mov	x4, #7676
	add	x3, x29, #80
	add	x3, x3, x4
	ldr	w3, [x3]
	cmp	w3, #0
	cset	w3, ne
	cmp	w3, #0
	beq	.L989
	mov	w3, #1
.L989:
	mov	x4, #6756
	mov	w23, w2
	add	x2, x29, #80
	add	x2, x2, x4
	ldr	w2, [x2]
	mov	w4, #10
	lsl	w2, w2, w4
	mov	w4, #10
	asr	w2, w2, w4
	cmp	w2, w3
	mov	x21, x0
	cset	w0, eq
	cmp	w0, #0
	beq	.L991
	mov	w0, #1
.L991:
	mov	x22, x1
	mov	w1, #65533
	bl	"safe_mul_func_int16_t_s_s"
	mov	w2, w23
	mov	w1, w0
	mov	x0, x21
	ldr	x3, [x29, 17184]
	sxth	w1, w1
	cmp	x3, #0
	mov	w23, w2
	cset	w2, eq
	mov	w3, #-1
	orr	w2, w2, w3
	cmp	w2, #1
	mov	x21, x0
	cset	w0, ne
	bl	"safe_rshift_func_uint8_t_u_u"
	mov	x1, x22
	mov	w2, w0
	mov	x0, x21
	uxtb	w2, w2
	cmp	x2, #1
	mov	x21, x0
	cset	w0, ls
	mov	x22, x1
	mov	w1, #9306
	movk	w1, #0x6381, lsl #16
	bl	"safe_lshift_func_uint16_t_u_s"
	uxth	w0, w0
	bl	"safe_unary_minus_func_uint64_t_u"
	mov	x1, x22
	mov	x0, x21
	mov	x21, x0
	adrp	x0, "g_646"
	add	x0, x0, #:lo12:"g_646"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x0, [x0]
	mov	x22, x1
	mov	x1, #0
	bl	"safe_sub_func_int64_t_s_s"
	mov	x1, x22
	sxth	w0, w0
	mov	x22, x1
	adrp	x1, "g_31"
	add	x1, x1, #:lo12:"g_31"
	ldrb	w1, [x1]
	bl	"safe_mul_func_int16_t_s_s"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	mov	w23, w2
	ldr	x2, [x29, 17176]
	mov	x22, x1
	ldr	x1, [x29, 16984]
	mov	x17, #17156
	add	x17, x29, x17
	ldr	w3, [x17]
	adrp	x4, "g_187"
	add	x4, x4, #:lo12:"g_187"
	ldr	w4, [x4]
	cmp	w4, w23
	cset	w4, hi
	sxth	w3, w3
	cmp	w3, w4
	mov	x21, x0
	cset	w0, gt
	sxtw	x0, w0
	str	x0, [x2]
	bl	"safe_sub_func_int64_t_s_s"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x26, [x29, 17112]
	mov	x3, #14756
	mov	x22, x1
	add	x1, x29, #80
	add	x1, x1, x3
	ldr	w1, [x1]
	eor	w1, w27, w1
	mov	w1, w1
	mov	w23, w2
	mov	x2, #10239
	orr	x1, x1, x2
	uxtb	w1, w1
	mov	x21, x0
	mov	w0, #1
	bl	"safe_div_func_int8_t_s_s"
	mov	w2, w23
	mov	x1, x22
	mov	w4, w0
	mov	x0, x21
	ldr	x3, [x29, 17096]
	ldr	x25, [x29, 17168]
	sxtb	w4, w4
	adrp	x5, "g_317"+24
	add	x5, x5, #:lo12:"g_317"+24
	str	w4, [x5]
	b	.L1016
.L992:
	mov	x20, x26
	mov	x19, x22
	mov	x1, #4799
	add	x0, x29, #80
	add	x0, x0, x1
	adrp	x3, "g_130"
	add	x3, x3, #:lo12:"g_130"
	mov	x1, #-5
	str	x1, [x3]
	mov	x3, #13592
	add	x1, x29, #80
	add	x22, x1, x3
	str	x22, [x29, 17160]
	cmp	x20, #0
	cset	w3, eq
	mov	x17, #17144
	add	x17, x29, x17
	str	w3, [x17]
	uxth	w1, w2
	mov	x17, #17148
	add	x17, x29, x17
	str	w1, [x17]
	cmp	x0, #0
	cset	w4, eq
	mov	x17, #17152
	add	x17, x29, x17
	str	w4, [x17]
	mov	w20, #8314
	movk	w20, #0x92d, lsl #16
	mov	x0, #-5
.L995:
	mov	w24, w7
	cmp	x0, #55
	bhi	.L1009
	mov	w21, w2
	mov	x2, #1008
	mov	w1, #0
	mov	x0, x22
	bl	memset
	mov	w7, w24
	mov	w2, w21
	mov	x17, #17144
	add	x17, x29, x17
	ldr	w3, [x17]
	mov	x1, #13592
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13608
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13616
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13624
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13648
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13664
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13680
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13688
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13696
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13704
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13720
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13728
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13736
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13752
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13760
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13768
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13776
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13792
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13808
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13824
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13832
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13840
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13864
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13880
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13896
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13904
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #13912
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13920
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13936
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13944
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13952
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13968
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #13976
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13984
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #13992
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14008
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14024
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14040
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14048
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14056
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14080
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14096
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14112
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14120
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14128
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14152
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14160
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14168
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14184
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14192
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14200
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14208
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14224
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14256
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14264
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14272
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14280
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14288
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14296
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14304
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14312
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14328
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14336
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14344
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14368
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14376
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14384
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14400
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14408
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14416
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14424
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14440
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14472
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14480
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14488
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14496
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14504
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14512
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14520
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14528
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14544
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #14552
	add	x0, x29, #80
	add	x1, x0, x1
	adrp	x0, "g_475"
	add	x0, x0, #:lo12:"g_475"
	str	x0, [x1]
	mov	x1, #14560
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14584
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #14592
	add	x0, x29, #80
	add	x0, x0, x1
	str	x23, [x0]
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w26, [x0]
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w0, #0
	mov	w21, w7
	cset	w7, ne
	cmp	w7, #0
	bne	.L1001
	mov	x1, #13520
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	x0, [x0]
	mov	w22, w2
	mov	x2, #13520
	add	x1, x29, #80
	add	x1, x1, x2
	str	x0, [x1]
	adrp	x1, "g_476"
	add	x1, x1, #:lo12:"g_476"
	cmp	x0, x1
	cset	w1, eq
	cmp	w1, #0
	bne	.L999
	adrp	x0, "g_896"
	add	x0, x0, #:lo12:"g_896"
	ldr	x1, [x0]
	mov	w0, #-7
	str	w0, [x1]
	adrp	x0, "g_1832"
	add	x0, x0, #:lo12:"g_1832"
	ldr	x25, [x0]
	mov	x1, #13568
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	x0, [x0]
	cmp	x25, x0
	cset	w0, eq
	mov	w1, #9
	bl	"safe_div_func_int16_t_s_s"
	sxth	x0, w0
	cmp	x0, #0
	cset	w0, eq
	mov	w1, #21900
	movk	w1, #0x428a, lsl #16
	bl	"safe_sub_func_uint32_t_u_u"
	mov	x17, #17148
	add	x17, x29, x17
	ldr	w1, [x17]
	uxth	w0, w0
	bl	"safe_mul_func_int16_t_s_s"
	sxtb	w1, w0
	mov	w0, #-113
	bl	"safe_mod_func_int8_t_s_s"
	sxtb	w0, w0
	cmp	w0, w22
	cset	w0, cs
	adrp	x1, "g_117"
	add	x1, x1, #:lo12:"g_117"
	strh	w0, [x1]
	adrp	x1, "g_35"
	add	x1, x1, #:lo12:"g_35"
	ldr	x1, [x1]
	uxth	w1, w1
	bl	"safe_mul_func_int16_t_s_s"
	adrp	x1, "g_1219"+24
	add	x1, x1, #:lo12:"g_1219"+24
	ldr	w1, [x1]
	sxth	w1, w1
	bl	"safe_div_func_int16_t_s_s"
	mov	x17, #17152
	add	x17, x29, x17
	ldr	w4, [x17]
	mov	w1, w27
	mov	w0, w4
	bl	"safe_mul_func_uint16_t_u_u"
	mov	w2, w22
	mov	x17, #17144
	add	x17, x29, x17
	ldr	w3, [x17]
	uxth	w0, w0
	mov	w22, w2
	mov	x2, #3840
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	cmp	w0, w1
	cset	w1, lt
.L999:
	mov	w0, w3
	bl	"safe_sub_func_uint16_t_u_u"
	mov	w7, w21
	ldr	x21, [x29, 17160]
	mov	w24, w7
	b	.L1002
.L1001:
	mov	w24, w7
	mov	w7, w21
	mov	x21, x22
	mov	w22, w2
.L1002:
	cmp	w24, #0
	bne	.L1004
	mov	w17, w7
	mov	w7, w24
	mov	w24, w17
	b	.L1005
.L1004:
	mov	x1, #6756
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w0, #0
	mov	w24, w7
	cset	w7, ne
.L1005:
	mov	w0, #10
	lsl	w0, w26, w0
	mov	w1, #10
	asr	w0, w0, w1
	and	w20, w0, w20
	sxtb	w0, w20
	mov	w1, w7
	bl	"safe_div_func_uint8_t_u_u"
	mov	w7, w24
	mov	w2, w22
	mov	x17, #17152
	add	x17, x29, x17
	ldr	w4, [x17]
	mov	x17, #17148
	add	x17, x29, x17
	ldr	w1, [x17]
	mov	x17, #17144
	add	x17, x29, x17
	ldr	w3, [x17]
	uxtb	w0, w0
	cmp	w0, w2
	cset	w0, ne
	mov	x6, #4072
	add	x5, x29, #80
	add	x5, x5, x6
	ldr	w5, [x5]
	orr	w0, w0, w5
	mov	x6, #4072
	add	x5, x29, #80
	add	x5, x5, x6
	str	w0, [x5]
	mov	x5, #6756
	add	x0, x29, #80
	add	x0, x0, x5
	ldr	w0, [x0]
	mov	w5, #10
	lsl	w0, w0, w5
	mov	w5, #10
	asr	w0, w0, w5
	mov	x6, #3840
	add	x5, x29, #80
	add	x5, x5, x6
	str	w0, [x5]
	adrp	x0, "g_130"
	add	x0, x0, #:lo12:"g_130"
	ldr	x0, [x0]
	mov	x5, #1
	add	x0, x0, x5
	adrp	x5, "g_130"
	add	x5, x5, #:lo12:"g_130"
	str	x0, [x5]
	mov	x22, x21
	b	.L995
.L1009:
	ldr	x24, [x29, 17128]
	ldr	x3, [x29, 17096]
	ldr	x26, [x29, 17112]
	ldr	x1, [x29, 16976]
	ldr	x19, [x29, 17120]
	ldr	x28, [x29, 16968]
	ldr	x0, [x29, 17136]
	ldr	x20, [x29, 16928]
	cmp	x25, x0
	cset	w4, cs
	cmp	w4, #0
	beq	.L1012
	cmp	x25, x3
	cset	w4, ls
.L1012:
	cmp	w4, #0
	bne	.L1014
	cmp	x25, #0
	cset	w4, eq
.L1014:
	cmp	w4, #0
	bne	.L1016
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #750
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1247"
	add	x0, x0, #:lo12:".ts.1247"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x3, [x29, 17096]
	ldr	x26, [x29, 17112]
.L1016:
	str	x25, [x29, 17104]
	adrp	x4, "g_200"
	add	x4, x4, #:lo12:"g_200"
	ldr	x4, [x4]
	cmp	x4, x24
	cset	w5, eq
	cmp	w5, #0
	bne	.L1018
	adrp	x5, "g_59"
	add	x5, x5, #:lo12:"g_59"
	cmp	x4, x5
	cset	w4, eq
	b	.L1019
.L1018:
	mov	w4, w5
.L1019:
	cmp	w4, #0
	bne	.L1021
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #777
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1288"
	add	x0, x0, #:lo12:".ts.1288"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x25, [x29, 17104]
	ldr	x3, [x29, 17096]
.L1021:
	cmp	x25, x0
	cset	w4, cs
	cmp	w4, #0
	beq	.L1023
	cmp	x25, x3
	cset	w4, ls
.L1023:
	cmp	w4, #0
	bne	.L1025
	cmp	x25, #0
	cset	w4, eq
.L1025:
	cmp	w4, #0
	bne	.L1027
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #779
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1247"
	add	x0, x0, #:lo12:".ts.1247"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x25, [x29, 17104]
	ldr	x3, [x29, 17096]
.L1027:
	str	x25, [x29, 17080]
	adrp	x4, "g_121"
	add	x4, x4, #:lo12:"g_121"
	ldr	x4, [x4]
	cmp	x4, #0
	cset	w5, eq
	cmp	w5, #0
	bne	.L1029
	cmp	x4, x24
	cset	w5, eq
.L1029:
	cmp	w5, #0
	bne	.L1031
	cmp	x26, x4
	cset	w4, eq
	b	.L1032
.L1031:
	mov	w4, w5
.L1032:
	cmp	w4, #0
	bne	.L1034
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #894
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1436"
	add	x0, x0, #:lo12:".ts.1436"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x25, [x29, 17080]
	ldr	x3, [x29, 17096]
.L1034:
	adrp	x4, "g_200"
	add	x4, x4, #:lo12:"g_200"
	ldr	x4, [x4]
	cmp	x4, x24
	cset	w5, eq
	cmp	w5, #0
	bne	.L1036
	adrp	x5, "g_59"
	add	x5, x5, #:lo12:"g_59"
	cmp	x4, x5
	cset	w4, eq
	b	.L1037
.L1036:
	mov	w4, w5
.L1037:
	cmp	w4, #0
	bne	.L1039
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #895
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1288"
	add	x0, x0, #:lo12:".ts.1288"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x25, [x29, 17080]
	ldr	x3, [x29, 17096]
.L1039:
	cmp	x25, x0
	cset	w21, cs
	mov	x17, #17088
	add	x17, x29, x17
	str	w21, [x17]
	cmp	x25, x3
	mov	w23, w21
	cset	w21, ls
	mov	x17, #17092
	add	x17, x29, x17
	str	w21, [x17]
	cmp	w23, #0
	bne	.L1041
	mov	w27, w23
	b	.L1042
.L1041:
	mov	w27, w21
.L1042:
	cmp	x25, #0
	cset	w22, eq
	mov	x17, #17060
	add	x17, x29, x17
	str	w22, [x17]
	cmp	w27, #0
	bne	.L1044
	mov	w27, w22
.L1044:
	cmp	w27, #0
	bne	.L1046
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w23, w2
	mov	w2, #898
	mov	x22, x1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x21, x0
	adrp	x0, ".ts.1247"
	add	x0, x0, #:lo12:".ts.1247"
	bl	"__assert_fail"
	mov	w2, w23
	mov	x1, x22
	mov	x0, x21
	ldr	x25, [x29, 17080]
	mov	x17, #17060
	add	x17, x29, x17
	ldr	w21, [x17]
	mov	w22, w21
	mov	x17, #17092
	add	x17, x29, x17
	ldr	w21, [x17]
	mov	x17, #17088
	add	x17, x29, x17
	ldr	w23, [x17]
.L1046:
	cmp	x28, #0
	cset	w3, eq
	cmp	w3, #0
	bne	.L1048
	cmp	x24, x28
	cset	w3, eq
.L1048:
	cmp	w3, #0
	bne	.L1050
	cmp	x26, x28
	cset	w3, eq
.L1050:
	cmp	w3, #0
	bne	.L1054
	cmp	x28, x20
	cset	w3, cs
	cmp	w3, #0
	bne	.L1053
	mov	w1, w3
	b	.L1055
.L1053:
	cmp	x28, x1
	cset	w1, ls
	b	.L1055
.L1054:
	mov	w1, w3
.L1055:
	cmp	w1, #0
	bne	.L1057
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w26, w2
	mov	w2, #900
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x22, x0
	adrp	x0, ".ts.1485"
	add	x0, x0, #:lo12:".ts.1485"
	bl	"__assert_fail"
	mov	w2, w26
	mov	x0, x22
	mov	w22, w21
	mov	x17, #17060
	add	x17, x29, x17
	ldr	w21, [x17]
	b	.L1058
.L1057:
	mov	w17, w22
	mov	w22, w21
	mov	w21, w17
.L1058:
	adrp	x1, "g_200"
	add	x1, x1, #:lo12:"g_200"
	ldr	x1, [x1]
	cmp	x1, x24
	cset	w3, eq
	cmp	w3, #0
	bne	.L1060
	adrp	x3, "g_59"
	add	x3, x3, #:lo12:"g_59"
	cmp	x1, x3
	cset	w1, eq
	b	.L1061
.L1060:
	mov	w1, w3
.L1061:
	cmp	w1, #0
	bne	.L1063
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w26, w2
	mov	w2, #904
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x24, x0
	adrp	x0, ".ts.1288"
	add	x0, x0, #:lo12:".ts.1288"
	bl	"__assert_fail"
	mov	w2, w26
	mov	x0, x24
.L1063:
	adrp	x1, "g_295"
	add	x1, x1, #:lo12:"g_295"
	ldr	x1, [x1]
	cmp	x1, #0
	cset	w3, eq
	cmp	w3, #0
	bne	.L1065
	adrp	x3, "g_1522"
	add	x3, x3, #:lo12:"g_1522"
	cmp	x1, x3
	cset	w1, eq
	b	.L1066
.L1065:
	mov	w1, w3
.L1066:
	cmp	w1, #0
	bne	.L1068
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w26, w2
	mov	w2, #905
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	mov	x24, x0
	adrp	x0, ".ts.801"
	add	x0, x0, #:lo12:".ts.801"
	bl	"__assert_fail"
	mov	w2, w26
	mov	x0, x24
.L1068:
	cmp	x25, x0
	bcs	.L1070
	mov	w22, w23
.L1070:
	cmp	w22, #0
	beq	.L1072
	mov	w21, w22
.L1072:
	cmp	w21, #0
	bne	.L1074
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w21, w2
	mov	w2, #906
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1247"
	add	x0, x0, #:lo12:".ts.1247"
	bl	"__assert_fail"
	mov	w2, w21
.L1074:
	adrp	x1, "g_1877"
	add	x1, x1, #:lo12:"g_1877"
	mov	w0, #0
	str	w0, [x1]
	mov	x1, #15064
	add	x0, x29, #80
	add	x9, x0, x1
	str	x9, [x29, 16992]
	mov	x1, #15120
	add	x0, x29, #80
	add	x10, x0, x1
	str	x10, [x29, 17000]
	mov	x1, #14996
	add	x0, x29, #80
	add	x23, x0, x1
	str	x23, [x29, 16936]
	mov	x1, #15024
	add	x0, x29, #80
	add	x24, x0, x1
	str	x24, [x29, 16944]
	mov	x1, #15028
	add	x0, x29, #80
	add	x25, x0, x1
	str	x25, [x29, 16952]
	cmp	w2, #0
	mov	x1, #15132
	add	x0, x29, #80
	add	x26, x0, x1
	mov	x1, #15536
	add	x0, x29, #80
	add	x3, x0, x1
	str	x3, [x29, 17008]
	mov	x1, #15776
	add	x0, x29, #80
	add	x4, x0, x1
	str	x4, [x29, 17016]
	mov	x1, #16684
	add	x0, x29, #80
	add	x5, x0, x1
	str	x5, [x29, 17024]
	mov	x1, #16764
	add	x0, x29, #80
	add	x6, x0, x1
	str	x6, [x29, 17032]
	mov	x1, #16800
	add	x0, x29, #80
	add	x7, x0, x1
	str	x7, [x29, 17040]
	mov	x1, #16672
	add	x0, x29, #80
	add	x21, x0, x1
	mov	x1, #16832
	add	x0, x29, #80
	add	x22, x0, x1
	mov	w0, #0
.L1076:
	cmp	w0, #3
	bhi	.L1122
	mov	x1, #14992
	add	x0, x29, #80
	add	x1, x0, x1
	mov	w0, #1
	str	w0, [x1]
	mov	x2, #56
	adrp	x1, .ci1510
	add	x1, x1, #:lo12:.ci1510
	mov	x0, x9
	bl	memcpy
	ldr	x10, [x29, 17000]
	mov	x2, #9
	adrp	x1, .ci1511
	add	x1, x1, #:lo12:.ci1511
	mov	x0, x10
	bl	memcpy
	mov	x17, #16964
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x7, [x29, 17040]
	ldr	x6, [x29, 17032]
	ldr	x5, [x29, 17024]
	ldr	x4, [x29, 17016]
	ldr	x3, [x29, 17008]
	ldr	x10, [x29, 17000]
	ldr	x9, [x29, 16992]
	ldr	x8, [x29, 16984]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x28, [x29, 16968]
	mov	w12, #0
.L1079:
	cmp	w12, #7
	bge	.L1086
	sxtw	x0, w12
	mov	x11, #4
	mul	x0, x0, x11
	add	x11, x23, x0
	mov	w0, #0
.L1082:
	cmp	w0, #1
	bge	.L1085
	sxtw	x13, w0
	mov	x14, #4
	mul	x13, x13, x14
	add	x14, x11, x13
	mov	w13, #18258
	movk	w13, #0x86c3, lsl #16
	str	w13, [x14]
	mov	w13, #1
	add	w0, w0, w13
	b	.L1082
.L1085:
	mov	w0, #1
	add	w12, w12, w0
	b	.L1079
.L1086:
	mov	w0, #0
.L1087:
	cmp	w0, #1
	bge	.L1090
	sxtw	x11, w0
	mov	x12, #4
	mul	x11, x11, x12
	add	x12, x24, x11
	mov	w11, #43744
	movk	w11, #0xbf58, lsl #16
	str	w11, [x12]
	mov	w11, #1
	add	w0, w0, w11
	b	.L1087
.L1090:
	mov	w0, #0
.L1091:
	cmp	w0, #8
	bge	.L1094
	sxtw	x11, w0
	mov	x12, #4
	mul	x11, x11, x12
	add	x12, x25, x11
	mov	w11, #7
	str	w11, [x12]
	mov	w11, #1
	add	w0, w0, w11
	b	.L1091
.L1094:
	cmp	w2, #0
	bne	.L1122
	mov	x1, #14992
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	cmp	w0, #0
	bne	.L1122
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxtb	w0, w0
	mov	x17, #17056
	add	x17, x29, x17
	str	w0, [x17]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x1, [x0]
	str	x1, [x29, 17064]
	adrp	x0, "g_895"
	add	x0, x0, #:lo12:"g_895"
	ldr	x0, [x0]
	ldr	x2, [x0]
	ldr	w0, [x2]
	mov	w1, #1
	sub	w1, w0, w1
	str	w1, [x2]
	mov	w1, #7798
	movk	w1, #0x2bb3, lsl #16
	bl	"safe_sub_func_uint32_t_u_u"
	mov	x1, #14992
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	sxth	w0, w0
	mov	w1, #0
	bl	"safe_lshift_func_uint16_t_u_s"
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	uxth	w0, w0
	str	x0, [x29, 17072]
	mov	x1, #7676
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	cmp	w27, w0
	cset	w1, ne
	mov	w0, #1
	bl	"safe_rshift_func_uint16_t_u_s"
	ldr	x0, [x29, 17072]
	ldr	x8, [x29, 16984]
	mov	x1, x8
	bl	"safe_mod_func_uint64_t_u_u"
	ldr	x1, [x29, 17064]
	mov	x17, #17056
	add	x17, x29, x17
	ldr	w0, [x17]
	ldr	x28, [x29, 16968]
	mov	x3, #4912
	add	x2, x29, #80
	add	x2, x2, x3
	str	x28, [x2]
	str	x28, [x1]
	mov	x2, #7660
	add	x1, x29, #80
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w3, w1, w2
	mov	w4, #0
	mov	x2, x28
	mov	w1, #14
	bl	"func_47"
	ldr	x1, [x29, 16976]
	str	x0, [x29, 17048]
	adrp	x2, "g_121"
	add	x2, x2, #:lo12:"g_121"
	ldr	x2, [x2]
	cmp	x2, x20
	cset	w3, cs
	cmp	w3, #0
	bne	.L1098
	mov	w2, w3
	b	.L1099
.L1098:
	cmp	x2, x1
	cset	w2, ls
.L1099:
	cmp	w2, #0
	bne	.L1101
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #961
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1359"
	add	x0, x0, #:lo12:".ts.1359"
	bl	"__assert_fail"
	ldr	x0, [x29, 17048]
	ldr	x1, [x29, 16976]
.L1101:
	cmp	x0, x20
	cset	w2, cs
	cmp	w2, #0
	bne	.L1103
	mov	w0, w2
	b	.L1104
.L1103:
	cmp	x0, x1
	cset	w0, ls
.L1104:
	cmp	w0, #0
	bne	.L1106
	adrp	x3, ".__func__.820"
	add	x3, x3, #:lo12:".__func__.820"
	mov	w2, #962
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1552"
	add	x0, x0, #:lo12:".ts.1552"
	bl	"__assert_fail"
.L1106:
	adrp	x1, "g_100"
	add	x1, x1, #:lo12:"g_100"
	mov	w0, #0
	str	w0, [x1]
	mov	w0, #0
.L1108:
	cmp	w0, #3
	bhi	.L1120
	mov	x2, #400
	adrp	x1, .ci1557
	add	x1, x1, #:lo12:.ci1557
	mov	x0, x26
	bl	memcpy
	ldr	x3, [x29, 17008]
	mov	x2, #240
	mov	w1, #0
	mov	x0, x3
	bl	memset
	ldr	x4, [x29, 17016]
	mov	x1, #15576
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15584
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15592
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15600
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15608
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15656
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15664
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15672
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15680
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15688
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15736
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15744
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15752
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15760
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x1, #15768
	add	x0, x29, #80
	add	x0, x0, x1
	str	x19, [x0]
	mov	x2, #896
	adrp	x1, .ci1558
	add	x1, x1, #:lo12:.ci1558
	mov	x0, x4
	bl	memcpy
	ldr	x5, [x29, 17024]
	mov	x2, #80
	adrp	x1, .ci1559
	add	x1, x1, #:lo12:.ci1559
	mov	x0, x5
	bl	memcpy
	ldr	x6, [x29, 17032]
	mov	x2, #36
	adrp	x1, .ci1560
	add	x1, x1, #:lo12:.ci1560
	mov	x0, x6
	bl	memcpy
	ldr	x7, [x29, 17040]
	mov	x2, #28
	adrp	x1, .ci1561
	add	x1, x1, #:lo12:.ci1561
	mov	x0, x7
	bl	memcpy
	mov	x17, #16964
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x7, [x29, 17040]
	ldr	x6, [x29, 17032]
	ldr	x5, [x29, 17024]
	ldr	x4, [x29, 17016]
	ldr	x3, [x29, 17008]
	ldr	x10, [x29, 17000]
	ldr	x9, [x29, 16992]
	ldr	x8, [x29, 16984]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x28, [x29, 16968]
	mov	w0, #0
.L1111:
	cmp	w0, #3
	bge	.L1114
	sxtw	x11, w0
	mov	x12, #4
	mul	x11, x11, x12
	add	x12, x21, x11
	mov	w11, #13378
	movk	w11, #0x7c59, lsl #16
	str	w11, [x12]
	mov	w11, #1
	add	w0, w0, w11
	b	.L1111
.L1114:
	mov	w0, #0
.L1115:
	cmp	w0, #2
	bge	.L1118
	sxtw	x11, w0
	mov	x12, #8
	mul	x11, x11, x12
	add	x12, x22, x11
	mov	x11, #6532
	movk	x11, #0xc3c4, lsl #16
	movk	x11, #0x4d59, lsl #32
	movk	x11, #0xa135, lsl #48
	str	x11, [x12]
	mov	w11, #1
	add	w0, w0, w11
	b	.L1115
.L1118:
	adrp	x0, "g_100"
	add	x0, x0, #:lo12:"g_100"
	ldr	w0, [x0]
	mov	w1, #1
	add	w0, w0, w1
	adrp	x1, "g_100"
	add	x1, x1, #:lo12:"g_100"
	str	w0, [x1]
	ldr	x25, [x29, 16952]
	ldr	x24, [x29, 16944]
	ldr	x23, [x29, 16936]
	ldr	x20, [x29, 16928]
	b	.L1108
.L1120:
	mov	x17, #16964
	add	x17, x29, x17
	ldr	w2, [x17]
	ldr	x7, [x29, 17040]
	ldr	x6, [x29, 17032]
	ldr	x5, [x29, 17024]
	ldr	x4, [x29, 17016]
	ldr	x3, [x29, 17008]
	ldr	x10, [x29, 17000]
	ldr	x9, [x29, 16992]
	ldr	x8, [x29, 16984]
	mov	x17, #16960
	add	x17, x29, x17
	ldr	w27, [x17]
	ldr	x1, [x29, 16976]
	ldr	x28, [x29, 16968]
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w0, [x0]
	mov	w11, #1
	add	w0, w0, w11
	adrp	x11, "g_1877"
	add	x11, x11, #:lo12:"g_1877"
	str	w0, [x11]
	b	.L1076
.L1122:
	mov	w0, #-9
	b	.L1124
.L1123:
	mov	x1, #7660
	add	x0, x29, #80
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	sxth	w0, w0
.L1124:
	ldr	x19, [x29, 17880]
	ldr	x20, [x29, 17872]
	ldr	x21, [x29, 17864]
	ldr	x22, [x29, 17856]
	ldr	x23, [x29, 17848]
	ldr	x24, [x29, 17840]
	ldr	x25, [x29, 17832]
	ldr	x26, [x29, 17824]
	ldr	x27, [x29, 17816]
	ldr	x28, [x29, 17808]
	ldp	x29, x30, [sp], 16
	mov	x16, #17872
	add	sp, sp, x16
	ret
.type "func_8", @function
.size "func_8", .-"func_8"

.data
.balign 1
".__func__.820":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 56
	.byte 0

.data
.balign 4
.ci821:
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295
	.int 4149482352
	.int 4149482352
	.int 4149482352
	.int 4294967295
	.int 3460870074
	.int 4294967290
	.int 4294967295
	.int 4294967290
	.int 3460870074
	.int 4294967295

.data
.balign 2
.ci822:
	.short 9
	.short 9
	.short 0
	.short 39953
	.short 0
	.short 9
	.short 9
	.short 60943
	.short 0
	.short 16430
	.short 0
	.short 60943
	.short 60943
	.short 0
	.short 46284
	.short 13029
	.short 46284
	.short 0
	.short 0
	.short 46284
	.short 13029

.data
.balign 1
.ci823:
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 37
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0
	.byte 186
	.byte 0

.data
.balign 4
.ci824:
	.int 7
	.int 2388110366
	.int 2388110366
	.int 7
	.int 2388110366
	.int 7
	.int 2388110366
	.int 1097551122
	.int 2388110366
	.int 2388110366
	.int 7
	.int 2388110366
	.int 2388110366
	.int 1097551122
	.int 1097551122
	.int 2388110366
	.int 1097551122
	.int 2388110366
	.int 1097551122
	.int 1097551122
	.int 2388110366
	.int 2388110366
	.int 7
	.int 2388110366

.data
.balign 4
.ci891:
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040
	.int 844807040

.data
.balign 4
.ci1046:
	.int 4294967292
	.int 4294967292
	.int 4294967292
	.int 4294967292

.data
.balign 4
.ci1047:
	.int 2172162
	.int 3
	.int 2172162
	.int 2172162
	.int 3
	.int 2172162
	.int 2172162

.data
.balign 4
.ci1100:
	.int 4294967295
	.int 4163852139
	.int 4294967295
	.int 723185953
	.int 3548040231
	.int 723185953
	.int 4294967295
	.int 4163852139
	.int 4294967295
	.int 723185953
	.int 3548040231
	.int 723185953
	.int 4294967295
	.int 4163852139

.data
.balign 4
.ci1140:
	.int 2963558835
	.int 2963558835
	.int 0
	.int 2963558835
	.int 2963558835
	.int 0
	.int 2963558835
	.int 2963558835
	.int 0
	.int 2963558835

.data
.balign 4
.ci1218:
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0

.data
.balign 4
.ci1249:
	.int 0
	.int 1126564033
	.int 2403008012
	.int 302471015
	.int 302471015
	.int 2403008012
	.int 1126564033
	.int 302471015
	.int 0
	.int 3491188941
	.int 306562981
	.int 2717558611
	.int 3766520837
	.int 3766520837
	.int 3491188941
	.int 0
	.int 302471015
	.int 0
	.int 3491188941
	.int 306562981
	.int 2717558611
	.int 2403008012
	.int 1126564033
	.int 0
	.int 306562981
	.int 181340972
	.int 306562981
	.int 0
	.int 2717558611
	.int 2717558611
	.int 3238067222
	.int 302471015
	.int 1126564033
	.int 3766520837
	.int 2403008012
	.int 2403008012
	.int 306562981
	.int 3238067222
	.int 3238067222
	.int 306562981
	.int 2403008012
	.int 181340972
	.int 3491188941
	.int 3238067222
	.int 0
	.int 181340972
	.int 1126564033
	.int 1126564033
	.int 181340972
	.int 302471015
	.int 2
	.int 302471015
	.int 3766520837
	.int 181340972
	.int 3491188941
	.int 2403008012
	.int 0
	.int 3238067222
	.int 3491188941
	.int 3766520837
	.int 3491188941
	.int 3238067222
	.int 0

.data
.balign 8
.ci1510:
	.quad 5576502055173220673
	.quad 5576502055173220673
	.quad 5576502055173220673
	.quad 5576502055173220673
	.quad 5576502055173220673
	.quad 5576502055173220673
	.quad 5576502055173220673

.data
.balign 1
.ci1511:
	.byte 18
	.byte 251
	.byte 18
	.byte 251
	.byte 18
	.byte 251
	.byte 18
	.byte 251
	.byte 18

.data
.balign 4
.ci1557:
	.int 594467907
	.int 0
	.int 594467907
	.int 1229094549
	.int 1229094549
	.int 0
	.int 4243676491
	.int 0
	.int 1
	.int 1
	.int 594467907
	.int 0
	.int 594467907
	.int 1229094549
	.int 1229094549
	.int 0
	.int 4243676491
	.int 0
	.int 1
	.int 1
	.int 594467907
	.int 0
	.int 594467907
	.int 1229094549
	.int 1229094549
	.int 0
	.int 4243676491
	.int 0
	.int 1
	.int 1
	.int 594467907
	.int 0
	.int 594467907
	.int 1229094549
	.int 1229094549
	.int 0
	.int 4243676491
	.int 0
	.int 1
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0
	.int 1729395287
	.int 1
	.int 1729395287
	.int 594467907
	.int 594467907
	.int 3346454836
	.int 3
	.int 3346454836
	.int 0
	.int 0

.data
.balign 8
.ci1558:
	.quad -3489825835990998762
	.quad -3489825835990998762
	.quad 1051718731215481711
	.quad 2
	.quad -1
	.quad 9
	.quad 2
	.quad -1
	.quad -1
	.quad -3489825835990998762
	.quad 6247170347406557580
	.quad -4031778814703058099
	.quad -1
	.quad -8
	.quad -4031778814703058099
	.quad -1
	.quad -3489825835990998762
	.quad -1
	.quad 6247170347406557580
	.quad 2
	.quad -8
	.quad -8
	.quad 2
	.quad 6247170347406557580
	.quad -3489825835990998762
	.quad -3489825835990998762
	.quad 1051718731215481711
	.quad 2
	.quad -1
	.quad 9
	.quad 2
	.quad -1
	.quad -1
	.quad -3489825835990998762
	.quad 6247170347406557580
	.quad -4031778814703058099
	.quad -1
	.quad -8
	.quad -4031778814703058099
	.quad -1
	.quad -3489825835990998762
	.quad -1
	.quad 6247170347406557580
	.quad 2
	.quad -8
	.quad -8
	.quad 2
	.quad 6247170347406557580
	.quad -3489825835990998762
	.quad -3489825835990998762
	.quad 1051718731215481711
	.quad 2
	.quad -1
	.quad 9
	.quad 2
	.quad -1
	.quad -1
	.quad -3489825835990998762
	.quad 6247170347406557580
	.quad -4031778814703058099
	.quad -1
	.quad -8
	.quad -4031778814703058099
	.quad -1
	.quad -3489825835990998762
	.quad -1
	.quad 6247170347406557580
	.quad 2
	.quad -8
	.quad -8
	.quad 2
	.quad 6247170347406557580
	.quad -3489825835990998762
	.quad -3489825835990998762
	.quad 1051718731215481711
	.quad 2
	.quad -1
	.quad 9
	.quad 2
	.quad -1
	.quad -1
	.quad -3489825835990998762
	.quad 6247170347406557580
	.quad -4031778814703058099
	.quad -1
	.quad -8
	.quad -4031778814703058099
	.quad -1
	.quad -3489825835990998762
	.quad -1
	.quad 6247170347406557580
	.quad 2
	.quad -8
	.quad -8
	.quad 2
	.quad 6247170347406557580
	.quad -3489825835990998762
	.quad -3489825835990998762
	.quad 1051718731215481711
	.quad -4031778814703058099
	.quad -8
	.quad -1
	.quad -4031778814703058099
	.quad 6247170347406557580
	.quad 6
	.quad -1
	.quad 1051718731215481711
	.quad 3
	.quad -8
	.quad 9
	.quad 3
	.quad 6247170347406557580

.data
.balign 2
.ci1559:
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283
	.short 64586
	.short 14283
	.short 65535
	.short 65535
	.short 14283

.data
.balign 4
.ci1560:
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295

.data
.balign 4
.ci1561:
	.int 0
	.int 4294967294
	.int 0
	.int 0
	.int 4294967294
	.int 0
	.int 0

.text
.balign 16
"func_19":
	hint	#34
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	mov	x2, #0
	add	x0, x29, #16
	add	x0, x0, x2
	str	x1, [x0]
	mov	x1, #4
	add	x0, x29, #24
	add	x0, x0, x1
	mov	x2, #0
	add	x1, x29, #16
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	x2, #0
	add	x2, x0, x2
	str	w1, [x2]
	mov	x1, #0
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	x2, #0
	add	x1, x29, #24
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #0
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	x0, [x0]
	ldp	x29, x30, [sp], 32
	ret
.type "func_19", @function
.size "func_19", .-"func_19"

.text
.balign 16
"func_23":
	hint	#34
	sub	sp, sp, #2704
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	str	x19, [x29, 2712]
	str	x20, [x29, 2704]
	str	x21, [x29, 2696]
	str	x22, [x29, 2688]
	str	x23, [x29, 2680]
	str	x24, [x29, 2672]
	str	x25, [x29, 2664]
	str	x26, [x29, 2656]
	str	x27, [x29, 2648]
	str	x0, [x29, 2608]
	mov	x2, #28
	adrp	x1, .ci1582
	add	x1, x1, #:lo12:.ci1582
	mov	x19, x0
	add	x0, x29, #16
	bl	memcpy
	mov	x0, x19
	mov	x2, #32
	add	x1, x29, #16
	add	x2, x1, x2
	mov	x1, #0
	str	x1, [x2]
	mov	x2, #40
	add	x1, x29, #16
	add	x4, x1, x2
	str	x4, [x29, 2616]
	adrp	x1, "g_200"
	add	x1, x1, #:lo12:"g_200"
	str	x1, [x4]
	mov	x1, #48
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #6
	adrp	x1, .ci1583
	add	x1, x1, #:lo12:.ci1583
	bl	memcpy
	mov	x0, x19
	mov	x1, #54
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #225
	adrp	x1, .ci1584
	add	x1, x1, #:lo12:.ci1584
	bl	memcpy
	mov	x0, x19
	mov	x1, #280
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #144
	adrp	x1, .ci1585
	add	x1, x1, #:lo12:.ci1585
	bl	memcpy
	mov	x0, x19
	mov	x1, #424
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #8
	adrp	x1, .ci1586
	add	x1, x1, #:lo12:.ci1586
	bl	memcpy
	mov	x0, x19
	mov	x1, #432
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #576
	adrp	x1, .ci1587
	add	x1, x1, #:lo12:.ci1587
	bl	memcpy
	mov	x0, x19
	mov	x1, #1008
	mov	x19, x0
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #1008
	adrp	x1, .ci1588
	add	x1, x1, #:lo12:.ci1588
	bl	memcpy
	mov	x0, x19
	adrp	x2, "g_26"
	add	x2, x2, #:lo12:"g_26"
	mov	x1, #0
	str	x1, [x2]
	mov	x2, #2016
	add	x1, x29, #16
	add	x22, x1, x2
	mov	x2, #2088
	add	x1, x29, #16
	add	x23, x1, x2
	mov	x2, #2144
	add	x1, x29, #16
	add	x24, x1, x2
	mov	x2, #2208
	add	x1, x29, #16
	add	x25, x1, x2
	mov	x2, #2568
	add	x1, x29, #16
	add	x27, x1, x2
	str	x27, [x29, 2624]
	mov	x2, #2056
	add	x1, x29, #16
	add	x19, x1, x2
	mov	x2, #2080
	add	x1, x29, #16
	add	x20, x1, x2
	mov	x2, #2528
	add	x1, x29, #16
	add	x21, x1, x2
	mov	x1, #0
.L1129:
	cmp	x1, #13
	bhi	.L1152
	mov	x2, #40
	adrp	x1, .ci1593
	add	x1, x1, #:lo12:.ci1593
	mov	x26, x0
	mov	x0, x22
	bl	memcpy
	mov	x0, x26
	mov	x2, #2072
	add	x1, x29, #16
	add	x2, x1, x2
	mov	x1, #0
	str	x1, [x2]
	mov	x2, #48
	mov	w1, #0
	mov	x26, x0
	mov	x0, x23
	bl	memset
	mov	x0, x26
	mov	x2, #2096
	add	x1, x29, #16
	add	x2, x1, x2
	adrp	x1, "g_771"
	add	x1, x1, #:lo12:"g_771"
	str	x1, [x2]
	mov	x2, #2104
	add	x1, x29, #16
	add	x2, x1, x2
	adrp	x1, "g_771"
	add	x1, x1, #:lo12:"g_771"
	str	x1, [x2]
	mov	x2, #2120
	add	x1, x29, #16
	add	x2, x1, x2
	adrp	x1, "g_771"
	add	x1, x1, #:lo12:"g_771"
	str	x1, [x2]
	mov	x2, #2128
	add	x1, x29, #16
	add	x2, x1, x2
	adrp	x1, "g_771"
	add	x1, x1, #:lo12:"g_771"
	str	x1, [x2]
	mov	x2, #2136
	add	x1, x29, #16
	add	x2, x1, x2
	mov	w1, #21998
	strh	w1, [x2]
	mov	x2, #64
	adrp	x1, .ci1594
	add	x1, x1, #:lo12:.ci1594
	mov	x26, x0
	mov	x0, x24
	bl	memcpy
	mov	x0, x26
	mov	x2, #320
	adrp	x1, .ci1595
	add	x1, x1, #:lo12:.ci1595
	mov	x26, x0
	mov	x0, x25
	bl	memcpy
	mov	x0, x26
	ldr	x27, [x29, 2624]
	mov	x2, #4
	mov	w1, #0
	mov	x26, x0
	mov	x0, x27
	bl	memset
	mov	x0, x26
	ldr	x26, [x29, 2624]
	ldr	x4, [x29, 2616]
	mov	x2, #2568
	add	x1, x29, #16
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #-4194304
	and	w1, w1, w2
	mov	w2, #27964
	movk	w2, #0xb, lsl #16
	orr	w1, w1, w2
	mov	x3, #2568
	add	x2, x29, #16
	add	x2, x2, x3
	str	w1, [x2]
	mov	w3, #0
.L1132:
	cmp	w3, #1
	bge	.L1139
	sxtw	x1, w3
	mov	x2, #16
	mul	x1, x1, x2
	add	x2, x19, x1
	mov	w1, #0
.L1135:
	cmp	w1, #4
	bge	.L1138
	sxtw	x5, w1
	mov	x6, #4
	mul	x5, x5, x6
	add	x6, x2, x5
	mov	w5, #51552
	movk	w5, #0x9d83, lsl #16
	str	w5, [x6]
	mov	w5, #1
	add	w1, w1, w5
	b	.L1135
.L1138:
	mov	w1, #1
	add	w3, w3, w1
	b	.L1132
.L1139:
	mov	w1, #0
.L1140:
	cmp	w1, #1
	bge	.L1143
	sxtw	x2, w1
	mov	x3, #8
	mul	x2, x2, x3
	add	x3, x20, x2
	mov	x2, #-1
	str	x2, [x3]
	mov	w2, #1
	add	w1, w1, w2
	b	.L1140
.L1143:
	mov	w1, #0
.L1144:
	cmp	w1, #5
	bge	.L1147
	sxtw	x2, w1
	mov	x3, #8
	mul	x2, x2, x3
	add	x3, x21, x2
	adrp	x2, "g_146"
	add	x2, x2, #:lo12:"g_146"
	str	x2, [x3]
	mov	w2, #1
	add	w1, w1, w2
	b	.L1144
.L1147:
	adrp	x0, "g_31"
	add	x0, x0, #:lo12:"g_31"
	ldrb	w0, [x0]
	cmp	w0, #0
	bne	.L1151
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	x1, #31850
	movk	x1, #0x95ed, lsl #16
	and	x0, x0, x1
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	str	w0, [x1]
	adrp	x0, "g_26"
	add	x0, x0, #:lo12:"g_26"
	ldr	x0, [x0]
	uxth	w0, w0
	mov	w1, #9
	bl	"safe_add_func_int16_t_s_s"
	sxth	x0, w0
	adrp	x1, "g_26"
	add	x1, x1, #:lo12:"g_26"
	str	x0, [x1]
	mov	x1, x0
	ldr	x0, [x29, 2608]
	b	.L1129
.L1151:
	ldr	x4, [x29, 2616]
	ldr	x0, [x29, 2608]
	b	.L1153
.L1152:
	ldr	x4, [x29, 2616]
.L1153:
	adrp	x2, "g_702"
	add	x2, x2, #:lo12:"g_702"
	mov	w1, #6
	str	w1, [x2]
	mov	x2, #2576
	add	x1, x29, #16
	add	x19, x1, x2
	mov	x2, #2584
	add	x1, x29, #16
	add	x20, x1, x2
	adrp	x1, "g_199"
	add	x1, x1, #:lo12:"g_199"
	cmp	x4, x1
	cset	w21, ne
	uxth	w22, w0
	mov	w1, #6
.L1155:
	cmp	w1, #15
	bne	.L1165
	mov	x2, #2584
	add	x1, x29, #16
	add	x2, x1, x2
	mov	w1, #21597
	movk	w1, #0x4c39, lsl #16
	str	w1, [x2]
	mov	w1, #0
.L1158:
	cmp	w1, #1
	bge	.L1161
	sxtw	x2, w1
	mov	x3, #8
	mul	x2, x2, x3
	add	x3, x19, x2
	mov	x2, #0
	str	x2, [x3]
	mov	w2, #1
	add	w1, w1, w2
	b	.L1158
.L1161:
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	ldr	x23, [x1]
	adrp	x1, "g_147"
	add	x1, x1, #:lo12:"g_147"
	ldr	x25, [x1]
	mov	w1, w21
	mov	x24, x0
	mov	w0, #36219
	movk	w0, #0xa59c, lsl #16
	bl	"safe_add_func_uint32_t_u_u"
	mov	x17, x0
	mov	x0, x24
	mov	x24, x17
	adrp	x1, "g_313"
	add	x1, x1, #:lo12:"g_313"
	ldrh	w1, [x1]
	mov	w2, #1
	orr	w1, w1, w2
	sxth	w1, w1
	adrp	x2, "g_313"
	add	x2, x2, #:lo12:"g_313"
	strh	w1, [x2]
	uxth	w1, w1
	mov	x2, #36008
	cmp	x1, x2
	cset	w1, ge
	cmp	w1, #0
	beq	.L1163
	adrp	x1, "g_648"
	add	x1, x1, #:lo12:"g_648"
	ldr	x1, [x1]
	ldr	x1, [x1]
	cmp	x1, #0
	cset	w1, ne
.L1163:
	mov	x26, x0
	mov	w0, w22
	bl	"safe_rshift_func_int16_t_s_s"
	mov	x2, #2584
	add	x1, x29, #16
	add	x1, x1, x2
	ldr	w1, [x1]
	bl	"safe_lshift_func_uint16_t_u_u"
	mov	x0, x26
	mov	w1, w24
	cmn	x1, #1
	mov	x24, x0
	cset	w0, lt
	strb	w0, [x25]
	mov	x2, #2584
	add	x1, x29, #16
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	mov	w4, w24
	mov	w3, w24
	mov	x2, x20
	bl	"func_47"
	mov	x1, x0
	mov	x0, x24
	str	x1, [x23]
	mov	x23, x0
	adrp	x0, "g_702"
	add	x0, x0, #:lo12:"g_702"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x1, #9
	bl	"safe_add_func_uint64_t_u_u"
	mov	x1, x0
	mov	x0, x23
	adrp	x2, "g_702"
	add	x2, x2, #:lo12:"g_702"
	str	w1, [x2]
	b	.L1155
.L1165:
	adrp	x1, "g_187"
	add	x1, x1, #:lo12:"g_187"
	str	w0, [x1]
	mov	w0, #0
	ldr	x19, [x29, 2712]
	ldr	x20, [x29, 2704]
	ldr	x21, [x29, 2696]
	ldr	x22, [x29, 2688]
	ldr	x23, [x29, 2680]
	ldr	x24, [x29, 2672]
	ldr	x25, [x29, 2664]
	ldr	x26, [x29, 2656]
	ldr	x27, [x29, 2648]
	ldp	x29, x30, [sp], 16
	add	sp, sp, #2704
	ret
.type "func_23", @function
.size "func_23", .-"func_23"

.data
.balign 4
.ci1582:
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 4294967295

.data
.balign 1
.ci1583:
	.byte 177
	.byte 177
	.byte 177
	.byte 177
	.byte 177
	.byte 177

.data
.balign 1
.ci1584:
	.byte 72057594037927931
	.byte 209
	.byte 0
	.byte 3
	.byte 0
	.byte 1
	.byte 127
	.byte 1
	.byte 72057594037927926
	.byte 0
	.byte 59
	.byte 126
	.byte 21
	.byte 3
	.byte 209
	.byte 72057594037927935
	.byte 3
	.byte 55
	.byte 31
	.byte 5
	.byte 3
	.byte 59
	.byte 1
	.byte 235
	.byte 1
	.byte 8
	.byte 1
	.byte 30
	.byte 0
	.byte 72057594037927934
	.byte 72057594037927930
	.byte 72057594037927935
	.byte 1
	.byte 0
	.byte 1
	.byte 190
	.byte 72057594037927935
	.byte 53
	.byte 209
	.byte 126
	.byte 6
	.byte 31
	.byte 71
	.byte 1
	.byte 1
	.byte 5
	.byte 27
	.byte 5
	.byte 21
	.byte 1
	.byte 21
	.byte 1
	.byte 245
	.byte 72057594037927927
	.byte 59
	.byte 59
	.byte 72057594037927930
	.byte 101
	.byte 1
	.byte 223
	.byte 9
	.byte 0
	.byte 245
	.byte 59
	.byte 101
	.byte 2
	.byte 0
	.byte 5
	.byte 72057594037927935
	.byte 150
	.byte 4
	.byte 72057594037927932
	.byte 71
	.byte 72057594037927930
	.byte 63
	.byte 1
	.byte 72057594037927933
	.byte 53
	.byte 6
	.byte 31
	.byte 72057594037927928
	.byte 199
	.byte 1
	.byte 150
	.byte 72057594037927931
	.byte 0
	.byte 71
	.byte 30
	.byte 72057594037927928
	.byte 9
	.byte 72057594037927933
	.byte 6
	.byte 1
	.byte 66
	.byte 176
	.byte 117
	.byte 72057594037927931
	.byte 55
	.byte 0
	.byte 105
	.byte 22
	.byte 150
	.byte 21
	.byte 2
	.byte 153
	.byte 63
	.byte 72057594037927935
	.byte 1
	.byte 101
	.byte 6
	.byte 8
	.byte 27
	.byte 72057594037927934
	.byte 72057594037927934
	.byte 133
	.byte 2
	.byte 17
	.byte 27
	.byte 3
	.byte 223
	.byte 1
	.byte 9
	.byte 106
	.byte 8
	.byte 1
	.byte 52
	.byte 4
	.byte 55
	.byte 0
	.byte 150
	.byte 9
	.byte 72057594037927929
	.byte 72057594037927926
	.byte 72057594037927928
	.byte 72057594037927935
	.byte 1
	.byte 0
	.byte 235
	.byte 214
	.byte 3
	.byte 71
	.byte 53
	.byte 117
	.byte 72057594037927928
	.byte 72057594037927930
	.byte 17
	.byte 127
	.byte 127
	.byte 17
	.byte 0
	.byte 127
	.byte 5
	.byte 161
	.byte 209
	.byte 101
	.byte 105
	.byte 72057594037927935
	.byte 1
	.byte 0
	.byte 72057594037927932
	.byte 0
	.byte 1
	.byte 0
	.byte 209
	.byte 2
	.byte 63
	.byte 72057594037927931
	.byte 1
	.byte 17
	.byte 141
	.byte 72057594037927929
	.byte 1
	.byte 1
	.byte 72057594037927928
	.byte 63
	.byte 1
	.byte 31
	.byte 223
	.byte 214
	.byte 224
	.byte 161
	.byte 1
	.byte 72057594037927935
	.byte 72057594037927928
	.byte 214
	.byte 1
	.byte 117
	.byte 9
	.byte 0
	.byte 190
	.byte 72057594037927935
	.byte 88
	.byte 1
	.byte 8
	.byte 52
	.byte 72057594037927935
	.byte 72057594037927935
	.byte 153
	.byte 3
	.byte 0
	.byte 190
	.byte 72057594037927927
	.byte 7
	.byte 72057594037927934
	.byte 63
	.byte 72057594037927928
	.byte 30
	.byte 71
	.byte 0
	.byte 252
	.byte 72057594037927927
	.byte 30
	.byte 2
	.byte 127
	.byte 0
	.byte 72057594037927931
	.byte 72057594037927927
	.byte 63
	.byte 6
	.byte 161
	.byte 0
	.byte 72057594037927935
	.byte 88
	.byte 72057594037927927
	.byte 27

.data
.balign 4
.ci1585:
	.int 3159852991
	.int 4294967295
	.int 1981931733
	.int 538446402
	.int 4063953527
	.int 0
	.int 1280933745
	.int 1395286978
	.int 1942949313
	.int 4294967295
	.int 292034568
	.int 1395286978
	.int 357135500
	.int 0
	.int 357135500
	.int 1395286978
	.int 292034568
	.int 4294967295
	.int 4063953527
	.int 4294967295
	.int 3042992986
	.int 0
	.int 1280933745
	.int 357135500
	.int 0
	.int 1981931733
	.int 292034568
	.int 4294967295
	.int 357135500
	.int 0
	.int 4294967287
	.int 4294967287
	.int 0
	.int 357135500
	.int 4294967295
	.int 538446402

.data
.balign 4
.ci1586:
	.int 4194303
	.int 4194303

.data
.balign 8
.ci1587:
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad -1
	.quad 3279348190485738222
	.quad 0
	.quad 3279348190485738222
	.quad -1
	.quad -5317258569845208791
	.quad -1
	.quad 3279348190485738222
	.quad 0
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad 1
	.quad 1
	.quad -3534528445530016496
	.quad -1
	.quad 3279348190485738222
	.quad 0
	.quad 3279348190485738222
	.quad -1
	.quad -5317258569845208791
	.quad -1
	.quad 3279348190485738222
	.quad 0
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 2
	.quad 0
	.quad -1
	.quad 0
	.quad 2
	.quad 3279348190485738222
	.quad 2
	.quad 0
	.quad -1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 1
	.quad 2
	.quad 0
	.quad -1
	.quad 0
	.quad 2
	.quad 3279348190485738222
	.quad 2
	.quad 0
	.quad -1

.data
.balign 4
.ci1588:
	.int 4061662058
	.int 4061662058
	.int 4294967295
	.int 3618418808
	.int 2117608283
	.int 4294967295
	.int 2117608283
	.int 462952503
	.int 4294967288
	.int 1
	.int 4294967295
	.int 4294967295
	.int 4061662058
	.int 2117608283
	.int 4294967288
	.int 1296126132
	.int 4061662058
	.int 4294967295
	.int 4294967295
	.int 1296126132
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 8
	.int 4294967295
	.int 4294967295
	.int 8
	.int 1296126132
	.int 2117608283
	.int 2366647667
	.int 4061662058
	.int 4294967294
	.int 4294967295
	.int 1
	.int 2117608283
	.int 6
	.int 2117608283
	.int 4294967295
	.int 4294967288
	.int 3618418808
	.int 4294967295
	.int 4294967294
	.int 4061662058
	.int 1296126132
	.int 4294967288
	.int 2117608283
	.int 4061662058
	.int 6
	.int 4294967295
	.int 2117608283
	.int 4294967295
	.int 0
	.int 4294967295
	.int 2366647667
	.int 4294967295
	.int 462952503
	.int 8
	.int 2117608283
	.int 2117608283
	.int 8
	.int 4061662058
	.int 4061662058
	.int 4294967295
	.int 3618418808
	.int 2117608283
	.int 4294967295
	.int 2117608283
	.int 462952503
	.int 4294967288
	.int 1
	.int 4294967295
	.int 4294967295
	.int 4061662058
	.int 2117608283
	.int 4294967288
	.int 1296126132
	.int 4061662058
	.int 4294967295
	.int 4294967295
	.int 1296126132
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 8
	.int 4294967295
	.int 4294967295
	.int 8
	.int 1296126132
	.int 2117608283
	.int 2366647667
	.int 4061662058
	.int 4294967294
	.int 4294967295
	.int 1
	.int 2117608283
	.int 6
	.int 2117608283
	.int 4294967295
	.int 4294967288
	.int 3618418808
	.int 4294967295
	.int 4294967294
	.int 4061662058
	.int 1296126132
	.int 4294967288
	.int 2117608283
	.int 4061662058
	.int 6
	.int 4294967295
	.int 2117608283
	.int 4294967295
	.int 0
	.int 4294967295
	.int 2366647667
	.int 4294967295
	.int 462952503
	.int 8
	.int 2117608283
	.int 2117608283
	.int 8
	.int 4061662058
	.int 4061662058
	.int 4294967295
	.int 3618418808
	.int 2117608283
	.int 4294967295
	.int 2117608283
	.int 462952503
	.int 4294967288
	.int 1
	.int 4294967295
	.int 4294967295
	.int 4061662058
	.int 2117608283
	.int 4294967288
	.int 1296126132
	.int 4061662058
	.int 4294967295
	.int 4294967295
	.int 1296126132
	.int 4294967295
	.int 4294967295
	.int 4294967295
	.int 8
	.int 4294967295
	.int 4294967295
	.int 8
	.int 1296126132
	.int 2117608283
	.int 2366647667
	.int 4061662058
	.int 4294967294
	.int 4294967295
	.int 1
	.int 2117608283
	.int 1296126132
	.int 4294967295
	.int 1
	.int 462952503
	.int 215254365
	.int 1
	.int 4294967295
	.int 4294967295
	.int 2444979275
	.int 462952503
	.int 4294967295
	.int 4294967295
	.int 1296126132
	.int 4
	.int 4294967295
	.int 0
	.int 4294967290
	.int 1
	.int 1
	.int 4
	.int 1420469742
	.int 3618418808
	.int 4294967295
	.int 4294967295
	.int 3618418808
	.int 4294967295
	.int 4294967295
	.int 0
	.int 215254365
	.int 4294967295
	.int 2117608283
	.int 4294967295
	.int 1420469742
	.int 462952503
	.int 4294967290
	.int 1
	.int 0
	.int 4294967295
	.int 4294967295
	.int 462952503
	.int 2444979275
	.int 4294967295
	.int 2117608283
	.int 4
	.int 2444979275
	.int 0
	.int 4
	.int 1
	.int 3618418808
	.int 4
	.int 1
	.int 3618418808
	.int 2444979275
	.int 4294967295
	.int 1
	.int 4294967295
	.int 2573005736
	.int 0
	.int 4294967290
	.int 4294967295
	.int 1296126132
	.int 4294967295
	.int 1
	.int 462952503
	.int 215254365
	.int 1
	.int 4294967295
	.int 4294967295
	.int 2444979275
	.int 462952503
	.int 4294967295
	.int 4294967295
	.int 1296126132
	.int 4
	.int 4294967295
	.int 0
	.int 4294967290
	.int 1
	.int 1
	.int 4
	.int 1420469742
	.int 3618418808
	.int 4294967295
	.int 4294967295
	.int 3618418808
	.int 4294967295
	.int 4294967295
	.int 0
	.int 215254365
	.int 4294967295
	.int 2117608283
	.int 4294967295
	.int 1420469742
	.int 462952503
	.int 4294967290
	.int 1
	.int 0

.data
.balign 1
.ci1593:
	.byte 1
	.byte 255
	.byte 255
	.byte 1
	.byte 4
	.byte 0
	.byte 4
	.byte 1
	.byte 255
	.byte 255
	.byte 4
	.byte 255
	.byte 247
	.byte 255
	.byte 255
	.byte 247
	.byte 255
	.byte 4
	.byte 255
	.byte 247
	.byte 0
	.byte 1
	.byte 255
	.byte 1
	.byte 0
	.byte 247
	.byte 247
	.byte 0
	.byte 1
	.byte 255
	.byte 4
	.byte 4
	.byte 255
	.byte 0
	.byte 0
	.byte 0
	.byte 255
	.byte 4
	.byte 4
	.byte 255

.data
.balign 8
.ci1594:
	.quad 8359375500616886880
	.quad 4402964775762120674
	.quad 4402964775762120674
	.quad 8359375500616886880
	.quad 4402964775762120674
	.quad 4402964775762120674
	.quad 8359375500616886880
	.quad 4402964775762120674

.data
.balign 4
.ci1595:
	.int 427078444
	.int 2749199522
	.int 3220909407
	.int 100451858
	.int 555074048
	.int 1579453971
	.int 3336020467
	.int 5
	.int 3220909407
	.int 5
	.int 3336020467
	.int 1579453971
	.int 555074048
	.int 100451858
	.int 3220909407
	.int 2749199522
	.int 427078444
	.int 1579453971
	.int 427078444
	.int 2749199522
	.int 3220909407
	.int 100451858
	.int 555074048
	.int 1579453971
	.int 3336020467
	.int 5
	.int 3220909407
	.int 5
	.int 3336020467
	.int 1579453971
	.int 555074048
	.int 100451858
	.int 3220909407
	.int 2749199522
	.int 427078444
	.int 1579453971
	.int 427078444
	.int 2749199522
	.int 3220909407
	.int 100451858
	.int 2353663665
	.int 272635521
	.int 3220909407
	.int 4294967295
	.int 3457312996
	.int 4294967295
	.int 3220909407
	.int 272635521
	.int 2353663665
	.int 4294967292
	.int 3457312996
	.int 1579453971
	.int 4294967292
	.int 272635521
	.int 4294967292
	.int 1579453971
	.int 3457312996
	.int 4294967292
	.int 2353663665
	.int 272635521
	.int 3220909407
	.int 4294967295
	.int 3457312996
	.int 4294967295
	.int 3220909407
	.int 272635521
	.int 2353663665
	.int 4294967292
	.int 3457312996
	.int 1579453971
	.int 4294967292
	.int 272635521
	.int 4294967292
	.int 1579453971
	.int 3457312996
	.int 4294967292
	.int 2353663665
	.int 272635521
	.int 3220909407
	.int 4294967295

.text
.balign 16
"func_37":
	hint	#34
	mov	x16, #4944
	sub	sp, sp, x16
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	add	x1, x29, #16
	mov	x0, #34993
	movk	x0, #0x90bb, lsl #16
	movk	x0, #0x8767, lsl #32
	movk	x0, #0x2b8d, lsl #48
	str	x0, [x1]
	mov	x1, #36
	add	x0, x29, #16
	add	x1, x0, x1
	mov	w0, #63634
	movk	w0, #0x9606, lsl #16
	str	w0, [x1]
	mov	x1, #40
	add	x0, x29, #16
	add	x1, x0, x1
	mov	w0, #41974
	movk	w0, #0x9c2a, lsl #16
	str	w0, [x1]
	mov	x1, #44
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #240
	adrp	x1, .ci1636
	add	x1, x1, #:lo12:.ci1636
	bl	memcpy
	mov	x1, #284
	add	x0, x29, #16
	add	x1, x0, x1
	mov	w0, #0
	strh	w0, [x1]
	mov	x1, #286
	add	x0, x29, #16
	add	x0, x0, x1
	mov	x2, #9
	adrp	x1, .ci1637
	add	x1, x1, #:lo12:.ci1637
	bl	memcpy
	mov	x1, #295
	add	x0, x29, #16
	add	x1, x0, x1
	mov	w0, #246
	strb	w0, [x1]
	mov	x1, #296
	add	x0, x29, #16
	add	x1, x0, x1
	adrp	x0, "g_157"
	add	x0, x0, #:lo12:"g_157"
	str	x0, [x1]
	mov	x1, #8
	add	x0, x29, #16
	add	x1, x0, x1
	mov	w0, #0
.L1169:
	cmp	w0, #7
	bge	.L1172
	sxtw	x2, w0
	mov	x3, #4
	mul	x2, x2, x3
	add	x3, x2, x1
	mov	w2, #0
	str	w2, [x3]
	mov	w2, #1
	add	w0, w0, w2
	b	.L1169
.L1172:
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	mov	x0, #24
	str	x0, [x1]
	add	x0, x29, #16
	ldr	x0, [x0]
	ldp	x29, x30, [sp], 16
	mov	x16, #4944
	add	sp, sp, x16
	ret
.type "func_37", @function
.size "func_37", .-"func_37"

.data
.balign 1
".__func__.1635":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 51
	.byte 55
	.byte 0

.data
.balign 4
.ci1636:
	.int 4294967290
	.int 1943674739
	.int 4294967295
	.int 3659387712
	.int 1943674739
	.int 3659387712
	.int 4294967290
	.int 30717731
	.int 4294967290
	.int 3659387712
	.int 30717731
	.int 4294967295
	.int 4294967290
	.int 1
	.int 3659387712
	.int 3659387712
	.int 1
	.int 4294967290
	.int 4294967290
	.int 1943674739
	.int 4294967295
	.int 3659387712
	.int 1943674739
	.int 3659387712
	.int 4294967290
	.int 30717731
	.int 4294967290
	.int 3659387712
	.int 30717731
	.int 4294967295
	.int 4294967290
	.int 1
	.int 3659387712
	.int 3659387712
	.int 1
	.int 4294967290
	.int 4294967290
	.int 1943674739
	.int 4294967295
	.int 3659387712
	.int 1943674739
	.int 3659387712
	.int 4294967290
	.int 30717731
	.int 4294967290
	.int 3659387712
	.int 30717731
	.int 4294967295
	.int 4294967290
	.int 1
	.int 3659387712
	.int 3659387712
	.int 1
	.int 4294967290
	.int 4294967290
	.int 1943674739
	.int 4294967295
	.int 3659387712
	.int 1943674739
	.int 3659387712

.data
.balign 1
.ci1637:
	.byte 72057594037927935
	.byte 72057594037927935
	.byte 72057594037927935
	.byte 99
	.byte 99
	.byte 99
	.byte 72057594037927935
	.byte 72057594037927935
	.byte 72057594037927935

.data
.balign 8
.ci1666:
	.quad -1
	.quad -1
	.quad -1
	.quad -1
	.quad -1
	.quad -1
	.quad -1

.data
.balign 4
.ci1667:
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 873818253
	.int 873818253
	.int 873818253
	.int 873818253
	.int 873818253
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 873818253
	.int 873818253
	.int 873818253
	.int 873818253
	.int 873818253

.data
.balign 4
.ci1691:
	.int 1
	.int 2
	.int 1
	.int 1
	.int 2
	.int 1

.data
.balign 4
.ci1711:
	.int 3870009027
	.int 3870009027
	.int 3454112429
	.int 4
	.int 4294967295
	.int 1
	.int 0
	.int 0
	.int 1
	.int 2246052854
	.int 3729013121
	.int 4
	.int 2548762310
	.int 2548762310
	.int 4
	.int 2246052854
	.int 0
	.int 0
	.int 1
	.int 1
	.int 4
	.int 4294967295
	.int 4
	.int 3454112429
	.int 3870009027
	.int 0
	.int 0
	.int 2246052854
	.int 0
	.int 0

.data
.balign 4
.ci1754:
	.int 1613093552
	.int 4294967289
	.int 1613093552
	.int 4294967289
	.int 1613093552
	.int 4294967289
	.int 1613093552
	.int 4294967289
	.int 1613093552

.text
.balign 16
"func_42":
	hint	#34
	mov	x16, #6592
	sub	sp, sp, x16
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	str	x19, [x29, 6600]
	str	x20, [x29, 6592]
	str	x21, [x29, 6584]
	str	x22, [x29, 6576]
	str	x23, [x29, 6568]
	str	x24, [x29, 6560]
	str	x25, [x29, 6552]
	str	x26, [x29, 6544]
	str	x27, [x29, 6536]
	str	x28, [x29, 6528]
	str	w2, [x29, 6372]
	str	w1, [x29, 6480]
	str	x0, [x29, 6392]
	mov	x5, #3728
	add	x4, x29, #24
	add	x20, x4, x5
	str	x20, [x29, 6304]
	strb	w3, [x20]
	add	x4, x29, #24
	adrp	x3, "g_120"
	add	x3, x3, #:lo12:"g_120"
	str	x3, [x4]
	mov	x4, #16
	add	x3, x29, #24
	add	x19, x3, x4
	adrp	x3, "g_200"
	add	x3, x3, #:lo12:"g_200"
	str	x3, [x19]
	mov	x4, #24
	add	x3, x29, #24
	add	x21, x3, x4
	mov	w24, w2
	mov	x2, #4
	mov	w23, w1
	mov	w1, #0
	mov	x22, x0
	mov	x0, x21
	bl	memset
	mov	w2, w24
	mov	w1, w23
	mov	x0, x22
	ldr	w3, [x21]
	mov	w4, #-4194304
	and	w3, w3, w4
	mov	w4, #65530
	movk	w4, #0x3f, lsl #16
	orr	w3, w3, w4
	str	w3, [x21]
	mov	x3, #28
	mov	x21, x0
	add	x0, x29, #24
	add	x0, x0, x3
	mov	w23, w2
	mov	x2, #12
	mov	w22, w1
	adrp	x1, .ci1817
	add	x1, x1, #:lo12:.ci1817
	bl	memcpy
	mov	w2, w23
	mov	w1, w22
	mov	x0, x21
	mov	x4, #40
	add	x3, x29, #24
	add	x21, x3, x4
	str	x21, [x29, 6448]
	mov	w3, #4588
	movk	w3, #0x8ba2, lsl #16
	str	w3, [x21]
	mov	x4, #8
	add	x3, x29, #24
	add	x26, x3, x4
	str	x26, [x29, 6472]
	adrp	x3, "g_200"
	add	x3, x3, #:lo12:"g_200"
	cmp	x3, #0
	cset	w3, eq
	str	w3, [x29, 6388]
	adrp	x4, "g_121"
	add	x4, x4, #:lo12:"g_121"
	cmp	x4, #0
	cset	w10, ne
	str	w10, [x29, 6288]
	adrp	x4, "g_119"
	add	x4, x4, #:lo12:"g_119"
	cmp	x4, #0
	cset	w5, ne
	str	w5, [x29, 6340]
	mov	w8, #0
.L1177:
	cmp	w8, #2
	bge	.L1190
	sxtw	x4, w8
	mov	w25, w5
	mov	x5, #4
	mul	x4, x4, x5
	add	x7, x4, x26
	mov	w5, w25
	mov	w9, w3
	mov	w6, #0
.L1180:
	cmp	w6, #1
	bge	.L1187
	sxtw	x3, w6
	mov	x4, #4
	mul	x3, x3, x4
	add	x4, x7, x3
	mov	w3, #0
.L1183:
	cmp	w3, #1
	bge	.L1186
	sxtw	x11, w3
	mov	x12, #4
	mul	x11, x11, x12
	add	x12, x4, x11
	mov	w11, #3
	str	w11, [x12]
	mov	w11, #1
	add	w3, w3, w11
	b	.L1183
.L1186:
	mov	w3, #1
	add	w6, w6, w3
	b	.L1180
.L1187:
	mov	w25, w5
	mov	w3, w9
	mov	w4, #1
	add	w8, w8, w4
	mov	w5, w25
	b	.L1177
.L1190:
	adrp	x3, "g_90"
	add	x3, x3, #:lo12:"g_90"
	mov	w0, #0
	strb	w0, [x3]
	mov	x3, #88
	add	x0, x29, #24
	add	x4, x0, x3
	str	x4, [x29, 6520]
	mov	x3, #44
	add	x0, x29, #24
	add	x22, x0, x3
	mov	x3, #64
	add	x0, x29, #24
	add	x23, x0, x3
	mov	w0, #0
.L1192:
	mov	w25, w5
	uxtb	w0, w0
	cmp	w0, #4
	bgt	.L1205
	mov	w24, w2
	mov	x2, #2048
	mov	w20, w1
	mov	w1, #0
	mov	x0, x4
	bl	memset
	mov	w5, w25
	mov	w2, w24
	mov	w1, w20
	ldr	w10, [x29, 6288]
	ldr	w3, [x29, 6388]
	ldr	x4, [x29, 6520]
	ldr	x20, [x29, 6304]
	ldr	x0, [x29, 6392]
	mov	x7, #88
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #96
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #104
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #112
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #120
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #128
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #136
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #144
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #152
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #168
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #176
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #184
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #192
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #200
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #208
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #216
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #232
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #240
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #248
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #256
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #264
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #272
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #280
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #288
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #296
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #304
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #312
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #328
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #336
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #344
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #352
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #360
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #368
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #376
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #392
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #400
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #408
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #416
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #424
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #432
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #440
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #448
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #456
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #464
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #472
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #488
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #496
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #504
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #512
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #520
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #528
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #536
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #552
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #560
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #568
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #576
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #584
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #592
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #600
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #608
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #624
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #632
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #640
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #664
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #672
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #680
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #696
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #704
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #712
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #720
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #728
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #736
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #744
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #752
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #760
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #768
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #784
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #792
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #800
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #824
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #832
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #840
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #856
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #864
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #872
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #880
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #888
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #896
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #904
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #912
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #920
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #928
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #944
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #952
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #960
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #984
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #992
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1000
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1016
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1024
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1032
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1040
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1048
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1056
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1064
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1072
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1080
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1088
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1104
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1112
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1120
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1144
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1152
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1160
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1176
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1184
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1192
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1200
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1208
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1216
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1224
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1232
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1240
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1248
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1264
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1272
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1280
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1304
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1312
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1320
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1336
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1344
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1352
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1360
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1368
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1376
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1384
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1392
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1400
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1408
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1424
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1432
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1440
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1464
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1472
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1480
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1496
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1504
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1512
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1520
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1528
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1536
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1544
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1552
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1560
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1568
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1584
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1592
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1600
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1624
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1632
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1640
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1656
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1664
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1672
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1680
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1688
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1696
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1704
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1712
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1720
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1728
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1744
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1752
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1760
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1784
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1792
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1800
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1816
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1824
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1832
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1840
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1848
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1856
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1864
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1872
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1880
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1888
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1904
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1912
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1920
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1944
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1952
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1960
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1976
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #1984
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #1992
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #2000
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2008
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #2016
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2024
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2032
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #2040
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #2048
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2064
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2072
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2080
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2096
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2104
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2112
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_124"
	add	x6, x6, #:lo12:"g_124"
	str	x6, [x7]
	mov	x7, #2120
	add	x6, x29, #24
	add	x7, x6, x7
	adrp	x6, "g_119"
	add	x6, x6, #:lo12:"g_119"
	str	x6, [x7]
	mov	x7, #2128
	add	x6, x29, #24
	add	x6, x6, x7
	mov	w27, w2
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x6]
	mov	w9, w3
	mov	w2, w27
	mov	w3, #0
.L1195:
	cmp	w3, #4
	bge	.L1198
	sxtw	x6, w3
	mov	x7, #4
	mul	x6, x6, x7
	add	x7, x22, x6
	mov	w6, #0
	str	w6, [x7]
	mov	w6, #1
	add	w3, w3, w6
	b	.L1195
.L1198:
	mov	w3, w9
	mov	w27, w2
	mov	w9, w3
	mov	w2, w27
	mov	w3, #0
.L1200:
	cmp	w3, #3
	bge	.L1203
	sxtw	x6, w3
	mov	x7, #8
	mul	x6, x6, x7
	add	x6, x23, x6
	str	x19, [x6]
	mov	w6, #1
	add	w3, w3, w6
	b	.L1200
.L1203:
	adrp	x0, "g_90"
	add	x0, x0, #:lo12:"g_90"
	ldrb	w0, [x0]
	mov	w2, #1
	add	w0, w0, w2
	sxtb	w0, w0
	adrp	x2, "g_90"
	add	x2, x2, #:lo12:"g_90"
	strb	w0, [x2]
	ldr	w2, [x29, 6372]
	b	.L1192
.L1205:
	adrp	x3, "g_190"
	add	x3, x3, #:lo12:"g_190"
	mov	x0, #0
	str	x0, [x3]
	mov	x3, #2136
	add	x0, x29, #24
	add	x12, x0, x3
	str	x12, [x29, 6400]
	mov	x3, #2640
	add	x0, x29, #24
	add	x13, x0, x3
	str	x13, [x29, 6408]
	mov	x3, #2960
	add	x0, x29, #24
	add	x14, x0, x3
	str	x14, [x29, 6416]
	sxth	x10, w1
	str	x10, [x29, 6376]
	uxtb	w0, w2
	cmp	x0, #165
	cset	w11, lt
	str	w11, [x29, 6384]
	mov	x3, #2956
	add	x0, x29, #24
	add	x25, x0, x3
	str	x25, [x29, 6464]
	sxth	w22, w1
	mov	x3, #3732
	add	x0, x29, #24
	add	x6, x0, x3
	str	x6, [x29, 6344]
	mov	x3, #3736
	add	x0, x29, #24
	add	x15, x0, x3
	str	x15, [x29, 6424]
	mov	x3, #4696
	add	x0, x29, #24
	add	x0, x0, x3
	str	x0, [x29, 6432]
	uxtb	w19, w2
	str	w19, [x29, 6312]
	cmp	w19, #0
	sxtb	w30, w1
	str	w30, [x29, 6316]
	mov	x2, #5008
	add	x0, x29, #24
	add	x27, x0, x2
	str	x27, [x29, 6320]
	mov	x2, #5048
	add	x0, x29, #24
	add	x28, x0, x2
	str	x28, [x29, 6328]
	mov	w0, #1
	orr	w4, w22, w0
	str	w4, [x29, 6336]
	mov	x2, #5144
	add	x0, x29, #24
	add	x19, x0, x2
	mov	x2, #2692
	add	x0, x29, #24
	add	x20, x0, x2
	mov	x2, #5176
	add	x0, x29, #24
	add	x0, x0, x2
	str	x0, [x29, 6296]
	mov	x2, #12
	add	x0, x29, #24
	add	x24, x0, x2
	str	x24, [x29, 6456]
	mov	x2, #2764
	add	x0, x29, #24
	add	x7, x0, x2
	str	x7, [x29, 6352]
	mov	x2, #2720
	add	x0, x29, #24
	add	x9, x0, x2
	str	x9, [x29, 6360]
	cmp	w22, #0
	cset	w0, ne
	mov	w2, #1
	eor	w2, w0, w2
	str	w2, [x29, 6292]
	mov	w17, #47905
	movk	w17, #0xe41e, lsl #16
	str	w17, [x29, 6444]
	mov	x16, #0
.L1207:
	cmp	x16, #20
	bne	.L1278
	mov	x2, #504
	mov	w23, w1
	mov	w1, #0
	mov	x0, x12
	bl	memset
	mov	w1, w23
	ldr	x13, [x29, 6408]
	mov	x2, #2144
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2160
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2168
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2176
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2184
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2192
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2216
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2240
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2248
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2264
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2280
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2288
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2296
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2304
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2312
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2336
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2360
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2368
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2384
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2400
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2408
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2416
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2424
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2432
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2456
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2480
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2488
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2504
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2520
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2528
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2536
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2544
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2552
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2576
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+4
	add	x0, x0, #:lo12:"g_92"+4
	str	x0, [x2]
	mov	x2, #2600
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2608
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #2624
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	str	x0, [x2]
	mov	x2, #320
	mov	w23, w1
	adrp	x1, .ci1852
	add	x1, x1, #:lo12:.ci1852
	mov	x0, x13
	bl	memcpy
	mov	w1, w23
	ldr	x14, [x29, 6416]
	mov	x2, #768
	mov	w23, w1
	mov	w1, #0
	mov	x0, x14
	bl	memset
	mov	w1, w23
	mov	x2, #2960
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #2992
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3000
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3008
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3016
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3024
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3040
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3048
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3064
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3080
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3088
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3104
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3112
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3120
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3128
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3136
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3168
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3192
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3200
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3208
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3216
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3224
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3232
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3240
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3248
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3256
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3264
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3272
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3288
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3296
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3304
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3320
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3328
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3336
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3344
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3352
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3360
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3368
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3376
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3384
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3392
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3400
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3408
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3416
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3424
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3440
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3456
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3464
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3472
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3480
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3488
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3496
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3504
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3512
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3520
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3528
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3536
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3544
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3552
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3560
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3576
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3584
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3592
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3608
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3616
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3624
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3632
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3640
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3648
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3656
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3672
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3680
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3688
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3696
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3704
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	mov	x2, #3712
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x2]
	add	x0, x29, #24
	ldr	x0, [x0]
	ldr	x2, [x0]
	mov	x0, #0
	str	x0, [x2]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, #0
	beq	.L1210
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1409
	mov	w23, w1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1329"
	add	x0, x0, #:lo12:".ts.1329"
	bl	"__assert_fail"
	mov	w1, w23
.L1210:
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	mov	w23, w1
	ldr	w1, [x0]
	mov	x2, #3728
	add	x0, x29, #24
	add	x0, x0, x2
	ldrsb	w0, [x0]
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L1212
	mov	w17, #1
	str	w17, [x29, 6512]
	b	.L1213
.L1212:
	str	w0, [x29, 6512]
.L1213:
	adrp	x0, "g_157"
	add	x0, x0, #:lo12:"g_157"
	ldr	x0, [x0]
	mov	x2, #41337
	movk	x2, #0xca1b, lsl #16
	movk	x2, #0x2e3c, lsl #32
	movk	x2, #0x5e03, lsl #48
	eor	x0, x0, x2
	uxth	w0, w0
	sxth	w1, w1
	bl	"safe_div_func_uint16_t_u_u"
	mov	w1, w0
	ldr	w0, [x29, 6512]
	uxtb	w1, w1
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w23
	ldr	x10, [x29, 6376]
	sxtb	w0, w0
	mov	x3, #3728
	add	x2, x29, #24
	add	x2, x2, x3
	ldrsb	w2, [x2]
	cmp	w0, w2
	cset	w0, ne
	sxtw	x0, w0
	mov	w23, w1
	mov	x1, x10
	bl	"safe_sub_func_int64_t_s_s"
	mov	w1, w23
	ldr	w11, [x29, 6384]
	adrp	x0, "g_92"+6
	add	x0, x0, #:lo12:"g_92"+6
	strh	w11, [x0]
	mov	x2, #2956
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	cmp	w11, w0
	cset	w0, lt
	adrp	x2, "g_147"
	add	x2, x2, #:lo12:"g_147"
	ldr	x2, [x2]
	ldrb	w2, [x2]
	cmp	w0, w2
	cset	w2, ne
	cmp	w2, #0
	bne	.L1215
	mov	w2, #1
.L1215:
	adrp	x0, "g_117"+2
	add	x0, x0, #:lo12:"g_117"+2
	ldrsh	w0, [x0]
	eor	w0, w0, w2
	sxth	w0, w0
	mov	w23, w1
	mov	w1, #-2
	bl	"safe_mul_func_uint16_t_u_u"
	mov	w1, w23
	mov	w23, w1
	mov	w1, #8
	bl	"safe_lshift_func_uint16_t_u_s"
	mov	w1, w23
	uxtb	w0, w0
	mov	x2, #40
	mov	w23, w1
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	sxtb	w1, w1
	bl	"safe_sub_func_uint8_t_u_u"
	mov	w1, w23
	mov	x2, #2956
	mov	w23, w1
	add	x1, x29, #24
	add	x1, x1, x2
	ldr	w1, [x1]
	bl	"safe_rshift_func_int8_t_s_u"
	mov	w1, w23
	ldr	x10, [x29, 6376]
	adrp	x0, "g_295"
	add	x0, x0, #:lo12:"g_295"
	ldr	x2, [x0]
	add	x0, x29, #24
	cmp	x0, x2
	cset	w0, eq
	sxtw	x0, w0
	mov	w23, w1
	mov	x1, x10
	bl	"safe_add_func_int64_t_s_s"
	mov	w1, w23
	ldr	x15, [x29, 6424]
	adrp	x0, "g_188"
	add	x0, x0, #:lo12:"g_188"
	ldr	x0, [x0]
	mov	x2, #1
	orr	x0, x0, x2
	adrp	x2, "g_188"
	add	x2, x2, #:lo12:"g_188"
	str	x0, [x2]
	adrp	x2, "g_117"+2
	add	x2, x2, #:lo12:"g_117"+2
	ldrsh	w2, [x2]
	sxth	x2, w2
	cmp	x0, x2
	bgt	.L1219
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x2, [x0]
	str	x2, [x29, 6496]
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldrb	w0, [x0]
	str	w0, [x29, 6504]
	mov	x2, #3728
	add	x0, x29, #24
	add	x0, x0, x2
	ldrsb	w0, [x0]
	mov	w23, w1
	mov	w1, #4
	bl	"safe_rshift_func_int8_t_s_u"
	mov	w1, w23
	str	w0, [x29, 6508]
	ldr	w27, [x29, 6372]
	adrp	x0, "g_188"
	add	x0, x0, #:lo12:"g_188"
	ldr	x0, [x0]
	sxtb	w0, w0
	mov	w23, w1
	mov	w1, w27
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w23
	ldr	w2, [x29, 6292]
	sxtb	w0, w0
	mov	x4, #3728
	add	x3, x29, #24
	add	x3, x3, x4
	ldrsb	w3, [x3]
	orr	w2, w2, w3
	cmp	w0, w2
	cset	w0, ne
	mov	w2, #-1
	eor	w0, w0, w2
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	beq	.L1218
	adrp	x0, "g_127"
	add	x0, x0, #:lo12:"g_127"
	ldrb	w0, [x0]
	cmp	w0, #0
	cset	w0, ne
.L1218:
	sxtw	x0, w0
	mov	x2, #-10
	and	x0, x0, x2
	sxth	w0, w0
	mov	w23, w1
	mov	w1, #1
	bl	"safe_div_func_int16_t_s_s"
	mov	w1, w23
	ldr	w0, [x29, 6508]
	ldr	x23, [x29, 6392]
	adrp	x2, "g_33"
	add	x2, x2, #:lo12:"g_33"
	ldr	w3, [x2]
	mov	w4, w22
	mov	x2, x23
	mov	w23, w1
	mov	w1, #253
	bl	"func_47"
	mov	w1, w23
	mov	x2, x0
	ldr	w0, [x29, 6504]
	ldr	w27, [x29, 6372]
	adrp	x3, "g_125"
	add	x3, x3, #:lo12:"g_125"
	ldr	w4, [x3]
	mov	w3, #-1
	mov	w23, w1
	mov	w1, w27
	bl	"func_47"
	mov	w1, w23
	ldr	x2, [x29, 6496]
	ldr	w8, [x29, 6444]
	str	x0, [x2]
	b	.L1254
.L1219:
	mov	x2, #3732
	add	x0, x29, #24
	add	x2, x0, x2
	mov	w0, #2
	str	w0, [x2]
	mov	x2, #960
	mov	w23, w1
	mov	w1, #0
	mov	x0, x15
	bl	memset
	mov	w1, w23
	ldr	x0, [x29, 6432]
	mov	x3, #3736
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3744
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3752
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3760
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3768
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3776
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3784
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3792
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3800
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3808
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3824
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3832
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3840
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3848
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3856
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3864
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3872
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3880
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3888
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3896
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3904
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3920
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3928
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3936
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3944
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3952
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3960
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3968
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #3976
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3984
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #3992
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4000
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4016
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4024
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4032
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4040
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4048
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4056
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4064
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4072
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4080
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4088
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4096
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4112
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4120
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4128
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4136
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4144
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4152
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4160
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4168
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4176
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4184
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4192
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4208
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4216
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4224
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4232
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4240
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4248
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4256
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4264
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4272
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4280
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4288
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4304
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4312
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4320
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4328
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4336
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4344
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4352
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4360
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4368
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4376
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4384
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4400
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4408
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4416
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4424
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4432
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4440
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4448
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4456
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4464
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4472
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4480
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4496
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4504
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4512
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4520
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4528
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4536
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4544
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4552
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4560
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4568
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4576
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4592
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4600
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4608
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4616
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4624
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4632
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4640
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4648
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4656
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_124"
	add	x2, x2, #:lo12:"g_124"
	str	x2, [x3]
	mov	x3, #4664
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4672
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x3, #4688
	add	x2, x29, #24
	add	x3, x2, x3
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	str	x2, [x3]
	mov	x2, #252
	mov	w23, w1
	adrp	x1, .ci1864
	add	x1, x1, #:lo12:.ci1864
	bl	memcpy
	mov	w1, w23
	adrp	x2, "g_127"
	add	x2, x2, #:lo12:"g_127"
	mov	w0, #0
	strb	w0, [x2]
	mov	w0, #0
.L1221:
	cmp	w0, #2
	bge	.L1224
	adrp	x2, "g_33"
	add	x2, x2, #:lo12:"g_33"
	ldr	w2, [x2]
	mov	x4, #3732
	add	x3, x29, #24
	add	x3, x3, x4
	ldr	w3, [x3]
	orr	w2, w2, w3
	mov	x4, #3732
	add	x3, x29, #24
	add	x3, x3, x4
	str	w2, [x3]
	mov	w23, w1
	mov	w1, #5
	bl	"safe_add_func_uint16_t_u_u"
	mov	w1, w23
	uxtb	w0, w0
	adrp	x2, "g_127"
	add	x2, x2, #:lo12:"g_127"
	strb	w0, [x2]
	b	.L1221
.L1224:
	adrp	x0, "g_130"
	add	x0, x0, #:lo12:"g_130"
	ldr	x0, [x0]
	str	x0, [x29, 6488]
	mov	x2, #3732
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	sxth	w0, w0
	adrp	x2, "g_117"
	add	x2, x2, #:lo12:"g_117"
	strh	w0, [x2]
	cmp	w0, #0
	mov	w23, w1
	cset	w1, ne
	cmp	w1, #0
	bne	.L1226
	mov	w1, #1
.L1226:
	mov	w0, #9
	bl	"safe_mod_func_int8_t_s_s"
	mov	w1, w0
	ldr	x0, [x29, 6488]
	sxtb	x1, w1
	bl	"safe_sub_func_int64_t_s_s"
	mov	w1, w23
	ldr	w8, [x29, 6444]
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	cmp	w0, #0
	cset	w2, ne
	cmp	w2, #0
	bne	.L1228
	mov	w2, #1
.L1228:
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w0, ne
	sxtw	x0, w0
	mov	x3, #56947
	movk	x3, #0xb6be, lsl #16
	cmp	x0, x3
	cset	w0, lt
	orr	w2, w0, w2
	mov	x3, #3732
	add	x0, x29, #24
	add	x0, x0, x3
	ldr	w0, [x0]
	cmp	w2, w0
	mov	w2, #-1
	eor	w0, w0, w2
	sxtw	x0, w0
	cmp	x0, #1
	bne	.L1263
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	str	x21, [x0]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x21, x0
	beq	.L1232
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1433
	mov	w23, w1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1883"
	add	x0, x0, #:lo12:".ts.1883"
	bl	"__assert_fail"
	mov	w1, w23
	ldr	w8, [x29, 6444]
.L1232:
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x21, x0
	beq	.L1234
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1463
	mov	w23, w1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1883"
	add	x0, x0, #:lo12:".ts.1883"
	bl	"__assert_fail"
	mov	w1, w23
	ldr	w8, [x29, 6444]
.L1234:
	cmp	w22, #0
	bne	.L1260
	mov	x2, #16
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_200"
	add	x0, x0, #:lo12:"g_200"
	str	x0, [x2]
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	str	w0, [x29, 6484]
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	cmp	w22, w0
	cset	w0, ne
	adrp	x2, "g_127"
	add	x2, x2, #:lo12:"g_127"
	strb	w0, [x2]
	adrp	x0, "g_67"
	add	x0, x0, #:lo12:"g_67"
	ldr	x0, [x0]
	adrp	x2, "g_67"
	add	x2, x2, #:lo12:"g_67"
	str	x0, [x2]
	cmp	x0, #0
	mov	w23, w1
	cset	w1, eq
	mov	w0, w23
	bl	"safe_lshift_func_int16_t_s_u"
	mov	w1, w23
	sxth	w0, w0
	mov	w23, w1
	add	x1, x29, #24
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	x1, [x1]
	ldr	w1, [x1]
	bl	"safe_mod_func_int32_t_s_s"
	mov	w1, w0
	ldr	w30, [x29, 6316]
	mov	w0, w30
	bl	"safe_lshift_func_int8_t_s_u"
	mov	w1, w23
	ldr	w10, [x29, 6288]
	ldr	w0, [x29, 6484]
	ldr	w3, [x29, 6388]
	and	w0, w0, w10
	adrp	x2, "g_119"
	add	x2, x2, #:lo12:"g_119"
	strb	w0, [x2]
	cmp	w3, w0
	cset	w0, lt
	mov	w23, w1
	mov	w1, #9926
	movk	w1, #0x757e, lsl #16
	bl	"safe_div_func_uint32_t_u_u"
	mov	w1, w23
	mov	w2, w0
	ldr	x0, [x29, 6296]
	ldr	x28, [x29, 6328]
	ldr	x27, [x29, 6320]
	mov	w2, w2
	cmp	x2, #0
	bne	.L1237
	mov	x2, #1080
	mov	w23, w1
	mov	w1, #0
	bl	memset
	mov	w1, w23
	ldr	w8, [x29, 6444]
	ldr	x9, [x29, 6360]
	ldr	x7, [x29, 6352]
	ldr	x6, [x29, 6344]
	mov	x2, #5176
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5184
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5200
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5216
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5224
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5232
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5240
	add	x0, x29, #24
	add	x0, x0, x2
	str	x7, [x0]
	mov	x2, #5248
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5256
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5264
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5272
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5280
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5288
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5296
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5304
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5312
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5320
	add	x0, x29, #24
	add	x0, x0, x2
	str	x6, [x0]
	mov	x2, #5328
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5336
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5344
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5360
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5376
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5384
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5392
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5400
	add	x0, x29, #24
	add	x0, x0, x2
	str	x7, [x0]
	mov	x2, #5408
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5416
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5424
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5432
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5440
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5448
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5456
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5464
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5472
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5480
	add	x0, x29, #24
	add	x0, x0, x2
	str	x6, [x0]
	mov	x2, #5488
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5496
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5504
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5520
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5536
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5544
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5552
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5560
	add	x0, x29, #24
	add	x0, x0, x2
	str	x7, [x0]
	mov	x2, #5568
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5576
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5584
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5592
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5600
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5608
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5616
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5624
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5632
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5640
	add	x0, x29, #24
	add	x0, x0, x2
	str	x6, [x0]
	mov	x2, #5648
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5656
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5664
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5680
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5696
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5704
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5712
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5720
	add	x0, x29, #24
	add	x0, x0, x2
	str	x7, [x0]
	mov	x2, #5728
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5736
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5744
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5752
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5760
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5768
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5776
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5784
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5792
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5800
	add	x0, x29, #24
	add	x0, x0, x2
	str	x6, [x0]
	mov	x2, #5808
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5816
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5824
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5840
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5856
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5864
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5872
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5880
	add	x0, x29, #24
	add	x0, x0, x2
	str	x7, [x0]
	mov	x2, #5888
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5896
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5904
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #5912
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5920
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5928
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #5936
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5944
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #5952
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #5960
	add	x0, x29, #24
	add	x0, x0, x2
	str	x6, [x0]
	mov	x2, #5968
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #5976
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	str	x0, [x2]
	mov	x2, #5984
	add	x0, x29, #24
	add	x0, x0, x2
	str	x26, [x0]
	mov	x2, #6000
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6016
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #6024
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #6032
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_317"+24
	add	x0, x0, #:lo12:"g_317"+24
	str	x0, [x2]
	mov	x2, #6048
	add	x0, x29, #24
	add	x0, x0, x2
	str	x9, [x0]
	mov	x2, #6056
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6064
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6072
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #6080
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #6088
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #6096
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #6104
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #6112
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_317"+24
	add	x0, x0, #:lo12:"g_317"+24
	str	x0, [x2]
	mov	x2, #6120
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6128
	add	x0, x29, #24
	add	x0, x0, x2
	str	x9, [x0]
	mov	x2, #6144
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6160
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #6176
	add	x0, x29, #24
	add	x0, x0, x2
	str	x25, [x0]
	mov	x2, #6184
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #6192
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_317"+24
	add	x0, x0, #:lo12:"g_317"+24
	str	x0, [x2]
	mov	x2, #6208
	add	x0, x29, #24
	add	x0, x0, x2
	str	x9, [x0]
	mov	x2, #6216
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6224
	add	x0, x29, #24
	add	x0, x0, x2
	str	x21, [x0]
	mov	x2, #6232
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #6240
	add	x0, x29, #24
	add	x0, x0, x2
	str	x24, [x0]
	mov	x2, #6248
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x2]
	mov	x2, #6256
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	str	x0, [x2]
	mov	w0, #1
	add	w8, w8, w0
	mov	x2, #6256
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	str	x0, [x2]
	mov	x2, #6256
	add	x0, x29, #24
	add	x2, x0, x2
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	str	x0, [x2]
	b	.L1254
.L1237:
	adrp	x1, "g_130"
	add	x1, x1, #:lo12:"g_130"
	mov	x0, #0
	str	x0, [x1]
	mov	x23, #-7
	mov	x0, #0
.L1239:
	cmp	x0, #53
	bne	.L1253
	mov	x2, #40
	adrp	x1, .ci1923
	add	x1, x1, #:lo12:.ci1923
	mov	x0, x27
	bl	memcpy
	mov	x2, #96
	adrp	x1, .ci1924
	add	x1, x1, #:lo12:.ci1924
	mov	x0, x28
	bl	memcpy
	mov	x1, #16
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	x0, [x0]
	ldr	x25, [x0]
	adrp	x0, "g_147"
	add	x0, x0, #:lo12:"g_147"
	ldr	x0, [x0]
	ldrb	w0, [x0]
	mov	w1, #2
	bl	"safe_lshift_func_uint8_t_u_u"
	uxtb	w0, w0
	cmp	x0, #0
	cset	w0, cs
	mov	w1, #1
	eor	w0, w0, w1
	str	w0, [x25]
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	str	w0, [x1]
	mov	x1, #5036
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	w26, [x0]
	mov	x1, #3728
	add	x0, x29, #24
	add	x0, x0, x1
	ldrsb	w27, [x0]
	mov	w1, #2
	mov	w0, #-69
	bl	"safe_lshift_func_int8_t_s_s"
	ldr	x25, [x29, 6464]
	sxtb	w0, w0
	cmp	w27, w0
	cset	w0, ne
	bl	"safe_unary_minus_func_int32_t_s"
	ldr	w1, [x29, 6480]
	adrp	x0, "g_31"
	add	x0, x0, #:lo12:"g_31"
	ldrb	w0, [x0]
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L1242
	mov	w0, #1
.L1242:
	bl	"safe_add_func_int16_t_s_s"
	adrp	x0, "g_17"
	add	x0, x0, #:lo12:"g_17"
	ldrb	w1, [x0]
	mov	w0, #1
	bl	"safe_rshift_func_int16_t_s_s"
	ldr	w5, [x29, 6340]
	sxth	w1, w0
	mov	w0, w5
	bl	"safe_div_func_uint32_t_u_u"
	mov	w3, w26
	ldr	w5, [x29, 6340]
	ldr	w8, [x29, 6444]
	ldr	x9, [x29, 6360]
	ldr	x7, [x29, 6352]
	ldr	w4, [x29, 6336]
	ldr	x28, [x29, 6328]
	ldr	x27, [x29, 6320]
	ldr	x26, [x29, 6472]
	ldr	x15, [x29, 6424]
	ldr	x6, [x29, 6344]
	ldr	w11, [x29, 6384]
	ldr	x10, [x29, 6376]
	ldr	x14, [x29, 6416]
	ldr	x13, [x29, 6408]
	ldr	x12, [x29, 6400]
	ldr	w2, [x29, 6372]
	ldr	w1, [x29, 6480]
	ldr	x0, [x29, 6392]
	and	w3, w22, w3
	cmp	w4, w3
	bne	.L1252
	mov	w3, #0
.L1244:
	cmp	w3, #4
	bge	.L1247
	sxtw	x16, w3
	mov	x30, #8
	mul	x16, x16, x30
	add	x16, x19, x16
	str	x20, [x16]
	mov	w16, #1
	add	w3, w3, w16
	b	.L1244
.L1247:
	mov	w24, w4
	mov	x2, #5036
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	sxth	w0, w0
	mov	w21, w1
	mov	w1, w22
	bl	"safe_lshift_func_uint16_t_u_u"
	mov	w4, w24
	mov	w1, w21
	ldr	w5, [x29, 6340]
	uxth	w0, w0
	mov	x3, #5084
	add	x2, x29, #24
	add	x2, x2, x3
	str	w0, [x2]
	mov	x2, #40
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	cmp	w0, #0
	adrp	x0, "g_130"
	add	x0, x0, #:lo12:"g_130"
	ldr	x0, [x0]
	mov	x2, #1
	add	x0, x0, x2
	adrp	x2, "g_130"
	add	x2, x2, #:lo12:"g_130"
	str	x0, [x2]
	mov	x2, #1
	sub	x23, x23, x2
	ldr	x24, [x29, 6456]
	ldr	x21, [x29, 6448]
	b	.L1239
.L1252:
	adrp	x0, "g_92"+2
	add	x0, x0, #:lo12:"g_92"+2
	ldrh	w0, [x0]
	b	.L1284
.L1253:
	ldr	w8, [x29, 6444]
	ldr	x26, [x29, 6472]
	ldr	x25, [x29, 6464]
	ldr	w1, [x29, 6480]
.L1254:
	str	w8, [x29, 6440]
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x0, #0
	cset	w2, eq
	cmp	w2, #0
	bne	.L1256
	cmp	x21, x0
	cset	w0, eq
	b	.L1257
.L1256:
	mov	w0, w2
.L1257:
	cmp	w0, #0
	bne	.L1259
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1528
	mov	w23, w1
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1952"
	add	x0, x0, #:lo12:".ts.1952"
	bl	"__assert_fail"
	mov	w1, w23
	ldr	w8, [x29, 6440]
.L1259:
	str	w8, [x29, 6368]
	b	.L1261
.L1260:
	str	w8, [x29, 6368]
.L1261:
	adrp	x0, "g_190"
	add	x0, x0, #:lo12:"g_190"
	ldr	x0, [x0]
	mov	w23, w1
	mov	w1, #4
	bl	"safe_add_func_uint32_t_u_u"
	mov	w1, w23
	mov	w16, w0
	ldr	w5, [x29, 6340]
	ldr	w8, [x29, 6368]
	ldr	x9, [x29, 6360]
	ldr	x7, [x29, 6352]
	ldr	w4, [x29, 6336]
	ldr	x28, [x29, 6328]
	ldr	x27, [x29, 6320]
	ldr	w3, [x29, 6388]
	ldr	x23, [x29, 6432]
	ldr	x15, [x29, 6424]
	ldr	x6, [x29, 6344]
	ldr	w11, [x29, 6384]
	ldr	x10, [x29, 6376]
	ldr	x14, [x29, 6416]
	ldr	x13, [x29, 6408]
	ldr	x12, [x29, 6400]
	ldr	w2, [x29, 6372]
	ldr	x0, [x29, 6392]
	mov	w16, w16
	adrp	x30, "g_190"
	add	x30, x30, #:lo12:"g_190"
	str	x16, [x30]
	ldr	w30, [x29, 6316]
	str	w8, [x29, 6444]
	b	.L1207
.L1263:
	ldr	w1, [x29, 6312]
	ldr	x20, [x29, 6304]
	mov	x2, #40
	add	x0, x29, #24
	add	x2, x0, x2
	mov	w0, #0
	str	w0, [x2]
	mov	w0, #0
	cmp	w0, #0
	bge	.L1268
	mov	x1, #3728
	add	x0, x29, #24
	add	x0, x0, x1
	ldrsb	w0, [x0]
	b	.L1284
.L1268:
	mov	w19, w1
	mov	x1, #4952
	add	x0, x29, #24
	add	x1, x0, x1
	mov	w0, #0
.L1270:
	cmp	w0, #1
	bge	.L1273
	sxtw	x2, w0
	mov	x3, #8
	mul	x2, x2, x3
	add	x3, x2, x1
	mov	x2, #19483
	movk	x2, #0x132f, lsl #16
	movk	x2, #0x10c0, lsl #32
	movk	x2, #0x1996, lsl #48
	str	x2, [x3]
	mov	w2, #1
	add	w0, w0, w2
	b	.L1270
.L1273:
	mov	w1, w19
	adrp	x2, "g_187"
	add	x2, x2, #:lo12:"g_187"
	mov	w0, #0
	str	w0, [x2]
	mov	x2, #4960
	add	x0, x29, #24
	add	x0, x0, x2
	mov	x2, #40
	mov	w19, w1
	adrp	x1, .ci1898
	add	x1, x1, #:lo12:.ci1898
	bl	memcpy
	mov	w1, w19
	mov	x2, #5000
	add	x0, x29, #24
	add	x19, x0, x2
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	str	x0, [x19]
	adrp	x0, "g_313"
	add	x0, x0, #:lo12:"g_313"
	ldrh	w0, [x0]
	mov	w2, #1
	sub	w0, w0, w2
	adrp	x2, "g_313"
	add	x2, x2, #:lo12:"g_313"
	strh	w0, [x2]
	mov	x2, #40
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	str	x20, [x19]
	mov	w2, #1
	add	w0, w0, w2
	sxtw	x0, w0
	mov	x2, #2
	mul	x0, x0, x2
	adrp	x2, "g_117"
	add	x2, x2, #:lo12:"g_117"
	add	x0, x0, x2
	ldrsh	w0, [x0]
	sxtb	w0, w0
	mov	w21, w1
	mov	w1, #0
	bl	"safe_sub_func_int8_t_s_s"
	mov	w1, w21
	adrp	x0, "g_146"
	add	x0, x0, #:lo12:"g_146"
	ldr	x0, [x0]
	ldr	x0, [x0]
	mov	w21, w1
	ldrb	w1, [x0]
	mov	w0, #0
	bl	"safe_rshift_func_int8_t_s_u"
	mov	w1, w21
	adrp	x2, "g_33"
	add	x2, x2, #:lo12:"g_33"
	mov	w0, #1
	str	w0, [x2]
	adrp	x0, "g_127"
	add	x0, x0, #:lo12:"g_127"
	ldrb	w0, [x0]
	cmp	w0, #1
	cset	w0, lt
	bl	"safe_div_func_int16_t_s_s"
	sxth	w0, w0
	mov	w1, #20576
	movk	w1, #0x1134, lsl #16
	cmp	w0, w1
	cset	w0, ls
	adrp	x1, "g_317"+24
	add	x1, x1, #:lo12:"g_317"+24
	str	w0, [x1]
	ldr	x0, [x19]
	cmp	x20, x0
	beq	.L1277
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1455
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1903"
	add	x0, x0, #:lo12:".ts.1903"
	bl	"__assert_fail"
.L1277:
	mov	x1, #3732
	add	x0, x29, #24
	add	x0, x0, x1
	ldr	w0, [x0]
	sxth	w0, w0
	b	.L1284
.L1278:
	adrp	x0, "g_121"
	add	x0, x0, #:lo12:"g_121"
	ldr	x0, [x0]
	cmp	x21, x0
	cset	w1, eq
	cmp	w1, #0
	bne	.L1280
	cmp	x0, #0
	cset	w0, eq
	b	.L1281
.L1280:
	mov	w0, w1
.L1281:
	cmp	w0, #0
	bne	.L1283
	adrp	x3, ".__func__.1816"
	add	x3, x3, #:lo12:".__func__.1816"
	mov	w2, #1531
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.1960"
	add	x0, x0, #:lo12:".ts.1960"
	bl	"__assert_fail"
.L1283:
	adrp	x0, "g_17"
	add	x0, x0, #:lo12:"g_17"
	ldrb	w0, [x0]
.L1284:
	ldr	x19, [x29, 6600]
	ldr	x20, [x29, 6592]
	ldr	x21, [x29, 6584]
	ldr	x22, [x29, 6576]
	ldr	x23, [x29, 6568]
	ldr	x24, [x29, 6560]
	ldr	x25, [x29, 6552]
	ldr	x26, [x29, 6544]
	ldr	x27, [x29, 6536]
	ldr	x28, [x29, 6528]
	ldp	x29, x30, [sp], 16
	mov	x16, #6592
	add	sp, sp, x16
	ret
.type "func_42", @function
.size "func_42", .-"func_42"

.data
.balign 1
".__func__.1816":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 52
	.byte 50
	.byte 0

.data
.balign 2
.ci1817:
	.short 26963
	.short 30110
	.short 30110
	.short 26963
	.short 30110
	.short 30110

.data
.balign 4
.ci1852:
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 921635602
	.int 2892979572
	.int 1242164841
	.int 2892979572
	.int 921635602
	.int 0
	.int 921635602
	.int 2892979572
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 921635602
	.int 2892979572
	.int 1242164841
	.int 2892979572
	.int 921635602
	.int 0
	.int 921635602
	.int 2892979572
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 921635602
	.int 2892979572
	.int 1242164841
	.int 2892979572
	.int 921635602
	.int 0
	.int 921635602
	.int 2892979572
	.int 0
	.int 2892979572
	.int 0
	.int 4294967295
	.int 921635602
	.int 4294967295
	.int 0
	.int 2892979572

.data
.balign 4
.ci1864:
	.int 1272080871
	.int 4294967288
	.int 2687045664
	.int 2235737927
	.int 746812041
	.int 2884833119
	.int 746812041
	.int 2235737927
	.int 2687045664
	.int 746812041
	.int 746812041
	.int 1272080871
	.int 1271797374
	.int 3093141054
	.int 1260986320
	.int 2687045664
	.int 1260986320
	.int 2884833119
	.int 746812041
	.int 1260986320
	.int 1260986320
	.int 746812041
	.int 4294967288
	.int 2884833119
	.int 0
	.int 1271797374
	.int 0
	.int 1271797374
	.int 1272080871
	.int 746812041
	.int 746812041
	.int 1272080871
	.int 1271797374
	.int 3093141054
	.int 1260986320
	.int 2687045664
	.int 1982981535
	.int 2884833119
	.int 1271797374
	.int 4294967288
	.int 4294967288
	.int 1271797374
	.int 2884833119
	.int 1982981535
	.int 1272080871
	.int 2687045664
	.int 746812041
	.int 1982981535
	.int 3093141054
	.int 2884833119
	.int 2884833119
	.int 3093141054
	.int 1982981535
	.int 746812041
	.int 4294967288
	.int 1982981535
	.int 2687045664
	.int 1272080871
	.int 1260986320
	.int 0
	.int 0
	.int 1260986320
	.int 1272080871

.data
.balign 8
.ci1898:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0

.data
.balign 4
.ci1923:
	.int 4294967291
	.int 1
	.int 4294967291
	.int 1
	.int 4294967291
	.int 1
	.int 4294967291
	.int 1
	.int 4294967291
	.int 1

.data
.balign 4
.ci1924:
	.int 1
	.int 1
	.int 1
	.int 1
	.int 2685528231
	.int 4294967295
	.int 1
	.int 1
	.int 4294967289
	.int 4294967289
	.int 1
	.int 2726650168
	.int 2685528231
	.int 2968755815
	.int 1
	.int 4294967295
	.int 1
	.int 1
	.int 2726650168
	.int 1
	.int 2726650168
	.int 1
	.int 1
	.int 4294967295

.text
.balign 16
"func_47":
	hint	#34
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	str	x19, [x29, 72]
	str	x20, [x29, 64]
	str	x21, [x29, 56]
	str	x22, [x29, 48]
	str	x23, [x29, 40]
	mov	w22, w4
	mov	w21, w3
	mov	x2, #4
	mov	w20, w1
	mov	w1, #0
	mov	w19, w0
	add	x0, x29, #24
	bl	memset
	mov	w4, w22
	mov	w3, w21
	mov	w1, w20
	mov	w0, w19
	add	x2, x29, #24
	ldr	w2, [x2]
	mov	w5, #-4194304
	and	w2, w2, w5
	mov	w23, w4
	mov	w4, #8
	orr	w2, w2, w4
	mov	w20, w3
	add	x3, x29, #24
	str	w2, [x3]
	adrp	x2, "g_146"
	add	x2, x2, #:lo12:"g_146"
	ldr	x21, [x2]
	cmp	w20, #0
	cset	w2, ne
	cmp	w2, #0
	bne	.L1287
	mov	w19, #19777
	movk	w19, #0x38e8, lsl #16
	mov	w1, w2
	b	.L1289
.L1287:
	mov	w19, w0
	uxtb	w0, w1
	mov	w22, w1
	mov	w1, #6
	bl	"safe_rshift_func_uint16_t_u_u"
	mov	w4, w23
	mov	w1, w22
	mov	w2, w0
	mov	w0, w19
	uxth	w19, w2
	uxtb	w1, w1
	mov	x2, #13139
	cmp	x1, x2
	cset	w1, lt
	orr	w1, w4, w1
	uxtb	w1, w1
	bl	"safe_mul_func_uint8_t_u_u"
	uxtb	w0, w0
	adrp	x1, "g_157"
	add	x1, x1, #:lo12:"g_157"
	ldr	x1, [x1]
	cmp	x0, x1
	cset	w0, ne
	cmp	w19, w0
	cset	w0, ge
	sxtw	x0, w0
	cmp	x0, #9
	cset	w1, ne
	mov	w19, #-5
.L1289:
	cmp	x21, #0
	cset	w0, ne
	cmp	w0, w1
	cset	w0, le
	mov	w1, #121
	bl	"safe_add_func_int8_t_s_s"
	mov	w3, w20
	sxtb	w0, w0
	cmp	w0, w3
	blt	.L1291
	cmp	w19, #0
.L1291:
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	ldr	x0, [x0]
	ldr	x19, [x29, 72]
	ldr	x20, [x29, 64]
	ldr	x21, [x29, 56]
	ldr	x22, [x29, 48]
	ldr	x23, [x29, 40]
	ldp	x29, x30, [sp], 80
	ret
.type "func_47", @function
.size "func_47", .-"func_47"

.text
.balign 16
"func_61":
	hint	#34
	stp	x29, x30, [sp, -320]!
	mov	x29, sp
	str	x19, [x29, 312]
	str	x20, [x29, 304]
	str	x21, [x29, 296]
	str	x22, [x29, 288]
	add	x4, x29, #24
	adrp	x1, "g_59"
	add	x1, x1, #:lo12:"g_59"
	str	x1, [x4]
	mov	w22, w3
	mov	x3, #96
	add	x1, x29, #24
	add	x19, x1, x3
	mov	w21, w2
	mov	x2, #144
	mov	w1, #0
	mov	x20, x0
	mov	x0, x19
	bl	memset
	mov	w3, w22
	mov	w2, w21
	mov	x0, x20
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x19]
	mov	x4, #120
	add	x1, x29, #24
	add	x4, x1, x4
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x4]
	mov	x4, #144
	add	x1, x29, #24
	add	x4, x1, x4
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x4]
	mov	x4, #168
	add	x1, x29, #24
	add	x4, x1, x4
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x4]
	mov	x4, #192
	add	x1, x29, #24
	add	x4, x1, x4
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x4]
	mov	x4, #216
	add	x1, x29, #24
	add	x4, x1, x4
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	x1, [x4]
	mov	x4, #8
	add	x1, x29, #24
	add	x4, x1, x4
	mov	w1, #0
.L1295:
	cmp	w1, #6
	bge	.L1298
	sxtw	x5, w1
	mov	x6, #8
	mul	x5, x5, x6
	add	x6, x4, x5
	adrp	x5, "g_33"
	add	x5, x5, #:lo12:"g_33"
	str	x5, [x6]
	mov	w5, #1
	add	w1, w1, w5
	b	.L1295
.L1298:
	mov	x4, #56
	add	x1, x29, #24
	add	x4, x1, x4
	mov	w1, #0
.L1300:
	cmp	w1, #5
	bge	.L1303
	sxtw	x5, w1
	mov	x6, #8
	mul	x5, x5, x6
	add	x6, x4, x5
	adrp	x5, "g_132"
	add	x5, x5, #:lo12:"g_132"
	str	x5, [x6]
	mov	w5, #1
	add	w1, w1, w5
	b	.L1300
.L1303:
	mov	x4, #240
	add	x1, x29, #24
	add	x4, x1, x4
	mov	w1, #0
.L1305:
	cmp	w1, #1
	bge	.L1308
	sxtw	x5, w1
	mov	x6, #8
	mul	x5, x5, x6
	add	x6, x4, x5
	adrp	x5, "g_100"
	add	x5, x5, #:lo12:"g_100"
	str	x5, [x6]
	mov	w5, #1
	add	w1, w1, w5
	b	.L1305
.L1308:
	mov	x4, #248
	add	x1, x29, #24
	add	x4, x1, x4
	mov	w1, #0
.L1310:
	cmp	w1, #10
	bge	.L1313
	sxtw	x5, w1
	add	x6, x5, x4
	mov	w5, #255
	strb	w5, [x6]
	mov	w5, #1
	add	w1, w1, w5
	b	.L1310
.L1313:
	mov	x4, #0
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	add	x1, x1, x4
	ldr	w1, [x1]
	mov	w21, w3
	mov	x3, #0
	mov	w20, w2
	adrp	x2, "g_75"
	add	x2, x2, #:lo12:"g_75"
	add	x2, x2, x3
	str	w1, [x2]
	mov	x1, #0
	mov	x19, x0
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	add	x0, x0, x1
	ldr	x0, [x0]
	bl	"func_72"
	mov	w3, w21
	mov	w2, w20
	mov	w1, w0
	mov	x0, x19
	cmp	w1, #0
	mov	w21, w3
	cset	w3, ne
	cmp	w3, #0
	bne	.L1315
	mov	x19, x0
	mov	w0, w3
	b	.L1316
.L1315:
	cmp	w2, #0
	mov	x19, x0
	cset	w0, ne
.L1316:
	mov	w20, w2
	adrp	x2, "g_127"
	add	x2, x2, #:lo12:"g_127"
	mov	w1, #-4
	strb	w1, [x2]
	mov	w1, #252
	bl	"safe_lshift_func_uint8_t_u_u"
	mov	w3, w21
	mov	w2, w20
	mov	w1, w0
	mov	x0, x19
	uxtb	w1, w1
	adrp	x4, "g_33"
	add	x4, x4, #:lo12:"g_33"
	str	w1, [x4]
	sxtw	x1, w1
	adrp	x4, "g_130"
	add	x4, x4, #:lo12:"g_130"
	str	x1, [x4]
	mov	w19, w2
	adrp	x1, "g_132"
	add	x1, x1, #:lo12:"g_132"
	str	x19, [x1]
	mov	x4, #120
	add	x1, x29, #24
	add	x1, x1, x4
	str	x0, [x1]
	mov	w22, w3
	mov	x3, #240
	add	x1, x29, #24
	add	x1, x1, x3
	str	x0, [x1]
	mov	x1, #257
	add	x0, x29, #24
	add	x0, x0, x1
	ldrb	w20, [x0]
	adrp	x0, "g_117"
	add	x0, x0, #:lo12:"g_117"
	ldrsh	w0, [x0]
	add	x1, x29, #24
	cmp	x1, #0
	cset	w1, eq
	mov	w21, w2
	mov	w2, #1
	eor	w1, w1, w2
	cmp	w0, w1
	cset	w0, eq
	sxtw	x0, w0
	adrp	x1, "g_117"+2
	add	x1, x1, #:lo12:"g_117"+2
	ldrsh	w1, [x1]
	sxth	x1, w1
	bl	"safe_add_func_uint64_t_u_u"
	mov	w3, w22
	mov	w2, w21
	cmp	x0, #0
	cset	w0, ne
	cmp	w0, #0
	beq	.L1318
	mov	w0, #1
.L1318:
	cmp	w20, w0
	cset	w0, le
	uxtb	w1, w3
	cmp	w0, w1
	cset	w0, gt
	sxtw	x0, w0
	and	x0, x19, x0
	adrp	x3, "g_92"+2
	add	x3, x3, #:lo12:"g_92"+2
	ldrh	w3, [x3]
	uxth	w3, w3
	cmp	x0, x3
	cset	w0, le
	and	w0, w1, w0
	eor	w0, w2, w0
	cmp	w0, w1
	cset	w0, hi
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	str	w0, [x1]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x1, [x0]
	ldr	x0, [x1]
	str	x0, [x1]
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	ldr	w1, [x1]
	and	w0, w0, w1
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	str	w0, [x1]
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	ldr	x19, [x29, 312]
	ldr	x20, [x29, 304]
	ldr	x21, [x29, 296]
	ldr	x22, [x29, 288]
	ldp	x29, x30, [sp], 320
	ret
.type "func_61", @function
.size "func_61", .-"func_61"

.text
.balign 16
"func_72":
	hint	#34
	sub	sp, sp, #2448
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	str	x19, [x29, 2456]
	str	x20, [x29, 2448]
	str	x21, [x29, 2440]
	str	x22, [x29, 2432]
	str	x23, [x29, 2424]
	mov	x2, #0
	add	x1, x29, #24
	add	x1, x1, x2
	str	x0, [x1]
	mov	x1, #2376
	add	x0, x29, #32
	add	x1, x0, x1
	mov	x2, #0
	add	x0, x29, #24
	add	x0, x0, x2
	ldr	w0, [x0]
	mov	x2, #0
	add	x1, x1, x2
	str	w0, [x1]
	mov	x1, #32
	add	x0, x29, #32
	add	x0, x0, x1
	mov	x2, #336
	mov	w1, #0
	bl	memset
	mov	x1, #40
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #56
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #64
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #80
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #88
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #104
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #128
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #136
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #144
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #152
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #184
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #192
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #200
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #208
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #232
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #248
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #256
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #272
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #280
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #296
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #320
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #328
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #336
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #344
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	str	x0, [x1]
	mov	x1, #368
	add	x0, x29, #32
	add	x19, x0, x1
	mov	w0, #-1
	str	w0, [x19]
	mov	x1, #376
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	str	x0, [x1]
	mov	x1, #384
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_90"
	add	x0, x0, #:lo12:"g_90"
	str	x0, [x1]
	mov	x1, #416
	add	x0, x29, #32
	add	x0, x0, x1
	mov	x2, #1960
	mov	w1, #0
	bl	memset
	mov	x1, #424
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #432
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #440
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #448
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #456
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #464
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #480
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #488
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #496
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #504
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #512
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #520
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #528
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #536
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #560
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #568
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #576
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #584
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #592
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #600
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #608
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #616
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #624
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #632
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #640
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #648
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #656
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #664
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #672
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #680
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #688
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #704
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #712
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #720
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #728
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #736
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #744
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #752
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #760
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #768
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #776
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #784
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #792
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #800
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #808
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #816
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #824
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #840
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #848
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #856
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #864
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #880
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #888
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #896
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #904
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #920
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #928
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #936
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #944
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #952
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #960
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #968
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #984
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #992
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1000
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1016
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1024
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1032
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1040
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1048
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1056
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1064
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1080
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1096
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1104
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1120
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1128
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1136
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1160
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1168
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1176
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1184
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1192
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1216
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1224
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1232
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1240
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1248
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1256
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1264
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1272
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1288
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1296
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1304
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1312
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1320
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1328
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1336
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1344
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1352
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1360
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1368
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1376
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1384
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1400
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1408
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1416
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1424
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1432
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1456
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1464
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1472
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1480
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1488
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1496
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1504
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1512
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1520
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1528
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1544
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1552
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1560
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1568
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1576
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1608
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1616
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1624
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1632
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1640
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1648
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1656
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1664
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1672
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1680
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1688
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1696
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1704
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1712
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1720
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1728
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1736
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1744
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1752
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1760
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1792
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1808
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1816
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1824
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1832
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1840
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1848
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1856
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1864
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1880
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1888
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1904
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1920
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1928
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1936
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1944
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1952
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1960
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1968
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1976
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1984
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #1992
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2000
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2008
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2016
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2024
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2032
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2040
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2048
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2056
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2064
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2072
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2088
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2096
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2104
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2112
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2120
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2128
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2136
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2144
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2152
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2160
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2168
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2176
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2184
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2200
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2208
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2216
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2224
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2232
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2240
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2248
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2256
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2264
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2280
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2288
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2304
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2312
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2328
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2336
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2344
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2352
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2360
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	mov	x1, #2368
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	str	x0, [x1]
	adrp	x1, "g_90"
	add	x1, x1, #:lo12:"g_90"
	adrp	x0, "g_17"
	add	x0, x0, #:lo12:"g_17"
	cmp	x0, x1
	cset	w0, eq
	cmp	w0, #8
	cset	w23, ne
	mov	w21, w23
	mov	x20, x19
	mov	w0, #0
.L1322:
	cmp	w0, #4
	bge	.L1325
	sxtw	x1, w0
	mov	x2, #8
	mul	x2, x1, x2
	add	x1, x29, #32
	add	x2, x1, x2
	mov	x1, #0
	str	x1, [x2]
	mov	w1, #1
	add	w0, w0, w1
	b	.L1322
.L1325:
	mov	w23, w21
	mov	x19, x20
	mov	x1, #392
	add	x0, x29, #32
	add	x20, x0, x1
	mov	w21, w23
	mov	x17, x20
	mov	x20, x19
	mov	x19, x17
	mov	w0, #0
.L1328:
	cmp	w0, #3
	bge	.L1331
	sxtw	x1, w0
	mov	x2, #8
	mul	x1, x1, x2
	add	x2, x1, x19
	mov	x1, #0
	str	x1, [x2]
	mov	w1, #1
	add	w0, w0, w1
	b	.L1328
.L1331:
	mov	w23, w21
	mov	x17, x19
	mov	x19, x20
	mov	x20, x17
	mov	x1, #16
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	str	x0, [x1]
	mov	x1, #272
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	x21, [x0]
	mov	x1, #64
	add	x0, x29, #32
	add	x0, x0, x1
	str	x21, [x0]
	mov	x1, #384
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	x22, [x0]
	mov	x1, #368
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	x1, #33978
	and	x0, x0, x1
	cmp	x0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L1334
	mov	x1, #376
	add	x0, x29, #32
	add	x0, x0, x1
	str	x19, [x0]
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	sxtb	w1, w0
	mov	w0, #14
	bl	"safe_sub_func_int8_t_s_s"
	mov	x1, #376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	x0, [x0]
	ldr	w0, [x0]
	cmp	w0, #0
	cset	w0, ne
.L1334:
	strb	w0, [x22]
	mov	x1, #2376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w1, w0, w1
	sxtw	x0, w1
	cmp	x0, #1
	cset	w0, eq
	sxtb	w1, w1
	bl	"safe_mul_func_int8_t_s_s"
	sxtb	w1, w0
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	cmp	x21, x0
	cset	w0, ne
	cmp	w0, w1
	cset	w0, lt
	adrp	x1, "g_92"+2
	add	x1, x1, #:lo12:"g_92"+2
	ldrh	w1, [x1]
	and	w0, w0, w1
	adrp	x1, "g_92"+2
	add	x1, x1, #:lo12:"g_92"+2
	strh	w0, [x1]
	mov	x1, #376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	x0, [x0]
	adrp	x1, "g_33"
	add	x1, x1, #:lo12:"g_33"
	cmp	x0, x1
	cset	w1, eq
	cmp	w1, #0
	bne	.L1337
	cmp	x19, x0
	cset	w0, eq
	b	.L1338
.L1337:
	mov	w0, w1
.L1338:
	cmp	w0, #0
	bne	.L1340
	adrp	x3, ".__func__.1995"
	add	x3, x3, #:lo12:".__func__.1995"
	mov	w2, #1631
	adrp	x1, ".ts.737"
	add	x1, x1, #:lo12:".ts.737"
	adrp	x0, ".ts.2019"
	add	x0, x0, #:lo12:".ts.2019"
	bl	"__assert_fail"
.L1340:
	adrp	x0, "g_125"
	add	x0, x0, #:lo12:"g_125"
	ldr	w19, [x0]
	adrp	x0, "g_26"
	add	x0, x0, #:lo12:"g_26"
	ldr	x21, [x0]
	adrp	x0, "g_100"
	add	x0, x0, #:lo12:"g_100"
	ldr	w22, [x0]
	mov	w0, #1
	sub	w0, w22, w0
	adrp	x1, "g_100"
	add	x1, x1, #:lo12:"g_100"
	str	w0, [x1]
	mov	x1, #2376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w1, w0, w1
	mov	w0, #1083
	movk	w0, #0xb07e, lsl #16
	bl	"safe_sub_func_int32_t_s_s"
	mov	x1, #384
	add	x0, x29, #32
	add	x1, x0, x1
	adrp	x0, "g_90"
	add	x0, x0, #:lo12:"g_90"
	str	x0, [x1]
	mov	x1, #2376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w23, w0
	cset	w0, ne
	mov	x2, #376
	add	x1, x29, #32
	add	x1, x1, x2
	ldr	x1, [x1]
	ldr	w1, [x1]
	bl	"safe_rshift_func_uint8_t_u_s"
	uxtb	w0, w0
	sxth	w0, w0
	adrp	x1, "g_117"+2
	add	x1, x1, #:lo12:"g_117"+2
	strh	w0, [x1]
	mov	w1, #-3986
	bl	"safe_mod_func_int16_t_s_s"
	sxth	w0, w0
	cmp	w0, #0
	cset	w0, ne
	cmp	w0, #0
	bne	.L1342
	mov	x1, #2376
	add	x0, x29, #32
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w1, #10
	lsl	w0, w0, w1
	mov	w1, #10
	asr	w0, w0, w1
	cmp	w0, #0
	cset	w0, ne
.L1342:
	mov	x2, #2376
	add	x1, x29, #32
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	cmp	w0, w1
	cset	w0, gt
	sxtw	x0, w0
	mov	x1, #60750
	movk	x1, #0xacdd, lsl #16
	movk	x1, #0x2817, lsl #32
	movk	x1, #0xea10, lsl #48
	eor	x0, x0, x1
	mov	x2, #376
	add	x1, x29, #32
	add	x1, x1, x2
	ldr	x1, [x1]
	ldr	w1, [x1]
	sxtw	x1, w1
	cmp	x0, x1
	cset	w0, ls
	mov	w1, #7
	bl	"safe_rshift_func_uint8_t_u_u"
	uxtb	w0, w0
	mov	x2, #2376
	add	x1, x29, #32
	add	x1, x1, x2
	ldr	w1, [x1]
	mov	w2, #10
	lsl	w1, w1, w2
	mov	w2, #10
	asr	w1, w1, w2
	bl	"safe_rshift_func_int16_t_s_u"
	mov	w0, w22
	cmp	x21, x0
	cset	w0, ls
	sxtw	x0, w0
	cmp	x0, #1
	cset	w1, le
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	strb	w1, [x0]
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	ldr	w0, [x0]
	mov	w2, #10
	lsl	w2, w0, w2
	mov	w3, #10
	asr	w2, w2, w3
	eor	w1, w1, w2
	mov	w2, #-4194304
	and	w0, w0, w2
	mov	w2, #4194303
	and	w1, w1, w2
	orr	w0, w0, w1
	adrp	x1, "g_75"
	add	x1, x1, #:lo12:"g_75"
	str	w0, [x1]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x0, [x0]
	adrp	x1, "g_120"
	add	x1, x1, #:lo12:"g_120"
	str	x0, [x1]
	cmp	x20, x0
	cset	w0, ne
	mov	w1, #13
	bl	"safe_lshift_func_int16_t_s_u"
	sxth	x0, w0
	cmp	x0, #0
	cset	w0, gt
	adrp	x1, "g_124"
	add	x1, x1, #:lo12:"g_124"
	strb	w0, [x1]
	mov	w1, #7
	bl	"safe_lshift_func_int8_t_s_s"
	sxtb	w0, w0
	and	w0, w0, w19
	adrp	x1, "g_125"
	add	x1, x1, #:lo12:"g_125"
	str	w0, [x1]
	adrp	x0, "g_120"
	add	x0, x0, #:lo12:"g_120"
	ldr	x1, [x0]
	ldr	x0, [x1]
	str	x0, [x1]
	adrp	x0, "g_100"
	add	x0, x0, #:lo12:"g_100"
	ldr	w0, [x0]
	ldr	x19, [x29, 2456]
	ldr	x20, [x29, 2448]
	ldr	x21, [x29, 2440]
	ldr	x22, [x29, 2432]
	ldr	x23, [x29, 2424]
	ldp	x29, x30, [sp], 16
	add	sp, sp, #2448
	ret
.type "func_72", @function
.size "func_72", .-"func_72"

.data
.balign 1
".__func__.1995":
	.byte 102
	.byte 117
	.byte 110
	.byte 99
	.byte 95
	.byte 55
	.byte 50
	.byte 0

.text
.balign 16
.globl "main"
"main":
	hint	#34
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	str	x19, [x29, 72]
	str	x20, [x29, 64]
	str	x21, [x29, 56]
	str	x22, [x29, 48]
	str	x23, [x29, 40]
	str	x24, [x29, 32]
	cmp	w0, #2
	cset	w0, eq
	cmp	w0, #0
	beq	.L1346
	mov	x0, #8
	add	x0, x1, x0
	ldr	x0, [x0]
	adrp	x1, ".ts.2028"
	add	x1, x1, #:lo12:".ts.2028"
	bl	"strcmp"
	cmp	w0, #0
	cset	w0, eq
.L1346:
	cmp	w0, #0
	bne	.L1348
	mov	w19, #0
	b	.L1349
.L1348:
	mov	w19, #1
.L1349:
	bl	"platform_main_begin"
	bl	"crc32_gentab"
	bl	"func_1"
	mov	w1, w19
	mov	x3, #0
	add	x2, x29, #24
	add	x2, x2, x3
	str	x0, [x2]
	adrp	x0, "g_17"
	add	x0, x0, #:lo12:"g_17"
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2029"
	add	x1, x1, #:lo12:".ts.2029"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_26"
	add	x0, x0, #:lo12:"g_26"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2030"
	add	x1, x1, #:lo12:".ts.2030"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_31"
	add	x0, x0, #:lo12:"g_31"
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2031"
	add	x1, x1, #:lo12:".ts.2031"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_33"
	add	x0, x0, #:lo12:"g_33"
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2032"
	add	x1, x1, #:lo12:".ts.2032"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_35"
	add	x0, x0, #:lo12:"g_35"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2033"
	add	x1, x1, #:lo12:".ts.2033"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_59"
	add	x0, x0, #:lo12:"g_59"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2034"
	add	x1, x1, #:lo12:".ts.2034"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_75"
	add	x0, x0, #:lo12:"g_75"
	ldr	w0, [x0]
	mov	w2, #10
	lsl	w0, w0, w2
	mov	w2, #10
	asr	w0, w0, w2
	sxtw	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2035"
	add	x1, x1, #:lo12:".ts.2035"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_90"
	add	x0, x0, #:lo12:"g_90"
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2036"
	add	x1, x1, #:lo12:".ts.2036"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1351:
	cmp	w20, #5
	bge	.L1355
	sxtw	x0, w20
	mov	x1, #2
	mul	x0, x0, x1
	adrp	x1, "g_92"
	add	x1, x1, #:lo12:"g_92"
	add	x0, x0, x1
	ldrh	w0, [x0]
	uxth	w0, w0
	mov	w2, w19
	adrp	x1, ".ts.2041"
	add	x1, x1, #:lo12:".ts.2041"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1354
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1354:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1351
.L1355:
	mov	w1, w19
	adrp	x0, "g_100"
	add	x0, x0, #:lo12:"g_100"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2046"
	add	x1, x1, #:lo12:".ts.2046"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1358:
	cmp	w20, #2
	bge	.L1362
	sxtw	x0, w20
	mov	x1, #2
	mul	x0, x0, x1
	adrp	x1, "g_117"
	add	x1, x1, #:lo12:"g_117"
	add	x0, x0, x1
	ldrsh	w0, [x0]
	sxth	x0, w0
	mov	w2, w19
	adrp	x1, ".ts.2051"
	add	x1, x1, #:lo12:".ts.2051"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1361
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1361:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1358
.L1362:
	mov	w1, w19
	adrp	x0, "g_119"
	add	x0, x0, #:lo12:"g_119"
	ldrsb	w0, [x0]
	sxtb	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2055"
	add	x1, x1, #:lo12:".ts.2055"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_124"
	add	x0, x0, #:lo12:"g_124"
	ldrsb	w0, [x0]
	sxtb	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2056"
	add	x1, x1, #:lo12:".ts.2056"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_125"
	add	x0, x0, #:lo12:"g_125"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2057"
	add	x1, x1, #:lo12:".ts.2057"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_127"
	add	x0, x0, #:lo12:"g_127"
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2058"
	add	x1, x1, #:lo12:".ts.2058"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_130"
	add	x0, x0, #:lo12:"g_130"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2059"
	add	x1, x1, #:lo12:".ts.2059"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_132"
	add	x0, x0, #:lo12:"g_132"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2060"
	add	x1, x1, #:lo12:".ts.2060"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_157"
	add	x0, x0, #:lo12:"g_157"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2061"
	add	x1, x1, #:lo12:".ts.2061"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_187"
	add	x0, x0, #:lo12:"g_187"
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2062"
	add	x1, x1, #:lo12:".ts.2062"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_188"
	add	x0, x0, #:lo12:"g_188"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2063"
	add	x1, x1, #:lo12:".ts.2063"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_190"
	add	x0, x0, #:lo12:"g_190"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2064"
	add	x1, x1, #:lo12:".ts.2064"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_313"
	add	x0, x0, #:lo12:"g_313"
	ldrh	w0, [x0]
	uxth	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2065"
	add	x1, x1, #:lo12:".ts.2065"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1365:
	cmp	w20, #10
	bge	.L1369
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	adrp	x1, "g_317"
	add	x1, x1, #:lo12:"g_317"
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w19
	adrp	x1, ".ts.2070"
	add	x1, x1, #:lo12:".ts.2070"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1368
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1368:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1365
.L1369:
	mov	w1, w19
	adrp	x0, "g_343"
	add	x0, x0, #:lo12:"g_343"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2074"
	add	x1, x1, #:lo12:".ts.2074"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w21, #0
.L1372:
	cmp	w21, #6
	bge	.L1380
	sxtw	x0, w21
	mov	x1, #12
	mul	x0, x0, x1
	adrp	x1, "g_413"
	add	x1, x1, #:lo12:"g_413"
	add	x22, x0, x1
	mov	w20, #0
.L1375:
	cmp	w20, #3
	bge	.L1379
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	add	x0, x22, x0
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w19
	adrp	x1, ".ts.2083"
	add	x1, x1, #:lo12:".ts.2083"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1378
	mov	w2, w20
	mov	w1, w21
	adrp	x0, ".ts.2086"
	add	x0, x0, #:lo12:".ts.2086"
	bl	"printf"
.L1378:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1375
.L1379:
	mov	w0, #1
	add	w21, w21, w0
	b	.L1372
.L1380:
	mov	w1, w19
	mov	w19, w1
	mov	w23, #0
.L1382:
	cmp	w23, #4
	bge	.L1394
	sxtw	x0, w23
	mov	x1, #144
	mul	x0, x0, x1
	adrp	x1, "g_436"
	add	x1, x1, #:lo12:"g_436"
	add	x24, x0, x1
	mov	w21, #0
.L1385:
	cmp	w21, #2
	bge	.L1393
	sxtw	x0, w21
	mov	x1, #72
	mul	x0, x0, x1
	add	x22, x24, x0
	mov	w20, #0
.L1388:
	cmp	w20, #9
	bge	.L1392
	sxtw	x0, w20
	mov	x1, #8
	mul	x0, x0, x1
	add	x0, x22, x0
	ldr	x0, [x0]
	mov	w2, w19
	adrp	x1, ".ts.2101"
	add	x1, x1, #:lo12:".ts.2101"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1391
	mov	w3, w20
	mov	w2, w21
	mov	w1, w23
	adrp	x0, ".ts.2104"
	add	x0, x0, #:lo12:".ts.2104"
	bl	"printf"
.L1391:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1388
.L1392:
	mov	w0, #1
	add	w21, w21, w0
	b	.L1385
.L1393:
	mov	w0, #1
	add	w23, w23, w0
	b	.L1382
.L1394:
	mov	w1, w19
	adrp	x0, "g_702"
	add	x0, x0, #:lo12:"g_702"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2108"
	add	x1, x1, #:lo12:".ts.2108"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_704"
	add	x0, x0, #:lo12:"g_704"
	ldrb	w0, [x0]
	uxtb	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2109"
	add	x1, x1, #:lo12:".ts.2109"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_747"
	add	x0, x0, #:lo12:"g_747"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2110"
	add	x1, x1, #:lo12:".ts.2110"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_771"
	add	x0, x0, #:lo12:"g_771"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2111"
	add	x1, x1, #:lo12:".ts.2111"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_887"
	add	x0, x0, #:lo12:"g_887"
	ldrsh	w0, [x0]
	sxth	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2112"
	add	x1, x1, #:lo12:".ts.2112"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_1049"
	add	x0, x0, #:lo12:"g_1049"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2113"
	add	x1, x1, #:lo12:".ts.2113"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_1081"
	add	x0, x0, #:lo12:"g_1081"
	ldrsh	w0, [x0]
	sxth	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2114"
	add	x1, x1, #:lo12:".ts.2114"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1397:
	cmp	w20, #9
	bge	.L1401
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	adrp	x1, "g_1219"
	add	x1, x1, #:lo12:"g_1219"
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w19
	adrp	x1, ".ts.2119"
	add	x1, x1, #:lo12:".ts.2119"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1400
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1400:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1397
.L1401:
	mov	w1, w19
	adrp	x0, "g_1270"
	add	x0, x0, #:lo12:"g_1270"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2123"
	add	x1, x1, #:lo12:".ts.2123"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_1304"
	add	x0, x0, #:lo12:"g_1304"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2124"
	add	x1, x1, #:lo12:".ts.2124"
	bl	"transparent_crc"
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1404:
	cmp	w20, #9
	bge	.L1408
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	adrp	x1, "g_1326"
	add	x1, x1, #:lo12:"g_1326"
	add	x0, x0, x1
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w19
	adrp	x1, ".ts.2129"
	add	x1, x1, #:lo12:".ts.2129"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1407
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1407:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1404
.L1408:
	mov	w1, w19
	mov	w19, w1
	mov	w23, #0
.L1410:
	cmp	w23, #3
	bge	.L1422
	sxtw	x0, w23
	mov	x1, #32
	mul	x0, x0, x1
	adrp	x1, "g_1523"
	add	x1, x1, #:lo12:"g_1523"
	add	x24, x0, x1
	mov	w21, #0
.L1413:
	cmp	w21, #4
	bge	.L1421
	sxtw	x0, w21
	mov	x1, #8
	mul	x0, x0, x1
	add	x22, x24, x0
	mov	w20, #0
.L1416:
	cmp	w20, #2
	bge	.L1420
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	add	x0, x22, x0
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w19
	adrp	x1, ".ts.2145"
	add	x1, x1, #:lo12:".ts.2145"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1419
	mov	w3, w20
	mov	w2, w21
	mov	w1, w23
	adrp	x0, ".ts.2104"
	add	x0, x0, #:lo12:".ts.2104"
	bl	"printf"
.L1419:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1416
.L1420:
	mov	w0, #1
	add	w21, w21, w0
	b	.L1413
.L1421:
	mov	w0, #1
	add	w23, w23, w0
	b	.L1410
.L1422:
	mov	w1, w19
	mov	w19, w1
	mov	w20, #0
.L1424:
	cmp	w20, #7
	bge	.L1428
	sxtw	x0, w20
	mov	x1, #4
	mul	x0, x0, x1
	adrp	x1, "g_1713"
	add	x1, x1, #:lo12:"g_1713"
	add	x0, x0, x1
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w19
	adrp	x1, ".ts.2155"
	add	x1, x1, #:lo12:".ts.2155"
	bl	"transparent_crc"
	cmp	w19, #0
	beq	.L1427
	mov	w1, w20
	adrp	x0, ".ts.2044"
	add	x0, x0, #:lo12:".ts.2044"
	bl	"printf"
.L1427:
	mov	w0, #1
	add	w20, w20, w0
	b	.L1424
.L1428:
	mov	w1, w19
	adrp	x0, "g_1802"
	add	x0, x0, #:lo12:"g_1802"
	ldr	w0, [x0]
	sxtw	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2159"
	add	x1, x1, #:lo12:".ts.2159"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_1877"
	add	x0, x0, #:lo12:"g_1877"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2160"
	add	x1, x1, #:lo12:".ts.2160"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_1965"
	add	x0, x0, #:lo12:"g_1965"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2161"
	add	x1, x1, #:lo12:".ts.2161"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_2183"
	add	x0, x0, #:lo12:"g_2183"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2162"
	add	x1, x1, #:lo12:".ts.2162"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_2422"
	add	x0, x0, #:lo12:"g_2422"
	ldrsh	w0, [x0]
	sxth	x0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2163"
	add	x1, x1, #:lo12:".ts.2163"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_2684"
	add	x0, x0, #:lo12:"g_2684"
	ldr	w0, [x0]
	mov	w0, w0
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2164"
	add	x1, x1, #:lo12:".ts.2164"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "g_2725"
	add	x0, x0, #:lo12:"g_2725"
	ldr	x0, [x0]
	mov	w2, w1
	mov	w19, w1
	adrp	x1, ".ts.2165"
	add	x1, x1, #:lo12:".ts.2165"
	bl	"transparent_crc"
	mov	w1, w19
	adrp	x0, "crc32_context"
	add	x0, x0, #:lo12:"crc32_context"
	ldr	w0, [x0]
	mov	w0, w0
	mov	x2, #4294967295
	eor	x0, x0, x2
	bl	"platform_main_end"
	mov	w0, #0
	ldr	x19, [x29, 72]
	ldr	x20, [x29, 64]
	ldr	x21, [x29, 56]
	ldr	x22, [x29, 48]
	ldr	x23, [x29, 40]
	ldr	x24, [x29, 32]
	ldp	x29, x30, [sp], 80
	ret
.type "main", @function
.size "main", .-"main"

.data
.balign 1
".ts.881":
	.byte 37
	.byte 105
	.byte 10
	.byte 0

.data
.balign 1
".ts.794":
	.byte 40
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 56
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.1359":
	.byte 40
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 54
	.byte 93
	.byte 91
	.byte 53
	.byte 93
	.byte 91
	.byte 49
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.736":
	.byte 40
	.byte 103
	.byte 95
	.byte 49
	.byte 52
	.byte 51
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 52
	.byte 51
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 56
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.746":
	.byte 40
	.byte 103
	.byte 95
	.byte 49
	.byte 52
	.byte 51
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 52
	.byte 51
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 56
	.byte 93
	.byte 41
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 52
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1247":
	.byte 40
	.byte 108
	.byte 95
	.byte 49
	.byte 56
	.byte 51
	.byte 51
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 51
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 108
	.byte 95
	.byte 49
	.byte 56
	.byte 51
	.byte 51
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 51
	.byte 91
	.byte 51
	.byte 93
	.byte 91
	.byte 57
	.byte 93
	.byte 41
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 49
	.byte 56
	.byte 51
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1552":
	.byte 40
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 55
	.byte 50
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 55
	.byte 50
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 54
	.byte 93
	.byte 91
	.byte 53
	.byte 93
	.byte 91
	.byte 49
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.1775":
	.byte 40
	.byte 108
	.byte 95
	.byte 54
	.byte 52
	.byte 51
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 57
	.byte 50
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 108
	.byte 95
	.byte 54
	.byte 52
	.byte 51
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 57
	.byte 50
	.byte 91
	.byte 52
	.byte 93
	.byte 41
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 54
	.byte 52
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.670":
	.byte 46
	.byte 46
	.byte 46
	.byte 99
	.byte 104
	.byte 101
	.byte 99
	.byte 107
	.byte 115
	.byte 117
	.byte 109
	.byte 32
	.byte 97
	.byte 102
	.byte 116
	.byte 101
	.byte 114
	.byte 32
	.byte 104
	.byte 97
	.byte 115
	.byte 104
	.byte 105
	.byte 110
	.byte 103
	.byte 32
	.byte 37
	.byte 115
	.byte 32
	.byte 58
	.byte 32
	.byte 37
	.byte 108
	.byte 88
	.byte 10
	.byte 0

.data
.balign 1
".ts.2028":
	.byte 49
	.byte 0

.data
.balign 1
".ts.737":
	.byte 98
	.byte 97
	.byte 100
	.byte 46
	.byte 99
	.byte 0

.data
.balign 1
".ts.5":
	.byte 99
	.byte 104
	.byte 101
	.byte 99
	.byte 107
	.byte 115
	.byte 117
	.byte 109
	.byte 32
	.byte 61
	.byte 32
	.byte 37
	.byte 88
	.byte 10
	.byte 0

.data
.balign 1
".ts.2046":
	.byte 103
	.byte 95
	.byte 49
	.byte 48
	.byte 48
	.byte 0

.data
.balign 1
".ts.2113":
	.byte 103
	.byte 95
	.byte 49
	.byte 48
	.byte 52
	.byte 57
	.byte 0

.data
.balign 1
".ts.2114":
	.byte 103
	.byte 95
	.byte 49
	.byte 48
	.byte 56
	.byte 49
	.byte 0

.data
.balign 1
".ts.2051":
	.byte 103
	.byte 95
	.byte 49
	.byte 49
	.byte 55
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.2055":
	.byte 103
	.byte 95
	.byte 49
	.byte 49
	.byte 57
	.byte 0

.data
.balign 1
".ts.1364":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 55
	.byte 53
	.byte 54
	.byte 0

.data
.balign 1
".ts.1883":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 50
	.byte 57
	.byte 52
	.byte 0

.data
.balign 1
".ts.1960":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 50
	.byte 57
	.byte 52
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.919":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 0

.data
.balign 1
".ts.1329":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1952":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 50
	.byte 57
	.byte 52
	.byte 0

.data
.balign 1
".ts.1124":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 0

.data
.balign 1
".ts.1436":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 55
	.byte 53
	.byte 54
	.byte 0

.data
.balign 1
".ts.2119":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 49
	.byte 57
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.2056":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 52
	.byte 0

.data
.balign 1
".ts.2057":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 53
	.byte 0

.data
.balign 1
".ts.2058":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 55
	.byte 0

.data
.balign 1
".ts.2123":
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 55
	.byte 48
	.byte 0

.data
.balign 1
".ts.2059":
	.byte 103
	.byte 95
	.byte 49
	.byte 51
	.byte 48
	.byte 0

.data
.balign 1
".ts.2124":
	.byte 103
	.byte 95
	.byte 49
	.byte 51
	.byte 48
	.byte 52
	.byte 0

.data
.balign 1
".ts.2060":
	.byte 103
	.byte 95
	.byte 49
	.byte 51
	.byte 50
	.byte 0

.data
.balign 1
".ts.2129":
	.byte 103
	.byte 95
	.byte 49
	.byte 51
	.byte 50
	.byte 54
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.808":
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 50
	.byte 50
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 50
	.byte 50
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 50
	.byte 48
	.byte 0

.data
.balign 1
".ts.2145":
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 50
	.byte 51
	.byte 91
	.byte 105
	.byte 93
	.byte 91
	.byte 106
	.byte 93
	.byte 91
	.byte 107
	.byte 93
	.byte 0

.data
.balign 1
".ts.2061":
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 55
	.byte 0

.data
.balign 1
".ts.2029":
	.byte 103
	.byte 95
	.byte 49
	.byte 55
	.byte 0

.data
.balign 1
".ts.2155":
	.byte 103
	.byte 95
	.byte 49
	.byte 55
	.byte 49
	.byte 51
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.2159":
	.byte 103
	.byte 95
	.byte 49
	.byte 56
	.byte 48
	.byte 50
	.byte 0

.data
.balign 1
".ts.2062":
	.byte 103
	.byte 95
	.byte 49
	.byte 56
	.byte 55
	.byte 0

.data
.balign 1
".ts.2160":
	.byte 103
	.byte 95
	.byte 49
	.byte 56
	.byte 55
	.byte 55
	.byte 0

.data
.balign 1
".ts.2063":
	.byte 103
	.byte 95
	.byte 49
	.byte 56
	.byte 56
	.byte 0

.data
.balign 1
".ts.2064":
	.byte 103
	.byte 95
	.byte 49
	.byte 57
	.byte 48
	.byte 0

.data
.balign 1
".ts.2161":
	.byte 103
	.byte 95
	.byte 49
	.byte 57
	.byte 54
	.byte 53
	.byte 0

.data
.balign 1
".ts.1277":
	.byte 103
	.byte 95
	.byte 50
	.byte 48
	.byte 48
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 0

.data
.balign 1
".ts.1288":
	.byte 103
	.byte 95
	.byte 50
	.byte 48
	.byte 48
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 50
	.byte 48
	.byte 48
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 53
	.byte 57
	.byte 0

.data
.balign 1
".ts.2162":
	.byte 103
	.byte 95
	.byte 50
	.byte 49
	.byte 56
	.byte 51
	.byte 0

.data
.balign 1
".ts.2163":
	.byte 103
	.byte 95
	.byte 50
	.byte 52
	.byte 50
	.byte 50
	.byte 0

.data
.balign 1
".ts.2030":
	.byte 103
	.byte 95
	.byte 50
	.byte 54
	.byte 0

.data
.balign 1
".ts.2164":
	.byte 103
	.byte 95
	.byte 50
	.byte 54
	.byte 56
	.byte 52
	.byte 0

.data
.balign 1
".ts.2165":
	.byte 103
	.byte 95
	.byte 50
	.byte 55
	.byte 50
	.byte 53
	.byte 0

.data
.balign 1
".ts.1182":
	.byte 103
	.byte 95
	.byte 50
	.byte 57
	.byte 53
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 50
	.byte 50
	.byte 0

.data
.balign 1
".ts.801":
	.byte 103
	.byte 95
	.byte 50
	.byte 57
	.byte 53
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 103
	.byte 95
	.byte 50
	.byte 57
	.byte 53
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 49
	.byte 53
	.byte 50
	.byte 50
	.byte 0

.data
.balign 1
".ts.2031":
	.byte 103
	.byte 95
	.byte 51
	.byte 49
	.byte 0

.data
.balign 1
".ts.2065":
	.byte 103
	.byte 95
	.byte 51
	.byte 49
	.byte 51
	.byte 0

.data
.balign 1
".ts.2070":
	.byte 103
	.byte 95
	.byte 51
	.byte 49
	.byte 55
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.2032":
	.byte 103
	.byte 95
	.byte 51
	.byte 51
	.byte 0

.data
.balign 1
".ts.2074":
	.byte 103
	.byte 95
	.byte 51
	.byte 52
	.byte 51
	.byte 0

.data
.balign 1
".ts.2033":
	.byte 103
	.byte 95
	.byte 51
	.byte 53
	.byte 0

.data
.balign 1
".ts.2083":
	.byte 103
	.byte 95
	.byte 52
	.byte 49
	.byte 51
	.byte 91
	.byte 105
	.byte 93
	.byte 91
	.byte 106
	.byte 93
	.byte 0

.data
.balign 1
".ts.2101":
	.byte 103
	.byte 95
	.byte 52
	.byte 51
	.byte 54
	.byte 91
	.byte 105
	.byte 93
	.byte 91
	.byte 106
	.byte 93
	.byte 91
	.byte 107
	.byte 93
	.byte 0

.data
.balign 1
".ts.2034":
	.byte 103
	.byte 95
	.byte 53
	.byte 57
	.byte 0

.data
.balign 1
".ts.2108":
	.byte 103
	.byte 95
	.byte 55
	.byte 48
	.byte 50
	.byte 0

.data
.balign 1
".ts.2109":
	.byte 103
	.byte 95
	.byte 55
	.byte 48
	.byte 52
	.byte 0

.data
.balign 1
".ts.2110":
	.byte 103
	.byte 95
	.byte 55
	.byte 52
	.byte 55
	.byte 0

.data
.balign 1
".ts.2035":
	.byte 103
	.byte 95
	.byte 55
	.byte 53
	.byte 46
	.byte 102
	.byte 48
	.byte 0

.data
.balign 1
".ts.2111":
	.byte 103
	.byte 95
	.byte 55
	.byte 55
	.byte 49
	.byte 0

.data
.balign 1
".ts.2112":
	.byte 103
	.byte 95
	.byte 56
	.byte 56
	.byte 55
	.byte 0

.data
.balign 1
".ts.2036":
	.byte 103
	.byte 95
	.byte 57
	.byte 48
	.byte 0

.data
.balign 1
".ts.2041":
	.byte 103
	.byte 95
	.byte 57
	.byte 50
	.byte 91
	.byte 105
	.byte 93
	.byte 0

.data
.balign 1
".ts.2044":
	.byte 105
	.byte 110
	.byte 100
	.byte 101
	.byte 120
	.byte 32
	.byte 61
	.byte 32
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 10
	.byte 0

.data
.balign 1
".ts.2086":
	.byte 105
	.byte 110
	.byte 100
	.byte 101
	.byte 120
	.byte 32
	.byte 61
	.byte 32
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 10
	.byte 0

.data
.balign 1
".ts.2104":
	.byte 105
	.byte 110
	.byte 100
	.byte 101
	.byte 120
	.byte 32
	.byte 61
	.byte 32
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 91
	.byte 37
	.byte 100
	.byte 93
	.byte 10
	.byte 0

.data
.balign 1
".ts.966":
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 52
	.byte 53
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 49
	.byte 48
	.byte 0

.data
.balign 1
".ts.1032":
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 57
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1041":
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 57
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 40
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 57
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 108
	.byte 95
	.byte 49
	.byte 53
	.byte 56
	.byte 57
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 54
	.byte 93
	.byte 91
	.byte 53
	.byte 93
	.byte 91
	.byte 49
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.1464":
	.byte 108
	.byte 95
	.byte 49
	.byte 55
	.byte 54
	.byte 50
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 56
	.byte 57
	.byte 54
	.byte 0

.data
.balign 1
".ts.1445":
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 55
	.byte 53
	.byte 54
	.byte 0

.data
.balign 1
".ts.1485":
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 57
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 55
	.byte 53
	.byte 54
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 40
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 62
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 91
	.byte 48
	.byte 93
	.byte 32
	.byte 38
	.byte 38
	.byte 32
	.byte 108
	.byte 95
	.byte 50
	.byte 48
	.byte 53
	.byte 51
	.byte 32
	.byte 60
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 49
	.byte 52
	.byte 56
	.byte 57
	.byte 91
	.byte 54
	.byte 93
	.byte 91
	.byte 53
	.byte 93
	.byte 91
	.byte 49
	.byte 93
	.byte 41
	.byte 0

.data
.balign 1
".ts.1903":
	.byte 108
	.byte 95
	.byte 51
	.byte 50
	.byte 52
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 112
	.byte 95
	.byte 52
	.byte 54
	.byte 0

.data
.balign 1
".ts.1701":
	.byte 108
	.byte 95
	.byte 53
	.byte 48
	.byte 51
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1749":
	.byte 108
	.byte 95
	.byte 53
	.byte 49
	.byte 50
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 53
	.byte 49
	.byte 50
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 52
	.byte 55
	.byte 54
	.byte 0

.data
.balign 1
".ts.1784":
	.byte 108
	.byte 95
	.byte 54
	.byte 55
	.byte 48
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 54
	.byte 55
	.byte 49
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 54
	.byte 55
	.byte 48
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.1789":
	.byte 108
	.byte 95
	.byte 54
	.byte 56
	.byte 52
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 48
	.byte 0

.data
.balign 1
".ts.2012":
	.byte 108
	.byte 95
	.byte 56
	.byte 49
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 53
	.byte 57
	.byte 0

.data
.balign 1
".ts.2019":
	.byte 108
	.byte 95
	.byte 56
	.byte 56
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 103
	.byte 95
	.byte 51
	.byte 51
	.byte 32
	.byte 124
	.byte 124
	.byte 32
	.byte 108
	.byte 95
	.byte 56
	.byte 56
	.byte 32
	.byte 61
	.byte 61
	.byte 32
	.byte 38
	.byte 108
	.byte 95
	.byte 56
	.byte 52
	.byte 0

/* floating point constants */
.section .rodata
.p2align 3
.Lfp10:
	.quad 9214364837600034815 /* 89884656743115785407263711865852178399035283762922498299458738401578630390014269380294779316383439085770229476757191232117160663444732091384233773351768758493024955288275641038122745045194664472037934254227566971152291618451611474082904279666061674137398913102072361584369088590459649940625202013092062429184.000000 */

.section .rodata
.p2align 3
.Lfp11:
	.quad 4602678819172646912 /* 0.500000 */

.section .rodata
.p2align 3
.Lfp12:
	.quad 4607182418800017407 /* 1.000000 */

.section .rodata
.p2align 3
.Lfp13:
	.quad 445856363109679104 /* 0.000000 */

.section .rodata
.p2align 3
.Lfp14:
	.quad 4156822456062967808 /* 0.000000 */

.section .rodata
.p2align 3
.Lfp15:
	.quad 4607182418800017408 /* 1.000000 */

.section .rodata
.p2align 3
.Lfp16:
	.quad 0 /* 0.000000 */

.section .rodata
.p2align 3
.Lfp17:
	.quad 4382002437431492607 /* 0.000000 */

.section .rodata
.p2align 3
.Lfp18:
	.quad 5057542381537067008 /* 1267650600228229401496703205376.000000 */

.section .rodata
.p2align 3
.Lfp19:
	.quad 220676381741154304 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp0:
	.int 2130706431 /* 170141173319264429905852091742258462720.000000 */

.section .rodata
.p2align 2
.Lfp1:
	.int 1056964608 /* 0.500000 */

.section .rodata
.p2align 2
.Lfp2:
	.int 1065353215 /* 1.000000 */

.section .rodata
.p2align 2
.Lfp3:
	.int 830472192 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp4:
	.int 226492416 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp5:
	.int 1065353216 /* 1.000000 */

.section .rodata
.p2align 2
.Lfp6:
	.int 0 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp7:
	.int 889192447 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp8:
	.int 1904214016 /* 1267650600228229401496703205376.000000 */

.section .rodata
.p2align 2
.Lfp9:
	.int 654311424 /* 0.000000 */

.section .rodata
.p2align 2
.Lfp20:
	.int -822083584 /* -2147483648.000000 */

.section .rodata
.p2align 2
.Lfp21:
	.int 1325400064 /* 2147483648.000000 */

.section .note.GNU-stack,"",@progbits
