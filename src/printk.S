/*
 *	Cocox-rv64
 *	/src/printk.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#include<board/uart.h>

	.global		printk
	.global		printk_init
	.global		printk_numhex
	.global		printk_num
	.global		printk_newline

	.text

/*
 *	Print a character to UART
 *	a0:	Character in ASCII
 */
.putchar:
	j		board_console_putchar_sync

printk_init:
	j		board_console_init

/*
 *	Print a string to UART
 *	a0:	Pointer to the string
 */
printk:
	add		sp,		sp,		16
	sd		s0,		0(sp)
	sd		ra,		8(sp)
	mv		s0,		a0

.put:
	lb		a0,		0(s0)
	call		.putchar
	addi		s0,		s0,		1
	bnez		a0,		.put

	ld		s0,		0(sp)
	ld		ra,		8(sp)
	add		sp,		sp,		-16
	ret

printk_newline:
	li		a0,		10
	j		.putchar
