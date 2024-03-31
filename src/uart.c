#include "uart.h"
#include <limits.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>

void uart_init() {
  // disable interrupts
  WriteReg(IER, 0);

  // set the baud latch on
  WriteReg(LCR, LCR_BAUD_LATCH);
  // set lsb for baud rate
  WriteReg(DLL, 0x03);
  // set msb for baud rate
  WriteReg(DLM, 0x00);

  // close baud latch and set 8 bit mode
  WriteReg(LCR, LCR_EIGHT_BITS);

  // Clear FIFO and enable it
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);

  // enable receive and transmit interrupts
  WriteReg(IER, IER_RX_ENABLE | IER_TX_ENABLE);
}

void uartputc_sync(int character) {
  // Wait for transmission hold to be empty
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  // transmit
  WriteReg(THR, character);
}

void uartputs_sync(const char *str) {
  while (*str) {
    uartputc_sync((int)*str);
    ++str;
  }
  uartputc_sync((int)'\n');
}
