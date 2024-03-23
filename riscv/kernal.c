#include <stddef.h>
#include <stdint.h>

volatile unsigned char *uart = (unsigned char *)0x10000000;
void putchar(char c) {
  *uart = c;
  return;
}

void print(const char *str) {
  while (*str != '\0') {
    putchar(*str);
    str++;
  }
  return;
}

void kmain(void) {
  print("Hello world!\n");
  while (1) {
   // putchar(*uart);
  }
  return;
}
