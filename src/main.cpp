#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"
#include "led.h"

int main()
{
  rcc::Rcc::Init<rcc::RccSource::HSE>();
  rcc::Systick::Init<common::Period::ms>();

  using port13 = gpio::PC13;
  port13::InitPortClock();
  port13::Init<gpio::PinMode::PushPull, gpio::PinSpeed::Speed_2MHz>();

  using LedControl = Led<port13>;

  while(1)
  {
    LedControl::Toggle();
    rcc::Systick::Delay(500);
  }
  return 0;
}

