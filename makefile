TOOLCHAIN_DIR = ../../programs/arm-gcc/bin
TOOLCHAIN = $(TOOLCHAIN_DIR)/arm-none-eabi-
ROOT_DIR = .
SRC_DIR = $(ROOT_DIR)/src
SYSTEM_DIR = $(ROOT_DIR)/system

ifeq ($(CONFIG), DEBUG)
OUTPUT_DIR = $(ROOT_DIR)/debug
else
OUTPUT_DIR = $(ROOT_DIR)/release
endif

TARGET = $(OUTPUT_DIR)/main

CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)gcc
CP = $(TOOLCHAIN)objcopy
SIZE = $(TOOLCHAIN)size

LDSCRIPT = -T$(SYSTEM_DIR)/stm32f103xb.ld

DEFS += -DSTM32F103xB

MCUFLAGS += -mcpu=cortex-m3
MCUFLAGS += -mlittle-endian
MCUFLAGS += -mthumb

LDFLAGS += $(MCUFLAGS)
LDFLAGS += $(LDSCRIPT)
LDFLAGS += -Wl,--gc-section
LDFLAGS += -Wl,-Map=$(TARGET).map
LDFLAGS += --specs=nano.specs
LDFLAGS += --specs=nosys.specs

CFLAGS += $(MCUFLAGS)
ifeq ($(CONFIG), DEBUG)
CFLAGS += -ggdb3
CFLAGS += -O0
else
CFLAGS += -Os
endif
CFLAGS += -fno-exceptions
CFLAGS += $(DEFS)
CFLAGS += $(INC)

INC += -I$(SYSTEM_DIR)/inc

SRC_CPP += $(SRC_DIR)/main.cpp
SRC_C += $(SYSTEM_DIR)/src/system_stm32f1xx.c

ASM += $(SYSTEM_DIR)/startup_stm32f103xb.s

OBJ = $(SRC_CPP:%.cpp=%.o)
OBJ += $(SRC_C:%.c=%.o)
OBJ += $(ASM:%.s=%.o)


all: directories clean clean_target hex
	@echo "*** DONE ***"
	@$(SIZE) $(TARGET).elf

directories:
	@echo "*** CREATE DIRECTORIES ***"
	@mkdir -p $(OUTPUT_DIR)

hex: elf
	@echo "*** MAKE HEX ***"
	@$(CP) -Oihex $(TARGET).elf $(TARGET).hex

elf: $(OBJ)
	@echo "*** LINK ***"
	@$(LD) $(LDFLAGS) $(OBJ) -o $(TARGET).elf

%.o: %.cpp
	@echo "*** COMPILE C++ ***"
	@$(CC) $(CFLAGS) -std=c++11 -c $< -o $@

%.o: %.c
	@echo "*** COMPILE C ***"
	@$(CC) $(CFLAGS) -std=c11 -c $< -o $@

%.o: %.s
	@echo "*** COMPILE ASM ***"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "*** CLEAN ***"
	@rm -f $(OBJ)

clean_target:
	@echo "*** CLEAN TARGET ***"
	@rm -f $(TARGET).elf $(TARGET).hex $(TARGET).map