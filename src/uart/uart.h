#ifndef UART_H
#define UART_H
#include <stdarg.h>
#include <stddef.h>

// todo create the device info thingy
#define UART_ADDR 0x10000000

void uart_init(size_t);

int kputchar(int);
int kputs(const char *);

void kvprintf(const char *, va_list);
void kprintf(const char *, ...);

#endif /* ifndef UART_H */
