#pragma once
#include "gpio/gpio.h"

template<class Pin>
struct Led
{
  __forceinline static void Toggle()
  {
    Pin::Toggle();
  }
};