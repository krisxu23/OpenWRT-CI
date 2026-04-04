#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"

#预置HomeProxy数据
if [ -d *"homeproxy"* ]; then
	echo " "

	HP_RULE="surge"
	HP_PATH="homeproxy/root/etc/homeproxy"

	rm -rf ./$HP_PATH/resources/*

	git clone -q --depth=1 --single-branch --branch "release" "https://github.com/Loyalsoldier/surge-rules.git" ./$HP_RULE/
	cd ./$HP_RULE/ && RES_VER=$(git log -1 --pretty=format:'%s' | grep -o "[0-9]*")

	echo "$RES_VER" | tee china_ip4.ver china_ip6.ver china_list.ver gfw_list.ver
	awk -F, '/^IP-CIDR,/{print $2 > "china_ip4.txt"} /^IP-CIDR6,/{print $2 > "china_ip6.txt"}' cncidr.txt
	sed 's/^\.//g' direct.txt > china_list.txt ; sed 's/^\.//g' gfw.txt > gfw_list.txt
	mv -f ./{china_*,gfw_list}.{ver,txt} ../$HP_PATH/resources/

	cd .. && rm -rf ./$HP_RULE/

	cd $PKG_PATH && echo "homeproxy date has been updated!"
fi

#修改argon主题字体和颜色
if [ -d *"luci-theme-argon"* ]; then
	echo " "

	cd ./luci-theme-argon/

	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon

	cd $PKG_PATH && echo "theme-argon has been fixed!"
fi

#修改aurora菜单式样
if [ -d *"luci-app-aurora-config"* ]; then
	echo " "

	cd ./luci-app-aurora-config/

	sed -i "s/nav_submenu_type '.*'/nav_submenu_type 'boxed-dropdown'/g" $(find ./root/ -type f -name "*aurora")

	cd $PKG_PATH && echo "theme-aurora has been fixed!"
fi

#修改qca-nss-drv启动顺序
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	echo " "

	sed -i 's/START=.*/START=85/g' $NSS_DRV

	cd $PKG_PATH && echo "qca-nss-drv has been fixed!"
fi

#修改qca-nss-pbuf启动顺序
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	echo " "

	sed -i 's/START=.*/START=86/g' $NSS_PBUF

	cd $PKG_PATH && echo "qca-nss-pbuf has been fixed!"
fi

#修复TailScale配置文件冲突
TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
	echo " "

	sed -i '/\/files/d' $TS_FILE

	cd $PKG_PATH && echo "tailscale has been fixed!"
fi

#修复Rust编译失败
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "

	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE

	cd $PKG_PATH && echo "rust has been fixed!"
fi

#修复DiskMan编译失败
DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
if [ -f "$DM_FILE" ]; then
	echo " "

	sed -i '/ntfs-3g-utils /d' $DM_FILE

	cd $PKG_PATH && echo "diskman has been fixed!"
fi

#修复luci-app-netspeedtest相关问题
if [ -d *"luci-app-netspeedtest"* ]; then
	echo " "

	cd ./luci-app-netspeedtest/

	sed -i '$a\exit 0' ./netspeedtest/files/99_netspeedtest.defaults
	sed -i 's/ca-certificates/ca-bundle/g' ./speedtest-cli/Makefile

	cd $PKG_PATH && echo "netspeedtest has been fixed!"
fi

# ==================== 启用BBR拥塞控制 ====================
echo " "
echo "启用BBR拥塞控制依赖..."
echo "CONFIG_PACKAGE_kmod-tcp-bbr=y" >> ./.config
echo "✓ BBR内核模块已添加"

# ==================== 添加自定义启动脚本 ====================
echo " "
echo "添加自定义启动脚本..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/rc.local << 'EOF'
# 设置 CPU 性能模式 (使用通配符适配多核多簇设备)
for governor in /sys/devices/system/cpu/cpufreq/policy*/scaling_governor; do
    [ -f "$governor" ] && echo performance > "$governor" 2>/dev/null
done

exit 0
EOF
chmod +x package/base-files/files/etc/rc.local
echo "✓ 启动脚本添加完成"

# ==================== 修改banner信息 ====================
echo " "
echo "修改banner信息..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/banner << 'EOF'
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__|  OpenWrt AutoBuild by Kris Xu
 -----------------------------------------------------
  固件版本: OpenWrt AutoBuild
  编译时间: $(date '+%Y-%m-%d %H:%M:%S')
  源码仓库: LiBwrt/openwrt-6.x
 -----------------------------------------------------
EOF
echo "✓ Banner修改完成"

# ==================== 添加motd信息 ====================
echo " "
echo "添加motd信息..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/motd << 'EOF'

欢迎使用 OpenWrt AutoBuild 固件!

系统信息:
  - 固件版本: OpenWrt AutoBuild
  - 默认IP: 192.168.100.1
  - 默认密码: password
  - 默认WiFi: OpenWrt-2.4G / OpenWrt-5G
  - WiFi密码: 12345678

常用命令:
  - 查看系统信息: cat /etc/os-release
  - 查看网络状态: ifconfig
  - 查看无线状态: iwinfo
  - 重启系统: reboot
  - 重置配置: firstboot

技术支持:
  - 源码: https://github.com/LiBwrt/openwrt-6.x
  - 插件: https://github.com/kenzok8/openwrt-packages
  - 依赖: https://github.com/wwz09/QCA-Package

EOF
echo "✓ motd添加完成"

# ==================== 优化 opkg 软件源为清华源 ====================
echo " "
echo "配置opkg软件源..."
# 使用 uci-defaults 首次启动脚本来替换源，这样绝对兼容任何分支
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-custom-repo << 'EOF'
#!/bin/sh
# 路由器首次开机时自动替换软件源为清华源
sed -i 's/downloads.immortalwrt.org/mirrors.tuna.tsinghua.edu.cn\/immortalwrt/g' /etc/opkg/distfeeds.conf 2>/dev/null
sed -i 's/downloads.openwrt.org/mirrors.tuna.tsinghua.edu.cn\/openwrt/g' /etc/opkg/distfeeds.conf 2>/dev/null
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-custom-repo
echo "✓ OPKG 软件源配置完成"

# ==================== 优化系统参数 ====================
echo " "
echo "优化系统参数..."
mkdir -p package/base-files/files/etc/sysctl.d
cat > package/base-files/files/etc/sysctl.d/99-custom.conf << 'EOF'
# 网络优化 (IPv4)
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# 网络优化 (IPv6)
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.default.accept_ra = 2
net.ipv6.conf.all.autoconf = 1
net.ipv6.conf.default.autoconf = 1
net.ipv6.conf.all.max_addresses = 16
net.ipv6.conf.default.max_addresses = 16

# 文件描述符限制
fs.file-max = 65535

# 内存优化
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF
echo "✓ 系统参数优化完成，已添加IPv6支持"

# ==================== 处理依赖缺失问题 ====================
echo " "
echo "处理依赖缺失问题..."
# 此处保留占位，如果有具体依赖包可写在这里
echo "✓ 依赖处理完成"

echo " "
echo "============================================"
echo "DIY Part 2 脚本执行完成"
echo "============================================"
