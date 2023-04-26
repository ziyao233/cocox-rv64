/*
 *	cocox-rv64
 *	/src/start.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#include<board/hart.h>

	.global		_start

	.text
_start:
	/*	Currently only on processor is used	*/
	csrr		t0,		mhartid
	la		t1,		.stack
	slli		t2,		t0,		12
	add		sp,		t1,		t2
	bnez		t0,		.halt

	/*	Clear .bss	*/
	la		a0,		__bss_start
	la		a1,		__bss_end
.clear_bss:
	sd		zero,		0(a0)
	addi		a0,		a0,		8
	bltu		a0,		a1,		.clear_bss

	j		kernel_start

.halt:
	wfi
	j		.halt

	.data

.hello:	.asciz	"Cocox-rv64 built " __DATE__ " " __TIME__

	.bss
.stack:
	.skip		BOARD_HART_NUM * 4096
