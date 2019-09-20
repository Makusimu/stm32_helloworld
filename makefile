
########################################################################
TOOLCHAIN_ROOT=~/projects/gcc-arm-none-eabi-8-2019-q3-update/bin
CC=$(TOOLCHAIN_ROOT)/arm-none-eabi-gcc
LD=$(TOOLCHAIN_ROOT)/arm-none-eabi-gcc
CP=$(TOOLCHAIN_ROOT)/arm-none-eabi-objcopy

ROOT_DIR=/home/makusimu/projects/test

########################################################################
LDSCRIPT=-T$(ROOT_DIR)/system/stm32f103xb.ld

########################################################################
INC+=-I$(ROOT_DIR)/system/inc

SRC+=$(ROOT_DIR)/main.c
SRC+=$(ROOT_DIR)/system/src/system_stm32f1xx.c

ASM+=$(ROOT_DIR)/system/src/startup_stm32f103xb.s

#######################################################################
OBJ=$(SRC:%.c=%.o)
OBJ+=$(ASM:%.s=%.o)

#######################################################################
CFLAGS += -mcpu=cortex-m3 
CFLAGS += -mlittle-endian
CFLAGS += -mthumb
CFLAGS += -g
CFLAGS += -DSTM32F103xB
CFLAGS += $(INC)

LDFLAGS += -mcpu=cortex-m3
LDFLAGS += -mlittle-endian
LDFLAGS += -mthumb
LDFLAGS += $(LDSCRIPT)
LDFLAGS += -Wl,--gc-section

######################################################################
all: start
	@echo "\n"
	@echo "END"

start: main.elf
	@echo "\n"
	@echo "OUT"
	@echo "********************************************************"
	$(CP) -Oihex main.elf main.hex 
	@echo "********************************************************"

main.elf: $(OBJ)
	@echo "\n"
	@echo "LINK"
	@echo "********************************************************"
	$(LD) $(LDFLAGS) $(OBJ) -o main.elf
	@echo "********************************************************"

%.o: %.c
	@echo "\n"
	@echo "COMPILE C"
	@echo "********************************************************"
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "********************************************************"

%.o: %.s
	@echo "\n"
	@echo "COMPILE S"
	@echo "********************************************************"
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "********************************************************"

clean:
	rm -f $(OBJ) main.elf main.hex