# 🚀 OpenWrt 固件 for 京东云无线宝 亚瑟（AX1800 Pro）

### 专为 **1G 内存硬改版** 定制 · **满血 NSS 硬件加速** · **内核级 Docker 支持**

<div align="center">

![OpenWrt](https://img.shields.io/badge/OpenWrt-ImmortalWrt%20Master-blue?style=flat-square&logo=openwrt)
![Platform](https://img.shields.io/badge/Platform-Qualcomm%20IPQ60xx-orange?style=flat-square&logo=qualcomm)
![NSS](https://img.shields.io/badge/NSS-Hardware%20Offload%2012.5-8A2D00?style=flat-square)
![Memory](https://img.shields.io/badge/Memory-1024MB%20Mod-FF69B4?style=flat-square)
![Build Status](https://img.shields.io/github/actions/workflow/status/krisxu23/wrt_release/build_wrt.yml?branch=main&label=CI%2FCD&style=flat-square&logo=github)

</div>

---

## ⚠️ 刷机前重要警告（必须阅读）

> [!CAUTION]
> **本固件仅适用于已硬改至 1024MB 内存的京东云无线宝 亚瑟（AX1800 Pro）**
>
> 固件已启用 **`CONFIG_IPQ_MEM_PROFILE_1024`** 等内核级内存配置。
>
> **原厂 512MB 内存设备严禁刷入**，否则可能导致：
> - ath11k 无线驱动无法加载  
> - 系统反复重启 / 无法启动  
> - 严重情况下直接变砖  

---

## ✨ 固件定位与设计目标

本固件面向 **Qualcomm IPQ60xx（IPQ6018）平台** 与 **1G 内存硬改亚瑟** 深度定制，核心目标：

- 稳定性优先，拒绝激进不成熟优化  
- NSS 硬件加速 **全路径启用**  
- 在高性能前提下，完整兼容 **代理 / QoS / Docker / NAS / 远程接入**

---

## 🚀 核心特性总览

### ⚡ 满血 NSS 硬件加速（NSS 12.5）

完整集成并启用 Qualcomm 官方 **NSS 12.5** 组件：

- `qca-nss-drv`
- `qca-nss-ecm`
- `qca-nss-dp`
- `qca-nss-crypto`
- `qca-nss-clients`
- `sqm-scripts-nss`

**效果说明：**

- IPv4 / IPv6 / NAT / PPPoE / Bridge 流量大规模卸载至 NSS
- 显著降低 CPU 占用，释放 ARM 核心算力
- 在大流量下载时，依然保持低延迟、低抖动

---

### 🐳 内核级 Docker 支持（按需安装）

固件**不直接内置 Docker 用户态**，而是预置所有 **内核级依赖**，避免模块不匹配问题：

- Namespace / Cgroups
- OverlayFS
- veth / bridge / iptables / nftables 兼容

**启用方式：**

```bash
opkg update
opkg install dockerd docker-compose luci-app-docker

/etc/init.d/dockerd enable
/etc/init.d/dockerd start
适合运行：

Home Assistant

Alist / Aria2

自建服务容器

🛡️ 稳定性与 1G 内存专项优化

编译优化：

-O2（稳定优先，放弃 -O3）

ARMv8 Cortex-A53 定向优化

内核策略：

PREEMPT 抢占式内核，提升网络包实时响应

内存管理：

ZRAM（ZSTD 压缩）

THP（MADVISE）

高并发调优：

nf_conntrack_max = 65535

🌐 网络、代理与远程接入

HomeProxy（sing-box 核心）

nftables / firewall4

FullCone NAT（iptables + nft 版本）

SQM（含 NSS 加速版）

WireGuard

ZeroTier

适用于：

透明代理 / 分流规则

异地安全访问家庭内网

多设备高并发网络环境

📡 无线与网络服务

ath11k + mac80211（Wi-Fi 6）

hostapd

IPv6 全支持（odhcp6c / odhcpd / 6rd）

DDNS / UPnP / WOL

🧰 存储与系统功能

ZRAM Swap

DiskMan 磁盘管理

Samba4 文件共享

smartmontools

btrfs / f2fs / exfat / ntfs3

automount 自动挂载

USB 网络共享（Android / iOS / 4G / 5G）

🖥 固件基础信息
项目	默认值
管理地址	192.168.2.1
登录用户	root
初始密码	无（首次登录请设置）
默认 SSID	JDC_AX1800PRO / JDC_AX1800PRO_5G
Wi-Fi 密码	12345678
LuCI 主题	Argon
📦 集成 LuCI 应用（节选）

luci-app-firewall

luci-app-sqm

luci-app-zerotier

luci-app-wireguard

luci-app-samba4

luci-app-diskman

luci-app-ddns

luci-app-upnp

luci-app-ttyd

luci-theme-argon

luci-theme-bootstrap

⚙️ CI/CD 自动化构建体系

本仓库 krisxu23/wrt_release 采用 全自动 GitHub Actions 构建：

自动化特性

统一编译环境，结果可复现

多设备配置模块化管理

ccache + staging_dir 缓存加速

Release 规范

自动创建 GitHub Release

Tag 格式：YY.MM.DD_HH.MM.SS_Device

Release Notes 自动包含：

内核版本

默认网络信息

插件清单

🧾 适合人群

京东云亚瑟 AX1800 Pro 用户

已完成 1G 内存硬改

追求 高性能 + 稳定 + 可维护

需要代理 / Docker / NAS / 远程访问的一体化方案

🙏 致谢

ImmortalWrt 项目组

Qualcomm QCA NSS

jerrykuku / luci-theme-argon

<div align="center">

固件不是“能用就行”，而是长期运行的基础设施。
如果本项目对你有帮助，欢迎点亮 ⭐ Star 支持。

<sub>Built by Kris Xu</sub>

</div> ```
