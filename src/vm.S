/*
 *	cocox-rv64
 *	/src/vm.S
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#include<cocox/tools.h>

	.global		kPageTable
	.global		vm_map
	.global		vm_map_range
	.global		vm_kinit
	.global		vm_kenable_paging

	.text
/*
 *	Get the leaf-level page table entry
 *	a0:	Root page table
 *	a1:	Virtual address
 *	a2:	Attributes
 *	Only 4K pages are used
 */
walk:
	addi		sp,		sp,		-48
	sd		ra,		0(sp)
	sd		s0,		8(sp)
	sd		s1,		16(sp)
	sd		s2,		24(sp)
	sd		s3,		32(sp)
	sd		s4,		40(sp)

	/*
	 *	s0:	Address of current level of page table
	 *	s1	Remaining bits of virtual address
	 *	s2	Level counter
	 *	s3	Attributes
	 *	s4	Temporarily holds the entry address
	 */
	mv		s0,		a0
	slli		s1,		a1,		25
	li		s2,		2
	and		s3,		a2,		0x11

.convert:
	srli		t0,		s1,		55
	slli		t0,		t0,		3
	add		s4,		s0,		t0
	ld		t1,		0(s4)
	and		t2,		t1,		1
	bnez		t2,		.entry_exist

	call		page_alloc
	mv		t0,		a0
	li		t1,		4096
	kmem_zero	t0,		t1
	srli		t1,		a0,		2
	or		t1,		t1,		s3
	sd		t1,		0(s4)
	
	// t1 holds the entry
.entry_exist:
	slli		t0,		t1,		2
	li		t1,		~4095
	and		s0,		t1,		t0
	addi		s2,		s2,		-1
	slli		s1,		s1,		9
	bnez		s2,		.convert

	srli		t0,		s1,		52
	add		a0,		s0,		t0

	ld		ra,		0(sp)
	ld		s0,		8(sp)
	ld		s1,		16(sp)
	ld		s2,		24(sp)
	ld		s3,		32(sp)
	ld		s4,		40(sp)
	addi		sp,		sp,		48
	ret

/*
 *	Map a virtual page to a physical one
 *	a0	Root page table
 *	a1	Virtual Address
 *	a2	Physical Address
 *	a3	Attributes
 */
vm_map:
	addi		sp,		sp,		-16
	sd		ra,		0(sp)
	srli		t0,		a2,		2
	or		t0,		a3,		t0
	sd		t0,		8(sp)
	mv		a2,		a3
	call		walk
	ld		t0,		8(sp)
	sd		t0,		0(a0)
	ld		ra,		0(sp)
	addi		sp,		sp,		16
	ret

vm_map_range:
	ret

vm_kinit:
	addi		sp,		sp,		-48
	sd		ra,		0(sp)
	sd		s0,		8(sp)
	sd		s1,		16(sp)
	sd		s2,		24(sp)
	sd		s3,		32(sp)
	call		page_alloc
	la		t0,		kPageTable
	sd		a0,		0(t0)
	mv		s0,		a0

	call		board_vm_kinit

	la		s1,		__mem_start
	la		s2,		__mem_end
	li		s3,		0xf		// RWXV

	/*
	 *	s0:	Root page table
	 *	s1:	Current page
	 *	s2:	End of physical memory
	 *	s3:	Attributes
	 */
.map_physical_mem:
	mv		a0,		s0
	mv		a1,		s1
	mv		a2,		s1
	mv		a3,		s3
	call		vm_map
	li		t0,		4096
	add		s1,		s1,		t0
	blt		s1,		s2,		.map_physical_mem

	ld		ra,		0(sp)
	ld		s0,		8(sp)
	ld		s1,		16(sp)
	ld		s2,		24(sp)
	ld		s3,		32(sp)
	addi		sp,		sp,		48
	ret

vm_kenable_paging:
	la		t0,		kPageTable
	ld		t0,		0(t0)
	srli		t0,		t0,		12
	li		t1,		1
	slli		t1,		t1,		63
	or		t0,		t0,		t1
	sfence.vma
	csrw		satp,		t0
	sfence.vma
	ret

	.data
kPageTable:
	.quad		0
