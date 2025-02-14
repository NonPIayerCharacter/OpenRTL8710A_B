#ifndef _UTIL_H
#define _UTIL_H

#include <wireless.h>
#include <wlan_intf.h>
#include <wifi_constants.h>
#include "wifi_structures.h"

#ifdef	__cplusplus
extern "C" {
#endif

int wext_get_ssid(const char *ifname, __u8 *ssid);
int wext_set_ssid(const char *ifname, const __u8 *ssid, __u16 ssid_len);
int wext_set_bssid(const char *ifname, const __u8 *bssid);
int wext_get_bssid(const char *ifname, __u8 *bssid);
int wext_set_auth_param(const char *ifname, __u16 idx, __u32 value);
int wext_set_mfp_support(const char *ifname, __u8 value);
#ifdef CONFIG_SAE_SUPPORT
int wext_set_group_id(const char *ifname, __u8 value);
int wext_set_support_wpa3(__u8 enable);
__u8 wext_get_support_wpa3(void);
#endif
#ifdef CONFIG_PMKSA_CACHING
int wext_set_pmk_cache_enable(const char *ifname, __u8 value);
#endif
int wext_set_key_ext(const char *ifname, __u16 alg, const __u8 *addr, int key_idx, int set_tx, const __u8 *seq, __u16 seq_len, __u8 *key, __u16 key_len);
int wext_get_enc_ext(const char *ifname, __u16 *alg, __u8 *key_idx, __u8 *passphrase);
int wext_get_auth_type(const char *ifname, __u32 *auth_type);
int wext_set_passphrase(const char *ifname, const __u8 *passphrase, __u16 passphrase_len);
int wext_get_passphrase(const char *ifname, __u8 *passphrase);
int wext_set_mode(const char *ifname, int mode);
int wext_get_mode(const char *ifname, int *mode);
int wext_set_ap_ssid(const char *ifname, const __u8 *ssid, __u16 ssid_len);
int wext_set_country(const char *ifname, rtw_country_code_t country_code);
int wext_get_rssi(const char *ifname, int *rssi);
int wext_get_snr(const char *ifname, int *snr);
int wext_set_channel(const char *ifname, __u8 ch);
int wext_get_channel(const char *ifname, __u8 *ch);
int wext_register_multicast_address(const char *ifname, rtw_mac_t *mac);
int wext_unregister_multicast_address(const char *ifname, rtw_mac_t *mac);
int wext_set_scan(const char *ifname, char *buf, __u16 buf_len, __u16 flags);
int wext_get_scan(const char *ifname, char *buf, __u16 buf_len);
int wext_set_mac_address(const char *ifname, char * mac);
int wext_get_mac_address(const char *ifname, char * mac);
int wext_enable_powersave(const char *ifname, __u8 lps_mode, __u8 ips_mode);
int wext_disable_powersave(const char *ifname);
int wext_set_tdma_param(const char *ifname, __u8 slot_period, __u8 rfon_period_len_1, __u8 rfon_period_len_2, __u8 rfon_period_len_3);
int wext_set_lps_dtim(const char *ifname, __u8 lps_dtim);
int wext_get_lps_dtim(const char *ifname, __u8 *lps_dtim);
int wext_get_tx_power(const char *ifname, __u8 *poweridx);
int wext_set_txpower(const char *ifname, int poweridx);
int wext_get_associated_client_list(const char *ifname, void * client_list_buffer, __u16 buffer_length);
int wext_get_ap_info(const char *ifname, rtw_bss_info_t * ap_info, rtw_security_t* security);
int wext_mp_command(const char *ifname, char *cmd, int show_msg);
int wext_private_command(const char *ifname, char *cmd, int show_msg);
int wext_private_command_with_retval(const char *ifname, char *cmd, char *ret_buf, int ret_len);
void wext_wlan_indicate(unsigned int cmd, union iwreq_data *wrqu, char *extra);
int wext_set_pscan_channel(const char *ifname, __u8 *ch, __u8 *pscan_config, __u8 length);
int wext_set_autoreconnect(const char *ifname, __u8 mode, __u8 retry_times, __u16 timeout);
int wext_get_autoreconnect(const char *ifname, __u8 *mode);
int wext_set_adaptivity(rtw_adaptivity_mode_t adaptivity_mode);
int wext_set_adaptivity_th_l2h_ini(__u8 l2h_threshold);
int wext_set_trp_tis(__u8 enable);
#if defined(CONFIG_WLAN_LOW_PW)
void wext_set_low_power_mode(__u8 enable);
#endif
int wext_get_auto_chl(const char *ifname, unsigned char *channel_set, unsigned char channel_num);
int wext_set_sta_num(unsigned char ap_sta_num);
int wext_del_station(const char *ifname, unsigned char* hwaddr);
int wext_init_mac_filter(void);
int wext_deinit_mac_filter(void);
int wext_add_mac_filter(unsigned char* hwaddr);
int wext_del_mac_filter(unsigned char* hwaddr);
void wext_set_indicate_mgnt(int enable);
#ifdef CONFIG_CUSTOM_IE
int wext_add_custom_ie(const char *ifname, void * cus_ie, int ie_num);
int wext_update_custom_ie(const char *ifname, void * cus_ie, int ie_index);
int wext_del_custom_ie(const char *ifname);
#endif

#define wext_handshake_done rltk_wlan_handshake_done

int wext_send_mgnt(const char *ifname, char *buf, __u16 buf_len, __u16 flags);
int wext_send_eapol(const char *ifname, char *buf, __u16 buf_len, __u16 flags);
int wext_set_gen_ie(const char *ifname, char *buf, __u16 buf_len, __u16 flags);
void wext_suspend_softap(const char *ifname);
int wext_ap_switch_chl_and_inform(unsigned char new_channel);
int wext_get_nhm_ratio_level(const char *ifname, __u32 *level);
int wext_get_retry_drop_num(const char *ifname, rtw_fw_retry_drop_t * retry);
int wext_get_sw_trx_statistics(const char *ifname, rtw_net_device_stats_t *stats);
void wext_set_indicate_mgnt(int enable);
void wext_set_lowrssi_use_b(int enable,int rssi);
#ifndef CONFIG_MCC_STA_AP_MODE
int wext_get_RxInfo(const char *ifname, __u8* BeaconCnt, int *rssi, __u8* CurIGValue, __u32* Fa_Ofdm_count, __u32* Fa_Cck_count);
int wext_get_RxCrcInfo(const char *ifname, __u32* CCK_Crc_Fail, __u32* CCK_Crc_OK, __u32* OFDM_Crc_Fail, __u32* OFDM_Crc_OK, __u32* HT_Crc_Fail, __u32* HT_Crc_OK);
int wext_get_TxInfo(const char *ifname, __u32 *tx_ok, __u32 *tx_retry, __u32 *tx_drop);
int wext_get_PSInfo(const char *ifname, __u32* tim_wake_up_count);
#endif
#ifdef CONFIG_SYNCPKT
int wext_set_syncpkt_da(const char *ifname, __u8 *da);
int wext_send_syncpkt(const char *ifname, __u8 flag, __u8 pktnum, __u8 interval);
int wext_disable_fw_ips(const char *ifname, __u8 enable);
#endif
int wext_set_adaptivity_enable(const char *ifname, __u8 value);
__u8 wext_get_adaptivity_enable(const char *ifname);
int wext_set_adaptivity_mode(const char *ifname, __u8 mode);
__u8 wext_get_adaptivity_mode(const char *ifname);
__u8 wext_get_channel_plan(const char *ifname);
#ifdef	__cplusplus
}
#endif

#endif /* _UTIL_H */
