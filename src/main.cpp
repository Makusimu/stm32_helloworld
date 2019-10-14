#include <stdint.h>
#include "stm32f1xx.h"
#include "rcc/rcc.h"
#include "gpio/gpio.h"

// LED: PC13


static void init_led();



using PC13 = gpio::Pin<GPIOC_BASE, 13>;

int main()
{
  rcc::init_hse8_72();
  rcc::systick::init_1ms();

  init_led();  

  while(1)
  {
    PC13::Toggle();
    rcc::systick::delay(500);
  }
  return 0;
}


void init_led()
{
  SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
  CLEAR_BIT(GPIOC->CRH, GPIO_CRH_MODE13|GPIO_CRH_CNF13);
  SET_BIT(GPIOC->CRH, GPIO_CRH_MODE13_0);
}
