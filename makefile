SRC_DIR = src
EMBEDDED_LIB_DIR = embedded
SYSTEM_DIR = system


ifeq ($(CONFIG), DEBUG)
OBJ_DIR = bin/obj/debug
OUTPUT_DIR = bin/debug
OFLAGS += -ggdb3
OFLAGS += -O0
else
OBJ_DIR = bin/obj/release
OUTPUT_DIR = bin/release
OFLAGS += -Os
endif

TARGET = $(OUTPUT_DIR)/main


#region TOOLCHAIN
TOOLCHAIN_DIR = ../../programs/arm-gcc/bin
TOOLCHAIN = $(TOOLCHAIN_DIR)/arm-none-eabi-
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)gcc
CP = $(TOOLCHAIN)objcopy
SIZE = $(TOOLCHAIN)size
OBJDUMP = $(TOOLCHAIN)objdump
NM = $(TOOLCHAIN)nm
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

all: directories clean clean_target hex lss sym size
	@echo "*** DONE ***"

size:
	@$(SIZE) -A -x $(TARGET).elf > $(TARGET).size
	@$(SIZE) -B  $(TARGET).elf

directories:
	@echo "*** CREATE DIRECTORIES ***"
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(sort $(dir $(OBJ_FILES)))

hex: elf
	@echo "*** MAKE HEX ***"
	@$(CP) -Oihex $(TARGET).elf $(TARGET).hex

lss: elf
	@$(OBJDUMP) -h -S -C -r $(TARGET).elf > $(TARGET).lss

sym: elf
	@$(NM) -n $(TARGET).elf > $(TARGET).sym

elf: $(OBJ_FILES)
	@echo "*** LINK ***"
	@$(LD) $(LDFLAGS) $(OBJ_FILES) -o $(TARGET).elf

$(OBJ_DIR)/%.o: %.cpp
	@echo "*** COMPILE" $< "***"
	@$(CC) $(CFLAGS) -std=c++17 -c $< -o $@

$(OBJ_DIR)/%.o: %.c
	@echo "*** COMPILE" $< "***"
	@$(CC) $(CFLAGS) -std=c11 -c $< -o $@

$(OBJ_DIR)/%.o: %.s
	@echo "*** COMPILE" $< "***"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "*** CLEAN ***"
	@rm -f $(OBJ_FILES)

clean_target:
	@echo "*** CLEAN TARGET ***"
	@rm -f $(TARGET).elf $(TARGET).hex $(TARGET).map $(TARGET).lss $(TARGET).sym $(TARGET).size

view:
	@echo $(INC)
	@echo $(SRC_DIRS)
	@echo $(ASM_FILES)
	@echo $(C_FILES)
	@echo $(CPP_FILES)
	@echo $(OBJ_FILES)
