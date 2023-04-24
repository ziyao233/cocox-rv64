/*
 *	cocox-rv64
 *	/src/start.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#include<board/uart.h>

	.global		_start

	.text
_start:
	/*	Currently only on processor is used	*/
	csrr		t0,		mhartid
	bnez		t0,		.halt

	la		a0,		.hello
	la		a1,		UART_THR

.wait_loop:
	la		t0,		UART_LSR
	lb		t0,		0(t0)
	li		t1,		UART_LSR_EMPTY_MASK
	and		t0,		t0,		t1
	beqz		t0,		.wait_loop

	lb		t0,		0(a0)
	sb		t0,		0(a1)
	add		a0,		a0,		1
	bnez		t0,		.wait_loop

.halt:
	wfi
	j		.halt

	.data

.hello:	.asciz	"Hello world!\0"
