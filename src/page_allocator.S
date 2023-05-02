/*
 *	cocox-rv64
 *	/src/page_allocator.S
 *	By MIT License
 *	Copyright (c) 2023 Ziyao.
 */

	.global		page_allocator_init
	.global		page_alloc
	.global		page_free

	.text
page_allocator_init:
	la		a1,		__free_pages_start
	li		t0,		4095
	add		a1,		a1,		t0
	li		t0,		~4095
	and		a1,		a1,		t0
	la		a2,		__mem_end
	la		t0,		pages		// t0 holds the lass
							// node
	li		t1,		4096
	mv		a0,		zero
.init_next_page:
	sd		a1,		0(t0)
	mv		t0,		a1
	add		a1,		a1,		t1
	add		a0,		a0,		1
	blt		a1,		a2,		.init_next_page

	sd		zero,		0(t0)
	ret

/*
 *	Allocate a physical page	(4k)
 *	Return: The beginning address of the page
 */
page_alloc:
	la		a1,		pages
	ld		a0,		0(a1)
	beqz		a0,		.no_available
	ld		t0,		0(a0)
	sd		t0,		0(a1)
.no_available:
	ret

/*
 *	Free a physical page		(4k)
 *	a0: The start address of the page
 */
page_free:
	beqz		a0,		.null_page
	la		t0,		pages
	ld		t1,		0(t0)
	sd		t1,		0(a0)
	sd		a0,		0(t0)
.null_page:
	ret

	.data
pages:	.quad		0
