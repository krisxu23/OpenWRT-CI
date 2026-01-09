```markdown
# OpenWrt for 京东云无线宝 亚瑟（AX1800 Pro）

> 面向 **IPQ60xx（IPQ6018）平台** 深度定制的高性能 OpenWrt 固件  
> 以 **稳定优先、性能拉满、长期可维护** 为设计目标

---

## 📌 固件定位

本固件基于 OpenWrt / ImmortalWrt 构建体系，专为 **京东云无线宝 亚瑟（AX1800 Pro）** 定制：

- 适配 **1GB 内存硬改**
- **完整启用 QCA NSS 硬件加速**
- 兼顾 **代理 / 科学上网 / QoS / NAS / 远程管理**
- 面向长期使用与持续更新

---

## 🧠 核心硬件信息

| 项目 | 说明 |
|----|----|
| SoC | Qualcomm IPQ6018（IPQ60xx） |
| 架构 | ARMv8 Cortex-A53 |
| 无线 | Wi-Fi 6（ath11k） |
| 内存 | 1GB（硬改适配） |
| 存储 | NAND |

---

## 🚀 性能与加速特性

### ✅ NSS 硬件加速（全套启用）

- qca-nss-drv
- qca-nss-ecm
- qca-nss-dp
- qca-nss-crypto
- qca-nss-clients
- sqm-scripts-nss

**说明：**
- IPv4/IPv6 转发、NAT、PPPoE、桥接流量全面走 NSS
- 在保证加速的前提下，保留 nft / tproxy 能力，兼容代理透明转发

---

## 🌐 网络与代理能力

- **homeproxy**
- **sing-box**
- nftables / firewall4
- FullCone NAT（iptables + nft 版本）
- WireGuard
- Zerotier

适用于：
- 透明代理
- 分流规则
- 远程访问内网服务
- 移动网络回家访问

---

## 📡 无线与网络服务

- ath11k + mac80211（Wi-Fi 6）
- hostapd
- IPv6 全支持（odhcp6c / odhcpd / 6rd）
- SQM（含 NSS 加速版本）
- DDNS
- UPnP
- WOL

---

## 🧰 系统与存储功能

- ZRAM Swap（适配大内存）
- DiskMan 磁盘管理
- Samba4 文件共享
- smartmontools
- btrfs / f2fs / exfat 支持
- automount 自动挂载

---

## 🖥 管理与运维

- LuCI Web 管理界面（完整版）
- ttyd Web 终端
- htop
- OpenSSH
- 定时任务（cron）
- 软件包在线管理

---

## 🔐 安全与基础组件

- firewall4 + nftables
- dropbear / openssh
- ca-certificates
- urandom-seed / urngd
- 完整 openssl / mbedtls 支持

---

## 📦 已集成的软件包（节选）

- luci-app-firewall
- luci-app-sqm
- luci-app-zerotier
- luci-app-samba4
- luci-app-diskman
- luci-app-ddns
- luci-app-upnp
- luci-app-ttyd
- luci-theme-argon
- luci-theme-bootstrap

---

## ⚠️ 说明与已知事项

- 编译过程中出现的 **依赖 WARNING** 不影响固件使用
- 未选中的实验性 5G / MHI / onionshare 组件已自动跳过
- 本固件 **优先稳定性**，不追求极限裁剪

---

## 🛠 适合人群

- 京东云亚瑟（AX1800 Pro）用户
- 1G 内存硬改玩家
- 需要 **高性能转发 + 代理 + QoS** 的家庭/工作室网络
- 希望长期维护、可持续升级的用户

---

## 📄 License

遵循 OpenWrt / ImmortalWrt 及各上游项目的开源协议。
```
