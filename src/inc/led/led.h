#include "stm32f1xx.h"

typedef enum eLedState
{
  ON, OFF
} LedState;


extern LedState ledState_;
extern GPIO_TypeDef *port;

void init_led();
void toggle_led();
void led_on();
void led_off();