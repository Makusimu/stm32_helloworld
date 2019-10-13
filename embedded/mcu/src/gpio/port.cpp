#include "gpio/gpio.h"
#include "stm32f1xx.h"

constexpr gpio::Port::Port(GPIO_TypeDef *port)
  : port_(port)
{}

constexpr void gpio::Port::Enable()
{
  if constexpr (port_ == GPIOC)
    SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
}