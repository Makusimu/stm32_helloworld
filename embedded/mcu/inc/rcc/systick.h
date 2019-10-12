#pragma once
#include <stdint.h>

namespace rcc::systick
{
  void init_1ms();
  void delay(uint32_t ticks);
}
