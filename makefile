TOOLCHAIN_DIR=../../programs/arm-gcc/bin
ROOT_DIR=.
SRC_DIR=$(ROOT_DIR)/src
SYSTEM_DIR=$(ROOT_DIR)/system
OUTPUT_DIR=$(ROOT_DIR)/release

CC=$(TOOLCHAIN_DIR)/arm-none-eabi-gcc
LD=$(TOOLCHAIN_DIR)/arm-none-eabi-gcc
CP=$(TOOLCHAIN_DIR)/arm-none-eabi-objcopy

LDSCRIPT=-T$(SYSTEM_DIR)/stm32f103xb.ld

LDFLAGS += -mcpu=cortex-m3
LDFLAGS += -mlittle-endian
LDFLAGS += -mthumb
LDFLAGS += $(LDSCRIPT)
# включает удаление неиспользуемых секций
LDFLAGS += -Wl,--gc-section
#LDFLAGS += -fno-exceptions

CFLAGS += -mcpu=cortex-m3
CFLAGS += -mlittle-endian
CFLAGS += -mthumb
# Добавление отладочной информации
CFLAGS += -g
#CFLAGS += -fno-exceptions
CFLAGS += -DSTM32F103xB
CFLAGS += $(INC)

INC+=-I$(SYSTEM_DIR)/inc

SRC_C+=$(SRC_DIR)/main.c
SRC_C+=$(SYSTEM_DIR)/src/system_stm32f1xx.c

ASM+=$(SYSTEM_DIR)/startup_stm32f103xb.s

OBJ=$(SRC_C:%.c=%.o)
OBJ+=$(ASM:%.s=%.o)


all: hex

hex: main.elf
	@echo "*** HEX ***"
	$(CP) -Oihex $(OUTPUT_DIR)/main.elf $(OUTPUT_DIR)/main.hex

main.elf: $(OBJ)
	@echo "*** LINK ***"
	@mkdir -p $(OUTPUT_DIR)
	$(LD) $(LDFLAGS) $(OBJ) -o $(OUTPUT_DIR)/main.elf

%.o: %.c
	@echo "*** COMPILE C ***"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	@echo "*** COMPILE ASM ***"
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "*** CLEAN ***"
	rm -f $(OBJ) $(OUTPUT_DIR)/main.elf $(OUTPUT_DIR)/main.hex