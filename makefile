
ROOT_DIR = .
SRC_DIR = $(ROOT_DIR)/src
SYSTEM_DIR = $(ROOT_DIR)/system

OBJ_DIR = $(ROOT_DIR)/obj
OUTPUT_DIR = $(ROOT_DIR)/bin

ifeq ($(CONFIG), DEBUG)
TARGET = $(OUTPUT_DIR)/main_debug
OFLAGS += -ggdb3
OFLAGS += -O0
else
TARGET = $(OUTPUT_DIR)/main
OFLAGS += -Os
endif



#region TOOLCHAIN
TOOLCHAIN_DIR = ../../programs/arm-gcc/bin
TOOLCHAIN = $(TOOLCHAIN_DIR)/arm-none-eabi-
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)gcc
CP = $(TOOLCHAIN)objcopy
SIZE = $(TOOLCHAIN)size
#endregion

#region PLATFORM
LDSCRIPT = -T$(SYSTEM_DIR)/stm32f103xb.ld

DEFS += -DSTM32F103xB

MCUFLAGS += -mcpu=cortex-m3
MCUFLAGS += -mlittle-endian
MCUFLAGS += -mthumb
#endregion

#region SOURCES
INC += -I$(SYSTEM_DIR)/inc
INC += -I$(SRC_DIR)/inc

SRC_CPP += $(SRC_DIR)/main.cpp
SRC_C += $(SYSTEM_DIR)/src/system_stm32f1xx.c
ASM += $(SYSTEM_DIR)/startup_stm32f103xb.s

OBJ = $(SRC_CPP:%.cpp=%.o)
OBJ += $(SRC_C:%.c=%.o)
OBJ += $(ASM:%.s=%.o)
#endregion

#region FLAGS
LDFLAGS += $(MCUFLAGS)
LDFLAGS += $(LDSCRIPT)
LDFLAGS += -Wl,--gc-section
LDFLAGS += -Wl,-Map=$(TARGET).map
LDFLAGS += --specs=nano.specs
LDFLAGS += --specs=nosys.specs

CFLAGS += $(MCUFLAGS)
CFLAGS += $(OFLAGS)
CFLAGS += -fno-exceptions
CFLAGS += -Wall -Wextra -Werror
CFLAGS += $(DEFS)
CFLAGS += $(INC)
#endregion

all: directories clean clean_target hex
	@echo "*** DONE ***"
	@$(SIZE) -A -x $(TARGET).elf
	@$(SIZE) -B -x $(TARGET).elf

directories:
	@echo "*** CREATE DIRECTORIES ***"
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(OBJ_DIR)

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