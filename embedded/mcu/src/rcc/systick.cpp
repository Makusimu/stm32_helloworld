#include "rcc/systick.h"
#include <stdint.h>
#include "stm32f1xx.h"

namespace rcc::systick
{
  static volatile uint32_t sysTickCount_ = 0;
}

void rcc::systick::init_1ms()
{
  SystemCoreClockUpdate();
  SysTick_Config(SystemCoreClock/1000);
}

void rcc::systick::delay(uint32_t ticks)
{
  sysTickCount_ = ticks;
  while(sysTickCount_);
}

extern "C"
{
  void SysTick_Handler()
  {
    if (rcc::systick::sysTickCount_)
      --rcc::systick::sysTickCount_;
  }
}