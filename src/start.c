#include "syscon.h"
#include "uart.h"

__attribute__((aligned(16))) char stack0[4096];

void kmain(void) {
  uart_init();

  uartputs_sync("This is awsome\0");
  poweroff();
}
