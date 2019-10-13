#pragma once
#include "stm32f1xx.h"

namespace gpio
{
  class Port
  {
  private:
    constexpr GPIO_TypeDef * const port_;
  public:
    constexpr Port(GPIO_TypeDef *port);

    constexpr void Enable();
  };

  class Pin
  {
  public:
    constexpr Pin(uint8_t number);
  };
}