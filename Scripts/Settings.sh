#!/bin/bash

#===========================
# 基础配置修改
#===========================

# 移除 luci-app-attendedsysupgrade
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# 修改 immortalwrt.lan 关联 IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

# 添加编译日期标识
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ $WRT_MARK-$WRT_DATE')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")

#===========================
# WiFi 配置
#===========================
WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"

if [ -f "$WIFI_SH" ]; then
    sed -i "s/BASE_SSID='.*'/BASE_SSID='$WRT_SSID'/g" $WIFI_SH
    sed -i "s/BASE_WORD='.*'/BASE_WORD='$WRT_WORD'/g" $WIFI_SH
elif [ -f "$WIFI_UC" ]; then
    sed -i "s/ssid='.*'/ssid='$WRT_SSID'/g" $WIFI_UC
    sed -i "s/key='.*'/key='$WRT_WORD'/g" $WIFI_UC
    sed -i "s/country='.*'/country='CN'/g" $WIFI_UC
    sed -i "s/encryption='.*'/encryption='psk2+ccmp'/g" $WIFI_UC
fi

#===========================
# 默认 IP 与主机名
#===========================
CFG_FILE="./package/base-files/files/bin/config_generate"
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
sed -i "s/hostname='.*'/hostname='$WRT_NAME'/g" $CFG_FILE

#===========================
# LuCI 插件与主题
#===========================
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

if [ -n "$WRT_PACKAGE" ]; then
    echo -e "$WRT_PACKAGE" >> ./.config
fi

#===========================
# NSS 满血补丁
#===========================
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
    echo -e "\n>>> Applying ultimate NSS full-blood patch for qualcommax ..."

    cfg_set() {
        local key="$1"
        local val="$2"
        sed -i "/^${key}=/d" ./.config 2>/dev/null || true
        echo "${key}=${val}" >> ./.config
    }

    cfg_set "CONFIG_FEED_nss_packages" "y"
    cfg_set "CONFIG_PACKAGE_kmod-qca-nss-drv-stats"   "y"
    cfg_set "CONFIG_PACKAGE_kmod-qca-nss-drv-netlink" "y"
    cfg_set "CONFIG_PACKAGE_kmod-qca-nss-drv-profile" "y"
    cfg_set "CONFIG_PACKAGE_luci-app-sqm"     "y"
    cfg_set "CONFIG_PACKAGE_sqm-scripts-nss"  "y"
    cfg_set "CONFIG_NSS_FIRMWARE_VERSION_11_4" "n"

    if [[ "${WRT_CONFIG,,}" == *"ipq50"* ]]; then
        cfg_set "CONFIG_NSS_FIRMWARE_VERSION_12_2" "y"
    else
        cfg_set "CONFIG_NSS_FIRMWARE_VERSION_12_5" "y"
    fi

    echo ">>> NSS full-blood patch applied successfully!"
fi

#===========================
# IPQ60xx WiFi 驱动（必备满血）
#===========================
cfg_set "CONFIG_PACKAGE_kmod-cfg80211" "y"
cfg_set "CONFIG_PACKAGE_kmod-mac80211" "y"
cfg_set "CONFIG_PACKAGE_wireless-regdb" "y"
cfg_set "CONFIG_PACKAGE_hostapd-common" "y"
cfg_set "CONFIG_PACKAGE_wpad-basic-mbedtls" "y"
cfg_set "CONFIG_PACKAGE_ath11k-firmware-ipq60xx" "y"
cfg_set "CONFIG_PACKAGE_ath11k-boarddata-ipq60xx" "y"
cfg_set "CONFIG_PACKAGE_kmod-ath11k" "y"
cfg_set "CONFIG_PACKAGE_kmod-ath11k-pci" "y"
cfg_set "CONFIG_PACKAGE_MAC80211_MESH" "y"

#===========================
# 无 WiFi 的特殊处理（Q6 / nowifi dtsi 替换）
#===========================
if [[ "${WRT_CONFIG,,}" == *"wifi"* && "${WRT_CONFIG,,}" == *"no"* ]]; then
    find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
    echo "qualcommax set up nowifi successfully!"
fi

#===========================
# NSS 最终自检
#===========================
echo -e "\n=== Final NSS Critical Config Check ==="
grep -E 'CONFIG_FEED_nss_packages|kmod-qca-nss-drv-|NSS_FIRMWARE_VERSION|sqm-scripts-nss|CONFIG_PACKAGE_kmod-cfg80211|CONFIG_PACKAGE_ath11k' ./.config || true
echo "======================================\n"
