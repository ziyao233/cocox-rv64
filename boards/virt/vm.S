/*
 *	cocox-rv64
 *	/boards/virt/vm.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#include<board/uart.h>
	.global		board_vm_kinit

	.text
/*
 *	Initialise board-specific kernel memory mapping
 *	a0:	The root page table
 */
board_vm_kinit:
	addi		sp,		sp,		-16
	sd		ra,		0(sp)
	sd		s0,		8(sp)

	mv		s0,		a0

	li		a1,		BOARD_UART0_BASE
	mv		a2,		a1
	li		a3,		0xf		// RWXV
	call		vm_map

	ld		ra,		0(sp)
	ld		s0,		8(sp)
	addi		sp,		sp,		16
	ret
