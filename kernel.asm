
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text
.global _entry
_entry:
  la sp, stack0
    80000000:	00001117          	auipc	sp,0x1
    80000004:	04010113          	addi	sp,sp,64 # 80001040 <stack0>
  la a0, 4096
    80000008:	00001537          	lui	a0,0x1

  csrr a1, mhartid
    8000000c:	f14025f3          	csrr	a1,mhartid
  addi a1, a1, 1
    80000010:	00158593          	addi	a1,a1,1
  mul a0,a0,a1
    80000014:	02b50533          	mul	a0,a0,a1
 
  add sp, sp, a0
    80000018:	00a10133          	add	sp,sp,a0
  call kmain
    8000001c:	00000097          	auipc	ra,0x0
    80000020:	008080e7          	jalr	8(ra) # 80000024 <kmain>

0000000080000024 <kmain>:
#include "syscon.h"
#include "uart.h"

__attribute__((aligned(16))) char stack0[4096];

void kmain(void) {
    80000024:	ff010113          	addi	sp,sp,-16
    80000028:	00113423          	sd	ra,8(sp)
    8000002c:	00813023          	sd	s0,0(sp)
    80000030:	01010413          	addi	s0,sp,16
  poweroff();
    80000034:	00000097          	auipc	ra,0x0
    80000038:	218080e7          	jalr	536(ra) # 8000024c <poweroff>

  uart_init(UART_ADDR);
    8000003c:	10000537          	lui	a0,0x10000
    80000040:	00000097          	auipc	ra,0x0
    80000044:	02c080e7          	jalr	44(ra) # 8000006c <uart_init>

  kputs("Hello world\0");
    80000048:	00001517          	auipc	a0,0x1
    8000004c:	fb850513          	addi	a0,a0,-72 # 80001000 <reboot+0xd70>
    80000050:	00000097          	auipc	ra,0x0
    80000054:	158080e7          	jalr	344(ra) # 800001a8 <kputs>

}
    80000058:	00000013          	nop
    8000005c:	00813083          	ld	ra,8(sp)
    80000060:	00013403          	ld	s0,0(sp)
    80000064:	01010113          	addi	sp,sp,16
    80000068:	00008067          	ret

000000008000006c <uart_init>:
#include <stddef.h>
#include <limits.h>
#include "uart.h"
#define to_hex_digit(n) ('0' + (n) + ((n) < 10 ? 0 : 'a' - '0' - 10))

void uart_init(size_t base_addr) {
    8000006c:	fd010113          	addi	sp,sp,-48
    80000070:	02813423          	sd	s0,40(sp)
    80000074:	03010413          	addi	s0,sp,48
    80000078:	fca43c23          	sd	a0,-40(s0)
  volatile uint8_t *ptr = (uint8_t *)base_addr;
    8000007c:	fd843783          	ld	a5,-40(s0)
    80000080:	fef43423          	sd	a5,-24(s0)

  // set word len to 8
  const uint8_t LCR = 0b11;
    80000084:	00300793          	li	a5,3
    80000088:	fef403a3          	sb	a5,-25(s0)
  ptr[3] = LCR;
    8000008c:	fe843783          	ld	a5,-24(s0)
    80000090:	00378793          	addi	a5,a5,3
    80000094:	fe744703          	lbu	a4,-25(s0)
    80000098:	00e78023          	sb	a4,0(a5)

  // enable fifo
  ptr[2] = 0b1;
    8000009c:	fe843783          	ld	a5,-24(s0)
    800000a0:	00278793          	addi	a5,a5,2
    800000a4:	00100713          	li	a4,1
    800000a8:	00e78023          	sb	a4,0(a5)

  // enable recv buf interrupts
  ptr[1] = 0b1;
    800000ac:	fe843783          	ld	a5,-24(s0)
    800000b0:	00178793          	addi	a5,a5,1
    800000b4:	00100713          	li	a4,1
    800000b8:	00e78023          	sb	a4,0(a5)
}
    800000bc:	00000013          	nop
    800000c0:	02813403          	ld	s0,40(sp)
    800000c4:	03010113          	addi	sp,sp,48
    800000c8:	00008067          	ret

00000000800000cc <uart_put>:

static void uart_put(size_t base_addr, uint8_t c) {
    800000cc:	fe010113          	addi	sp,sp,-32
    800000d0:	00813c23          	sd	s0,24(sp)
    800000d4:	02010413          	addi	s0,sp,32
    800000d8:	fea43423          	sd	a0,-24(s0)
    800000dc:	00058793          	mv	a5,a1
    800000e0:	fef403a3          	sb	a5,-25(s0)
  *(uint8_t *)base_addr = c;
    800000e4:	fe843783          	ld	a5,-24(s0)
    800000e8:	fe744703          	lbu	a4,-25(s0)
    800000ec:	00e78023          	sb	a4,0(a5)
}
    800000f0:	00000013          	nop
    800000f4:	01813403          	ld	s0,24(sp)
    800000f8:	02010113          	addi	sp,sp,32
    800000fc:	00008067          	ret

0000000080000100 <kputchar>:

int kputchar(int character) {
    80000100:	fe010113          	addi	sp,sp,-32
    80000104:	00113c23          	sd	ra,24(sp)
    80000108:	00813823          	sd	s0,16(sp)
    8000010c:	02010413          	addi	s0,sp,32
    80000110:	00050793          	mv	a5,a0
    80000114:	fef42623          	sw	a5,-20(s0)
  uart_put(UART_ADDR, (uint8_t)character);
    80000118:	fec42783          	lw	a5,-20(s0)
    8000011c:	0ff7f793          	zext.b	a5,a5
    80000120:	00078593          	mv	a1,a5
    80000124:	10000537          	lui	a0,0x10000
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	fa4080e7          	jalr	-92(ra) # 800000cc <uart_put>
  return character;
    80000130:	fec42783          	lw	a5,-20(s0)
}
    80000134:	00078513          	mv	a0,a5
    80000138:	01813083          	ld	ra,24(sp)
    8000013c:	01013403          	ld	s0,16(sp)
    80000140:	02010113          	addi	sp,sp,32
    80000144:	00008067          	ret

0000000080000148 <kprint>:

static void kprint(const char *str) {
    80000148:	fe010113          	addi	sp,sp,-32
    8000014c:	00113c23          	sd	ra,24(sp)
    80000150:	00813823          	sd	s0,16(sp)
    80000154:	02010413          	addi	s0,sp,32
    80000158:	fea43423          	sd	a0,-24(s0)
  while (*str) {
    8000015c:	0280006f          	j	80000184 <kprint+0x3c>
    kputchar((int)*str);
    80000160:	fe843783          	ld	a5,-24(s0)
    80000164:	0007c783          	lbu	a5,0(a5)
    80000168:	0007879b          	sext.w	a5,a5
    8000016c:	00078513          	mv	a0,a5
    80000170:	00000097          	auipc	ra,0x0
    80000174:	f90080e7          	jalr	-112(ra) # 80000100 <kputchar>
    ++str;
    80000178:	fe843783          	ld	a5,-24(s0)
    8000017c:	00178793          	addi	a5,a5,1
    80000180:	fef43423          	sd	a5,-24(s0)
  while (*str) {
    80000184:	fe843783          	ld	a5,-24(s0)
    80000188:	0007c783          	lbu	a5,0(a5)
    8000018c:	fc079ae3          	bnez	a5,80000160 <kprint+0x18>
  }
}
    80000190:	00000013          	nop
    80000194:	00000013          	nop
    80000198:	01813083          	ld	ra,24(sp)
    8000019c:	01013403          	ld	s0,16(sp)
    800001a0:	02010113          	addi	sp,sp,32
    800001a4:	00008067          	ret

00000000800001a8 <kputs>:

int kputs(const char *str) {
    800001a8:	fe010113          	addi	sp,sp,-32
    800001ac:	00113c23          	sd	ra,24(sp)
    800001b0:	00813823          	sd	s0,16(sp)
    800001b4:	02010413          	addi	s0,sp,32
    800001b8:	fea43423          	sd	a0,-24(s0)
  kprint(str);
    800001bc:	fe843503          	ld	a0,-24(s0)
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	f88080e7          	jalr	-120(ra) # 80000148 <kprint>
  kputchar((int)'\n');
    800001c8:	00a00513          	li	a0,10
    800001cc:	00000097          	auipc	ra,0x0
    800001d0:	f34080e7          	jalr	-204(ra) # 80000100 <kputchar>
  return 0;
    800001d4:	00000793          	li	a5,0
}
    800001d8:	00078513          	mv	a0,a5
    800001dc:	01813083          	ld	ra,24(sp)
    800001e0:	01013403          	ld	s0,16(sp)
    800001e4:	02010113          	addi	sp,sp,32
    800001e8:	00008067          	ret

00000000800001ec <kvprintf>:

void kvprintf(const char *fmt, va_list args){
    800001ec:	fe010113          	addi	sp,sp,-32
    800001f0:	00813c23          	sd	s0,24(sp)
    800001f4:	02010413          	addi	s0,sp,32
    800001f8:	fea43423          	sd	a0,-24(s0)
    800001fc:	feb43023          	sd	a1,-32(s0)
  return;
    80000200:	00000013          	nop
}
    80000204:	01813403          	ld	s0,24(sp)
    80000208:	02010113          	addi	sp,sp,32
    8000020c:	00008067          	ret

0000000080000210 <kprintf>:

void kprintf(const char *fmt, ...){
    80000210:	fa010113          	addi	sp,sp,-96
    80000214:	00813c23          	sd	s0,24(sp)
    80000218:	02010413          	addi	s0,sp,32
    8000021c:	fea43423          	sd	a0,-24(s0)
    80000220:	00b43423          	sd	a1,8(s0)
    80000224:	00c43823          	sd	a2,16(s0)
    80000228:	00d43c23          	sd	a3,24(s0)
    8000022c:	02e43023          	sd	a4,32(s0)
    80000230:	02f43423          	sd	a5,40(s0)
    80000234:	03043823          	sd	a6,48(s0)
    80000238:	03143c23          	sd	a7,56(s0)
  return;
    8000023c:	00000013          	nop
}
    80000240:	01813403          	ld	s0,24(sp)
    80000244:	06010113          	addi	sp,sp,96
    80000248:	00008067          	ret

000000008000024c <poweroff>:
#include <stdint.h>
#include "syscon.h"
#include "uart.h"

void poweroff(void) {
    8000024c:	ff010113          	addi	sp,sp,-16
    80000250:	00113423          	sd	ra,8(sp)
    80000254:	00813023          	sd	s0,0(sp)
    80000258:	01010413          	addi	s0,sp,16
  kputs("Poweroff requested");
    8000025c:	00001517          	auipc	a0,0x1
    80000260:	db450513          	addi	a0,a0,-588 # 80001010 <reboot+0xd80>
    80000264:	00000097          	auipc	ra,0x0
    80000268:	f44080e7          	jalr	-188(ra) # 800001a8 <kputs>
  *(uint32_t *)SYSCON_ADDR = 0X5555;
    8000026c:	001007b7          	lui	a5,0x100
    80000270:	00005737          	lui	a4,0x5
    80000274:	55570713          	addi	a4,a4,1365 # 5555 <_entry-0x7fffaaab>
    80000278:	00e7a023          	sw	a4,0(a5) # 100000 <_entry-0x7ff00000>
}
    8000027c:	00000013          	nop
    80000280:	00813083          	ld	ra,8(sp)
    80000284:	00013403          	ld	s0,0(sp)
    80000288:	01010113          	addi	sp,sp,16
    8000028c:	00008067          	ret

0000000080000290 <reboot>:

void reboot(void) {
    80000290:	ff010113          	addi	sp,sp,-16
    80000294:	00113423          	sd	ra,8(sp)
    80000298:	00813023          	sd	s0,0(sp)
    8000029c:	01010413          	addi	s0,sp,16
  kputs("Reboot requested");
    800002a0:	00001517          	auipc	a0,0x1
    800002a4:	d8850513          	addi	a0,a0,-632 # 80001028 <reboot+0xd98>
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	f00080e7          	jalr	-256(ra) # 800001a8 <kputs>
  *(uint32_t *)SYSCON_ADDR = 0x7777;
    800002b0:	001007b7          	lui	a5,0x100
    800002b4:	00007737          	lui	a4,0x7
    800002b8:	77770713          	addi	a4,a4,1911 # 7777 <_entry-0x7fff8889>
    800002bc:	00e7a023          	sw	a4,0(a5) # 100000 <_entry-0x7ff00000>
}
    800002c0:	00000013          	nop
    800002c4:	00813083          	ld	ra,8(sp)
    800002c8:	00013403          	ld	s0,0(sp)
    800002cc:	01010113          	addi	sp,sp,16
    800002d0:	00008067          	ret
	...
