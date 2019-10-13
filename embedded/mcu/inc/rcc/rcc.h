#pragma once
#include <stdint.h>


namespace rcc
{
  void init_hse8_72();

  namespace systick
  {
    void init_1ms();
    void delay(uint32_t ticks);
  }
}
