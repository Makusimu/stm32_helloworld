#pragma once
#include "gpio/gpio.h"

template<class Pin>
struct Led
{
  static void Toggle()
  {
    Pin::Toggle();
  }
};