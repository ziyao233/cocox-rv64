/*
 *	cocox-rv64
 *	/src/kernel.S
 *	By MIT License,
 *	Copyright (c) 2023 Ziyao.
 */

	.global		kernel_start

	.text

kernel_start:
	call		printk_init
	la		a0,		.kernelBuiltInfo
	call		printk
	call		printk_newline

	la		a0,		.kernelInitPages
	call		page_allocator_init
	call		printk_num
	la		a0,		.availablePages
	call		printk

	call		page_alloc
	mv		s0,		a0
	call		printk_numhex
	call		printk_newline
	call		page_alloc
	mv		s1,		a0
	call		printk_numhex
	call		printk_newline

	mv		a0,		s0
	call		page_free
	mv		a0,		s1
	call		page_free

	call		page_alloc
	mv		s0,		a0
	call		printk_numhex
	call		printk_newline

	mv		a0,		zero
	call		page_free

	la		a0,		.done
	call		printk

.loop:
	wfi
	j		.loop

	.data
.kernelBuiltInfo:
	.asciz		"Cocox-rv64 built on " __DATE__ " at " __TIME__
.kernelInitPages:
	.asciz		"Initializing page allocator..."
.availablePages:
	.asciz		" pages (4k) available.\n"
.done:	.asciz		"done\n"
