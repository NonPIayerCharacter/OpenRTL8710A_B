/**
 ******************************************************************************
 *This file contains general configurations for ameba platform
 ******************************************************************************
*/

#ifndef __PLATFORM_OPTS_H__
#define __PLATFORM_OPTS_H__

#include "platform_autoconf.h"
/*For MP mode setting*/
//#define SUPPORT_MP_MODE		1

#define TCP_MSL 1000
#define LWIP_TIMEVAL_PRIVATE 0
#define IN_ADDR_T_DEFINED 1
#define LWIP_NETIF_HOSTNAME 1
/**
 * For AT cmd Log service configurations
 */
#define SUPPORT_LOG_SERVICE	0
#if SUPPORT_LOG_SERVICE
#define LOG_SERVICE_BUFLEN     100 //can't larger than UART_LOG_CMD_BUFLEN(127)
#define CONFIG_LOG_HISTORY	0
#if CONFIG_LOG_HISTORY
#define LOG_HISTORY_LEN    5
#endif
#define SUPPORT_INTERACTIVE_MODE		0//on/off wifi_interactive_mode
#define CONFIG_LOG_SERVICE_LOCK 0
#endif

/**
 * For interactive mode configurations, depents on log service
 */
#if SUPPORT_INTERACTIVE_MODE
#define CONFIG_INTERACTIVE_MODE     1
#define CONFIG_INTERACTIVE_EXT   0
#else
#define CONFIG_INTERACTIVE_MODE     0
#define CONFIG_INTERACTIVE_EXT   0
#endif

/**
 * For FreeRTOS tickless configurations
 */
#define FREERTOS_PMU_TICKLESS_SUSPEND_SDRAM  1   // In sleep mode, 1: suspend SDRAM, 0: no act

/******************************************************************************/

/**
* For common flash usage  
*/
#define AP_SETTING_SECTOR		0x000FE000
#define UART_SETTING_SECTOR		0x000FC000
#define SPI_SETTING_SECTOR		0x000FC000
#define FAST_RECONNECT_DATA 	(0x80000 - 0x1000)
#define FLASH_SECTOR_SIZE       0x1000

#define CONFIG_ENABLE_RDP		0

/**
 * For Wlan configurations
 */
#define CONFIG_WLAN	1
#if CONFIG_WLAN
#define CONFIG_LWIP_LAYER	1
#define CONFIG_INIT_NET		1 //init lwip layer when start up
#define CONFIG_WIFI_IND_USE_THREAD	0	// wifi indicate worker thread

//on/off relative commands in log service
#define CONFIG_SSL_CLIENT		0
#define CONFIG_WEBSERVER		0
#define CONFIG_OTA_UPDATE		1
#define CONFIG_BSD_TCP		1//NOTE : Enable CONFIG_BSD_TCP will increase about 11KB code size
#define CONFIG_AIRKISS			0//on or off tencent airkiss
#define CONFIG_UART_SOCKET	0
#define CONFIG_JOYLINK			0//on or off for jdsmart or joylink
#define CONFIG_QQ_LINK		0//on or off for qqlink
#define CONFIG_UART_XMODEM	0//support uart xmodem upgrade or not
#define CONFIG_GOOGLE_NEST	0//on or off the at command control for google nest
#define CONFIG_TRANSPORT		0//on or off the at command for transport socket
#define CONFIG_ALINK			0//on or off for alibaba alink
#define CONFIG_HILINK			0//on or off for huawei hilink
#define CONFIG_GREE			0//on or off for gree
#define CONFIG_RIC			0//on or off for RICloud

/* For WPS and P2P */
#define CONFIG_ENABLE_WPS		0
#define CONFIG_ENABLE_P2P		0//on/off p2p cmd in log_service or interactive mode
#if CONFIG_ENABLE_WPS
#define CONFIG_ENABLE_WPS_DISCOVERY	1
#endif
#if CONFIG_ENABLE_P2P
#define CONFIG_ENABLE_WPS_AP		1
#undef CONFIG_WIFI_IND_USE_THREAD
#define CONFIG_WIFI_IND_USE_THREAD	1
#endif
#if (CONFIG_ENABLE_P2P && ((CONFIG_ENABLE_WPS_AP == 0) || (CONFIG_ENABLE_WPS == 0)))
#error "If CONFIG_ENABLE_P2P, need to define CONFIG_ENABLE_WPS_AP 1" 
#endif

/* For SSL/TLS */
#define CONFIG_USE_POLARSSL     0
#define CONFIG_USE_MBEDTLS      1
#if ((CONFIG_USE_POLARSSL == 0) && (CONFIG_USE_MBEDTLS == 0)) || ((CONFIG_USE_POLARSSL == 1) && (CONFIG_USE_MBEDTLS == 1))
#undef CONFIG_USE_POLARSSL
#define CONFIG_USE_POLARSSL 1
#undef CONFIG_USE_MBEDTLS
#define CONFIG_USE_MBEDTLS 0
#endif

/* for syncpkt  */
#define CONFIG_SYNCPKT

/* For Simple Link */
#define CONFIG_INCLUDE_SIMPLE_CONFIG		1

/* For DPP */
#define CONFIG_INCLUDE_DPP_CONFIG		0

/*For fast reconnection*/
#define CONFIG_EXAMPLE_WLAN_FAST_CONNECT	0
#if CONFIG_EXAMPLE_WLAN_FAST_CONNECT
#define CONFIG_FAST_DHCP 1
#else
#define CONFIG_FAST_DHCP 0
#endif

/*For wowlan service settings*/
#define CONFIG_WOWLAN_SERVICE           			0

#define CONFIG_GAGENT			0
/*Disable CONFIG_EXAMPLE_WLAN_FAST_CONNECT when CONFIG_GAGENT is enabled,because
	reconnect to previous AP is not suitable when re-configuration. 
*/
#if CONFIG_GAGENT
#define CONFIG_EXAMPLE_WLAN_FAST_CONNECT 0
#endif

#define CONFIG_JOINLINK    0

/*For promisc rx unsupported pkt info */
#define CONFIG_UNSUPPORT_PLCPHDR_RPT 1

#endif //end of #if CONFIG_WLAN
/*******************************************************************************/

/**
 * For Ethernet configurations
 */
#define CONFIG_ETHERNET 0
#if CONFIG_ETHERNET

#define CONFIG_LWIP_LAYER	1
#define CONFIG_INIT_NET         1 //init lwip layer when start up

//on/off relative commands in log service
#define CONFIG_SSL_CLIENT	0
#define CONFIG_BSD_TCP		0//NOTE : Enable CONFIG_BSD_TCP will increase about 11KB code size

#endif

/**
 * For user to adjust SLEEP_INTERVAL
 */
#define CONFIG_DYNAMIC_TICKLESS  1

#if CONFIG_DYNAMIC_TICKLESS
#define DYNAMIC_TICKLESS_SLEEP_INTERVAL 10000  //10*1000ms
#else
#define DYNAMIC_TICKLESS_SLEEP_INTERVAL 0
#endif
/*******************************************************************************/

/**
 * For iNIC configurations
 */
//#define CONFIG_INIC_EN 0//enable iNIC mode
#if CONFIG_INIC_EN
#ifndef CONFIG_LWIP_LAYER
#define CONFIG_LWIP_LAYER	0
#endif
#ifndef CONFIG_INIC_SDIO_HCI
#define CONFIG_INIC_SDIO_HCI	0 //for SDIO or USB iNIC
#endif
#ifndef CONFIG_INIC_CMD_RSP
#define CONFIG_INIC_CMD_RSP	0
#endif
#ifndef CONFIG_INIC_USB_HCI
#define CONFIG_INIC_USB_HCI	0
#endif
#endif
/******************End of iNIC configurations*******************/

#if CONFIG_ENABLE_WPS
#define WPS_CONNECT_RETRY_COUNT		4
#define WPS_CONNECT_RETRY_INTERVAL	5000 // in ms
#endif 

#define AUTO_RECONNECT_COUNT	8
#define AUTO_RECONNECT_INTERVAL	5 // in sec

#endif
