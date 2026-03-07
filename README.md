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

## ⚠️ 注意事项
**本固件默认针对已硬改内存为 1GB 的京东云亚瑟（JDCloud RE-ss-01）！**  
原厂 512MB 内存设备 **切勿直接刷入**，否则无法启动。  

> 内存优化已针对 1GB 深度调优（`IPQ_MEM_PROFILE_1024` + `ATH11K_MEM_PROFILE_1G`），NSS 全速硬件加速，CPU 占用低、吞吐高。

---

## 🔧 512MB 内存设备修改说明
如果你使用的是 **原厂 512MB 内存设备**，请在编译前进行以下修改：

1. **修改内存配置**  
   - 打开 `Config/IPQ60XX-WIFI-YES.txt` 或你使用的 config 文件  
   - 注释或删除：
     ```text
     CONFIG_IPQ_MEM_PROFILE_1024=y
     CONFIG_ATH11K_MEM_PROFILE_1G=y
     ```
   - 添加或启用：
     ```text
     CONFIG_IPQ_MEM_PROFILE_512=y
     CONFIG_ATH11K_MEM_PROFILE_512M=y
     ```

2. **检查 NSS 内存配置**  
   - 如果你希望开启 NSS 硬件加速，请确认 `CONFIG_NSS_MEM_PROFILE_HIGH` 是否会超出 512MB，可改为低/中档配置（可参考 GENERAL.txt NSS 设置）。

3. **重新编译固件**  
   - GitHub Actions 手动触发 workflow  
   - 可选输入插件配置，保持与 1GB 版本一致  
   - 编译完成后，下载固件即可刷入 512MB 设备  

> ⚠️ 注意：原厂 512MB 内存设备使用 1GB 配置刷入可能导致系统无法启动或变砖，请务必修改配置。

---

## 🔥 核心亮点（适用于 1GB / 512MB 调整后）
### ⚡ 网络性能与硬件加速
- 高通 NSS 硬件卸载（有线 + 无线，可根据内存调整）  
- 支持 Mesh WiFi 与 ath11k 驱动  
- ARMv8 硬件加密（AES/SHA）  

### 🌐 网络功能
- nftables 防火墙、多线聚合  
- WireGuard、Tailscale、SQM QoS  
- USB 网卡、4G/5G 模组支持  

### 🐳 Docker 原生支持
- 内核自带 veth/bridge/iptables-nft  
- 预装 `dockerd` + `luci-app-dockerman`  

### 🧩 LuCI 管理与应用
- 系统管理：diskman、partexp、cpufreq、cpulimit、ttyd、ramfree  
- 代理与 DNS：homeproxy、mosdns、openclash、nikki、momo  
- 网络测速与监控：netspeedtest、iperf3、coremark  
- 主题：argon（默认）、aurora、kucat  

---

## 📦 快速使用
1. Fork 仓库 → Actions 标签页  
2. 选择 **QCA-ALL 工作流** → 点击 **Run workflow**  
3. （可选）手动调整插件配置  
4. 编译完成后下载固件  

**默认配置：** IP 192.168.2.1 | WiFi ImmortalWrt / 12345678 | 主题 argon  

---

## 🙏 致谢
- VIKINGYFY / ImmortalWrt  
- OpenWrt 社区及插件作者  
- Loyalsoldier 规则集  

⭐ 如果固件对你有帮助，请给个 **Star** 支持！
