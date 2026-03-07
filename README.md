🚀 OpenWrt 京东云亚瑟（1GB 硬改版）专用固件
<div align="center"> <img src="https://img.shields.io/badge/OpenWrt-23.05-blue?logo=openwrt"> <img src="https://img.shields.io/badge/Platform-IPQ60xx-ff69b4"> <img src="https://img.shields.io/badge/Memory-1GB%20(Hardware%20Mod)-brightgreen"> <img src="https://img.shields.io/badge/NSS-Acceleration-yellow"> <img src="https://img.shields.io/badge/Docker-Supported-orange"> <img src="https://img.shields.io/badge/Build-Automated%20via%20GitHub%20Actions-success"> </div>
⚠️ 重要：仅适用于 硬改 1GB 内存 的京东云亚瑟
原厂 512MB 内存设备切勿刷入，否则无法启动！
本固件已针对 1GB 内存全面优化，包括内核参数、NSS 内存配置及驱动选择。

🔥 核心特性
⚡ 全速硬件加速
完整 NSS 硬件卸载（有线 + 无线），启用 ath11k-nss，CPU 占用更低，吞吐更高。

🧠 1GB 内存专调
开启 IPQ_MEM_PROFILE_1024 与 ATH11K_MEM_PROFILE_1G，内存管理更高效。

🐳 Docker 容器支持
内核集成 veth、bridge、iptables-nft，预装 dockerd 及 luci-app-dockerman。

🌐 全方位网络功能
nftables 防火墙、WireGuard、Tailscale、SQM QoS、多线聚合、完整 USB 驱动（含 4G/5G 模组）。

🧩 丰富 LuCI 应用
代理（homeproxy/nikki/openclash）、存储（diskman/samba4）、DNS（mosdns）、主题 argon、网络测速等。

🤖 全自动编译
GitHub Actions 每日检查更新，支持一键触发与插件自定义，ccache 加速。

📦 快速使用
Fork 本仓库 → 进入 Actions 页面

选择 QCA-ALL 工作流 → 点击 Run workflow

可选：输入需要额外启用的插件（每行一个 CONFIG_PACKAGE_xxx=y）

编译完成后，Releases 页面下载固件

默认 IP：192.168.2.1，WiFi：ImmortalWrt / 12345678，主题：argon

🔧 自定义提示
修改默认配置：编辑 Config/IPQ60XX-WIFI-YES.txt（已合并 GENERAL.txt 所有通用包）

手动触发时可通过 手动调整插件包 增减软件包

如需仅生成 .config 文件测试，勾选 仅输出配置文件

🙏 致谢
VIKINGYFY/immortalwrt 源码基础
OpenWrt 社区及所有插件作者
Loyalsoldier 规则集

⭐ 如果这个固件对你有帮助，请给个 Star 吧！
