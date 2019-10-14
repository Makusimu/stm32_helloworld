#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"

// LED: PC13

void init_led();
void toggle_led();
void led_on();
void led_off();

GPIO_TypeDef * const port = GPIOC;

int main()
{
  rcc::init_hse8_72();
  rcc::systick::init_1ms();

  init_led();
  while(1)
  {
    toggle_led();
    rcc::systick::delay(500);
  }
  return 0;
}


void init_led()
{
  SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
  CLEAR_BIT(port->CRH, GPIO_CRH_MODE13|GPIO_CRH_CNF13);
  SET_BIT(port->CRH, GPIO_CRH_MODE13_0);
}

void toggle_led()
{
  if((port->ODR & GPIO_ODR_ODR13) == GPIO_ODR_ODR13)
    led_off();
  else
    led_on();
}

void led_on()
{
  SET_BIT(port->BSRR, GPIO_BSRR_BS13);
}

void led_off()
{
  SET_BIT(port->BSRR, GPIO_BSRR_BR13);
}