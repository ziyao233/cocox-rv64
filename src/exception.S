/*
 *	cocox-rv64
 *	/src/exception.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

	.global		exception_handler

	.text
context_dump:
	addi		sp,		sp,		-16
	sd		s0,		0(sp)
	sd		s1,		8(sp)
	mv		s0,		a0
	mv		s1,		a0

	la		a0,		.msg_exception
	call		printk

	csrr		a0,		scause
	call		printk_numhex
	call		printk_newline

	la		a0,		.msg_sepc
	call		printk
	csrr		a0,		sepc
	call		printk_numhex
	call		printk_tab

	la		a0,		.msg_stval
	call		printk
	csrr		a0,		stval
	call		printk_numhex
	call		printk_newline

	la		a0,		.msg_ra
	call		printk
	ld		a0,		0(s0)
	call		printk_numhex
	call		printk_newline

	la		a0,		.msg_tx
	call		printk
	addi		s1,		s1,		56
.print_tx:
	ld		a0,		0(s0)
	call		printk_numhex
	call		printk_tab
	addi		s0,		s0,		8
	blt		s0,		s1,		.print_tx

	call		printk_newline

	la		a0,		.msg_ax
	call		printk
	addi		s1,		s1,		64
.print_ax:
	ld		a0,		0(s0)
	call		printk_numhex
	call		printk_tab
	addi		s0,		s0,		8
	blt		s0,		s1,		.print_ax

	call		printk_newline

	la		a0,		.msg_sx
	call		printk

	ld		a0,		0(sp)
	call		printk_numhex
	call		printk_tab
	ld		a0,		8(sp)
	call		printk_numhex
	call		printk_tab
	mv		a0,		s2
	call		printk_numhex
	call		printk_tab
	mv		a0,		s3
	call		printk_numhex
	call		printk_tab
	mv		a0,		s4
	call		printk_numhex
	call		printk_tab
	mv		a0,		s5
	call		printk_numhex
	call		printk_tab
	mv		a0,		s6
	call		printk_numhex
	call		printk_tab
	mv		a0,		s7
	call		printk_numhex
	call		printk_newline

	addi		sp,		sp,		16
.loop:
	wfi
	j		.loop

exception_handler:
	addi		sp,		sp,		-256
	sd		ra,		0(sp)
	sd		t0,		8(sp)
	sd		t1,		16(sp)
	sd		t2,		24(sp)
	sd		t3,		32(sp)
	sd		t4,		40(sp)
	sd		t5,		48(sp)
	sd		t6,		56(sp)
	sd		a0,		64(sp)
	sd		a1,		72(sp)
	sd		a2,		80(sp)
	sd		a3,		88(sp)
	sd		a4,		96(sp)
	sd		a5,		108(sp)
	sd		a6,		112(sp)
	sd		a7,		120(sp)

	addi		a0,		sp,		8

	j		context_dump

	.data
.msg_exception:
	.asciz		"Unhandled exception: scause = "
.msg_scause:
	.asciz		"scause: "
.msg_sepc:
	.asciz		"sepc: "
.msg_stval:
	.asciz		"stval: "
.msg_ra:
	.asciz		"ra: "
.msg_tx:
	.asciz		"tx:\n"
.msg_ax:
	.asciz		"ax:\n"
.msg_sx:
	.asciz		"sx:\n"
