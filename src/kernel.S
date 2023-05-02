/*
 *	cocox-rv64
 *	/src/kernel.S
 *	By MIT License,
 *	Copyright (c) 2023 Ziyao.
 */

	.global		kernel_start

	.text

init_exception:
	la		t0,		exception_handler
	csrw		stvec,		t0
	ret

kernel_start:
	call		printk_init
	la		a0,		.kernelBuiltInfo
	call		printk
	call		printk_newline

	call		init_exception

	la		a0,		.kernelInitPages
	call		page_allocator_init
	call		printk_num
	la		a0,		.availablePages
	call		printk

	la		a0,		.initKernelPageTable
	call		printk
	call		vm_kinit

	la		a0,		.enablePaging
	call		printk
	call		vm_kenable_paging

	la		a0,		.done
	call		printk
	call		printk_newline
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
.initKernelPageTable:
	.asciz		"Initializing kernel page table...\n"
.enablePaging:
	.asciz		"Enable paging...\n"
.done:	.asciz		"done\n"
	.align		4
