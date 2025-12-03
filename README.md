<div align="center">
OpenWrt · 京东云无线宝 亚瑟 RE-SS-01（IPQ6018）
1GB 满血 NSS WiFi 旗舰版｜by Kris Xu｜2025












</div>
⚠️ Warning 刷机前必读（非常重要！）

[!IMPORTANT]
本固件仅针对已硬改 1GB 内存的 RE-SS-01（亚瑟）编译！
原厂 512MB 机器刷入会持续重启或无法开机，已在编译时强制开启 IPQ_MEM_PROFILE_1024，不兼容小内存。

刷机有风险，操作需谨慎，作者不承担任何砖。

ℹ️ 基础信息 (Basic Info)
项目	内容	备注
默认管理地址	192.168.2.1	Config / Scripts 已固定
默认用户名	root	
默认密码	首次登录要求设置	LuCI 会弹出改密码页面
默认 WiFi 名称	ImmortalWrt	可在 Scripts / UCI 默认修改
默认 WiFi 密码	12345678	可在 Scripts / UCI 默认修改
源码基底	ImmortalWrt 6.12 主线 + 自研补丁	每日同步上游
内核版本	Linux 6.12.y（长期维护分支）	
NSS 固件版本	官方最新 12.5 分支	性能、稳定性最优
内存策略	CONFIG_IPQ_MEM_PROFILE_1024=y	1GB 内存机器专用
WiFi 驱动	ath11k / MAC80211 全套驱动	支持 2.4/5GHz + Mesh
🚀 核心特色 (Features)
⚡ 极致性能与硬件加速

🧬 1GB 内存全释放
IPQ_MEM_PROFILE_1024 + NSS_MEM_PROFILE_HIGH + ATH11K_MEM_PROFILE_1024M 全开，队列数满载

🚀 满血 NSS 硬件加速
默认加载：

kmod-qca-nss-drv + kmod-qca-nss-pbuf + ecm + sqm-scripts-nss

2.5G 口实测 PPPoE + NAT + SQM 可稳定跑满 2.3–2.4 Gbps

WireGuard / IPSec 硬件加密加速
AES/SHA 完全走 NSS 加密引擎，实测 WireGuard 1.8 Gbps+

📂 极速存储与 NAS 体验

原生支持 NTFS3（内核态）、exFAT、Btrfs、EXT4

Diskman + 自动挂载 + 一键扩容 + smartmontools 全套硬盘工具

ZRAM 256MB 换页，1GB 内存下流畅运行多任务

🌐 网络连接与增强

HomeProxy + sing-box 轻量科学上网代理

MosDNS 本地智能分流

luci-app-ttyd 网页终端

luci-app-cpufreq 动态调频

luci-app-sqm + sqm-scripts-nss（Cake 可硬件加速）

完整 USB 网络共享（iPhone ipheth、华为 HiLink、5G 模组全支持）

🔌 外设与系统工具

最新 Argon 主题（暗色/透明/毛玻璃） + Argon-Config 一键切换

系统首次启动自动显示详细固件信息

luci-app-autoreboot、luci-app-gecoosac、luci-app-netspeedtest、luci-app-partexp、luci-app-samba4、luci-app-upnp 等工具集成

各类 USB 外设支持完整（音频、存储、网卡、调试接口等）

🛠️ 运维工具链

htop、iperf3、curl、coremark、bash、usbutils、mmc-utils、nand-utils、fdisk、gdisk、blkid、usbmuxd、openssh-keygen、openssl-util

Docker / containerd / runc 可选（源码保留，不默认安装）

🔧 编译与定制

GitHub Actions 自动化编译：支持 workflow_run 与 workflow_dispatch

配置完全自定义，可添加/删除插件，支持仅生成 config 文件

支持 NSS、IPQ60xx WiFi 满血补丁，TailScale / Rust / DiskMan 等问题修复

🤝 致谢 (Credits)（排名不分先后）

ImmortalWrt 主线源码
→ https://github.com/immortalwrt/immortalwrt

VIKINGYFY（IPQ60xx NSS 优化补丁长期维护）
→ https://github.com/VIKINGYFY/immortalwrt

sbwml（Golang / MosDNS / Argon 主题维护）
→ https://github.com/sbwml

nikkinikki-org / sirpdboy / Lisaac / Loyalsoldier / EasyTier 等
→ 提供各类高性能插件和科学网络软件包

所有默默为 IPQ60xx / NSS / ImmortalWrt 生态贡献的前辈们

<div align="center">

<sub>Built with ❤️ by Kris Xu — 专为 1GB 亚瑟玩家打造的满血 WiFi 旗舰固件</sub>

</div>
