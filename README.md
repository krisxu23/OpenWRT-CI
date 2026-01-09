🚀 OpenWrt 固件 for 京东云无线宝 亚瑟 (AX1800 Pro)
专为 1G 内存硬改版定制 · 满血 NSS 硬件加速 · 内核级 Docker 支持
<div align="center">
  
</div>
⚠️ 刷机前重要警告：1G 内存硬改专属
本固件仅适用于已硬改至 1024MB 内存的京东云无线宝 亚瑟 (AX1800 Pro)！

固件已针对 1G 内存进行内核级深度优化（配置 CONFIG_IPQ_MEM_PROFILE_1024）。

原厂 512MB 内存设备严禁刷入，否则将导致无线驱动加载失败、系统频繁重启等严重问题，甚至可能砖机！

✨ 核心特性：亚瑟极致性能释放
本固件是针对 Qualcomm IPQ6000 平台和 1G 内存硬改 亚瑟的定制化解决方案，旨在提供极致的性能和稳定性。

1. ⚡ 满血 NSS 硬件加速 (NSS 12.5)
通过集成官方 NSS 12.5 驱动，全面激活硬件卸载能力，大幅降低 CPU 负载：

核心优势：

全路径卸载：支持 ECM (连接管理器)、PPPoE、L2TP、Bridge-mgr、QDisc (流量整形) 等关键网络路径的硬件加速

NSS-SQM 优化：集成 sqm-scripts-nss，实现硬件加速的流量整形，确保大流量下载时依然保持极低游戏延迟

性能提升：

IPv4 / IPv6 / NAT / PPPoE / Bridge 流量大规模卸载至 NSS

显著降低 CPU 占用，释放 ARM 核心算力

在大流量下载时，依然保持低延迟、低抖动

2. 🐳 内核级 Docker 支持
为保持固件纯净和体积，仅内置了 Docker 运行所需的全部内核依赖，避免了内核模块版本不匹配的问题：

内置核心组件：

Namespace / Cgroups：容器隔离与资源管理

OverlayFS：现代容器存储驱动

veth / bridge：容器网络虚拟化

iptables / nftables 兼容：防火墙与网络策略

启用方式：

bash
# 1. 更新软件源
opkg update

# 2. 安装 Docker 用户态组件
opkg install dockerd docker-compose luci-app-docker

# 3. 启动并设置开机自启
/etc/init.d/dockerd enable
/etc/init.d/dockerd start
适用场景：

Home Assistant 智能家居中枢

Alist / Aria2 文件管理和下载

各类自建服务容器

轻量级应用部署

3. 🛡️ 极致稳定与内存调优
编译策略优化：

-O2 优化级别：稳定优先，放弃不稳定 -O3

PREEMPT 抢占式内核：提升网络包处理实时性

ARMv8 Cortex-A53 定向优化：针对亚瑟 CPU 架构专门调优

1G 内存专项优化：

ZRAM (ZSTD 压缩)：高效内存压缩交换，提升可用内存

透明大页 (MADVISE)：优化内存访问效率

连接数增强：net.netfilter.nf_conntrack_max 提升至 65535

网络性能调优：

网络缓冲区优化，减少丢包

TCP 拥塞控制算法优化

硬件队列调度优化

🌐 网络功能全家桶
🔌 代理与 VPN
HomeProxy：基于 sing-box 核心，支持多种协议

nftables / firewall4：现代防火墙框架

FullCone NAT：iptables + nftables 双版本支持

WireGuard：高性能 VPN 协议

ZeroTier：SD-WAN 虚拟组网

📡 无线与连接
ath11k + mac80211：完整 Wi-Fi 6 支持

IPv6 全协议栈：odhcp6c / odhcpd / 6rd

DDNS：动态域名解析

UPnP：端口自动映射

WOL：网络唤醒

💾 存储与扩展
Diskman：可视化磁盘管理

Samba4：高性能文件共享

USB 全家桶：完整支持 NTFS3、ExFAT、UAS 协议

移动网络共享：支持 Apple/Android/4G/5G 模块

文件系统支持：btrfs / f2fs / exfat / ntfs3

🛠️ 固件基础信息
项目	默认配置	说明
管理地址	192.168.2.1	路由器管理界面
登录用户	root	超级管理员账户
登录密码	无	首次登录时自行设置
无线 SSID	JDC_AX1800PRO_5G / JDC_AX1800PRO	双频 Wi-Fi 名称
无线密码	12345678	建议首次使用后修改
默认主题	Argon	现代化 Web 界面
📦 已集成核心应用 (精选)
🛡️ 网络与安全
luci-app-firewall - 防火墙管理

luci-app-sqm - 流量整形（含 NSS 优化版）

luci-app-wireguard - WireGuard VPN 管理

luci-app-zerotier - ZeroTier 虚拟组网

🗂️ 存储与管理
luci-app-samba4 - Samba 文件共享

luci-app-diskman - 磁盘管理

luci-app-ddns - 动态域名解析

luci-app-upnp - UPnP 自动端口映射

🔌 系统与服务
luci-app-ttyd - Web 终端

luci-app-docker - Docker 容器管理

luci-theme-argon - Argon 现代化主题

luci-theme-bootstrap - Bootstrap 经典主题

⚙️ 项目架构：CI/CD 自动化构建
本项目 krisxu23/wrt_release 是一个高度自动化的固件构建仓库，确保您获得的固件始终是最新、最稳定的版本。

🔄 自动化编译流程
GitHub Actions：所有固件均通过 GitHub Actions CI/CD 流程自动编译，确保环境一致性和可重复性

模块化配置：通过 deconfig/*.config 和 compilecfg/*.ini 文件管理不同设备的配置，实现多设备支持

智能缓存：利用 ccache 和 staging_dir 缓存，大幅缩短后续编译时间

📋 固件发布规范
自动 Release：编译成功后，系统将自动创建 GitHub Release

版本命名：Release Tag 采用 YY.MM.DD_HH.MM.SS_DeviceModel 格式

详细说明：Release Notes 自动包含：

内核版本信息

默认网络配置

集成插件列表

刷机注意事项

🌍 支持设备平台
本项目通过统一的 CI/CD 流程，支持以下主流高性能路由器平台：

Qualcomm IPQ60xx：京东云亚瑟 AX1800 Pro（1G 硬改版）

Qualcomm IPQ807x：红米 AX6/AX6000

x86-64：软路由平台

Amlogic：N1 盒子等 ARM 设备

🧾 适合人群
京东云亚瑟 AX1800 Pro 用户：设备持有者

已完成 1G 内存硬改：必须满足硬件条件

追求极致性能：需要充分利用硬件加速能力

全功能需求者：需要代理、Docker、NAS、远程访问的一体化方案

技术爱好者：愿意折腾并理解系统工作原理

🙏 致谢与开源
本项目基于以下优秀开源项目和社区资源：

ImmortalWrt 项目组：提供优秀的 OpenWrt 衍生版本

QCA NSS Builds：Qualcomm 官方 NSS 驱动

jerrykuku / luci-theme-argon：现代化 Web 界面主题

所有开源贡献者：感谢社区的共同努力与分享

<div align="center">
⭐ 支持与反馈
编译固件就像烹饪，这是一份精心调配的食谱。

如果您觉得本项目对您有帮助，请不吝 点亮一个 Star ⭐ 以示支持，这将成为我们持续优化的动力！

<sub>Built with ❤️ by Kris Xu</sub>

</div>
