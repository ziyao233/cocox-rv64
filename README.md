# cocox-rv64

> Assembly is zombie, monokernel is shit.

A monokernel written in pure rv64gc assembly

---

## Build

Change to `src/` and run `make`. The kernel is compiled into an ELF file.

### Options

- `CROSS_PREFIX`: The prefix of ld and gcc
- `CC`: C compiler used to compile assembly code and handle C macros
- `LD`: The linker
- `BOARD`: The targeted RISC-V hardware, see Supported Boards

## Run

After building the kernel, run `./qemu-run.sh`. Make sure `qemu-system-riscv64`
is installed.

## Debug

Debug infomation is attached to the ELF file by default. After a successful
build of the kernel, run `./qemu-debug.sh` to start debugging. You could
make `gdb` attach to QEMU by using `target remote localhost:1234`.

Note that gdb-multiarch instead of native gdb may be needed.

## Directory Structure

- `include/`: Headers
- `src/`: Source of the kernel
- `boards`: BSP

## Supported Boards

- `virt`: QEMU virtual machine

## License

Authored by Ziyao and distributed under MIT License.
