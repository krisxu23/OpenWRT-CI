🚀 OpenWrt 固件 for 京东云无线宝 亚瑟（AX1800 Pro）
专为 1G 内存硬改版 定制 · 满血 NSS 硬件加速 · 内核级 Docker 支持
<div align="center">
https://img.shields.io/badge/OpenWrt-ImmortalWrt%2520Master-blue?style=flat-square&logo=openwrt
https://img.shields.io/badge/Platform-Qualcomm%2520IPQ60xx-orange?style=flat-square&logo=qualcomm
https://img.shields.io/badge/NSS-Hardware%2520Offload%252012.5-8A2D00?style=flat-square
https://img.shields.io/badge/Memory-1024MB%2520Mod-FF69B4?style=flat-square
https://img.shields.io/github/actions/workflow/status/krisxu23/wrt_release/build_wrt.yml?branch=main&label=CI%252FCD&style=flat-square&logo=github

</div>
⚠️ 刷机前重要警告（必须阅读）
本固件仅适用于已硬改至 1024MB 内存的京东云无线宝 亚瑟（AX1800 Pro）

固件已启用 CONFIG_IPQ_MEM_PROFILE_1024 等内核级内存配置。

原厂 512MB 内存设备严禁刷入，否则可能导致：

ath11k 无线驱动无法加载

系统反复重启 / 无法启动

严重情况下直接变砖

✨ 固件定位与设计目标
本固件面向 Qualcomm IPQ60xx（IPQ6018）平台 与 1G 内存硬改亚瑟 深度定制，核心目标：

稳定性优先：拒绝激进不成熟优化，确保长期稳定运行

全路径 NSS 硬件加速：充分发挥硬件性能，降低 CPU 负载

全方位兼容性：在高性能前提下，完整兼容代理、QoS、Docker、NAS、远程接入等核心功能

🚀 核心特性总览
⚡ 满血 NSS 硬件加速（NSS 12.5）
完整集成并启用 Qualcomm 官方 NSS 12.5 组件，实现真正的硬件级加速：

包含组件：

qca-nss-drv - 核心驱动

qca-nss-ecm - 连接管理

qca-nss-dp - 数据路径加速

qca-nss-crypto - 加密加速

qca-nss-clients - 客户端模块

sqm-scripts-nss - 流量整形优化

加速效果：

IPv4 / IPv6 / NAT / PPPoE / Bridge 流量大规模卸载至 NSS

显著降低 CPU 占用，释放 ARM 核心算力

在大流量下载时，依然保持低延迟、低抖动

🐳 内核级 Docker 支持（按需安装）
固件不直接内置 Docker 用户态，而是预置所有 内核级依赖，避免模块不匹配问题：

支持的内核特性：

Namespace / Cgroups 完整支持

OverlayFS 存储驱动

veth / bridge / iptables / nftables 网络兼容

启用方式：

bash
opkg update
opkg install dockerd docker-compose luci-app-docker
/etc/init.d/dockerd enable
/etc/init.d/dockerd start
适用场景：

Home Assistant 智能家居中枢

Alist / Aria2 文件管理和下载

各类自建服务容器

🛡️ 稳定性与 1G 内存专项优化
编译层优化：

-O2 优化级别：稳定优先，放弃激进的 -O3

ARMv8 Cortex-A53 定向优化：针对亚瑟 CPU 架构专门调优

内核策略优化：

PREEMPT 抢占式内核：提升网络包实时响应能力

内存管理优化：

ZRAM（采用 ZSTD 压缩算法）

THP（透明大页，MADVISE 策略）

网络性能调优：

nf_conntrack_max = 65535（提升连接跟踪容量）

网络缓冲区优化，减少丢包

🌐 网络、代理与远程接入
核心网络组件：

HomeProxy：基于 sing-box 核心，支持多种协议

nftables / firewall4：现代防火墙框架

FullCone NAT：iptables + nftables 双版本支持

SQM：含 NSS 加速版流量整形

WireGuard：高性能 VPN

ZeroTier：SD-WAN 虚拟组网

应用场景：

透明代理与智能分流

异地安全访问家庭内网

多设备高并发网络环境

📡 无线与网络服务
无线系统：

ath11k + mac80211：完整 Wi-Fi 6 支持

hostapd：企业级 AP 功能

支持 160MHz 频宽（硬件支持时）

网络服务：

IPv6 全协议栈支持（odhcp6c / odhcpd / 6rd）

DDNS 动态域名解析

UPnP 端口自动映射

WOL 网络唤醒

🧰 存储与系统功能
存储特性：

ZRAM Swap：高效内存压缩交换

DiskMan：可视化磁盘管理

Samba4：高性能文件共享

smartmontools：磁盘健康监测

文件系统支持：

btrfs / f2fs / exfat / ntfs3

automount 自动挂载

扩展功能：

USB 网络共享（支持 Android / iOS / 4G / 5G 模块）

USB 打印服务器

🖥 固件基础信息
项目	默认值	说明
管理地址	192.168.2.1	路由器管理界面
登录用户	root	超级管理员账户
初始密码	无	首次登录时自行设置
默认 SSID	JDC_AX1800PRO / JDC_AX1800PRO_5G	双频 Wi-Fi 名称
Wi-Fi 密码	12345678	建议首次使用后修改
LuCI 主题	Argon	现代化 Web 界面
📦 集成 LuCI 应用（精选）
🛡️ 网络与安全
luci-app-firewall - 防火墙管理

luci-app-sqm - 流量整形（含 NSS 优化版）

luci-app-wireguard - WireGuard VPN 管理

luci-app-zerotier - ZeroTier 虚拟组网

🗂️ 存储与文件
luci-app-samba4 - Samba 文件共享

luci-app-diskman - 磁盘管理

luci-app-ddns - 动态域名解析

🔌 系统与服务
luci-app-upnp - UPnP 自动端口映射

luci-app-ttyd - Web 终端

luci-app-docker - Docker 容器管理

🎨 界面与主题
luci-theme-argon - Argon 现代化主题

luci-theme-bootstrap - Bootstrap 经典主题

⚙️ CI/CD 自动化构建体系
本仓库 krisxu23/wrt_release 采用 全自动 GitHub Actions 构建，确保每次编译结果的一致性。

🔄 自动化特性
统一编译环境：Docker 容器化编译，结果完全可复现

配置模块化管理：多设备支持，配置清晰分离

智能缓存加速：ccache + staging_dir 双缓存，大幅提升编译速度

📋 Release 规范
自动发布：编译成功后自动创建 GitHub Release

版本标签：格式为 YY.MM.DD_HH.MM.SS_Device

详细说明：Release Notes 自动包含：

内核版本信息

默认网络配置

完整插件清单

刷机注意事项

🧾 适合人群
京东云亚瑟 AX1800 Pro 用户：设备持有者

已完成 1G 内存硬改：必须满足硬件条件

追求性能与稳定：需要高性能 + 长期稳定运行

全功能需求：需要代理、Docker、NAS、远程访问的一体化方案

技术爱好者：愿意折腾并理解系统工作原理

🙏 致谢
ImmortalWrt 项目组：提供优秀的 OpenWrt 衍生版本

Qualcomm QCA NSS：提供高性能网络加速组件

jerrykuku / luci-theme-argon：提供现代化的 Web 界面主题

所有开源贡献者：感谢社区的共同努力

<div align="center">
⭐ 支持与反馈
固件不是"能用就行"，而是长期运行的基础设施。

如果本项目对你有帮助，欢迎 点亮 ⭐ Star 支持项目的持续发展！

<sub>Built with ❤️ by Kris Xu</sub>

</div>
