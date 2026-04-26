# jdcloud_re-ss-01 OpenWrt 固件

本固件基于 OpenWrt 编译，针对 **IPQ60XX jdcloud_re-ss-01** 设备优化，功能完整，适合中国大陆用户。

## 目标设备
- Qualcomm IPQ60XX 平台
- 设备型号：jdcloud_re-ss-01
- 内存配置：1GB

## 核心功能
- **网络与加速**
  - NSS 驱动全功能启用（L2TP、PPTP、VXLAN、IGS、Shaper 等）
  - Ath11k Wi-Fi 驱动，支持 Mesh 网络
  - 支持 MPTCP、nftables、透明代理与多种隧道

- **USB 与存储**
  - USB 2/3 全系列驱动
  - 支持大部分 4G/5G 网卡
  - 支持 BTRFS/F2FS/NTFS3/exFAT/VFAT/XFS 等文件系统
  - 支持 U盘、移动硬盘、USB Modem

- **系统与工具**
  - LuCI Web 界面（argon、bootstrap 主题）
  - 常用网络与系统工具：htop、btop、tmux、iperf3、tcpdump、curl、openssh
  - 支持 ZRAM 压缩交换
  - 支持 homeproxy、OpenClash 等代理工具

## 编译优化
- CPU 指令优化：`-O3 -march=armv8-a+crypto+crc -mcpu=cortex-a53`
- 内存 1GB 设备优化配置
- Skb recycler 多 CPU 支持

---

**注意**：本固件为定制固件，包含多种高级功能和驱动，如果不需要所有功能，可根据实际需求裁剪部分模块以减小固件体积。
