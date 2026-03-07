🚀 OpenWrt 京东云亚瑟（JDCloud RE-SS-01）硬改1GB内存专属固件
<div align="center"> <img src="https://img.shields.io/badge/OpenWrt-23.05-blue?logo=openwrt"> <img src="https://img.shields.io/badge/Platform-IPQ60xx-ff69b4"> <img src="https://img.shields.io/badge/Memory-1GB%20(Hardware%20Mod)-brightgreen"> <img src="https://img.shields.io/badge/NSS-Acceleration-yellow"> <img src="https://img.shields.io/badge/Docker-Supported-orange"> <img src="https://img.shields.io/badge/Build-Automated%20via%20GitHub%20Actions-success"> </div>
📖 项目简介
本项目为京东云亚瑟（JDCloud RE-SS-01） 路由器量身定制的 OpenWrt 固件，基于 Qualcomm IPQ60xx 平台，深度融合高通底层优化，并针对硬改 1GB 内存的设备进行全适配。固件集成了 NSS 硬件加速、Docker 容器支持、完整的 USB 驱动、现代防火墙 nftables 以及丰富的 LuCI 应用插件，旨在释放亚瑟的全部潜能，打造高性能、多功能的家庭网络中心。

⚠️ 注意：本固件仅适用于已硬改内存为 1GB 的京东云亚瑟。若您的设备仍为原厂 512MB 内存，请勿刷入，否则可能无法启动或出现异常。

✨ 核心特性
🔥 硬件深度适配
1GB 内存专调：正确设置 IPQ_MEM_PROFILE_1024 与 ATH11K_MEM_PROFILE_1G，充分发挥大内存优势。

NSS 硬件加速：启用完整 NSS 驱动套件（kmod-qca-nss-drv、kmod-qca-nss-ecm、kmod-qca-ssdk 等），搭配 12.5 版本 NSS 固件，实现 CPU 卸载，大幅提升路由转发性能。

无线 NSS 卸载：集成 kmod-ath11k-nss，将无线数据流卸载至 NSS 引擎，降低 CPU 负载，提升无线吞吐。

硬件加密引擎：启用 QCE（Qualcomm Crypto Engine）及 ARMv8 Crypto 扩展，加速 IPSec、WireGuard 等加密连接。

🐳 Docker 容器支持
内核开启必要模块（veth、bridge、iptables-nft 等），预装 dockerd 与 luci-app-dockerman（可选），轻松运行容器化应用。

🌐 完整网络功能
nftables 防火墙：支持 offload、fullcone NAT、tproxy 等现代特性。

VPN 就绪：集成 WireGuard、Tailscale、OpenVPN 依赖。

QoS 与 SQM：内置 cake 队列及 sqm-scripts-nss，智能流量整形。

多线聚合：支持 bonding 与协议代理。

🧰 丰富的 LuCI 应用
代理全家桶：homeproxy、nikki、openclash、passwall（可选）

存储与文件共享：diskman、partexp、samba4、USB 自动挂载

网络工具：netspeedtest、wolplus、upnp、ddns-go

系统增强：argon 主题、cpufreq、ttyd、ramfree、autoreboot

DNS 与去广告：mosdns、openlist2

🛠️ 自动编译流水线
基于 GitHub Actions 实现 全自动编译，每日检测源码更新，支持手动触发与自定义插件选择。

采用 ccache 缓存 加速重复编译，节省时间。

📋 固件配置详解
分类	关键配置	说明
目标平台	CONFIG_TARGET_qualcommax_ipq60xx
CONFIG_TARGET_DEVICE_jdcloud_re-ss-01	指定亚瑟设备
内存配置	CONFIG_IPQ_MEM_PROFILE_1024=y
CONFIG_ATH11K_MEM_PROFILE_1G=y	1GB 内存专用
NSS 加速	CONFIG_PACKAGE_kmod-qca-nss-drv=y
CONFIG_NSS_FIRMWARE_VERSION_12_5=y
CONFIG_PACKAGE_kmod-ath11k-nss=y	有线+无线硬件卸载
无线驱动	CONFIG_PACKAGE_kmod-ath11k-ahb=y
CONFIG_PACKAGE_ath11k-firmware-ipq6018=y	启用 IPQ6018 内置无线
Docker 支持	CONFIG_PACKAGE_kmod-veth=y
CONFIG_PACKAGE_iptables-nft=y
CONFIG_PACKAGE_dockerd=m	容器运行时依赖
文件系统	CONFIG_PACKAGE_kmod-fs-btrfs、xfs、fuse
CONFIG_PACKAGE_btrfs-progs、xfsprogs	支持多种外部存储
USB 驱动	集成 USB2/3、DWC3、串口、网卡驱动（AX88179、RTL8152 等）	即插即用
编译优化	-march=armv8-a+crypto+crc -mcpu=cortex-a53	针对 Cortex-A53 优化
完整配置可查看 Config/IPQ60XX-WIFI-YES.txt 与 Config/GENERAL.txt（已合并）。

🚦 如何使用
1️⃣ Fork 本仓库
点击右上角 Fork 按钮，将项目复制到您的 GitHub 账户下。

2️⃣ 触发编译
自动编译：仓库默认每天检查上游源码更新，若有新提交则自动开始编译。

手动编译：进入 Actions 页面，选择 QCA-ALL 工作流，点击 Run workflow，可选择：

手动调整插件包：按行输入需要额外启用的包（如 luci-app-passwall）。

仅输出配置文件：勾选后只生成 .config 文件，不编译固件（用于测试配置）。

3️⃣ 下载固件
编译成功后，GitHub Releases 页面会生成一个以 IPQ60XX-WIFI-YES- 开头的发布包，包含适用于亚瑟的固件文件（如 *-squashfs-sysupgrade.bin）及对应的配置文件。

🧩 自定义编译
修改默认配置
您可以直接编辑仓库中的配置文件：

Config/IPQ60XX-WIFI-YES.txt：平台相关配置。

Config/GENERAL.txt：通用软件包配置（已合并入主文件，若分离需调整工作流）。

调整插件选择
在手动触发工作流时，通过 手动调整插件包 输入框添加或移除包。例如：

text
CONFIG_PACKAGE_luci-app-openclash=y
# CONFIG_PACKAGE_luci-app-homeproxy is not set
个性化设置
脚本 Scripts/Settings.sh 会根据工作流输入自动修改：

默认 IP：192.168.2.1

默认 WiFi 名称/密码：ImmortalWrt / 12345678

默认主题：argon

主机名：ImmortalWrt
您也可在触发工作流时通过环境变量覆盖这些值。

⚠️ 重要提示
硬件要求
本固件必须搭配 1GB 内存的硬改亚瑟使用。原厂 512MB 设备请勿尝试，否则可能变砖。

无线 NSS 加速
无线 NSS 卸载需要内核与驱动配合，默认已开启。若遇到无线异常，可尝试在编译时切换 NSS 固件版本（12.2 或 12.5）。

Docker 存储路径
建议将 Docker 根目录挂载到外部存储（如 USB 硬盘）以避免占用系统空间。可通过 luci-app-dockerman 配置。

首次刷机
请通过 uboot Web 恢复模式 或 TFTP 刷入 initramfs 内核，然后再从 LuCI 升级到 sysupgrade 固件。切勿直接从官方固件 Web 升级！

反馈与问题
若编译失败或固件运行异常，请提交 Issue 并提供编译日志（可开启 WRT_TEST=true 生成配置后手动编译调试）。

🙏 致谢
感谢 VIKINGYFY/immortalwrt 提供源码基础。

感谢所有 OpenWrt 社区开发者及插件作者。

特别感谢 Loyalsoldier 的规则集。

📄 许可证
本项目遵循 GPL-3.0 协议，详情请见 LICENSE 文件。

✨ 如果您喜欢这个项目，请给一个 ⭐ 支持！
Happy Building!
