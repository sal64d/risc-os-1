#include "syscon.h"
#include "uart.h"

__attribute__((aligned(16))) char stack0[4096];

void kmain(void) {
  uart_init();

  uartputs_sync("\nThis is awsome\0");
  uartputs_sync("Please enter some value:\0");
  uartputc_sync((int)'>');
  uartputc_sync((int)':');
  uartputc_sync((int)' ');

  char c;
  while (c = uartgetc_sync(), c != '\r') {
    // backspace on delete
    if(c == 127) {
      uartputc_sync((int)'\b');
      uartputc_sync((int)' ');
      uartputc_sync((int)'\b');
    }
    else uartputc_sync(c);
  }

  uartputs_sync("\n\0");
  poweroff();
}
