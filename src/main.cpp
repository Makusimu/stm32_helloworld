#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"

static void init_led();

using Led = gpio::PC13;

int main()
{
  rcc::init_hse8_72();
  rcc::Systick::Init<common::Period::ms>();

  init_led();  

  while(1)
  {
    Led::Toggle();
    rcc::delay(500);
  }
  return 0;
}


void init_led()
{
  Led::InitPortClock();
  Led::Init<gpio::PinMode::PushPull>();
}
