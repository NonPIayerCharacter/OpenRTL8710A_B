# Flags
# -------------------------------------------------------------------
CONFIG_BT = 0
# -------------------------------------------------------------------
# Initialize tool chain
# -------------------------------------------------------------------
ARM_GCC_TOOLCHAIN = ../../../tools/arm-none-eabi-gcc/4_8-2014q3/bin/
AMEBA_TOOLDIR	= ../../../component/soc/realtek/8195a/misc/iar_utility/common/tools/
FLASH_TOOLDIR = ../../../component/soc/realtek/8195a/misc/gcc_utility/
IMAGE1_DIR = ../../../component/soc/realtek/8195a/misc/bsp/image/

CROSS_COMPILE = arm-none-eabi-

# Compilation tools
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
LD = $(CROSS_COMPILE)gcc
GDB = $(CROSS_COMPILE)gdb
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OS := $(shell uname)

ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
PICK = $(AMEBA_TOOLDIR)pick.exe
PAD  = $(AMEBA_TOOLDIR)padding.exe
CHKSUM = $(AMEBA_TOOLDIR)checksum.exe
ED25519 =  $(AMEBA_TOOLDIR)ed25519.exe
TAIL =  $(AMEBA_TOOLDIR)tail.exe
else
PICK = $(AMEBA_TOOLDIR)pick
PAD  = $(AMEBA_TOOLDIR)padding
CHKSUM = $(AMEBA_TOOLDIR)checksum
ED25519 =  $(AMEBA_TOOLDIR)ed25519
endif

HASH_PY =  $(AMEBA_TOOLDIR)hashing.py
#REHEADER_PY =  $(AMEBA_TOOLDIR)reheader.py
SIGN_LEN = 64
SECURE_BOOT = 0

Q := @
ifeq ($(V),1)
Q := 
endif
LWIP_VERSION=v2.0.2
RTOS_VERSION=v10.0.1
CFLAGS =

# Initialize target name and target object files
# -------------------------------------------------------------------

all: application manipulate_images

mp: application manipulate_images

TARGET=application

OBJ_DIR=$(TARGET)/Debug/obj
BIN_DIR=$(TARGET)/Debug/bin

# Include folder list
# -------------------------------------------------------------------

INCLUDES =
INCLUDES += -I../inc
INCLUDES += -I../../../component/soc/realtek/common/bsp
INCLUDES += -I../../../component/os/freertos
INCLUDES += -I../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/include
INCLUDES += -I../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/portable/GCC/ARM_CM3
INCLUDES += -I../../../component/os/os_dep/include
INCLUDES += -I../../../component/soc/realtek/8195a/misc/driver
INCLUDES += -I../../../component/soc/realtek/8195a/misc/os
INCLUDES += -I../../../component/common/api/network/include
INCLUDES += -I../../../component/common/api
INCLUDES += -I../../../component/common/api/platform
INCLUDES += -I../../../component/common/api/wifi
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src
INCLUDES += -I../../../component/common/api/wifi/rtw_wpa_supplicant/src/crypto
INCLUDES += -I../../../component/common/application
INCLUDES += -I../../../component/common/application/iotdemokit
INCLUDES += -I../../../component/common/application/google
ifeq ($(CONFIG_BT), 1)
INCLUDES += -I../../../component/common/bluetooth
endif
INCLUDES += -I../../../component/common/media/framework
INCLUDES += -I../../../component/common/example
INCLUDES += -I../../../component/common/example/wlan_fast_connect
INCLUDES += -I../../../component/common/mbed/api
INCLUDES += -I../../../component/common/mbed/hal
INCLUDES += -I../../../component/common/mbed/hal_ext
INCLUDES += -I../../../component/common/mbed/targets/hal/rtl8195a
INCLUDES += -I../../../component/common/file_system
INCLUDES += -I../../../component/common/network
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek/freertos
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include/lwip
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/include/ipv4
INCLUDES += -I../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek
INCLUDES += -I../../../component/common/test
INCLUDES += -I../../../component/soc/realtek/8195a/cmsis
INCLUDES += -I../../../component/soc/realtek/8195a/cmsis/device
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/rtl8195a
INCLUDES += -I../../../component/soc/realtek/8195a/misc/platform
INCLUDES += -I../../../component/soc/realtek/8195a/misc/rtl_std_lib/include
INCLUDES += -I../../../component/common/drivers/wlan/realtek/include
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/osdep
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hci
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/hal/OUTSRC
INCLUDES += -I../../../component/common/drivers/wlan/realtek/src/core/option
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/ram_lib/wlan/realtek/wlan_ram_map/rom
INCLUDES += -I../../../component/common/network/ssl/polarssl-1.3.8/include
INCLUDES += -I../../../component/common/network/ssl/mbedtls-2.4.0/include
INCLUDES += -I../../../component/common/network/ssl/ssl_ram_map/rom
INCLUDES += -I../../../component/common/utilities
INCLUDES += -I../../../component/soc/realtek/8195a/misc/rtl_std_lib/include
INCLUDES += -I../../../component/common/application/apple/WACServer/External/Curve25519
INCLUDES += -I../../../component/common/application/apple/WACServer/External/GladmanAES
INCLUDES += -I../../../component/soc/realtek/8195a/fwlib/ram_lib/usb_otg/include
INCLUDES += -I../../../component/common/video/v4l2/inc
INCLUDES += -I../../../component/common/media/rtp_codec
INCLUDES += -I../../../component/common/drivers/usb_class/host/uvc/inc
INCLUDES += -I../../../component/common/drivers/usb_class/device
INCLUDES += -I../../../component/common/drivers/usb_class/device/class
INCLUDES += -I../../../component/common/file_system/fatfs
INCLUDES += -I../../../component/common/file_system/fatfs/r0.10c/include
INCLUDES += -I../../../component/common/drivers/sdio/realtek/sdio_host/inc
INCLUDES += -I../../../component/common/audio
INCLUDES += -I../../../component/common/drivers/i2s
INCLUDES += -I../../../component/common/application/xmodem
INCLUDES += -I../../../component/common/application/mqtt/MQTTClient

# Source file list
# -------------------------------------------------------------------

SRC_C =
DRAM_C =
#cmsis
SRC_C += ../../../component/soc/realtek/8195a/cmsis/device/system_8195a.c

#console
#ifeq ($(CONFIG_BT), 1)
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_bt.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_cloud.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_ethernet.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_lwip.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_mp.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_sys.c
#DRAM_C += ../../../component/common/api/at_cmd/atcmd_wifi.c
#else
#SRC_C += ../../../component/common/api/at_cmd/atcmd_cloud.c
#SRC_C += ../../../component/common/api/at_cmd/atcmd_ethernet.c
#SRC_C += ../../../component/common/api/at_cmd/atcmd_lwip.c
#SRC_C += ../../../component/common/api/at_cmd/atcmd_mp.c
#SRC_C += ../../../component/common/api/at_cmd/atcmd_sys.c
#SRC_C += ../../../component/common/api/at_cmd/atcmd_wifi.c
#endif
#SRC_C += ../../../component/common/api/at_cmd/log_service.c
SRC_C += ../../../component/soc/realtek/8195a/misc/driver/low_level_io.c
SRC_C += ../../../component/soc/realtek/8195a/misc/driver/rtl_consol.c

#multimedia - audio_driver
SRC_C += ../../../component/common/drivers/i2s/sgtl5000.c

#network - api
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/src/crypto/tls_polarssl.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_eap_config.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_p2p_config.c
SRC_C += ../../../component/common/api/wifi/rtw_wpa_supplicant/wpa_supplicant/wifi_wps_config.c
SRC_C += ../../../component/common/api/wifi/wifi_conf.c
SRC_C += ../../../component/common/api/wifi/wifi_ind.c
SRC_C += ../../../component/common/api/wifi/wifi_promisc.c
SRC_C += ../../../component/common/api/wifi/wifi_simple_config.c
SRC_C += ../../../component/common/api/wifi/wifi_util.c
SRC_C += ../../../component/common/api/lwip_netconf.c

#network - app
SRC_C += ../../../component/soc/realtek/8195a/misc/platform/ota_8195a.c
SRC_C += ../../../component/common/api/network/src/ping_test.c
SRC_C += ../../../component/common/utilities/ssl_client.c
SRC_C += ../../../component/common/utilities/ssl_client_ext.c
SRC_C += ../../../component/common/utilities/tcptest.c
#SRC_C += ../../../component/common/application/uart_adapter/uart_adapter.c
SRC_C += ../../../component/common/utilities/uart_ymodem.c
SRC_C += ../../../component/common/utilities/update.c
SRC_C += ../../../component/common/api/network/src/wlan_network.c


#network - lwip
#network - lwip - api
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/api_lib.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/api_msg.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/err.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/netbuf.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/netdb.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/netifapi.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/sockets.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/api/tcpip.c

#network - lwip - core
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/def.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/dns.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/inet_chksum.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/init.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ip.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/mem.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/memp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/netif.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/pbuf.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/raw.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/stats.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/sys.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/tcp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/tcp_in.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/tcp_out.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/timeouts.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/udp.c

#network - lwip - core - ipv4
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/autoip.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/dhcp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/etharp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/icmp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/igmp.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/ip4.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/ip4_addr.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/ip4_frag.c
#for 2.2.0
#SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv4/acd.c

#network - lwip - core - ipv6
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/dhcp6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/ethip6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/icmp6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/inet6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/ip6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/ip6_addr.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/ip6_frag.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/mld6.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/core/ipv6/nd6.c

#network - lwip - netif
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/netif/ethernet.c

#network lwip port
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek/freertos/ethernetif.c
SRC_C += ../../../component/common/drivers/wlan/realtek/src/osdep/lwip_intf.c
SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/port/realtek/freertos/sys_arch.c

SRC_C += ../../../component/common/network/lwip/lwip_$(LWIP_VERSION)/src/apps/mqtt/mqtt.c

SRC_C += ../../../component/common/network/dhcp/dhcps.c
SRC_C += ../../../component/common/network/sntp/sntp.c

#network - mdns
SRC_C += ../../../component/common/network/mDNS/mDNSPlatform.c

#os - freertos
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/portable/MemMang/heap_5.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/portable/GCC/ARM_CM3/port.c

SRC_C += ../../../component/os/freertos/cmsis_os.c
#SRC_C += ../../../component/os/freertos/freertos_cb.c
SRC_C += ../../../component/os/freertos/freertos_service.c
#SRC_C += ../../../component/os/freertos/freertos_pmu.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/croutine.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/event_groups.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/list.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/queue.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/tasks.c
SRC_C += ../../../component/os/freertos/freertos_$(RTOS_VERSION)/Source/timers.c

#os - osdep
SRC_C += ../../../component/os/os_dep/device_lock.c
SRC_C += ../../../component/soc/realtek/8195a/misc/os/mailbox.c
SRC_C += ../../../component/soc/realtek/8195a/misc/os/osdep_api.c
SRC_C += ../../../component/os/os_dep/osdep_service.c
SRC_C += ../../../component/os/os_dep/tcm_heap.c

#peripheral - api
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/analogin_api.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/analogout_api.c
endif
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/dma_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/efuse_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/ethernet_api.c
SRC_C += ../../../component/common/drivers/ethernet_mii/ethernet_mii.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/flash_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/gpio_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/gpio_irq_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/i2c_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/i2s_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/log_uart_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/nfc_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pinmap.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pinmap_common.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/port_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/pwmout_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/reset_reason_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/rtc_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/serial_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/sleep.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/spdio_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/spi_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/sys_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/timer_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/us_ticker.c
SRC_C += ../../../component/common/mbed/common/us_ticker_api.c
SRC_C += ../../../component/common/mbed/common/wait_api.c
SRC_C += ../../../component/common/mbed/targets/hal/rtl8195a/wdt_api.c

#peripheral - hal
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_32k.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_adc.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_dac.c
endif
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_gdma.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_gpio.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_i2c.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_i2s.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_mii.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_nfc.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_pcm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_pwm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_sdr_controller.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_ssi.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_timer.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/src/hal_uart.c

#peripheral - rtl8195a
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_adc.c
ifeq ($(CONFIG_BT), 1)
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_dac.c
endif
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_gdma.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_gpio.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_i2c.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_i2s.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_mii.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_nfc.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_pwm.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_ssi.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_timer.c
SRC_C += ../../../component/soc/realtek/8195a/fwlib/rtl8195a/src/rtl8195a_uart.c

#peripheral - wlan
#all:SRC_C += ../../../component/common/drivers/wlan/realtek/src/core/option/rtw_opt_skbuf.c

#SDRAM
DRAM_C += ../../../component/common/api/platform/stdlib_patch.c

ifeq ($(CONFIG_BT), 1)
#SDRAM - bluetooth
DRAM_C += ../../../component/common/bluetooth/bt_conf.c
DRAM_C += ../../../component/common/bluetooth/bt_util.c
DRAM_C += ../../../component/common/bluetooth/ring_buffer.c
endif

#SDRAM - polarssl
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/aes.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/aesni.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/arc4.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/asn1parse.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/asn1write.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/base64.c
#SRC_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/bignum.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/blowfish.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/camellia.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ccm.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/certs.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/cipher.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/cipher_wrap.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ctr_drbg.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/debug.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/des.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/dhm.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecp.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecp_curves.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecdh.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ecdsa.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/entropy.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/entropy_poll.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/error.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/gcm.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/havege.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/hmac_drbg.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md_wrap.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md2.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md4.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/md5.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/memory_buffer_alloc.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/net.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/oid.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/padlock.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pbkdf2.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pem.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs5.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs11.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkcs12.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pk.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pk_wrap.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkparse.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/pkwrite.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/platform.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ripemd160.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/rsa.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha1.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha256.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/sha512.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_cache.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_ciphersuites.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_cli.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_srv.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/ssl_tls.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/threading.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/timing.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/version.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/version_features.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_crt.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_crl.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_csr.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509_create.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509write_crt.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/x509write_csr.c
#DRAM_C += ../../../component/common/network/ssl/polarssl-1.3.8/library/xtea.c

#SDRAM - mbedtls
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/aes.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/aesni.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/arc4.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/asn1parse.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/asn1write.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/mb_base64.c
SRC_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/bignum.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/blowfish.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/camellia.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ccm.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/certs.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/cipher.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/cipher_wrap.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ctr_drbg.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/debug.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/des.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/dhm.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecp.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecp_curves.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecdh.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ecdsa.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/entropy.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/entropy_poll.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/error.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/gcm.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/havege.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/hmac_drbg.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md_wrap.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md2.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md4.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/md5.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/memory_buffer_alloc.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/net_sockets.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/oid.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/padlock.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pem.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs5.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs11.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkcs12.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pk.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pk_wrap.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkparse.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/pkwrite.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/platform.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ripemd160.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/rsa.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha1.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha256.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/sha512.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_cache.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_ciphersuites.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_cli.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_srv.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/ssl_tls.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/threading.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/timing.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/version.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/version_features.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_crt.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_crl.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_csr.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509_create.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509write_crt.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/x509write_csr.c
DRAM_C += ../../../component/common/network/ssl/mbedtls-2.4.0/library/xtea.c

# - ssl wpa3
SRC_C += ../../../component/common/drivers/wlan/realtek/src/core/option/rtw_opt_crypto_ssl.c

#SDRAM - ssl_ram_map
DRAM_C += ../../../component/common/network/ssl/ssl_ram_map/rom/rom_ssl_ram_map.c
DRAM_C += ../../../component/common/network/ssl/ssl_ram_map/ssl_ram_map.c

#utilities - FatFS
#SRC_C += ../../../component/common/file_system/fatfs/fatfs_ext/src/ff_driver.c
#SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/diskio.c
#SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/ff.c
#SRC_C += ../../../component/common/file_system/fatfs/r0.10c/src/option/ccsbcs.c
#SRC_C += ../../../component/common/file_system/fatfs/disk_if/src/sdcard.c

#utilities - xmodme update
SRC_C += ../../../component/common/application/xmodem/uart_fw_update.c

#gcc wrap
SRC_C += ../../../component/soc/realtek/8195a/misc/platform/gcc_wrap.c
SRC_C += ../../../component/common/api/platform/gcc_wrap_time.c

#user 
#SRC_C += ../src/main.c

-include ../../../../../platforms/RTL8710A/OpenBeken.mk

# Generate obj list
# -------------------------------------------------------------------

SRC_O = $(patsubst %.c,%.o,$(SRC_C))
DRAM_O = $(patsubst %.c,%.o,$(DRAM_C))

SRC_C_LIST = $(notdir $(SRC_C)) $(notdir $(DRAM_C))
OBJ_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.o,$(SRC_C_LIST)))
DEPENDENCY_LIST = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.d,$(SRC_C_LIST)))

# Compile options
# -------------------------------------------------------------------

CFLAGS += -DM3 -DCONFIG_PLATFORM_8195A -DGCC_ARMCM3
CFLAGS += -mcpu=cortex-m3 -mthumb -g2 -w -Os -Wno-pointer-sign -fno-common -fmessage-length=0  -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-short-enums -DF_CPU=166000000L -std=gnu99 -fsigned-char
CFLAGS += -include time64_gcc.h

LFLAGS = 
LFLAGS += -mcpu=cortex-m3 -mthumb -g --specs=nano.specs -nostartfiles -Wl,-Map=$(BIN_DIR)/application.map -Os -Wl,--gc-sections -Wl,--cref -Wl,--entry=Reset_Handler -Wl,--no-enum-size-warning -Wl,--no-wchar-size-warning
LFLAGS += -Wl,-wrap,malloc -Wl,-wrap,free -Wl,-wrap,realloc -Wl,-wrap,_malloc_r -Wl,-wrap,_free_r -Wl,-wrap,_realloc_r
LFLAGS += -Wl,-wrap,localtime -Wl,-wrap,mktime
LFLAGS += -Wl,-wrap,rom_psk_CalcGTK
LFLAGS += -Wl,-wrap,rom_psk_CalcPTK
LFLAGS += -Wl,-wrap,aes_80211_encrypt
LFLAGS += -Wl,-wrap,aes_80211_decrypt
LFLAGS += -Wl,--undefined=gImage2EntryFun0
LFLAGS += -Wl,-wrap,atoi
LFLAGS += -Wl,-wrap,atol
LFLAGS += -Wl,-wrap,strtol
LFLAGS += -Wl,-wrap,strtoul
LFLAGS += -Wl,-wrap,rand
LFLAGS += -Wl,-wrap,strcat
LFLAGS += -Wl,-wrap,strcpy
LFLAGS += -Wl,-wrap,strncat
LFLAGS += -Wl,-wrap,strncpy
LFLAGS += -Wl,-wrap,strchr
LFLAGS += -Wl,-wrap,strcmp
LFLAGS += -Wl,-wrap,strlen
LFLAGS += -Wl,-wrap,strncmp
LFLAGS += -Wl,-wrap,strpbrk
LFLAGS += -Wl,-wrap,strstr
LFLAGS += -Wl,-wrap,strtok
LFLAGS += -Wl,-wrap,memchr
LFLAGS += -Wl,-wrap,memcmp
LFLAGS += -Wl,-wrap,memcpy
LFLAGS += -Wl,-wrap,memmove
LFLAGS += -Wl,-wrap,memset
LFLAGS += -Wl,-wrap,strsep

LIBFLAGS =
ifeq ($(CONFIG_BT), 1)
all: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_bt -l_platform -l_wlan -l_btsdk -l_eap -l_http -l_dct -l_p2p -l_wps -l_rtlstd -l_usbd -l_sdcard -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
mp: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_bt -l_platform -l_wlan_mp -l_btsdk -l_p2p -l_wps -l_rtlstd -l_dct -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
else
all: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_platform -l_wlan -l_eap -l_http -l_dct -l_p2p -l_wps -l_rtlstd -l_usbd -l_sdcard -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
mp: LIBFLAGS += -L../../../component/soc/realtek/8195a/misc/bsp/lib/common/GCC/ -l_platform -l_wlan_mp -l_p2p -l_wps -l_rtlstd -l_dct -l_websocket -l_xmodem -lm -lc -lnosys -lgcc
endif

RAMALL_BIN =
OTA_BIN = 
all: RAMALL_BIN = ram_all.bin
all: OTA_BIN = ota.bin
mp: RAMALL_BIN = ram_all_mp.bin
mp: OTA_BIN = ota_mp.bin

# Compile
# -------------------------------------------------------------------

.PHONY: application
application: prerequirement build_info $(SRC_O) $(DRAM_O)
	$(LD) $(LFLAGS) -o $(BIN_DIR)/$(TARGET).axf  $(OBJ_LIST) $(OBJ_DIR)/ram_1.r.o $(LIBFLAGS) -T./rlx8195A-symbol-v02-img2.ld
	$(OBJDUMP) -d $(BIN_DIR)/$(TARGET).axf > $(BIN_DIR)/$(TARGET).asm


# Manipulate Image
# -------------------------------------------------------------------
	
.PHONY: manipulate_images
manipulate_images:	application
	@echo ===========================================================
	@echo Image manipulating
	@echo ===========================================================
	$(Q)$(NM) $(BIN_DIR)/$(TARGET).axf | sort > $(BIN_DIR)/$(TARGET).nmap
	$(Q)$(OBJCOPY) -j .image2.start.table -j .ram_image2.text -j .ram_image2.rodata -j .ram.data -Obinary $(BIN_DIR)/$(TARGET).axf $(BIN_DIR)/ram_2.bin
	$(Q)$(OBJCOPY) -j .sdr_text -j .sdr_rodata -j .sdr_data -Obinary $(BIN_DIR)/$(TARGET).axf $(BIN_DIR)/sdram.bin
	$(Q)cp $(IMAGE1_DIR)/ram_1.p.bin $(BIN_DIR)/ram_1.p.bin
	$(Q)chmod 777 $(BIN_DIR)/ram_1.p.bin
ifeq ($(SECURE_BOOT),1)
	$(Q)chmod +rx $(PICK) $(CHKSUM) $(PAD) $(ED25519)
else
	$(Q)chmod +rx $(PICK) $(CHKSUM) $(PAD)
endif

	$(Q)$(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.p.bin body+reset_offset+sig
	$(Q)$(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.ns.bin body+reset_offset
	$(Q)$(PICK) 0x`grep __sdram_data_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __sdram_data_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/sdram.bin $(BIN_DIR)/ram_3.p.bin body+reset_offset

ifeq ($(SECURE_BOOT),1)
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(Q)$(TAIL) -c +17 $(BIN_DIR)/ram_2.p.bin > $(BIN_DIR)/ram_2_for_hash.p.bin
else
	$(Q)tail -c +17 $(BIN_DIR)/ram_2.p.bin > $(BIN_DIR)/ram_2_for_hash.p.bin
endif
	$(Q)python $(HASH_PY) $(BIN_DIR)/ram_2_for_hash.p.bin
	$(Q)cp output.bin hash_sum_2.bin
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(Q)$(TAIL) -c +17 $(BIN_DIR)/ram_3.p.bin > $(BIN_DIR)/ram_3_for_hash.p.bin
else
	$(Q)tail -c +17 $(BIN_DIR)/ram_3.p.bin > $(BIN_DIR)/ram_3_for_hash.p.bin
endif
	$(Q)python $(HASH_PY) $(BIN_DIR)/ram_3_for_hash.p.bin
	$(Q)cp output.bin hash_sum_3.bin
endif		

	$(Q)$(PAD) 44k 0xFF $(BIN_DIR)/ram_1.p.bin
	cat $(BIN_DIR)/ram_1.p.bin > $(BIN_DIR)/$(RAMALL_BIN)
	$(Q)chmod 777 $(BIN_DIR)/$(RAMALL_BIN)
ifeq ($(SECURE_BOOT),1)
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(Q)$(ED25519) sign hash_sum_2.bin keypair.json; \
	fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(Q)$(TAIL) -c 64 hash_sum_2.bin > signature_ram_2;\
	fi
else
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(Q)mv signature signature_ram_2; \
	fi
endif
	@if [ -f $(BIN_DIR)/ram_2.bin ]; then \
		$(Q)python $(REHEADER_PY) $(BIN_DIR)/ram_2.p.bin; \
		$(Q)python $(REHEADER_PY) $(BIN_DIR)/ram_2.ns.bin; \
		cat signature_ram_2 >> $(BIN_DIR)/ram_2.p.bin; \
		cat signature_ram_2 >> $(BIN_DIR)/ram_2.ns.bin; \
		$(Q)chmod 777 $(BIN_DIR)/ram_2.p.bin; \
	fi
endif
	cat $(BIN_DIR)/ram_2.p.bin >> $(BIN_DIR)/$(RAMALL_BIN)
ifeq ($(SECURE_BOOT),1)
	if [ -s $(BIN_DIR)/sdram.bin ]; then \
		$(Q)$(ED25519) sign hash_sum_3.bin keypair.json; \
	fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	@if [ -f $(BIN_DIR)/sdram.bin ]; then \
		$(Q)$(TAIL) -c 64 hash_sum_3.bin > signature_ram_3;\
	fi
else
	@if [ -f $(BIN_DIR)/sdram.bin ]; then \
		$(Q)mv signature signature_ram_3; \
	fi
endif
	@if [ -s $(BIN_DIR)/sdram.bin ]; then \
		$(Q)python $(REHEADER_PY) $(BIN_DIR)/ram_3.p.bin; \
		cat signature_ram_3 >> $(BIN_DIR)/ram_3.p.bin; \
		$(Q)chmod 777 $(BIN_DIR)/ram_3.p.bin; \
		cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(RAMALL_BIN);\
	fi
else
	@if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(RAMALL_BIN); fi
endif
# OTA
	cat $(BIN_DIR)/ram_2.ns.bin > $(BIN_DIR)/$(OTA_BIN)
	$(Q)chmod 777 $(BIN_DIR)/$(OTA_BIN)
	$(Q)if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(OTA_BIN); fi
	$(Q)$(CHKSUM) $(BIN_DIR)/$(OTA_BIN) || true
	$(Q)rm $(BIN_DIR)/ram_*.p.bin $(BIN_DIR)/ram_*.ns.bin

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
	$(Q)cp ../../../component/soc/realtek/8195a/misc/bsp/image/ram_1.r.bin $(OBJ_DIR)/ram_1.r.bin
	$(Q)chmod 777 $(OBJ_DIR)/ram_1.r.bin
	$(Q)$(OBJCOPY) --rename-section .data=.loader.data,contents,alloc,load,readonly,data -I binary -O elf32-littlearm -B arm $(OBJ_DIR)/ram_1.r.bin $(OBJ_DIR)/ram_1.r.o 

$(SRC_O): %.o : %.c
	@echo "compile_c $<"
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(OBJ_DIR)/$(notdir $(patsubst %.o,%.d,$@))
	$(Q)cp $@ $(OBJ_DIR)/$(notdir $@)
	$(Q)chmod 777 $(OBJ_DIR)/$(notdir $@)

$(DRAM_O): %.o : %.c
	@echo "compile_c $<"
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(OBJCOPY) --prefix-alloc-sections .sdram $@
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(OBJ_DIR)/$(notdir $(patsubst %.o,%.d,$@))
	$(Q)cp $@ $(OBJ_DIR)/$(notdir $@)
	$(Q)chmod 777 $(OBJ_DIR)/$(notdir $@)

-include $(DEPENDENCY_LIST)

# Generate build info
# -------------------------------------------------------------------	
#ifeq (setup,$(firstword $(MAKECMDGOALS)))
#  # use the rest as arguments for "run"
#  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#  # ...and turn them into do-nothing targets
#  $(eval $(RUN_ARGS):;@:)
#endif
.PHONY: setup
setup:
	@echo "----------------"
	@echo Setup $(GDB_SERVER)
	@echo "----------------"
ifeq ($(GDB_SERVER), openocd)
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_debug_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_ramdebug_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_flash_write_openocd.txt $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
else
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_debug_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_ramdebug_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt
	cp -p $(FLASH_TOOLDIR)/rtl_gdb_flash_write_jlink.txt $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
endif

.PHONY: flashburn
flashburn:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
endif

	# manipulate ram_all.bin to no image1 sig (0x88167923)
	#head -c 52 $(BIN_DIR)/ram_all.bin > $(BIN_DIR)/ram_all.ns.bin
	#echo -n -e '\xFF\xFF\xFF\xFF' >> $(BIN_DIR)/ram_all.ns.bin
	#tail -c +57 $(BIN_DIR)/ram_all.bin >> $(BIN_DIR)/ram_all.ns.bin
	#rm $(BIN_DIR)/ram_all.bin
	cp $(BIN_DIR)/ram_all.bin $(BIN_DIR)/ram_all.ns.bin
	cp	$(FLASH_TOOLDIR)/target_NORMALB.axf $(FLASH_TOOLDIR)/target_NORMAL.axf
	chmod 777 $(FLASH_TOOLDIR)/target_NORMAL.axf
	chmod +rx $(FLASH_TOOLDIR)/SetupGDB_NORMAL.sh
	$(FLASH_TOOLDIR)/SetupGDB_NORMAL.sh
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_flash_write.txt
	rm $(BIN_DIR)/ram_*.ns.bin
	
.PHONY: debug
debug:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_debug.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
	cmd /c start $(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
else
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_debug.txt
endif

.PHONY: ramdebug
ramdebug:
	@if [ ! -f $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt ] ; then echo Please do \"make setup GDB_SERVER=[jlink or openocd]\" first; echo && false ; fi
ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
	$(FLASH_TOOLDIR)/Check_Jtag.sh
	cmd /c start $(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt	
else
	$(GDB) -x $(FLASH_TOOLDIR)/rtl_gdb_ramdebug.txt	
endif

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -f $(SRC_O) $(DRAM_O)
	rm -f $(patsubst %.o,%.d,$(SRC_O)) $(patsubst %.o,%.d,$(DRAM_O))

