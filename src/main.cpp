#include <stdint.h>
#include "stm32f1xx.h"
#include "led/led.h"
#include "rcc/rcc.h"
#include "rcc/systick.h"

// LED: PC13

int main()
{
  rcc::init_hse8_72();
  rcc::systick::init_1ms();

  init_led();
  while(1)
  {
    toggle_led();
    rcc::systick::delay(500);
  }
  return 0;
}
