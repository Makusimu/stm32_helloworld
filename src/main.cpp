#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"

int main()
{
  rcc::Rcc::Init<rcc::RccSource::HSE>();
  rcc::Systick::Init<common::Period::ms>();

  using Led = gpio::PC13;
  Led::InitPortClock();
  Led::Init<gpio::PinMode::PushPull>();

  while(1)
  {
    Led::Toggle();
    rcc::Systick::Delay(500);
  }
  return 0;
}

