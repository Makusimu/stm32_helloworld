TOOLCHAIN_DIR=../../programs/arm-gcc/bin
ROOT_DIR=.
SRC_DIR=$(ROOT_DIR)/src
SYSTEM_DIR=$(ROOT_DIR)/system
OUTPUT_DIR=$(ROOT_DIR)/release

CC=$(TOOLCHAIN_DIR)/arm-none-eabi-g++
LD=$(TOOLCHAIN_DIR)/arm-none-eabi-g++
CP=$(TOOLCHAIN_DIR)/arm-none-eabi-objcopy
SIZE=$(TOOLCHAIN_DIR)/arm-none-eabi-size

LDSCRIPT=-T$(SYSTEM_DIR)/stm32f103xb.ld

LDFLAGS += -mcpu=cortex-m3
LDFLAGS += -mlittle-endian
LDFLAGS += -mthumb
LDFLAGS += $(LDSCRIPT)
# включает удаление неиспользуемых секций
LDFLAGS += -Wl,--gc-section
# Без этого флага не собирается с помощью g++
LDFLAGS += -specs=nosys.specs

CFLAGS += -mcpu=cortex-m3
CFLAGS += -mlittle-endian
CFLAGS += -mthumb
# Добавление отладочной информации
CFLAGS += -g
# Без этого флага не собирается с помощью g++
#CFLAGS += -fno-exceptions
CFLAGS += -DSTM32F103xB
CFLAGS += $(INC)

INC+=-I$(SYSTEM_DIR)/inc

SRC_CPP+=$(SRC_DIR)/main.cpp
SRC_C+=$(SYSTEM_DIR)/src/system_stm32f1xx.c

ASM+=$(SYSTEM_DIR)/startup_stm32f103xb.s

OBJ=$(SRC_CPP:%.cpp=%.o)
OBJ+=$(SRC_C:%.c=%.o)
OBJ+=$(ASM:%.s=%.o)


all: directories hex
	@echo "*** DONE ***"
	$(SIZE) $(OUTPUT_DIR)/main.elf

directories:
	@echo "*** CREATE DIRECTORIES ***"
	@mkdir -p $(OUTPUT_DIR)

hex: main.elf
	@echo "*** MAKE HEX ***"
	$(CP) -Oihex $(OUTPUT_DIR)/main.elf $(OUTPUT_DIR)/main.hex

main.elf: $(OBJ)
	@echo "*** LINK ***"
	$(LD) $(LDFLAGS) $(OBJ) -o $(OUTPUT_DIR)/main.elf

%.o: %.cpp
	@echo "*** COMPILE C++ ***"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.c
	@echo "*** COMPILE C ***"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	@echo "*** COMPILE ASM ***"
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "*** CLEAN ***"
	rm -f $(OBJ) $(OUTPUT_DIR)/main.elf $(OUTPUT_DIR)/main.hex