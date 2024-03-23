.set MAGIC, 0xE85250D6
.set ARCH, 4 # this is wrong
.set SIZE, multiboot_header_end - multiboot_header

.section .multiboot
.align   8
multiboot_header:
	.long MAGIC
	.long ARCH
	.long SIZE
	.long -(MAGIC + ARCH + SIZE)
	.short 0
	.short 0
	.long  8
multiboot_header_end:

	.text
	.globl __start
__start:
	move $a0, $zero
	dli  $v0, 5058
	syscall
