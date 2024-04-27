#include "syscon.h"
#include "uart.h"
#include <stdint.h>

__attribute__((aligned(16))) char stack0[4096];

static inline uint64_t r_mstatus() {
  uint64_t x;
  asm volatile("csrr %0, mstatus" : "=r"(x));
  return x;
}

static inline void w_mstatus(uint64_t x) {
  asm volatile("csrw mstatus, %0" : : "r"(x));
}

#define MPP_MASK (0b11 << 11)
#define MPP_S (0b01 << 11)

void main() {
  uartputs_sync("\nWe should now be in S mode\0");
  poweroff();
}

void kmain(void) {
  uart_init();

  uint64_t mstatus = r_mstatus();
  mstatus |= MPP_S;
  w_mstatus(mstatus);
  asm volatile("csrw mepc, %0" : : "r"((uint64_t)main));
  asm volatile("csrw medeleg, %0" : : "r"(0xffff));
  asm volatile("csrw mideleg, %0" : : "r"(0xffff));

  uint64_t sie;
  asm volatile("csrr %0, sie" : "=r"(sie));

  asm volatile("csrw sie, %0" : : "r"(sie | (1 << 9) | (1 << 5) | 0b10));

  asm volatile("csrw pmpaddr0, %0" : : "r"(0x3fffffffffffffull));
  asm volatile("csrw pmpcfg0, %0" : : "r"(0xf));

  asm volatile("mret");

  uartputs_sync("\nThis is awsome\0");

  uartputc_sync('\n');

  // char xvalue[64];
  //  itos(c , xvalue);
  // uartputs_sync(xvalue);

  uartputc_sync('\n');

  uartputs_sync("Please enter some value:\0");
  uartputc_sync((int)'>');
  uartputc_sync((int)':');
  uartputc_sync((int)' ');

  char c;
  while (c = uartgetc_sync(), c != '\r') {
    // backspace on delete
    if (c == 127) {
      uartputc_sync((int)'\b');
      uartputc_sync((int)' ');
      uartputc_sync((int)'\b');
    } else
      uartputc_sync(c);
  }

  uartputs_sync("\n\0");
}
