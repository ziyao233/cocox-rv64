#	cocox-rv64
#	/src/makefile
#	By MIT License
#	Copyright (c) 2023 Ziyao.

CROSS_PREFIX	= riscv-none-elf-
CC		= $(CROSS_PREFIX)gcc
LD		= $(CROSS_PREFIX)ld
HOSTCC		= gcc
BOARD		= virt

THISBOARD	= ../boards/$(BOARD)
INCLUDE		= ../include
LDSCRIPT	= $(THISBOARD)/link.ld

CFLAGS		= -nostdlib -nostdinc -I$(INCLUDE)	\
		  -I$(THISBOARD)/ -march=rv64gc		\
		  -mcmodel=medany -mabi=lp64d -g
LDFLAGS		= -T $(LDSCRIPT)

OBJS		:= start.o kernel.o printk.o
KERNEL		:= cocox.elf

include $(THISBOARD)/makefile

default: build

build: $(KERNEL)

$(KERNEL): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(KERNEL)

clean:
	-rm $(OBJS)

disbuild: clean
	-rm $(KERNEL)

%.o:	%.S
	$(CC) $< -c $(CFLAGS) -o $@
