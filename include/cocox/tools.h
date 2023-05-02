/*
 *	cocox-rv64
 *	/include/cocox/tools.h
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */

#ifndef __COCOX_COCOX_TOOLS_H_INC__
#define __COCOX_COCOX_TOOLS_H_INC__

	.macro	kmemset	start, size, val

.kmemset\@:	
	sd		\val,		0(\start)
	addi		\start,		\start,		8
	addi		\size,		\size,		-8
	bnez		\size,		.kmemset\@

	.endm

	.macro	kmem_zero	start, size

	kmemset		\start,		\size,		zero

	.endm

#endif	// __COCOX_COCOX_TOOLS_H_INC__
