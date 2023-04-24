#!/bin/sh

echo Type ^A then x to exit QEMU
echo 'Type "target remote localhost:1234" in gdb(-multiarch) to debug'

qemu-system-riscv64 -machine virt -nographic -bios none		\
	-kernel src/cocox.elf -S -s
