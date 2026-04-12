#!/bin/bash
# =====================================================================
# 描述：自动识别并配置 USB 随身WiFi
# 作用：在固件中注入热插拔脚本，实现插电即上网
# =====================================================================

echo " "
echo "正在注入 USB 随身WiFi 自动拨号脚本..."

# 1. 创建固件内的目标目录
# 在 OpenWrt 编译体系中，放置在 package/base-files/files 的文件会最终打包到系统的根目录
DEST_DIR="./package/base-files/files/etc/hotplug.d/net"
mkdir -p "$DEST_DIR"

# 2. 写入热插拔逻辑脚本
# 注意：这里使用 cat <<'EOF' (带引号) 是为了防止脚本中的 $ 变量被当前 shell 解析
cat <<'EOF' > "$DEST_DIR/40-usb-tethering"
#!/bin/sh

# 仅在网络接口添加时触发
[ "$ACTION" = "add" ] || exit 0
[ "$INTERFACE" = "lo" ] && exit 0

# 【精准识别】通过 sysfs 判断该接口是否挂载在 USB 总线上
# 解决 ASR 芯片识别为 eth0 但实际是 USB 设备的问题，同时不伤及路由器原生网口
if readlink /sys/class/net/$INTERFACE/device/subsystem | grep -q "usb"; then
    logger -t [USB_AUTO] "检测到 USB 网络设备插入: $INTERFACE"

    # 设置逻辑接口名（LuCI 中显示的名称）
    INTF_NAME="usb_wan"

    # 配置网络接口为 DHCP 协议
    uci set network.$INTF_NAME=interface
    uci set network.$INTF_NAME.proto='dhcp'
    uci set network.$INTF_NAME.device="$INTERFACE"
    uci set network.$INTF_NAME.metric='10'
    
    # 动态查找防火墙中的 wan 区域名（通常是 'wan'）
    wan_zone=$(uci show firewall | grep ".name='wan'" | cut -d. -f2)
    if [ -n "$wan_zone" ]; then
        # 如果不在列表中则添加，防止重复
        if ! uci get firewall.$wan_zone.network | grep -q "$INTF_NAME"; then
            uci add_list firewall.$wan_zone.network="$INTF_NAME"
        fi
    else
        # 兜底：如果没找到名为 wan 的区域，则尝试分配到默认的第二个区域（通常是 wan）
        uci add_list firewall.@zone[1].network="$INTF_NAME"
    fi

    # 提交配置
    uci commit network
    uci commit firewall
    
    # 异步重启网络服务，让配置生效
    (sleep 5; /etc/init.d/network restart) &
    logger -t [USB_AUTO] "接口 $INTERFACE 已成功绑定至 $INTF_NAME 并分配到防火墙 WAN 区"
fi
EOF

# 3. 赋予执行权限
chmod +x "$DEST_DIR/40-usb-tethering"

echo "USB 随身WiFi 自动化脚本注入完成！"
echo " "
