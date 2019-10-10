SRC_DIR = src
EMBEDDED_LIB_DIR = embedded
SYSTEM_DIR = system

OBJ_DIR = obj
OUTPUT_DIR = bin

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
INC += $(SYSTEM_DIR)/inc
INC += $(SRC_DIR)/inc
INC += $(EMBEDDED_LIB_DIR)/*/inc
INC := $(addprefix -I, $(wildcard $(INC)))

SRC_DIRS += $(SYSTEM_DIR)
SRC_DIRS += $(SYSTEM_DIR)/src
SRC_DIRS += $(SRC_DIR)
SRC_DIRS += $(SRC_DIR)/src/*
SRC_DIRS += $(EMBEDDED_LIB_DIR)/*/src/*

ASM_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.s))
C_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
CPP_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))

OBJ_FILES := $(ASM_FILES:%.s=%.o)
OBJ_FILES += $(C_FILES:%.c=%.o)
OBJ_FILES += $(CPP_FILES:%.cpp=%.o)
OBJ_FILES := $(addprefix $(OBJ_DIR)/, $(OBJ_FILES))

#endregion

#region FLAGS
LDFLAGS += $(MCUFLAGS)
LDFLAGS += $(LDSCRIPT)
LDFLAGS += -Wl,--gc-section
LDFLAGS += -Wl,-Map=$(TARGET).map
LDFLAGS += --specs=nano.specs
LDFLAGS += --specs=nosys.specs
LDFLAGS += -pipe

CFLAGS += $(MCUFLAGS)
CFLAGS += $(OFLAGS)
CFLAGS += -fno-exceptions
CFLAGS += -Wall -Wextra -Werror
CFLAGS += -pipe
CFLAGS += $(DEFS)
CFLAGS += $(INC)
#endregion

all: directories clean clean_target hex
	@echo "*** DONE ***"
	@$(SIZE) -A -x $(TARGET).elf
	@$(SIZE) -B  $(TARGET).elf

directories:
	@echo "*** CREATE DIRECTORIES ***"
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(sort $(dir $(OBJ_FILES)))

hex: elf
	@echo "*** MAKE HEX ***"
	@$(CP) -Oihex $(TARGET).elf $(TARGET).hex

elf: $(OBJ_FILES)
	@echo "*** LINK ***"
	@$(LD) $(LDFLAGS) $(OBJ_FILES) -o $(TARGET).elf

$(OBJ_DIR)/%.o: %.cpp
	@echo "*** COMPILE C++ ***"
	@$(CC) $(CFLAGS) -std=c++17 -c $< -o $@

$(OBJ_DIR)/%.o: %.c
	@echo "*** COMPILE C ***"
	@$(CC) $(CFLAGS) -std=c11 -c $< -o $@

$(OBJ_DIR)/%.o: %.s
	@echo "*** COMPILE ASM ***"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "*** CLEAN ***"
	@rm -f $(OBJ_FILES)

clean_target:
	@echo "*** CLEAN TARGET ***"
	@rm -f $(TARGET).elf $(TARGET).hex $(TARGET).map

view:
	@echo $(INC)
	@echo $(SRC_DIRS)
	@echo $(ASM_FILES)
	@echo $(C_FILES)
	@echo $(CPP_FILES)
	@echo $(OBJ_FILES)