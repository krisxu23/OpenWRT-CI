<div align="center">

# OpenWrt · 京东云无线宝 亚瑟 RE-SS-01 (IPQ60xx)
### ImmortalWrt 满血 NSS 旗舰版｜WiFi 增强｜2025

![System](https://img.shields.io/badge/OpenWrt-ImmortalWrt-blue?style=flat-square&logo=openwrt)
![Platform](https://img.shields.io/badge/Platform-Qualcomm%20IPQ60xx-orange?style=flat-square&logo=qualcomm)
![Kernel](https://img.shields.io/badge/Kernel-6.6%2F6.12-brightgreen?style=flat-square&logo=linux)
![NSS](https://img.shields.io/badge/NSS-Full%20Offload%2012.5-8A2D00?style=flat-square)
![WiFi](https://img.shields.io/badge/WiFi-Ath11k%20Original-critical?style=flat-square&logo=wifi)
![Build](https://img.shields.io/github/actions/workflow/status/你的用户名/仓库名/IPQ60XX-WIFI-YES.yml?branch=main&label=CI%20Build&style=flat-square)

</div>

---

## ⚠️ Warning 刷机前必读

> [!IMPORTANT]
> **本固件基于 VIKINGYFY/ImmortalWrt 源码构建，采用 Qualcommax 新平台架构。**
> 1. **NSS 版本**：默认启用 NSS 12.5 固件，开启全量硬件加速（SFE/Flow Offload）。
> 2. **WiFi 驱动**：集成 `ath11k` 原厂固件与板级数据，提供优秀的无线性能。
> 3. **初始密码**：为了安全起见，固件默认无密码，首次登录请设置密码。

> 刷机有风险，操作需谨慎，请确保了解 U-Boot 刷机流程。

---

## ℹ️ 基础信息 (Basic Info)

| 项目 | 内容 | 备注 |
| :--- | :--- | :--- |
| **默认管理地址** | `192.168.2.1` | 固件默认 IP |
| **默认用户名** | `root` | |
| **默认密码** | **无** (None) | 首次访问 Web 界面无需密码 |
| **WiFi 名称** | `ImmortalWrt` | 默认开启 |
| **WiFi 密码** | `12345678` | WPA2/WPA3 混合加密 |
| **源码基底** | ImmortalWrt Main | 每日紧跟上游更新 |
| **核心架构** | Qualcommax / IPQ60xx | 下一代高通开源驱动架构 |

---

## 🚀 核心特色 (Features)

### ⚡ 极致性能与硬件加速
- **🚀 满血 NSS 12.5 加速**
  默认集成 `kmod-qca-nss-drv`、`sqm-scripts-nss` 及全套 NSS 组件。支持有线/无线硬件卸载，显著降低 CPU 占用，跑满千兆/2.5G无压力。
- **📶 WiFi 性能增强**
  集成 `ath11k-firmware-ipq60xx` 及 `boarddata`，支持 Mesh 组网 (`kmod-ath11k` + `MAC80211_MESH`)。
- **🛠 内核与系统优化**
  启用 `BBR` 拥塞控制，支持 `ZRAM` 内存压缩，优化小内存设备体验。

### 🌍 网络科学与分流
- **HomeProxy (Sing-box)**：预置 Surge 规则（ChinaIP/GFWList），开箱即用，轻量且强大。
- **MosDNS v5**：集成高性能 DNS 分流工具，抗污染能力强。
- **内网穿透全家桶**：集成 `Tailscale`、`EasyTier`、`VNT`、`DDNS-Go`、`UPnP`，满足各种远程访问需求。

### 📂 存储与多媒体
- **NAS 级文件服务**：预装 `Samba4` (SMB共享)，支持 `NTFS3` (内核级驱动)、`Btrfs`、`EXT4` 等主流文件系统。
- **下载与管理**：
  - `qBittorrent`：高性能下载工具。
  - `Diskman`：图形化磁盘管理工具（已修复 NTFS3 挂载问题）。
  - `PartExp`：一键分区扩容工具，方便利用剩余空间。

### 🔌 丰富的 USB 外设支持
- **全能 USB 网络支持**：
  支持 Android (RNDIS)、iPhone (Ipheth)、华为 (NCM/HiLink) 及各类 4G/5G 模组 (QMI/MBIM/ECM)。
  包含：`kmod-usb-net-huawei-cdc-ncm`、`kmod-usb-net-qmi-wwan` 等全套驱动。

### 🎨 界面与交互
- **定制 Argon 主题**：默认修改为清新的 **Teal (#31a1a1)** 配色，集成 `Argon-Config` 支持自定义背景。
- **实用面板**：
  - `NetSpeedTest`：内网测速工具。
  - `TTYD`：网页版终端命令行。
  - `GecoosAC`：AC控制器支持。

---

## 📦 包含插件列表 (Package List)

| 类型 | 插件名称 | 说明 |
| :--- | :--- | :--- |
| **核心** | `luci-app-homeproxy` | 新一代 Sing-box 代理客户端 |
| **DNS** | `luci-app-mosdns` | 灵活的 DNS 分流工具 |
| **共享** | `luci-app-samba4` | Windows 文件共享 |
| **下载** | `luci-app-qbittorrent` | BT/PT 下载神器 |
| **穿透** | `luci-app-tailscale` | 零配置 VPN 组网 |
| **穿透** | `luci-app-ddns-go` | 多平台 DDNS 客户端 |
| **管理** | `luci-app-diskman` | 磁盘分区与挂载管理 |
| **管理** | `luci-app-partexp` | 剩余空间自动扩容 |
| **系统** | `luci-app-ttyd` | 网页终端 |
| **系统** | `luci-app-autoreboot` | 计划重启 |
| **网络** | `luci-app-upnp` | 通用即插即用 |
| **网络** | `luci-app-netspeedtest` | 网络速度测试 |

---

## 🔨 如何使用 (How to Build)

本项目支持 GitHub Actions 云编译，配置位于 `.github/workflows/IPQ60XX-WIFI-YES.yml`。

1. **Fork 本仓库** 到你的 GitHub 账号。
2. 进入 **Actions** 页面，选择 **IPQ60XX-WIFI-YES**。
3. 点击 **Run workflow**。
   - `PACKAGE`：(可选) 手动输入需要增加的插件包名，多个用空格隔开。
   - `TEST`：(可选) 勾选后仅输出配置文件，不进行长时间编译。
4. 等待编译完成后，在 Actions 详情页下载固件。

---

## 🤝 致谢 (Credits)

- **源码来源**：[VIKINGYFY/immortalwrt](https://github.com/VIKINGYFY/immortalwrt)
- **主题来源**：[jerrykuku/luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon)
- **插件来源**：
  - [kenzok8/small-package](https://github.com/kenzok8/small-package)
  - [sbwml/openwrt_pkgs](https://github.com/sbwml)
  - [sirpdboy/luci-app-partexp](https://github.com/sirpdboy/luci-app-partexp)
  - [VIKINGYFY/homeproxy](https://github.com/VIKINGYFY/homeproxy)

<div align="center">

<sub>Built with ❤️ by GitHub Actions</sub>

</div>
