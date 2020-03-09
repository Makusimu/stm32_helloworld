#pragma once
#include "stm32f1xx.h"
#include <stdint.h>

namespace io
{
  template<uint32_t addr>
  struct Usart
  {
    __forceinline static void InitClock()
    {
      if constexpr (addr == USART1_BASE)
        SET_BIT(RCC->APB2ENR, RCC_APB2ENR_USART1EN);
      else if constexpr (addr == USART2_BASE)
        SET_BIT(RCC->APB1ENR, RCC_APB1ENR_USART2EN);
      else if constexpr (addr == USART3_BASE)
        SET_BIT(RCC->APB1ENR, RCC_APB1ENR_USART3EN);
      else
        throw "Not implemented";
    }

    __forceinline static void Init()
    {
      USART_TypeDef *UsartStruct{reinterpret_cast<USART_TypeDef*>(addr)};

      ////USART needs to be in disabled state, in order to be able to configure some bits in CRx registers
      if(READ_BIT(UsartStruct->CR1, USART_CR1_UE) != (USART_CR1_UE))
      {
        MODIFY_REG(UsartStruct->CR1, USART_CR1_M | USART_CR1_PCE | USART_CR1_PS , USART_CR1_TE | USART_CR1_RE);
      }

      //Async Mode
      CLEAR_BIT(UsartStruct->CR2, (USART_CR2_LINEN | USART_CR2_CLKEN));
      CLEAR_BIT(UsartStruct->CR3, (USART_CR3_SCEN | USART_CR3_IREN | USART_CR3_HDSEL));

      //115200
      WRITE_REG(UsartStruct->BRR, ((0x27)<<4)|0x01);

      //Enable
      SET_BIT(UsartStruct->CR1, USART_CR1_UE);
    }

    static void WriteDataSync(uint8_t *data, uint16_t size)
    {
      USART_TypeDef *UsartStruct{reinterpret_cast<USART_TypeDef*>(addr)};

      for (uint16_t i=0; i<size;++i)
      {
        while (READ_BIT(UsartStruct->SR, USART_SR_TXE) != (USART_SR_TXE)) {}
        UsartStruct->DR = (uint16_t)data[i];
      }
    }
  };

  using Usart1 = io::Usart<USART1_BASE>;
  using Usart2 = io::Usart<USART2_BASE>;
  using Usart3 = io::Usart<USART3_BASE>;
}