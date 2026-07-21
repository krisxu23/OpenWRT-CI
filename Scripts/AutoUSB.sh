#!/bin/sh
# =====================================================================
# 脚本：40-usb-tethering
# 适用：京东云亚瑟（单USB口）自动识别随身WiFi并创建WAN
# 特点：自适应等待、失败重试、完整清理、无冗余
# =====================================================================

LOGIC_NAME="usb"
LOG_TAG="[USB_AUTO]"
# 最长等待网络接口就绪（秒）
MAX_WAIT=30
# DHCP 重试次数
RETRIES=3

log() {
    logger -t "$LOG_TAG" "$@"
}

# 等待接口真实就绪（替代固定 sleep 5）
wait_iface_ready() {
    local iface="$1" waited=0

    while [ $waited -lt $MAX_WAIT ]; do
        # 设备被拔走了则放弃
        [ ! -d "/sys/class/net/$iface" ] && return 1

        # 检查接口是否真正 operational（link up）
        local flags
        flags=$(cat "/sys/class/net/$iface/flags" 2>/dev/null)
        # 0x1001 = UP + LOWER_UP，表示链路已通
        if [ $((flags & 0x1001)) -eq 4097 ] 2>/dev/null; then
            log "设备 $iface 链路就绪（${waited}s）"
            return 0
        fi

        # 额外的：检查是否有 carrier（物理连通）
        if [ "$(cat /sys/class/net/$iface/carrier 2>/dev/null)" = "1" ]; then
            log "设备 $iface carrier 就绪（${waited}s）"
            return 0
        fi

        sleep 1
        waited=$((waited + 1))
    done

    log "设备 $iface 就绪超时（${MAX_WAIT}s）"
    return 1
}

# 带重试的 DHCP 拉取，并验证是否拿到 IP
ifup_with_check() {
    local name="$1" retry=0

    while [ $retry -lt $RETRIES ]; do
        /sbin/ifup "$name" 2>/dev/null
        sleep 4

        local dev
        dev=$(uci -q get "network.$name.device")
        if ip -4 addr show dev "$dev" 2>/dev/null | grep -q "inet "; then
            log "接口 $name DHCP 成功，IP: $(ip -4 addr show dev "$dev" | grep inet | awk '{print $2}')"
            return 0
        fi

        retry=$((retry + 1))
        [ $retry -lt $RETRIES ] && log "DHCP 第 ${retry} 次失败，重试..."
    done

    log "接口 $name DHCP 全部失败，请检查设备"
    return 1
}

# 清理残留的地址和路由
cleanup_net() {
    local iface="$1"
    ip -4 addr flush dev "$iface" 2>/dev/null
    ip -4 route flush dev "$iface" 2>/dev/null
    ip -6 addr flush dev "$iface" 2>/dev/null
    ip -6 route flush dev "$iface" 2>/dev/null
}

# ===== 主逻辑 =====

case "$ACTION" in
    add)
        # 校验：必须是 USB 子系统设备
        readlink "/sys/class/net/$INTERFACE/device/subsystem" 2>/dev/null | grep -q "usb" || exit 0

        log "检测到 USB 设备插入: $INTERFACE"

        # 等待接口真正就绪（link up / carrier），而非固定 sleep
        wait_iface_ready "$INTERFACE" || exit 1

        # 创建/更新 uci 配置
        uci -q batch <<-EOT
            set network.$LOGIC_NAME=interface
            set network.$LOGIC_NAME.proto='dhcp'
            set network.$LOGIC_NAME.device='$INTERFACE'
            set network.$LOGIC_NAME.metric='10'
            commit network
EOT

        # 绑定防火墙 WAN 区域
        wan_zone=$(uci show firewall | grep ".name='wan'" | cut -d. -f2 | head -1)
        if [ -n "$wan_zone" ]; then
            uci -q get firewall.$wan_zone.network | grep -qw "$LOGIC_NAME" || {
                uci -q add_list firewall.$wan_zone.network="$LOGIC_NAME"
                uci -q commit firewall
            }
        fi

        # 带重试的 DHCP 拉取
        ifup_with_check "$LOGIC_NAME"

        /etc/init.d/firewall reload 2>/dev/null
        ;;

    remove)
        # 只处理当前绑定的设备
        CURRENT_DEV=$(uci -q get "network.$LOGIC_NAME.device")
        [ "$INTERFACE" != "$CURRENT_DEV" ] && exit 0

        log "USB 设备拔出: $INTERFACE"

        # 先清理地址和路由（避免残留默认路由）
        cleanup_net "$INTERFACE"

        /sbin/ifdown "$LOGIC_NAME" >/dev/null 2>&1

        # 从防火墙移除
        wan_zone=$(uci show firewall | grep ".name='wan'" | cut -d. -f2 | head -1)
        if [ -n "$wan_zone" ]; then
            uci -q del_list firewall.$wan_zone.network="$LOGIC_NAME"
            uci -q commit firewall
        fi

        uci -q delete "network.$LOGIC_NAME" && uci -q commit network
        log "配置已清理"

        /etc/init.d/firewall reload 2>/dev/null
        ;;
esac
