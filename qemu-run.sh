#!/bin/sh

echo Type ^A then x to exit QEMU

qemu-system-riscv64 -machine virt -nographic -bios none		\
	-kernel src/cocox.elf
