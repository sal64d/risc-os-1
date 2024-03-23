# Build
CC=riscv64-elf-gcc
CFLAGS=-ffreestanding -nostartfiles -nostdlib -nodefaultlibs
CFLAGS+=-g -Wl,--gc-sections -mcmodel=medany
RUNTIME=src/asm/crt0.s
LINKER_SCRIPT=src/lds/riscv64-virt.ld
KERNAL_IMAGE=kernal.elf

# QEMU
QEMU=qemu-system-riscv64
MACHINE=virt
MEM=128M
RUN=$(QEMU) -nographic -machine $(MACHINE) -m $(MEM)
RUN+=-bios none -kernel "build/$(KERNAL_IMAGE)"

# QEMU Debug
GDB_PORT=1234

all: uart syscon common kmain
	$(CC) build/*.o $(RUNTIME) $(CFLAGS) -T $(LINKER_SCRIPT) -o build/$(KERNAL_IMAGE)
uart:
	$(CC) -c src/uart/uart.c $(CFLAGS) -o build/uart.o
syscon:
	$(CC) -c src/syscon/syscon.c $(CFLAGS) -o build/syscon.o
common:
	$(CC) -c src/common/common.c $(CFLAGS) -o build/common.o
kmain:
	$(CC) -c src/kmain.c $(CFLAGS) -o build/kmain.o

run: all
	$(RUN)

debug: all
	$(RUN) -gdb tcp::$(GDB_PORT) -S

clean:
	rm -vf build/*.o
	rm -vf build/$(KERNAL_IMAGE)
