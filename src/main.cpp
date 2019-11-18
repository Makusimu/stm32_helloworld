#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"
#include "led.h"
#include "shift_register/74HC595.h"


int main()
{
  rcc::Rcc::Init<rcc::RccSource::HSE>();
  rcc::Systick::Init<common::Period::ms>();

  using port13 = gpio::PC13;
  port13::InitPortClock();
  port13::Init<gpio::PinMode::PushPull>();

  using LedControl = Led<port13>;

  using ShiftRegister = shift_register::SN74HC595<gpio::PC1, gpio::PC2, gpio::PC3>;
  ShiftRegister::Init();

  while(1)
  {
    LedControl::Toggle();
    rcc::Systick::Delay(500);
  }
  return 0;
}

