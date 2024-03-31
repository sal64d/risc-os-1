#include <stdint.h>
#include "syscon.h"
#include "uart.h"

void poweroff(void) {
  uartputs_sync("Poweroff requested");
  *(uint32_t *)SYSCON_ADDR = 0X5555;
}

void reboot(void) {
  uartputs_sync("Reboot requested");
  *(uint32_t *)SYSCON_ADDR = 0x7777;
}

