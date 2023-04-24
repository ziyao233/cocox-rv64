/*
 *	cocox-rv64
 *	/src/boards/virt/board/uart.h
 *	By MIT License.
 *	Copyright (c) 2023 Ziyao.
 */


#ifndef __BOARD_UART_H_INC__
#define __BOARD_UART_H_INC__

#define UART_BASE		0x10000000
#define UART_THR		(UART_BASE)
#define UART_LSR		(UART_BASE + 0x05)
#define UART_LSR_EMPTY_MASK	0x40

#endif
