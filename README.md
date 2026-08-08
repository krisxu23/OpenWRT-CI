# OpenWRT-CI 云编译

基于 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 的 OpenWrt 云编译项目，使用 GitHub Actions 全自动编译 [ImmortalWrt](https://github.com/VIKINGYFY/immortalwrt) 固件（**6.18 内核**），每日定时 + 手动触发，编译产物自动发布到 GitHub Releases。

## 当前重点设备：JDCloud RE-SS-01（京东云亚瑟 AX1800 Pro）

本项目当前配置为**仅编译 RE-SS-01**，并对该设备做了针对性优化：

| 项目 | 说明 |
|---|---|
| CPU / SoC | 高通 IPQ6000 四核 1.2GHz（Cortex-A53） |
| 存储 | eMMC 启动（`EmmcImage`），Docker 数据空间充足 |
| 内存 | 支持**硬改 1G 内存**（原厂 512M）。内核通过 CDT/UBoot 自动识别内存大小，刷机时使用 1G CDT 即可 |
| WiFi | ath11k 驱动，硬改 1G 后自动切换**完整内存模式**（16 VDEV / 512 peers，原厂省内存模式仅 8 VDEV / 128 peers） |
| Docker | 内置完整 Docker 支持：`docker` + `dockerd` + `docker-compose` + `luci-app-dockerman`（中文界面） |
| 加速 | NSS 芯片级网络加速、AES/SHA256/512 ARMv8 硬件加速、nftables fullcone NAT |

## 固件默认配置

- 登录地址：`192.168.10.1`
- 登录密码：无（或见 Release 说明）
- WiFi 名称：`OWRT`　WiFi 密码：`12345678`
- 主题：`argon`
- 语言：简体中文（zh_Hans）

## 固件特性

- **Docker 容器**：DockerMan 管理界面（中文），支持 Compose
- **科学上网**：luci-app-homeproxy、gecoosac
- **USB 网卡驱动**：RNDIS、QMI、NCM、RTL8150/8152、ASIX、Sierra Wireless 等全系列
- **磁盘管理**：diskman、partexp、samba4、btrfs/ksmbd/fuse 文件系统支持
- **网络工具**：nftables fullcone、kmod-bonding、mptcp-diag、upnp、wolultra
- **日常插件**：cpufreq、autoreboot、mini-diskmanager、ttyd 等

## 目录结构

```
├── .github/workflows/   # CI 工作流
│   ├── QCA-ALL.yml      # 高通 qualcommax 系列编译（IPQ60XX / IPQ807X）
│   ├── OWRT-ALL.yml     # 全系列编译
│   ├── MTK-ALL.yml      # 联发科系列编译
│   ├── WRT-CORE.yml     # 公用编译核心（不可删除）
│   ├── WRT-TEST.yml     # 测试模式（只输出配置不编译）
│   ├── Auto-Clean.yml   # 每日自动清理（触发编译）
│   └── Cache-Clean.yml  # 缓存清理
├── Config/              # 编译配置（设备列表 + 插件选择）
│   ├── GENERAL.txt      # 公共插件配置（所有配置共用）
│   ├── IPQ60XX-WIFI-YES.txt   # IPQ60XX 带 WiFi（当前仅 RE-SS-01）
│   ├── IPQ60XX-WIFI-NO.txt    # IPQ60XX 无 WiFi 版
│   ├── IPQ807X-WIFI-YES/NO.txt
│   ├── MEDIATEK-WIFI-YES/NO.txt
│   ├── ROCKCHIP.txt / X86.txt
│   └── TEST.txt
└── Scripts/             # 编译脚本
    ├── Packages.sh      # 拉取/更新第三方插件包（主题、科学插件等）
    ├── Handles.sh       # 插件修正（预置数据、修复冲突）
    └── Settings.sh      # 编译期配置修改（默认 IP/WiFi/主题/设备 DTS 调整）
```

## 使用方法

### 手动编译

1. 打开仓库 **Actions** 页面
2. 选择 **QCA-ALL**（或 OWRT-ALL / WRT-TEST）
3. 点击 **Run workflow**
   - `PACKAGE`：可临时追加编译的插件（多行分隔）
   - `TEST`：勾选后**只输出 .config 配置文件、不编译固件**，用于验证配置

### 自动编译

Auto-Clean 每天定时运行（北京时间约 05:00），完成后自动触发各系列编译，产物发布到 **Releases**（每个配置一个 tag）。

### 刷机

- **首次刷入**（当前为原厂系统）：进入 U-Boot 刷 `*squashfs-factory.bin`（RE-SS-01 需配合大分区 U-Boot）
- **已有 OpenWrt**：Web 界面直接升级 `*squashfs-sysupgrade.bin`
- 硬改 1G 内存的机器：确保已刷 1G CDT（通常商家已刷好，自带的初始系统能识别 1G 即说明 CDT 正确）

## 定制指南

### 只编译指定设备

编辑 `Config/IPQ60XX-WIFI-YES.txt`，只保留目标设备行（`=y`），其余注释掉（`#`）：

```
CONFIG_TARGET_DEVICE_qualcommax_ipq60xx_DEVICE_jdcloud_re-ss-01=y
```

### 增删插件

- **所有配置通用**：编辑 `Config/GENERAL.txt`
- **单个配置专用**：编辑对应的 `Config/XXX.txt`
- 格式：`CONFIG_PACKAGE_插件名=y` 启用，`=n` 禁用

### 调整默认 IP / WiFi / 主题

编辑对应 workflow 文件（如 `QCA-ALL.yml`）中的 `WRT_IP`、`WRT_SSID`、`WRT_WORD`、`WRT_THEME` 变量。

### 更换源码

修改 workflow 中的 `SOURCE`（默认 `VIKINGYFY/immortalwrt`）与 `BRANCH`（默认 `main`）。

## 第三方软件源（可选补充）

固件刷好后可添加在线软件源，安装编译时未内置的插件：

- **JDCloud 软件源**（恩山大佬自建，8000+ 包）：`http://47.106.253.36:765/JDCloud-Packages`
  - ⚠️ **注意**：该源基于 **6.12 内核**编译，**kmod 内核模块与本固件（6.18 内核）不兼容，安装会导致死机**，仅可安装 luci 应用/工具类（非 kmod）软件包
  - 添加方法：`系统 → 软件包 → 配置`，注释 `option check_signature`，添加 `src/gz jdcloud http://47.106.253.36:765/JDCloud-Packages`，然后更新列表

## 参考链接

- 源码：<https://github.com/VIKINGYFY/immortalwrt.git>
- 原版 CI：<https://github.com/VIKINGYFY/OpenWRT-CI.git>
- 高通 U-Boot（沉心）：<https://github.com/chenxin527/uboot-qsdk12.5-build.git>
- 高通 U-Boot（小猪）：<https://github.com/1980490718/u-boot-2016.git>
- 联发科 U-Boot：<https://github.com/VIKINGYFY/UBOOT-CI/releases>
- 本地编译工具：<https://github.com/VIKINGYFY/OWRT-Tools.git>

## 致谢

感谢 ImmortalWrt 开源项目、VIKINGYFY 的 OpenWRT-CI 模板，以及恩山论坛各位大佬的分享。

> 固件仅供学习交流使用，刷机有风险，请自行承担。
