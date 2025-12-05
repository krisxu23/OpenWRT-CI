<div align="center">

# 🚀 OpenWrt for 京东云无线宝 亚瑟 RE-SS-01
### 专为IPQ6018深度定制 · 满血NSS加速 · 旗舰级功能集成

![OpenWrt](https://img.shields.io/badge/OpenWrt-ImmortalWrt%20Master-blue?style=flat-square&logo=openwrt)
![Platform](https://img.shields.io/badge/Platform-Qualcomm%20IPQ60xx-orange?style=flat-square&logo=qualcomm)
![Kernel](https://img.shields.io/badge/Kernel-6.12.y-brightgreen?style=flat-square&logo=linux)
![NSS](https://img.shields.io/badge/NSS-Hardware%20Offload%2012.2-8A2D00?style=flat-square)
![License](https://img.shields.io/badge/License-GPL--2.0-lightgrey?style=flat-square)

**为硬核玩家与家庭极客打造的，在京东云亚瑟（IPQ6018）上功能最全面、性能最极致的OpenWrt固件之一。**

[核心特性](#-核心特性) | [刷机警告](#-刷机前重要警告) | [功能详情](#-功能详解) | [致谢](#-致谢)

</div>

---

## ⚠️ 刷机前重要警告

> **🚨 内存配置警告**
> 本固件配置文件已启用 `CONFIG_IPQ_MEM_PROFILE_1024=y`，**仅适用于硬改1024MB内存的京东云亚瑟路由器**。**请勿**在原厂为512MB内存的设备上使用，否则可能出现兼容性问题。
>
> **🔐 风险自担**
> 刷机有风险，操作需谨慎。请确保你理解每一步操作的含义，并自行承担可能产生的后果。

---

## ✨ 核心特性

*   **⚡ 极致性能**：深度优化内核与NSS驱动，释放高通IPQ6018芯片全部潜力。
*   **🔧 功能完整**：从最全的USB支持到现代防火墙，满足高级用户一切想象。
*   **🛡️ 稳定高效**：历经多轮配置优化与冲突解决，追求长期稳定运行。
*   **🎯 开箱即用**：集成常用插件与优化设置，减少繁琐配置。

## 📋 固件信息

| 项目 | 详情 |
| :--- | :--- |
| **目标设备** | `jdcloud,re-ss-01` (京东云无线宝 亚瑟) |
| **SOC平台** | Qualcomm IPQ6018 (ARM Cortex-A53) |
| **源码基底** | ImmortalWrt Master Branch |
| **内核版本** | Linux 6.12.y |
| **管理地址** | `192.168.2.1` (首次启动请使用此地址) |
| **用户名/密码** | `root` / 无 (首次登录需在LuCI界面设置) |
| **无线SSID** | `OpenWrt-2.4G` & `OpenWrt-5G` (默认密码12345678) |

## 🛠️ 功能详解

### 1. 🧠 网络与硬件加速 (NSS)
这是本固件的灵魂。通过完整的高通网络子系统 (NSS) 驱动，实现了网络数据的硬件级加速，极大提升转发效率与降低CPU负载。

| 模块 | 功能 |
| :--- | :--- |
| **核心驱动** | `kmod-qca-nss-drv` |
| **连接加速** | `kmod-qca-nss-ecm` (增强连接管理) |
| **协议卸载** | `kmod-qca-nss-drv-pppoe` / `-pptp` / `-l2tpv2` |
| **队列管理** | `kmod-qca-nss-drv-qdisc` |
| **桥接加速** | `kmod-qca-nss-drv-bridge-mgr` (优化局域网互访) |
| **智能组播** | `kmod-qca-nss-drv-igs` |
| **SQM优化** | `sqm-scripts-nss` (NSS专用的智能队列管理) |

### 2. 📂 完整的存储与USB支持
堪称“USB大全”，支持几乎所有主流存储设备和网络共享方式。

*   **文件系统**：EXT4, F2FS, NTFS3, exFAT, XFS, VFAT。
*   **USB控制器**：完整支持XHCI (USB 3.0)、EHCI/OHCI (USB 2.0)。
*   **USB网络共享**：
    *   `kmod-usb-net-rndis` (Android/Windows)
    *   `kmod-usb-net-ipheth` (iPhone)
    *   `kmod-usb-net-huawei-cdc-ncm` (华为随行WiFi)
    *   `kmod-usb-net-qmi-wwan` / `-mbim` (4G/5G上网卡)
    *   `kmod-usb-net-asix-ax88179` / `-rtl8152` (常见USB有线网卡)
*   **工具**：完整的 `usbutils`、`block-mount`、`automount`。

### 3. 🔐 现代防火墙与网络
拥抱未来，使用基于nftables的Firewall4，并精简冗余配置。

*   **防火墙**：`firewall4` + `nftables-json`。
*   **NAT**：采用 `kmod-nft-fullcone` (NAT1)，移除旧的iptables模块避免冲突。
*   **隧道协议**：WireGuard、GRE、VXLAN、SIT等完整支持。
*   **流量管理**：`kmod-sched-cake` (CAKE QoS)、`kmod-ifb`。

### 4. 🧩 核心插件与系统工具
精心挑选的LuCI应用与系统工具，兼顾实用与强大。

| 类别 | 包含的插件/工具 |
| :--- | :--- |
| **网络服务** | `luci-app-homeproxy` (sing-box) / `luci-app-mosdns` / `luci-app-ddns` / `luci-app-upnp` / `luci-app-zerotier` |
| **存储管理** | `luci-app-diskman` (磁盘管理) / `luci-app-samba4` (网络共享) |
| **系统工具** | `luci-app-ttyd` (网页终端) / `luci-app-autoreboot` / `luci-app-netspeedtest` |
| **主题界面** | `luci-theme-argon` + `luci-app-argon-config` (现代化主题) |
| **性能工具** | `htop` / `iperf3` / `coremark` / `smartmontools` / `zram-swap` |
| **内核优化** | TCP BBR / 透明大页(MADVISE模式) / ZRAM / SKB Recycler |

### 5. ⚙️ 编译与性能优化
固件在编译阶段即注入性能基因。

*   **编译优化**：`-O3 -pipe -march=armv8-a+crypto+crc -mcpu=cortex-a53+crypto+crc`
*   **内核配置**：启用CGROUP、PERF_EVENTS、PMU等，方便性能分析与调优。
*   **无线加密**：使用 `wpad-openssl` 提供完整WPA3与企业级特性支持。

## 📦 如何获取与使用

1.  **下载固件**：在 [Releases](../../releases) 页面下载最新的 `*-sysupgrade.bin` 文件。
2.  **刷入设备**：通过原厂系统升级页面、uboot控制台或其它刷机方法，将固件刷入你的京东云亚瑟路由器。
3.  **首次配置**：
    *   连接至 `OpenWrt` 无线网络或有线LAN口。
    *   浏览器访问 `http://192.168.2.1`。
    *   **首要步骤**：按照LuCI提示，立即设置一个强密码。
    *   根据向导配置网络（WAN口）并探索丰富功能。

## 🙏 致谢

本固件的诞生离不开以下开源项目与社区的贡献，在此表示诚挚的感谢（排名不分先后）：

*   **[ImmortalWrt](https://github.com/immortalwrt/immortalwrt)**：提供了稳定、前瞻的OpenWrt源码基底。
*   **[OpenWrt](https://openwrt.org/)** & **[LEDE](https://lede-project.org/)**：伟大的开源路由器系统。
*   **所有软件包的维护者**：特别是 `kenzok8/small-package`, `LI-Bwrt`, 以及各大 feeds 中的贡献者。
*   **高通及相关芯片开发者**：提供了强大的硬件平台与内核驱动。
*   **OpenWrt 中文社区**：无数教程、经验分享与问题解答，是学习路上的明灯。

## 📄 许可证

本项目遵循其源码基底（ImmortalWrt/OpenWrt）所采用的 **GPL-2.0** 开源许可证。具体条款见 [LICENSE](LICENSE) 文件。

---
<div align="center">

**如果你喜欢这个项目，请点个 Star ⭐ 以示支持！**

编译固件就像烹饪，这份配置是精心调配的食谱。<br>愿你的网络，从此快如闪电，稳若磐石。

<sub>Built with ❤️ by GitHub Actions</sub>

</div>
