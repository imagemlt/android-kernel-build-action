#!/bin/bash
# Generate a compatible Makefile for 88x2eu Realtek WiFi driver for Android GKI
# Usage: generate-88x2eu-makefile.sh <output_dir>

OUTPUT_DIR="$1"

if [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <output_dir>"
    exit 1
fi

# Backup original Makefile if it exists
if [ -f "$OUTPUT_DIR/Makefile" ]; then
    mv "$OUTPUT_DIR/Makefile" "$OUTPUT_DIR/Makefile.orig"
fi

cat > "$OUTPUT_DIR/Makefile" << 'MAKEFILE_END'
# Makefile for 88x2eu Realtek WiFi driver - Android GKI compatible version
# Monitor mode enabled

CONFIG_RTL8822EU = m
CONFIG_RTL8822E = y
CONFIG_USB_HCI = y
CONFIG_BT_COEXIST = n
CONFIG_AP_MODE = y
CONFIG_P2P = y
CONFIG_80211W = y
CONFIG_EFUSE_CONFIG_FILE = y
CONFIG_LOAD_PHY_PARA_FROM_FILE = y
CONFIG_RTW_NAPI = y
CONFIG_RTW_GRO = y
CONFIG_RTW_NETIF_SG = y
CONFIG_LAYER2_ROAMING = y
CONFIG_RTW_ACS = y
CONFIG_BR_EXT = y
CONFIG_WIFI_MONITOR = y
CONFIG_POWER_SAVING = y
CONFIG_RTW_REGDB = rtk
CONFIG_TXPWR_BY_RATE = y
CONFIG_TXPWR_LIMIT = y
CONFIG_PROC_DEBUG = y
CONFIG_MP_INCLUDED = n
CONFIG_WOWLAN = n
CONFIG_TDLS = n
CONFIG_WAPI_SUPPORT = n
CONFIG_RTW_ANDROID = 0

EXTRA_CFLAGS := -O1
EXTRA_CFLAGS += -DCONFIG_RTL8822E
EXTRA_CFLAGS += -DCONFIG_LITTLE_ENDIAN
EXTRA_CFLAGS += -DCONFIG_IOCTL_CFG80211 -DRTW_USE_CFG80211_STA_EVENT
EXTRA_CFLAGS += -DCONFIG_AP_MODE
EXTRA_CFLAGS += -DCONFIG_P2P
EXTRA_CFLAGS += -DCONFIG_80211W
EXTRA_CFLAGS += -DCONFIG_EFUSE_CONFIG_FILE -DEFUSE_MAP_PATH=\"/system/etc/wifi/wifi_efuse_88x2eu.map\" -DWIFIMAC_PATH=\"/data/wifimac.txt\"
EXTRA_CFLAGS += -DCONFIG_LOAD_PHY_PARA_FROM_FILE -DREALTEK_CONFIG_PATH=\"/lib/firmware/\"
EXTRA_CFLAGS += -DCONFIG_RTW_NAPI -DCONFIG_RTW_GRO -DCONFIG_RTW_NETIF_SG
EXTRA_CFLAGS += -DCONFIG_LAYER2_ROAMING -DCONFIG_ROAMING_FLAG=0x3
EXTRA_CFLAGS += -DCONFIG_RTW_ACS -DCONFIG_RTW_ACS_DBG
EXTRA_CFLAGS += -DCONFIG_BR_EXT -DCONFIG_BR_EXT_BRNAME=\"br0\"
EXTRA_CFLAGS += -DCONFIG_WIFI_MONITOR
EXTRA_CFLAGS += -DCONFIG_PROC_DEBUG
EXTRA_CFLAGS += -DCONFIG_POWER_SAVING -DRTW_IPS_MODE=0 -DRTW_LPS_MODE=0
EXTRA_CFLAGS += -DCONFIG_REGD_SRC_FROM_OS -DCONFIG_RTW_TX_NPATH_EN
EXTRA_CFLAGS += -DDM_ODM_SUPPORT_TYPE=0x04
EXTRA_CFLAGS += -DCONFIG_RTW_SDIO_PM_KEEP_POWER
EXTRA_CFLAGS += -I$(src)/include -I$(src)/platform -I$(src)/hal/btc
EXTRA_CFLAGS += -Wno-unused-variable -Wno-unused-value -Wno-unused-label
EXTRA_CFLAGS += -Wno-unused-parameter -Wno-unused-function -Wno-unused
EXTRA_CFLAGS += -Wno-uninitialized
EXTRA_CFLAGS += -Wno-missing-prototypes -Wno-header-guard -Wno-missing-declarations

ifeq ($(CC), clang)
EXTRA_CFLAGS += -Wno-enum-conversion -Wno-fortify-source
endif

HCI_NAME := usb
RTL871X := rtl8822e
ccflags-y += $(EXTRA_CFLAGS)

# OS interface files
_OS_INTFS_FILES := os_dep/osdep_service.o \
	os_dep/linux/os_intfs.o \
	os_dep/linux/$(HCI_NAME)_intf.o \
	os_dep/linux/$(HCI_NAME)_ops_linux.o \
	os_dep/linux/ioctl_linux.o \
	os_dep/linux/xmit_linux.o \
	os_dep/linux/mlme_linux.o \
	os_dep/linux/recv_linux.o \
	os_dep/linux/ioctl_cfg80211.o \
	os_dep/linux/rtw_cfgvendor.o \
	os_dep/linux/wifi_regd.o \
	os_dep/linux/rtw_android.o \
	os_dep/linux/rtw_proc.o \
	os_dep/linux/nlrtw.o \
	os_dep/linux/rtw_rhashtable.o \
	os_dep/linux/rtw_radiotap.o \
	os_dep/linux/ioctl_mp.o

# HAL interface files
_HAL_INTFS_FILES := hal/hal_intf.o \
	hal/hal_com.o \
	hal/hal_com_phycfg.o \
	hal/hal_phy.o \
	hal/hal_dm.o \
	hal/hal_dm_acs.o \
	hal/hal_pwr_table.o \
	hal/hal_dfs.o \
	hal/hal_btcoex_wifionly.o \
	hal/hal_btcoex.o \
	hal/hal_mp.o \
	hal/hal_mcc.o \
	hal/hal_hci/hal_$(HCI_NAME).o \
	hal/led/hal_led.o \
	hal/led/hal_$(HCI_NAME)_led.o \
	hal/hal_halmac.o \
	hal/HalPwrSeqCmd.o

# RTL8822E specific files
_HAL_INTFS_FILES += hal/$(RTL871X)/Hal8812PwrSeq.o \
	hal/$(RTL871X)/Hal8821APwrSeq.o \
	hal/$(RTL871X)/$(RTL871X)_xmit.o \
	hal/$(RTL871X)/$(RTL871X)_sreset.o \
	hal/$(RTL871X)/$(RTL871X)_hal_init.o \
	hal/$(RTL871X)/$(RTL871X)_phycfg.o \
	hal/$(RTL871X)/$(RTL871X)_rf6052.o \
	hal/$(RTL871X)/$(RTL871X)_dm.o \
	hal/$(RTL871X)/$(RTL871X)_rxdesc.o \
	hal/$(RTL871X)/$(RTL871X)_cmd.o \
	hal/$(RTL871X)/hal8822e_fw.o \
	hal/$(RTL871X)/hal8822e_fw_10M.o \
	hal/$(RTL871X)/rtl8822e_halinit.o \
	hal/$(RTL871X)/rtl8822e_ops.o \
	hal/$(RTL871X)/rtl8822e_cmd.o \
	hal/$(RTL871X)/rtl8822e_phy.o \
	hal/$(RTL871X)/rtl8822e_mac.o \
	hal/$(RTL871X)/rtl8822e_bf_monitor.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_halinit.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_halmac.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_io.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_led.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_ops.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_recv.o \
	hal/$(RTL871X)/$(HCI_NAME)/rtl8822eu_xmit.o \
	hal/efuse/$(RTL871X)/HalEfuseMask8822E_USB.o

# HALMAC files
_HALMAC_FILES := hal/halmac/halmac_api.o \
	hal/halmac/halmac_dbg.o \
	hal/halmac/halmac_88xx/halmac_bb_rf_88xx.o \
	hal/halmac/halmac_88xx/halmac_cfg_wmac_88xx.o \
	hal/halmac/halmac_88xx/halmac_common_88xx.o \
	hal/halmac/halmac_88xx/halmac_efuse_88xx.o \
	hal/halmac/halmac_88xx/halmac_flash_88xx.o \
	hal/halmac/halmac_88xx/halmac_fw_88xx.o \
	hal/halmac/halmac_88xx/halmac_gpio_88xx.o \
	hal/halmac/halmac_88xx/halmac_init_88xx.o \
	hal/halmac/halmac_88xx/halmac_mimo_88xx.o \
	hal/halmac/halmac_88xx/halmac_usb_88xx.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_cfg_wmac_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_common_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_efuse_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_gpio_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_init_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_phy_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_pwr_seq_8822e.o \
	hal/halmac/halmac_88xx/halmac_8822e/halmac_usb_8822e.o

# BTC files
_BTC_FILES := hal/btc/halbtccommon.o \
	hal/btc/halbtc8822e.o \
	hal/btc/halbtc8822ewifionly.o

# PHYDM files
_PHYDM_FILES := hal/phydm/phydm.o \
	hal/phydm/phydm_adaptivity.o \
	hal/phydm/phydm_adc_sampling.o \
	hal/phydm/phydm_antdect.o \
	hal/phydm/phydm_antdiv.o \
	hal/phydm/phydm_api.o \
	hal/phydm/phydm_auto_dbg.o \
	hal/phydm/phydm_beamforming.o \
	hal/phydm/phydm_cck_pd.o \
	hal/phydm/phydm_cck_rx_pathdiv.o \
	hal/phydm/phydm_ccx.o \
	hal/phydm/phydm_cfotracking.o \
	hal/phydm/phydm_debug.o \
	hal/phydm/phydm_dfs.o \
	hal/phydm/phydm_dig.o \
	hal/phydm/phydm_direct_bf.o \
	hal/phydm/phydm_dynamictxpower.o \
	hal/phydm/phydm_hwconfig.o \
	hal/phydm/phydm_interface.o \
	hal/phydm/phydm_lna_sat.o \
	hal/phydm/phydm_math_lib.o \
	hal/phydm/phydm_mp.o \
	hal/phydm/phydm_noisemonitor.o \
	hal/phydm/phydm_pathdiv.o \
	hal/phydm/phydm_phystatus.o \
	hal/phydm/phydm_pmac_tx_setting.o \
	hal/phydm/phydm_pow_train.o \
	hal/phydm/phydm_primary_cca.o \
	hal/phydm/phydm_psd.o \
	hal/phydm/phydm_rainfo.o \
	hal/phydm/phydm_rssi_monitor.o \
	hal/phydm/phydm_smt_ant.o \
	hal/phydm/phydm_soml.o \
	hal/phydm/rtl8822e/halhwimg8822e_bb.o \
	hal/phydm/rtl8822e/phydm_hal_api8822e.o \
	hal/phydm/rtl8822e/phydm_regconfig8822e.o \
	hal/phydm/rtl8822e/phydm_rtl8822e.o \
	hal/phydm/halrf/halrf.o \
	hal/phydm/halrf/halrf_debug.o \
	hal/phydm/halrf/halrf_kfree.o \
	hal/phydm/halrf/halrf_powertracking.o \
	hal/phydm/halrf/halrf_powertracking_ce.o \
	hal/phydm/halrf/halrf_psd.o \
	hal/phydm/halrf/halrf_txgapcal.o \
	hal/phydm/halrf/halphyrf_ce.o \
	hal/phydm/halrf/rtl8822e/halhwimg8822e_rf.o \
	hal/phydm/halrf/rtl8822e/halrf_8822e.o \
	hal/phydm/halrf/rtl8822e/halrf_dpk_8822e.o \
	hal/phydm/halrf/rtl8822e/halrf_iqk_8822e.o \
	hal/phydm/halrf/rtl8822e/halrf_rfk_init_8822e.o \
	hal/phydm/halrf/rtl8822e/halrf_tssi_8822e.o \
	hal/phydm/halrf/rtl8822e/halrf_txgapk_8822e.o \
	hal/phydm/txbf/halcomtxbf.o \
	hal/phydm/txbf/haltxbf8822b.o \
	hal/phydm/txbf/haltxbfinterface.o \
	hal/phydm/txbf/phydm_hal_txbf_api.o

# Core files
rtk_core := core/rtw_cmd.o \
	core/rtw_security.o \
	core/rtw_debug.o \
	core/rtw_io.o \
	core/rtw_ioctl_query.o \
	core/rtw_ioctl_set.o \
	core/rtw_ieee80211.o \
	core/rtw_mlme.o \
	core/rtw_mlme_ext.o \
	core/rtw_mi.o \
	core/rtw_wlan_util.o \
	core/rtw_vht.o \
	core/rtw_pwrctrl.o \
	core/rtw_rf.o \
	core/rtw_chplan.o \
	core/rtw_regdb_rtk.o \
	core/rtw_chset.o \
	core/rtw_dfs.o \
	core/rtw_txpwr.o \
	core/monitor/rtw_radiotap.o \
	core/rtw_recv.o \
	core/rtw_sta_mgt.o \
	core/rtw_ap.o \
	core/wds/rtw_wds.o \
	core/mesh/rtw_mesh.o \
	core/mesh/rtw_mesh_pathtbl.o \
	core/mesh/rtw_mesh_hwmp.o \
	core/rtw_xmit.o \
	core/rtw_p2p.o \
	core/rtw_rson.o \
	core/rtw_tdls.o \
	core/rtw_br_ext.o \
	core/rtw_iol.o \
	core/rtw_sreset.o \
	core/rtw_btcoex_wifionly.o \
	core/rtw_btcoex.o \
	core/rtw_beamforming.o \
	core/rtw_odm.o \
	core/rtw_rm.o \
	core/rtw_rm_fsm.o \
	core/rtw_ft.o \
	core/rtw_wnm.o \
	core/rtw_mbo.o \
	core/rtw_rm_util.o \
	core/efuse/rtw_efuse.o \
	core/rtw_roch.o \
	core/rtw_sdio.o

# Crypto files
rtk_core += core/crypto/aes-internal.o \
	core/crypto/aes-internal-enc.o \
	core/crypto/aes-gcm.o \
	core/crypto/aes-ccm.o \
	core/crypto/aes-omac1.o \
	core/crypto/ccmp.o \
	core/crypto/gcmp.o \
	core/crypto/aes-siv.o \
	core/crypto/aes-ctr.o \
	core/crypto/sha256-internal.o \
	core/crypto/sha256.o \
	core/crypto/sha256-prf.o \
	core/crypto/rtw_crypto_wrap.o \
	core/rtw_swcrypto.o

# Platform files
_PLATFORM_FILES := platform/platform_ops.o

# Final module object list
88x2eu-objs := $(rtk_core) $(_OS_INTFS_FILES) $(_HAL_INTFS_FILES) $(_HALMAC_FILES) $(_BTC_FILES) $(_PHYDM_FILES) $(_PLATFORM_FILES)

# Force in-tree module build even when no Kconfig symbol is enabled.
obj-m += 88x2eu.o
MAKEFILE_END

echo "[+] Generated 88x2eu Makefile in $OUTPUT_DIR"
