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

	/*	Prepare for switching to S-mode	*/

	/*	Disable Physical Memory Protection	*/
	csrw		pmpcfg0,	0x0f
	li		t0,		0x3fffffffffffff
	csrw		pmpaddr0,	t0

	//	Disable paging
	csrw		satp,		zero

	//	Save mhartid
	csrr		tp,		mhartid

	/*	Delegate interrupts to S-Mode	*/
	li		t0,		0xffff
	csrw		medeleg,	t0
	csrw		mideleg,	t0

	/*	Enable external, timer and software interrupts	*/
/*
	li		t0,		1 << 3
	csrs		mie,		t0
	li		t0,		1 << 7
	csrs		mie,		t0
	li		t0,		1 << 11
	csrs		mie,		t0
*/

	csrr		t0,		mstatus
	li		t1,		~(3 << 11)
	and		t0,		t0,		t1
	li		t1,		1 << 11
	or		t0,		t0,		t1
	csrw		mstatus,	t0
	la		t0,		kernel_start
	csrw		mepc,		t0
	mret

.halt:
	wfi
	j		.halt

	.data

.hello:	.asciz	"Cocox-rv64 built " __DATE__ " " __TIME__

	.bss
.stack:
	.skip		BOARD_HART_NUM * 4096
