# 🚀 OpenWrt 京东云亚瑟（1GB 硬改版）专用固件

<div align="center">
  <img src="https://img.shields.io/badge/OpenWrt-23.05-blue?logo=openwrt">
  <img src="https://img.shields.io/badge/Platform-IPQ60xx-ff69b4">
  <img src="https://img.shields.io/badge/Memory-1GB%20(Hardware%20Mod)-brightgreen">
  <img src="https://img.shields.io/badge/NSS-Acceleration-yellow">
  <img src="https://img.shields.io/badge/Docker-Supported-orange">
  <img src="https://img.shields.io/badge/Build-Automated%20via%20GitHub%20Actions-success">
</div>

---

## ⚠️ 重要警告
**本固件仅适用于已硬改内存为 1GB 的京东云亚瑟（JDCloud RE-ss-01）！**  
原厂 512MB 内存设备 **切勿刷入**，否则将无法启动甚至变砖。  

> 内存配置已针对 1GB 深度优化（`IPQ_MEM_PROFILE_1024` + `ATH11K_MEM_PROFILE_1G`），非 1GB 设备请勿使用。

---

## 🔥 核心亮点

### ⚡ 全速 NSS 硬件加速
- 有线 + 无线均启用 NSS 卸载（`kmod-ath11k-nss`）  
- CPU 占用降低，吞吐量提升  

### 🐳 Docker 容器原生支持
- 内核集成必要模块（`veth`、`bridge`、`iptables-nft`）  
- 预装 `dockerd` 与 `luci-app-dockerman`  
- 可轻松运行各类容器  

### 🌐 完整网络功能
- nftables 防火墙  
- WireGuard / Tailscale  
- SQM QoS，多线聚合  
- 4G/5G 模组驱动  

### 🧩 丰富 LuCI 应用
- 代理：homeproxy / nikki / openclash  
- 存储：diskman / samba4  
- DNS：mosdns  
- 主题：argon  
- 网络测速工具  

### 🤖 全自动编译流水线
- GitHub Actions 每日检查源码更新  
- 一键触发，ccache 加速编译  

---

## 📦 快速开始
1. Fork 本仓库 → 进入 **Actions** 标签页  
2. 选择 **QCA-ALL 工作流** → 点击 **Run workflow**  
3. （可选）在输入框添加额外插件，每行一个 `CONFIG_PACKAGE_xxx=y`  
4. 编译完成后，在 **Releases** 页面下载固件  

**默认配置：**  
- IP：`192.168.2.1`  
- WiFi：`ImmortalWrt / 12345678`  
- 主题：argon  

---

## 🔧 自定义编译
- 修改默认配置：编辑 `Config/IPQ60XX-WIFI-YES.txt`（已合并 GENERAL.txt 通用包）  
- 增减插件：手动触发工作流时，通过插件包输入框添加或移除  
- 测试配置：勾选 **仅输出配置文件**，生成 `.config` 而不编译固件  

---

## 🙏 致谢
- VIKINGYFY / immortalwrt 源码基础  
- OpenWrt 社区及所有插件作者  
- Loyalsoldier 规则集  

⭐ 如果这个固件对你有帮助，请给个 **Star** 支持！
