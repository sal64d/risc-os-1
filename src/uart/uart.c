#include <stdint.h>
#include <stdarg.h>
#include <stddef.h>
#include <limits.h>
#include "uart.h"
#define to_hex_digit(n) ('0' + (n) + ((n) < 10 ? 0 : 'a' - '0' - 10))

void uart_init(size_t base_addr) {
  volatile uint8_t *ptr = (uint8_t *)base_addr;

  // set word len to 8
  const uint8_t LCR = 0b11;
  ptr[3] = LCR;

  // enable fifo
  ptr[2] = 0b1;

  // enable recv buf interrupts
  ptr[1] = 0b1;
}

static void uart_put(size_t base_addr, uint8_t c) {
  *(uint8_t *)base_addr = c;
}

int kputchar(int character) {
  uart_put(UART_ADDR, (uint8_t)character);
  return character;
}

static void kprint(const char *str) {
  while (*str) {
    kputchar((int)*str);
    ++str;
  }
}

int kputs(const char *str) {
  kprint(str);
  kputchar((int)'\n');
  return 0;
}

void kvprintf(const char *fmt, va_list args){
  return;
}

void kprintf(const char *fmt, ...){
  return;
}

