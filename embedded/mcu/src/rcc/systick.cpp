#include "rcc/rcc.h"
#include <stdint.h>
#include "stm32f1xx.h"

namespace rcc
{
  static volatile uint32_t sysTickCount_ = 0;
}

void rcc::Systick::Delay(uint32_t ticks)
{
  rcc::sysTickCount_ = ticks;
  while(rcc::sysTickCount_);
}

extern "C"
{
  void SysTick_Handler()
  {
    if (rcc::sysTickCount_)
      --rcc::sysTickCount_;
  }
}