#ifndef UART_H
#define UART_H

#include <stdarg.h>
#include <stddef.h>

// https://www.lammertbies.nl/comm/info/serial-uart

#define UART0 0x10000000L
#define Reg(reg) ((volatile unsigned char*)(UART0 + reg))
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// Uart mem-mapped registers
#define RHR 0 // (R) receive hold
#define THR 0 // (W) transmit hold
#define DLL 0 // (DLAB) Divisor latch lsb

#define IER 1 // (R/W) interrupt enable
#define DLM 1 // (DLAB) Divisor latch msb

#define ISR 2 // (R) interrupt status
#define FCR 2 // (W) fifo control

#define LCR 3 // line control
#define MCR 4 // modem control
#define LSR 5 // line status
#define MSR 6 // modem status
#define SCR 7 // scratch

#define IER_RX_ENABLE (1 << 0) // received data available
#define IER_TX_ENABLE (1 << 1) // transmitter holding register empty

#define FCR_FIFO_ENABLE (1 << 0) // enable fifo
#define FCR_FIFO_CLEAR (3 << 1)  // clear recieve and transmit fifo

#define LCR_EIGHT_BITS (3 << 0) // 8 bits
#define LCR_BAUD_LATCH (1 << 7) // enable DLAB mode

#define LSR_RX_READY (1 << 0)
#define LSR_TX_IDLE (1 << 5)

void uart_init();
void uartputc_sync(int);
int uargetc_sync();

void uartputs_sync(const char *);

#endif /* ifndef UART_H */
