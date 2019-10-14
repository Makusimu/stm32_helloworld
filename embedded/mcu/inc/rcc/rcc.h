#pragma once
#include <stdint.h>
#include "stm32f1xx.h"
#include "common/timers.h"
namespace rcc
{
  void init_hse8_72();

  void delay(uint32_t ticks);

  struct Systick
  {
    template<common::Period period>
    __forceinline static void Init()
    {
      if constexpr (period == common::Period::ms)
      {
        SystemCoreClockUpdate();
        SysTick_Config(SystemCoreClock/1000);
      }
    }
  };
}
