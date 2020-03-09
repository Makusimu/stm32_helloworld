#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"
#include "led.h"
#include "io/usart.h"

int main()
{
  rcc::Rcc::Init<rcc::RccSource::HSE>();
  rcc::Systick::Init<common::Period::ms>();

  using port13 = gpio::PC13;
  port13::InitPortClock();
  port13::Init<gpio::PinMode::PushPull, gpio::PinSpeed::Speed_2MHz>();

  using LedControl = Led<port13>;

  io::Usart1::InitClock();

  gpio::GpioA::InitClock();
  using tx = gpio::PA9;
  using rx = gpio::PA10;

  tx::Init<gpio::PinMode::AF_PushPull, gpio::PinSpeed::Speed_50MHz>();
  rx::Init<gpio::PinMode::AF_PushPull, gpio::PinSpeed::Speed_50MHz>();

  io::Usart1::Init();

  while(1)
  {
    io::Usart1::WriteDataSync((uint8_t *)"!\n", 2);
    LedControl::Toggle();
    rcc::Systick::Delay(500);
  }
  return 0;
}

