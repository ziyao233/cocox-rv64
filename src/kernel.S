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

.loop:
	wfi
	j		.loop

	.data
.kernelBuiltInfo:
	.asciz		"Cocox-rv64 built on " __DATE__ " at " __TIME__