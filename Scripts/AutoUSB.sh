#!/bin/bash
# =====================================================================
# 脚本：AutoUSB.sh 
# 适用：全自动处理 USB 随身WiFi 插拔
# 特点：快速插拔保护、物理设备校验、静默清理
# =====================================================================

echo " "
echo ">>> 正在注入 USB 自动化脚本..."

DEST_DIR="./package/base-files/files/etc/hotplug.d/net"
mkdir -p "$DEST_DIR"

cat <<'EOF' > "$DEST_DIR/40-usb-tethering"
#!/bin/sh

# 定义逻辑接口名
LOGIC_NAME="usb"

case "$ACTION" in
    add)
        # 识别是否为 USB 设备 (不论是 eth0, usb0 还是 wwan0)
        if readlink /sys/class/net/$INTERFACE/device/subsystem | grep -q "usb"; then
            logger -t [USB_AUTO] "检测到 USB 设备插入: $INTERFACE"

            # 1. 创建/更新配置 (使用 uci -q 确保操作安全)
            if ! uci -q get network.$LOGIC_NAME >/dev/null; then
                uci set network.$LOGIC_NAME=interface
                uci set network.$LOGIC_NAME.proto='dhcp'
            fi
            uci set network.$LOGIC_NAME.device="$INTERFACE"
            uci set network.$LOGIC_NAME.metric='10'
            uci commit network

            # 2. 绑定防火墙 WAN 区域
            wan_zone=$(uci show firewall | grep ".name='wan'" | cut -d. -f2)
            if [ -n "$wan_zone" ]; then
                if ! uci get firewall.$wan_zone.network | grep -qw "$LOGIC_NAME"; then
                    uci add_list firewall.$wan_zone.network="$LOGIC_NAME"
                    uci commit firewall
                fi
            fi

            # 3. 异步启动 (增加存活校验，防止快速插拔导致的无效操作)
            (
                sleep 5
                if [ -d "/sys/class/net/$INTERFACE" ]; then
                    /sbin/ifup $LOGIC_NAME
                    /etc/init.d/firewall reload
                    logger -t [USB_AUTO] "接口 $INTERFACE 已成功拉起并应用防火墙"
                else
                    logger -t [USB_AUTO] "接口 $INTERFACE 已在启动前被移除，跳过操作"
                fi
            ) &
        fi
        ;;

    remove)
        # 获取逻辑接口当前绑定的物理设备名
        CURRENT_DEV=$(uci -q get network.$LOGIC_NAME.device)
        
        # 只有拔出的设备与配置匹配时才清理 (防止误删)
        if [ "$INTERFACE" = "$CURRENT_DEV" ]; then
            logger -t [USB_AUTO] "检测到 USB 设备拔出: $INTERFACE，清理残留配置..."

            # 1. 静默关停逻辑接口
            /sbin/ifdown $LOGIC_NAME >/dev/null 2>&1

            # 2. 从防火墙移除
            wan_zone=$(uci show firewall | grep ".name='wan'" | cut -d. -f2)
            if [ -n "$wan_zone" ]; then
                uci del_list firewall.$wan_zone.network="$LOGIC_NAME"
                uci commit firewall
            fi

            # 3. 删除整个逻辑接口 Section
            uci delete network.$LOGIC_NAME
            uci commit network

            # 4. 刷新防火墙状态
            /etc/init.d/firewall reload
        fi
        ;;
esac
EOF

chmod +x "$DEST_DIR/40-usb-tethering"

echo ">>> 脚本注入完成！逻辑覆盖：自动识别、快速插拔保护、彻底清理。"
echo " "
