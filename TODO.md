Hello, World!!!
===

### Программирование

- [x] Мигание светодиодом:
  - [x] Включить тактирование порта __GPIOC__
  - [x] Настроить пин __PC13__ как __PushPull__
  - [x] Функции включения/отключения светодиода
- [x] Настройка тактирования
- [x] Использование таймера SysTick для формирования задержек


### Сборка

- [ ] Все временные файлы компиляции складывать в папку __obj__ 
  - (https://habr.com/ru/post/111691/) 
  - (https://www.opennet.ru/docs/RUS/make_compile/make-8.html) 
  - (http://www.cyberforum.ru/c-linux/thread696887.html)
- [x] Скомпилированные файлы __*.elf__ и __*.hex__ складывать в папку __release__
- [x] Перевести проект на __C++__
- [x] Автоматический поиск всех __*.s__, __*.c__ и __*.cpp__ файлов
- [ ] При выводе размеров используемой памяти (FLASH, RAM)
  - [ ] Выводить изменение в сравнении с предыдущей компиляцией
  - [ ] Выводить посчитанные FLASH и RAM
- [ ] Разобраться с флагами компиляции
  - http://fatlortroll.blogspot.com/2016/10/makefile-stm32-v2.html
  - http://mmote.ru/stm32f1x-makefile
  - https://github.com/robots/STM32/blob/master/dtmf/Makefile
  - -msoft-float
  - -ffunction-sections
  - -fdata-sections
  - -mfix-cortex-m3-ldrd
  - -fomit-frame-pointer
  - -mapcs-frame
  - -mlong-calls
  - -mapcs-frame
  - -Wimplicit -Wcast-align -Wpointer-arith
  - -Wredundant-decls -Wshadow -Wcast-qual -Wcast-align
  - -pedantic
  - -Wa,-adhlns=
  - -MD -MP -MF
  - -Wnested-externs  (flags only for C)
  - -fno-rtti -fno-exceptions  (flags only for C++)
  - # Link with the GNU C++ stdlib.
  - #CPLUSPLUS_LIB = -lstdc++ (LDFLAGS += $(CPLUSPLUS_LIB))
  - LDFLAGS += -lc -lgcc 
  - LDFLAGS = -nostartfiles -Wl,--cref
  - MATH_LIB = -lm (LDFLAGS += $(MATH_LIB))

### Отладка

- [ ] OpenOCD