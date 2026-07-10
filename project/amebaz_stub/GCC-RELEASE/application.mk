
# Initialize tool chain
# -------------------------------------------------------------------
AMEBA_TOOLDIR	= ../../../component/soc/realtek/8711b/misc/iar_utility/common/tools/
FLASH_TOOLDIR = ../../../component/soc/realtek/8195a/misc/gcc_utility/
FLASHDOWNLOAD_TOOLDIR = ../../../component/soc/realtek/8711b/misc/gnu_utility/flash_download/image
DEBUG_TOOLDIR = ../../../component/soc/realtek/8711b/misc/gcc_utility/

CROSS_COMPILE = arm-none-eabi-

ota_idx ?= 1

# Compilation tools
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
LD = $(CC)
GDB = $(CROSS_COMPILE)gdb
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OS := $(shell uname)

ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
PICK = $(AMEBA_TOOLDIR)pick.exe
PAD  = $(AMEBA_TOOLDIR)padding.exe
CHKSUM = $(AMEBA_TOOLDIR)checksum.exe
OTA = $(AMEBA_TOOLDIR)ota.exe
else
PICK = $(AMEBA_TOOLDIR)pick
PAD  = $(AMEBA_TOOLDIR)padding
CHKSUM = $(AMEBA_TOOLDIR)checksum
OTA = $(AMEBA_TOOLDIR)ota
endif

Q := @
ifeq ($(V),1)
Q := 
endif
LWIP_VERSION=v2.0.2
RTOS_VERSION=v10.0.1
CFLAGS =

# Initialize target name and target object files
# -------------------------------------------------------------------

all: application

TARGET=application

OBJ_DIR=$(TARGET)/Debug/obj
BIN_DIR=$(TARGET)/Debug/bin

# Include folder list
# -------------------------------------------------------------------

INCLUDES =
INCLUDES += -I../inc
INCLUDES += -I../../../component/os/freertos
INCLUDES += -I../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/include
INCLUDES += -I../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/portable/GCC/ARM_CM4F
INCLUDES += -I../../../component/os/os_dep/include
INCLUDES += -I../../../component/common/api/network/include
INCLUDES += -I../../../component/common/api
INCLUDES += -I../../../component/common/api/at_cmd
INCLUDES += -I../../../component/common/api/platform
INCLUDES += -I../../../component/common/api/wifi
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src/crypto
INCLUDES += -I../../../component/common/api/wifi/rtw_wowlan
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant
INCLUDES += -I../../../component/common/application
INCLUDES += -I../../../component/common/application/mqtt/MQTTClient
INCLUDES += -I../../../component/common/application/mqtt/MQTTPacket
INCLUDES += -I../../../component/common/application/realmesh/include
INCLUDES += -I../../../component/common/example
INCLUDES += -I../../../component/common/example/wlan_fast_connect
INCLUDES += -I../../../component/common/drivers/modules
INCLUDES += -I../../../component/common/drivers/sdio/realtek/sdio_host/inc
INCLUDES += -I../../../component/common/drivers/inic/rtl8711b
INCLUDES += -I../../../component/common/drivers/usb_class/device
INCLUDES += -I../../../component/common/drivers/usb_class/device/class
INCLUDES += -I../../../component/common/drivers/wlan/realtek/include
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/osdep
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hci
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal/rtl8711b
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal/OUTSRC
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/core/option
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/core/mesh
INCLUDES += -I../../../component/common/drivers/wlan/realtek/wlan_ram_map/rom
INCLUDES += -I../../../component/common/network
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek/freertos
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include/lwip
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include/ipv4
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek
INCLUDES += -I../../../component/common/network/ssl/polarssl-1.3.8/include
INCLUDES += -I../../../component/common/network/ssl/mbedtls-2.4.0/include
INCLUDES += -I../../../component/common/network/ssl/ssl_ram_map/rom
INCLUDES += -I../../../component/common/test
INCLUDES += -I../../../component/common/utilities
INCLUDES += -I../../../component/soc/realtek/8711b/app/monitor/include
INCLUDES += -I../../../component/soc/realtek/8711b/cmsis
INCLUDES += -I../../../component/soc/realtek/8711b/cmsis/device
INCLUDES += -I../../../component/soc/realtek/8711b/fwlib
INCLUDES += -I../../../component/soc/realtek/8711b/fwlib/include
INCLUDES += -I../../../component/soc/realtek/8711b/fwlib/ram_lib/crypto
INCLUDES += -I../../../component/soc/realtek/8711b/fwlib/rom_lib
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/os_dep/include
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/std_lib/include
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/std_lib/libc/include
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/std_lib/libc/rom/string
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/std_lib/libgcc/rtl8195a/include
INCLUDES += -I../../../component/soc/realtek/8711b/swlib/rtl_lib
INCLUDES += -I../../../component/soc/realtek/8711b/misc
INCLUDES += -I../../../component/soc/realtek/8711b/misc/os
INCLUDES += -I../../../component/common/mbed/api
INCLUDES += -I../../../component/common/mbed/hal
INCLUDES += -I../../../component/common/mbed/hal_ext
INCLUDES += -I../../../component/common/mbed/targets/cmsis/rtl8711b
INCLUDES += -I../../../component/common/mbed/targets/hal/rtl8711b
INCLUDES += -I../../../project/realtek_8195a_gen_project/rtl8195a/sw/lib/sw_lib/mbed/api
INCLUDES += -I../../../../../libraries/miniz


# Source file list
# -------------------------------------------------------------------

SRC_C =

SRC_C += ../src/main.c
SRC_C += ../../../../../libraries/miniz/miniz.c
SRC_C += ../../../../../libraries/miniz/miniz_tdef.c
SRC_C += ../../../../../libraries/miniz/miniz_tinfl.c


# Generate obj list
# -------------------------------------------------------------------

SRC_O = $(patsubst %.c,%.o,$(SRC_C))

SRC_C_LIST = $(notdir $(SRC_C))
OBJ_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.o,$(SRC_C_LIST)))
DEPENDENCY_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.d,$(SRC_C_LIST)))
DEPENDENCY_LIST += $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.d,$(SRC_CPP_LIST)))

# Compile options
# -------------------------------------------------------------------

CFLAGS += -DM3 -DCONFIG_PLATFORM_8711B -DMINIZ_LITTLE_ENDIAN=1 -DTDEFL_LESS_MEMORY -DMINIZ_USE_UNALIGNED_LOADS_AND_STORES=1 -DNDEBUG
CXXFLAGS += $(CFLAGS)
CFLAGS += -std=gnu99 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -w -Os -Wno-pointer-sign -fno-common -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-short-enums -DF_CPU=166000000L -fsigned-char -MMD -flto

LFLAGS = 
LFLAGS += -nostdlib -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -nostartfiles -specs=nosys.specs -Wl,-Map=$(BIN_DIR)/application.map -Os -Wl,--gc-sections -Wl,--cref -Wl,--entry=Reset_Handler -Wl,--no-enum-size-warning -Wl,--no-wchar-size-warning -flto
LFLAGS += -Wl,--undefined=gImage2EntryFun0
#LFLAGS += -Wl,-wrap,atoi
#LFLAGS += -Wl,-wrap,atol
#LFLAGS += -Wl,-wrap,strtol
#LFLAGS += -Wl,-wrap,strtoul
#LFLAGS += -Wl,-wrap,rand
#LFLAGS += -Wl,-wrap,strcat
#LFLAGS += -Wl,-wrap,strcpy
#LFLAGS += -Wl,-wrap,strncat
#LFLAGS += -Wl,-wrap,strncpy
#LFLAGS += -Wl,-wrap,strchr
#LFLAGS += -Wl,-wrap,strcmp
#LFLAGS += -Wl,-wrap,strlen
#LFLAGS += -Wl,-wrap,strncmp
#LFLAGS += -Wl,-wrap,strpbrk
#LFLAGS += -Wl,-wrap,strstr
#LFLAGS += -Wl,-wrap,strtok
#LFLAGS += -Wl,-wrap,memchr
#LFLAGS += -Wl,-wrap,memcmp
LFLAGS += -Wl,-wrap,memcpy
#LFLAGS += -Wl,-wrap,memmove
LFLAGS += -Wl,-wrap,memset
#LFLAGS += -Wl,-wrap,strsep
LFLAGS += -Wl,-wrap,malloc
LFLAGS += -Wl,-wrap,free
LFLAGS += -Wl,-wrap,realloc

LIBFLAGS =
# Compile
# -------------------------------------------------------------------

.PHONY: application
application: prerequirement build_info $(SRC_O)
	$(LD) $(LFLAGS) -o $(BIN_DIR)/$(TARGET).axf  $(OBJ_LIST) $(LIBFLAGS) -T./stub.ld
	$(Q)$(OBJCOPY) -O binary $(BIN_DIR)/$(TARGET).axf $(BIN_DIR)/stub.bin
	gzip -k $(BIN_DIR)/stub.bin
	mv $(BIN_DIR)/stub.bin.gz RTL8710B_Stub.bin

	$(OBJDUMP) -d $(BIN_DIR)/$(TARGET).axf > $(BIN_DIR)/$(TARGET).asm


# Generate build info
# -------------------------------------------------------------------	

.PHONY: build_info
build_info:
	@touch .ver
	@mv -f .ver ../inc/$@.h


.PHONY: prerequirement
prerequirement:
	@echo ===========================================================
	@echo Build $(TARGET)
	@echo ===========================================================
	$(Q)mkdir -p $(OBJ_DIR)
	$(Q)mkdir -p $(BIN_DIR)

$(SRC_O): %.o : %.c
	@echo "compile_c $<"
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(OBJ_DIR)/$(notdir $(patsubst %.o,%.d,$@))
	$(Q)cp $@ $(OBJ_DIR)/$(notdir $@)
	$(Q)chmod 777 $(OBJ_DIR)/$(notdir $@)

-include $(DEPENDENCY_LIST)

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -f $(SRC_O)
	rm -f $(patsubst %.o,%.d,$(SRC_O))

