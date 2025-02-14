#ifndef __WLAN_INTF_H__
#define __WLAN_INTF_H__

#ifdef	__cplusplus
extern "C" {
#endif
#include <autoconf.h>

#include <wireless.h>
#include "wifi_constants.h"

#ifndef WLAN0_IDX
	#define WLAN0_IDX	0
#endif
#ifndef WLAN1_IDX
	#define WLAN1_IDX	1
#endif
#ifndef WLAN_UNDEF
	#define WLAN_UNDEF	-1
#endif

/***********************************************************/
/* 
struct sk_buff {
	// These two members must be first.
	struct sk_buff		*next;		// Next buffer in list
	struct sk_buff		*prev;		// Previous buffer in list
	
	struct sk_buff_head	*list;			// List we are on	
	unsigned char		*head;		// Head of buffer
	unsigned char		*data;		// Data head pointer
	unsigned char		*tail;		// Tail pointer
	unsigned char		*end;		//End pointer
	struct net_device 	*dev;		//Device we arrived on/are leaving by 	
	unsigned int 		len;			// Length of actual data 
};
*/
/************************************************************/

//----- ------------------------------------------------------------------
// Wlan Interface opened for upper layer
//----- ------------------------------------------------------------------
int rltk_wlan_init(int idx_wlan, rtw_mode_t mode);				//return 0: success. -1:fail
//void rltk_wlan_deinit(void);
void rltk_wlan_deinit_fastly(void);
void rltk_wlan_deinit_hardware(void);
int rltk_wlan_start(int idx_wlan);
void rltk_wlan_statistic(unsigned char idx);
unsigned char rltk_wlan_running(unsigned char idx);		// interface is up. 0: interface is down
int rltk_wlan_control(unsigned long cmd, void *data);
int rltk_wlan_handshake_done(void);
int rltk_wlan_get_link_status(void); /*return: -1 handshake fail; -2 assoc fail; -3 auth fail; -4 scan fail*/
int rltk_wlan_rf_on(void);
int rltk_wlan_rf_off(void);
int rltk_wlan_check_bus(void);
int rltk_wlan_wireless_mode(unsigned char mode);
int rltk_wlan_get_wireless_mode(unsigned char *pmode);
int rltk_wlan_set_wpa_mode(const char *ifname, unsigned int wpa_mode);
int rltk_wlan_set_wps_phase(unsigned char is_trigger_wps);
int rtw_ps_enable(int enable);
int rltk_wlan_is_connected_to_ap(void);

#ifdef CONFIG_IEEE80211W
void rltk_wlan_tx_sa_query(unsigned char key_type);
void rltk_wlan_tx_deauth(unsigned char b_broadcast, unsigned char key_type);
void rltk_wlan_tx_auth(void);
#endif

/******************************************************
 *				Enum wlan low power mode
 ******************************************************/
#if defined(CONFIG_WLAN_LOW_PW)
#define BIT(x) (1<<(x))
typedef enum {
	PW_MODE_NONE = 0,
	PW_MODE_1	 = BIT(0),  // CPU 31.25
	PW_MODE_2	 = BIT(1),  // LNA 
	PW_MODE_3	 = BIT(2),  // RX I
	PW_MODE_4	 = BIT(3),  // LPS
	PW_MODE_5	 = BIT(4),  // CPU 62.5
	PW_MODE_6	 = BIT(5)   // sys register 0x20[27:24] = 3(core power)
} WLAN_LOW_PW_MODE;
#endif

#ifdef	__cplusplus
}
#endif



#endif //#ifndef __WLAN_INTF_H__
