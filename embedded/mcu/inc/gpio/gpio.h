#pragma once
#include "stm32f1xx.h"
#include <stdint.h>

namespace gpio
{
  enum class PinMode
  {
    PushPull
  };

  template<uint32_t addr>
  struct Port
  {
    __forceinline static void InitClock()
    {
      if constexpr (addr == GPIOA_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPAEN);
      else if constexpr (addr == GPIOB_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPBEN);
      else if constexpr (addr == GPIOC_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
      else if constexpr (addr == GPIOD_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPDEN);
      else if constexpr (addr == GPIOE_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPEEN);
      else
        throw "Not implemented";
    }

    template<uint32_t pinNum>
    struct Pin
    {
      using port = gpio::Port<addr>;
      using self = port::Pin<pinNum>;

      __forceinline static void InitPortClock()
      {
        port::InitClock();
      }

      template<gpio::PinMode mode>
      __forceinline static void Init()
      {
        GPIO_TypeDef *GpioPort{reinterpret_cast<GPIO_TypeDef*>(addr)};
        if constexpr (mode == gpio::PinMode::PushPull)
        {
          constexpr uint32_t modePos = get_ModePos();
          constexpr uint32_t cnfPos = get_CnfPos();

          if constexpr (pinNum > 7)
          {
            CLEAR_BIT(GpioPort->CRH, (0x3UL << modePos)|(0x3UL << cnfPos));
            SET_BIT(GpioPort->CRH, (0x1UL << modePos));
          }
          else
          {
            CLEAR_BIT(GpioPort->CRL, (0x3UL << modePos)|(0x3UL << cnfPos));
            SET_BIT(GpioPort->CRL, (0x1UL << modePos));
          }
        }
        else
          throw "Not implemented";
      }

      __forceinline static void Toggle()
      {
        if(self::IsHigh())
          self::Low();
        else
          self::High();
      }

      __forceinline static bool IsHigh()
      {
        GPIO_TypeDef *GpioPort{reinterpret_cast<GPIO_TypeDef*>(addr)};
        return READ_BIT(GpioPort->ODR, 1 << pinNum) == (1 << pinNum);
      }

      __forceinline static void High()
      {
        GPIO_TypeDef *GpioPort{reinterpret_cast<GPIO_TypeDef*>(addr)};
        SET_BIT(GpioPort->BSRR, 1 << pinNum);
      }

      __forceinline static void Low()
      {
        GPIO_TypeDef *GpioPort{reinterpret_cast<GPIO_TypeDef*>(addr)};
        SET_BIT(GpioPort->BRR, 1 << pinNum);
      }

    private:
      constexpr static uint32_t get_ModePos()
      {
        if(pinNum > 7)
          return (pinNum - 8) * 4;
        return pinNum * 4;
      }

      constexpr static uint32_t get_CnfPos()
      {
        return get_ModePos() + 2;
      }
    };

    using P0 = Pin<0>;
    using P1 = Pin<1>;
    using P2 = Pin<2>;
    using P3 = Pin<3>;
    using P4 = Pin<4>;
    using P5 = Pin<5>;
    using P6 = Pin<6>;
    using P7 = Pin<7>;
    using P8 = Pin<8>;
    using P9 = Pin<9>;
    using P10 = Pin<10>;
    using P11 = Pin<11>;
    using P12 = Pin<12>;
    using P13 = Pin<13>;
    using P14 = Pin<14>;
    using P15 = Pin<15>;
  };

  using GpioA = gpio::Port<GPIOA_BASE>;
  using GpioB = gpio::Port<GPIOB_BASE>;
  using GpioC = gpio::Port<GPIOC_BASE>;
  using GpioD = gpio::Port<GPIOD_BASE>;
  using GpioE = gpio::Port<GPIOE_BASE>;

  using PA0 = GpioA::P0;
  using PA1 = GpioA::P1;
  using PA2 = GpioA::P2;
  using PA3 = GpioA::P3;
  using PA4 = GpioA::P4;
  using PA5 = GpioA::P5;
  using PA6 = GpioA::P6;
  using PA7 = GpioA::P7;
  using PA8 = GpioA::P8;
  using PA9 = GpioA::P9;
  using PA10 = GpioA::P10;
  using PA11 = GpioA::P11;
  using PA12 = GpioA::P12;
  using PA13 = GpioA::P13;
  using PA14 = GpioA::P14;
  using PA15 = GpioA::P15;

  using PB0 = GpioB::P0;
  using PB1 = GpioB::P1;
  using PB2 = GpioB::P2;
  using PB3 = GpioB::P3;
  using PB4 = GpioB::P4;
  using PB5 = GpioB::P5;
  using PB6 = GpioB::P6;
  using PB7 = GpioB::P7;
  using PB8 = GpioB::P8;
  using PB9 = GpioB::P9;
  using PB10 = GpioB::P10;
  using PB11 = GpioB::P11;
  using PB12 = GpioB::P12;
  using PB13 = GpioB::P13;
  using PB14 = GpioB::P14;
  using PB15 = GpioB::P15;

  using PC0 = GpioC::P0;
  using PC1 = GpioC::P1;
  using PC2 = GpioC::P2;
  using PC3 = GpioC::P3;
  using PC4 = GpioC::P4;
  using PC5 = GpioC::P5;
  using PC6 = GpioC::P6;
  using PC7 = GpioC::P7;
  using PC8 = GpioC::P8;
  using PC9 = GpioC::P9;
  using PC10 = GpioC::P10;
  using PC11 = GpioC::P11;
  using PC12 = GpioC::P12;
  using PC13 = GpioC::P13;
  using PC14 = GpioC::P14;
  using PC15 = GpioC::P15;

  using PD0 = GpioD::P0;
  using PD1 = GpioD::P1;
  using PD2 = GpioD::P2;
  using PD3 = GpioD::P3;
  using PD4 = GpioD::P4;
  using PD5 = GpioD::P5;
  using PD6 = GpioD::P6;
  using PD7 = GpioD::P7;
  using PD8 = GpioD::P8;
  using PD9 = GpioD::P9;
  using PD10 = GpioD::P10;
  using PD11 = GpioD::P11;
  using PD12 = GpioD::P12;
  using PD13 = GpioD::P13;
  using PD14 = GpioD::P14;
  using PD15 = GpioD::P15;

  using PE0 = GpioE::P0;
  using PE1 = GpioE::P1;
  using PE2 = GpioE::P2;
  using PE3 = GpioE::P3;
  using PE4 = GpioE::P4;
  using PE5 = GpioE::P5;
  using PE6 = GpioE::P6;
  using PE7 = GpioE::P7;
  using PE8 = GpioE::P8;
  using PE9 = GpioE::P9;
  using PE10 = GpioE::P10;
  using PE11 = GpioE::P11;
  using PE12 = GpioE::P12;
  using PE13 = GpioE::P13;
  using PE14 = GpioE::P14;
  using PE15 = GpioE::P15;
}