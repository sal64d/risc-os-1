S = ../src
LDS = $S/kernel.ld

OBJS = \
		entry.o \
		start.o \
		uart.o \
		syscon.o \

# Tools
CC = riscv64-elf-gcc
AS = riscv64-elf-gas
LD = riscv64-elf-ld
OBJCOPY = riscv64-elf-objcopy
OBJDUMP = riscv64-elf-objdump

# CFLAGS  = -Wall -Werror
# CFLAGS += -O
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -fno-stack-protector
CFLAGS += -fno-common
CFLAGS += -ffreestanding
CFLAGS += -nostartfiles
CFLAGS += -nostdlib
CFLAGS += -nodefaultlibs
CFLAGS += -mno-relax
CFLAGS += -g -Wl,--gc-sections
CFLAGS += -ggdb -gdwarf-2
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -march=rv64g
# CFLAGS += -nostdinc

LDFLAGS = -z max-page-size=4096

# QEMU
QEMU = qemu-system-riscv64
MACHINE = virt
MEM = 128M
CPUS = 3
QEMUOPTS  = -machine $(MACHINE)
QEMUOPTS += -m $(MEM)
QEMUOPTS += -bios none
QEMUOPTS += -kernel kernel
#QEMUOPTS += -smp $(CPUS)
QEMUOPTS += -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
#QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
#QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

# QEMU Debug
GDB_PORT=1234

kernel: $(OBJS) $(LDS)
		$(LD) $(OBJS) $(LDFLAGS) -T $(LDS) -o kernel
		$(OBJDUMP) -S kernel > kernel.asm
		$(OBJDUMP) -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > kernel.sym

%.o : $S/%.c
		$(CC) $(CFLAGS) -c $< -o $@

%.o : $S/%.S
		$(CC) $(CFLAGS) -c $< -o $@

qemu: kernel
		$(QEMU) $(QEMUOPTS)

qemu-gdb: kernel .gdbinit
		$(QEMU) $(QEMUOPTS) -gdb tcp::$(GDB_PORT) -S

clean:
		rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg *.o *.d \
		*/*.o */*.d */*.asm */*.sym \
		kernel

