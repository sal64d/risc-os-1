#include "syscon/syscon.h"
#include "uart/uart.h"
#include "common/common.h"

#define ARCH "RISC-V"
#define MODE 'M'

void kmain(void) {
  uart_init(UART_ADDR);

  kputs("Hello world\0");
  kprintf("Hello %s World!\n", ARCH);
  kprintf("We are in %c-mode!\n", MODE);

  poweroff();
}

