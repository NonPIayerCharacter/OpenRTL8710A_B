#ifndef MAIN_H
#define MAIN_H

#include <autoconf.h>

#ifndef CONFIG_WLAN
#define CONFIG_WLAN	1
#endif

/* Header file declaration*/
void wlan_network(void);

/* Interactive Mode */
#define SERIAL_DEBUG_RX 1
#define ATCMD_VER 1

#endif
