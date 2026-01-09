# 🚀 OpenWrt 固件 for 京东云无线宝 亚瑟 (AX1800 Pro)

### 专为 1G 内存硬改版定制 · 满血 NSS 硬件加速 · 内核级 Docker 支持

<div align="center">

![OpenWrt](https://img.shields.io/badge/OpenWrt-ImmortalWrt%20Master-blue?style=flat-square&logo=openwrt)
![Platform](https://img.shields.io/badge/Platform-Qualcomm%20IPQ60xx-orange?style=flat-square&logo=qualcomm)
![NSS](https://img.shields.io/badge/NSS-Hardware%20Offload%2012.5-8A2D00?style=flat-square)
![Memory](https://img.shields.io/badge/Memory-1024MB%20Mod-FF69B4?style=flat-square)
![Build Status](https://img.shields.io/github/actions/workflow/status/krisxu23/wrt_release/build_wrt.yml?branch=main&label=CI%2FCD%20Status&style=flat-square&logo=github)

</div>

---

## ⚠️ 刷机前重要警告：1G 内存硬改专属

> [!CAUTION]
> **本固件仅适用于已硬改至 1024MB 内存的京东云无线宝 亚瑟 (AX1800 Pro)！**
>
> 固件已针对 1G 内存进行内核级深度优化（配置 `CONFIG_IPQ_MEM_PROFILE_1024`）。
>
> **原厂 512MB 内存设备严禁刷入**，否则将导致无线驱动加载失败、系统频繁重启等严重问题，甚至可能砖机！

---

## ✨ 核心特性：亚瑟极致性能释放

本固件是针对 **Qualcomm IPQ6000** 平台和 **1G 内存硬改** 亚瑟的定制化解决方案，旨在提供极致的性能和稳定性。

### 1. ⚡ 满血 NSS 硬件加速 (NSS 12.5)

通过集成官方 NSS 12.5 驱动，全面激活硬件卸载能力，大幅降低 CPU 负载：
- **全路径卸载**：支持 **ECM (连接管理器)**、**PPPoE**、**L2TP**、**Bridge-mgr**、**QDisc (流量整形)** 等关键网络路径的硬件加速。
- **NSS-SQM 优化**：集成 `sqm-scripts-nss`，实现硬件加速的流量整形，确保大流量下载时依然保持极低游戏延迟。

### 2. 🐳 内核级 Docker 支持

为保持固件纯净和体积，仅内置了 Docker 运行所需的全部内核依赖，避免了内核模块版本不匹配的问题：
- **内置依赖**：完整支持 **Namespace**、**Cgroups**、**OverlayFS** 等核心组件。
- **启用方式**：需要使用 Docker 时，在 LuCI 终端（TTYD）或 SSH 执行以下命令即可：

```bash
# 1. 更新软件源
opkg update

# 2. 安装 Docker 用户态组件
opkg install dockerd docker-compose luci-app-docker

# 3. 启动并设置开机自启
/etc/init.d/dockerd enable
/etc/init.d/dockerd start
```

### 3. 🛡️ 极致稳定与内存调优

- **编译策略**：采用 `-O2` 优化级别，放弃不稳定 `-O3`，并开启 **PREEMPT 抢占式内核**，提升网络包处理实时性。
- **1G 内存优化**：启用 **ZRAM (ZSTD 压缩)** 和 **透明大页 (MADVISE)**，让 1G 内存利用更高效，系统更流畅。
- **连接数增强**：默认将 **`net.netfilter.nf_conntrack_max` 提升至 65535**，有效应对高并发连接。

---

## 🛠️ 固件基础信息与集成应用

| 项目 | 默认配置 |
| :--- | :--- |
| **管理地址** | `192.168.2.1` |
| **登录用户** | `root` |
| **登录密码** | 无（首次登录请务必设置密码） |
| **无线 SSID** | `JDC_AX1800PRO_5G` / `JDC_AX1800PRO` |
| **无线密码** | `12345678` |
| **默认主题** | Argon |

### 已集成核心应用 (精选)

- **网络服务**：`HomeProxy`（sing-box 核心）、`DDNS`、`UPnP`。
- **远程接入**：`ZeroTier` 内网穿透、`WireGuard` 协议支持。
- **管理辅助**：`Samba4` 网络共享、`Diskman` 磁盘管理、`TTYD` 终端、`Argon` 主题配置。
- **USB 全家桶**：完整支持 **NTFS3**、**ExFAT**、**UAS 协议**，以及 **Apple/Android/4G/5G** 网络共享。

---

## ⚙️ 项目架构：CI/CD 自动化构建

本项目 `krisxu23/wrt_release` 是一个高度自动化的固件构建仓库，确保您获得的固件始终是最新、最稳定的版本。

### 1. 自动化编译流程

- **GitHub Actions**：所有固件均通过 **GitHub Actions CI/CD** 流程自动编译，确保环境一致性和可重复性。
- **模块化配置**：通过 `deconfig/*.config` 和 `compilecfg/*.ini` 文件管理不同设备的配置，实现多设备支持。
- **缓存机制**：利用 `ccache` 和 `staging_dir` 缓存，大幅缩短后续编译时间，加速固件迭代。

### 2. 固件发布与版本管理

- **自动 Release**：编译成功后，系统将自动创建 GitHub Release。
- **版本命名**：Release Tag 采用 `YY.MM.DD_HH.MM.SS_DeviceModel` 格式，便于用户追踪版本。
- **Release Body**：自动包含 **内核版本**、**WIFI 密码**、**LAN 地址** 以及 **集成插件列表**，确保信息透明。

### 3. 支持设备列表 (部分)

本项目通过统一的 CI/CD 流程，支持以下主流高性能路由器平台：
- **Qualcomm IPQ60xx**：京东云亚瑟 AX1800 Pro
- **Qualcomm IPQ807x**：红米 AX6/AX6000
- **x86-64**：软路由平台
- **Amlogic**：N1 盒子

---

## 🙏 致谢

本项目基于以下优秀开源项目和社区资源：

- [ImmortalWrt 项目组](https://github.com/immortalwrt/immortalwrt)
- [QCA NSS Builds](https://github.com/qca/nss-807x)
- [jerrykuku / luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon)

<div align="center">

**编译固件就像烹饪，这是一份精心调配的食谱。**  
如果您觉得本项目对您有帮助，请不吝点亮一个 Star ⭐ 以示支持！

<sub>Built with ❤️ by Kris Xu</sub>

</div>
