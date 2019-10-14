#pragma once
#include "stm32f1xx.h"
#include <stdint.h>

namespace gpio
{
  template<uint32_t addr, uint32_t pinNum>
  struct Pin
  {
    using self = Pin<addr, pinNum>;
    using Registers = GPIO_TypeDef;

    __forceinline static void Toggle()
    {
      if(self::IsHigh())
        self::Low();
      else
        self::High();
    }

    __forceinline static bool IsHigh()
    {
      Registers *GpioPort{reinterpret_cast<Registers*>(addr)};
      return READ_BIT(GpioPort->ODR, 1 << pinNum) == (1 << pinNum);
    }

    __forceinline static void High()
    {
      Registers *GpioPort{reinterpret_cast<Registers*>(addr)};

      SET_BIT(GpioPort->BSRR, 1 << pinNum);
    }

    __forceinline static void Low()
    {
      Registers *GpioPort{reinterpret_cast<Registers*>(addr)};

      SET_BIT(GpioPort->BRR, 1 << pinNum);
    }
  };
}