#include <stdint.h>
#include "stm32f1xx.h"
#include "led/led.h"

extern "C"
{
#include "rcc/rcc.h"
}

// LED: PC13

static volatile uint32_t sysTickCount_ = 0;
void delay(uint32_t ticks);

int main()
{
  init_rcc();
  init_led();
  while(1)
  {
    toggle_led();
    delay(200);
  }
  return 0;
}

void delay(uint32_t ticks)
{
  sysTickCount_ = ticks;
  while(sysTickCount_);
}

extern "C"
{
  void SysTick_Handler()
  {
    if (sysTickCount_)
      --sysTickCount_;
  }
}