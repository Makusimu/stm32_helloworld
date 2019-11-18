#pragma once
#include "stm32f1xx.h"
#include <stdint.h>
#include "gpio/gpio.h"

namespace shift_register
{
  template<class DataPin /* DS */, class ClockPin /* SH_CP */, class LatchPin /* ST_CP */>
  struct SN74HC595
  {
    __forceinline static void Init()
    {
      DataPin::Init<gpio::PinMode::PushPull>();
      ClockPin::Init<gpio::PinMode::PushPull>();
      LatchPin::Init<gpio::PinMode::PushPull>();

      ClockPin::Low();
      LatchPin::Low();
    }

    __forceinline static void Write(uint8_t data)
    {
      for (uint8_t i=0; i<8; ++i)
      {
        if (READ_BIT(data, 1<<i))
          DataPin::High();
        else   
          DataPin::Low();

        ClockPin::High();
        ClockPin::Low();
      }

      LatchPin::High();
      LatchPin::Low();
    }
  };
}