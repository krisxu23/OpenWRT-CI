# OpenWRT-CI 云编译

基于 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 的 OpenWrt 云编译项目，使用 GitHub Actions 自动编译 [ImmortalWrt](https://github.com/VIKINGYFY/immortalwrt) 固件（**6.18 内核**），编译产物发布到 GitHub Releases。

> **本项目当前只编译一个配置：`IPQ60XX-WIFI-YES`，且该配置里只勾选了 JDCloud RE-SS-01 一台设备。** 其余工作流（`OWRT-ALL` / `MTK-ALL` / `WRT-TEST`）已手动禁用，`Auto-Clean` / `Cache-Clean` 见下方说明。

## ⚠️ 先看这里：关于自动编译

**本仓库是 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 的 fork。GitHub 默认会关闭 fork 仓库里的定时工作流**，所以：

| 工作流 | 状态 | 后果 |
|---|---|---|
| `Auto-Clean` | `disabled_fork` | 每日 05:00（北京时间）的定时清理**不会自己运行** |
| `Cache-Clean` | `disabled_fork` | 缓存清理定时任务同样不会运行 |
| `QCA-ALL` | active | 只能**手动** Run workflow |
| `OWRT-ALL` / `MTK-ALL` / `WRT-TEST` | `disabled_manually` | 已主动禁用 |

`QCA-ALL` 的自动触发依赖 `workflow_run`（等 `Auto-Clean` 跑完），`Auto-Clean` 不跑 ⇒ **自动编译链路整条是断的，目前全靠手动触发。**

想恢复定时自动编译，去 **Actions 页面 → 左侧选中 `Auto-Clean` / `Cache-Clean` → 点 `Enable workflow`**。不启用也不影响手动编译。

## 当前重点设备：JDCloud RE-SS-01（京东云亚瑟 AX1800 Pro）

本项目配置为**仅编译 RE-SS-01**，并对该设备做了针对性优化：

| 项目 | 说明 |
|---|---|
| CPU / SoC | 高通 IPQ6000 四核 1.2GHz（Cortex-A53） |
| 存储 | eMMC 启动（`EmmcImage`），Docker 数据空间充足 |
| 内存 | 支持**硬改 1G 内存**（原厂 512M）。内核通过 CDT/UBoot 自动识别内存大小，刷机时使用 1G CDT 即可 |
| WiFi | ath11k 驱动，硬改 1G 后自动切换**完整内存模式**（16 VDEV / 512 peers，原厂省内存模式仅 8 VDEV / 128 peers） |
| NSS 加速 | 源码已内置满血 NSS（`kmod-qca-nss-drv` 等进 `DEFAULT_PACKAGES`），**NSS 固件版本固定 12.5**，见下方「已知坑」 |
| 硬件加密 | AES / SHA256 / SHA512 的 ARMv8 指令级加速 |
| Docker | 内置完整 Docker 支持：`docker` + `dockerd` + `docker-compose` + `luci-app-dockerman`（中文界面） |

## 固件默认配置

- 登录地址：`192.168.10.1`
- 登录密码：无（或见 Release 说明）
- WiFi 名称：`OWRT`　WiFi 密码：`12345678`
- 主机名：`OWRT`
- 主题：`argon`
- 语言：简体中文（zh_Hans）

## 固件特性

以下为**实际在 `Config/` 中启用**的内容（已逐项核对，非愿望清单）：

- **Docker 容器**：`docker` + `dockerd` + `docker-compose` + `containerd` + `runc` + `tini`，DockerMan 中文管理界面；`fuse-overlayfs`（ext4 存储驱动）+ `macvlan` + `iptables-nft` + cgroup 内核选项全套依赖已补齐
- **科学上网**：`luci-app-homeproxy`（sing-box 内核）、`luci-app-gecoosac`
- **USB 网卡驱动**：RNDIS、QMI（含 Fibocom/Quectel 变体）、NCM、ECM、EEM、MBIM、Huawei CDC-NCM、RTL8150/8152、ASIX/AX88179、Sierra Wireless、iPhone tethering（`ipheth`）等全系列
- **4G/5G 拨号**：`uqmi` + `mbim` + `comgt` + `usb-modeswitch`，以及 LuCI 的 3g / mbim / qmi / ncm / ppp / ipv6 / wireguard 协议支持
- **磁盘管理**：`luci-app-mini-diskmanager`、`luci-app-partexp`、`luci-app-samba4`、ksmbd、btrfs、exfat、ntfs3、`automount` + `block-mount`，另有 fdisk/gdisk/sfdisk/sgdisk/cfdisk/cgdisk、smartmontools、nvme-cli、mmc-utils
- **网络工具**：nftables fullcone NAT、`kmod-bonding`、`kmod-inet-mptcp-diag`、`luci-app-upnp`、`luci-app-wolultra`
- **系统工具**：`cpufreq`、`autoreboot`、`zram-swap`（内存压缩交换）、`htop`、`iperf3`、`coremark`、`dmesg`
- **文件系统**：btrfs / ksmbd / fuse / exfat / vfat / ntfs3，含 UTF-8 中文文件名支持（`kmod-nls-utf8`）

### 已拉取但未启用（想用自己加）

`Scripts/Packages.sh` 里会把这些仓库克隆下来备用，但 `Config/` 中**没有启用**，所以**不在固件里**。需要的话在 `Config/GENERAL.txt` 加一行 `CONFIG_PACKAGE_xxx=y`：

| 插件 | 启用键 |
|---|---|
| Tailscale 组网 | `CONFIG_PACKAGE_luci-app-tailscale=y` |
| QModem 通用拨号 | `CONFIG_PACKAGE_qmodem=y` / `CONFIG_PACKAGE_luci-app-qmodem-generic=y` |
| OpenClash | `CONFIG_PACKAGE_luci-app-openclash=y` |
| PassWall / PassWall2 | `CONFIG_PACKAGE_luci-app-passwall=y` / `luci-app-passwall2` |
| MosDNS | `CONFIG_PACKAGE_luci-app-mosdns=y` |
| qBittorrent | `CONFIG_PACKAGE_luci-app-qbittorrent=y` |
| ddns-go / easytier / vnt / netwizard / timecontrol / openlist2 / quickfile | 见 `Packages.sh` 中的包名 |
| 其他主题（aurora / kucat / noobwrt / shadcn / fluent） | `CONFIG_PACKAGE_luci-theme-xxx=y` |

> 注意：部分插件会连带拉进很大的依赖（如 qBittorrent 要 `qt6base`/`rblibtorrent`），会明显拉长编译时间与固件体积。

## 目录结构

```
├── .github/workflows/   # CI 工作流
│   ├── QCA-ALL.yml      # 高通 qualcommax 系列编译（当前唯一启用的入口）
│   ├── WRT-CORE.yml     # 公用编译核心（workflow_call，不可删除）
│   ├── OWRT-ALL.yml     # 全系列编译（已禁用）
│   ├── MTK-ALL.yml      # 联发科系列编译（已禁用）
│   ├── WRT-TEST.yml     # 测试模式，只输出配置不编译（已禁用）
│   ├── Auto-Clean.yml   # 每日自动清理并触发编译（fork 中定时被禁用）
│   └── Cache-Clean.yml  # 缓存清理（fork 中定时被禁用）
├── Config/              # 编译配置（设备列表 + 插件选择）
│   ├── GENERAL.txt            # 公共插件配置（所有配置共用）
│   ├── IPQ60XX-WIFI-YES.txt   # ★ 当前实际使用的配置（仅 RE-SS-01）
│   ├── IPQ60XX-JDCLOUD.txt    # IPQ60XX 京东云专用（备用/未挂到工作流）
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

## 编译流程

`WRT-CORE.yml` 是真正的编译核心，被 `QCA-ALL.yml` 通过 `workflow_call` 调用。步骤依次为：

```
Checkout Projects → Initialization Environment → Initialization Values → Clone Code
→ Check Scripts → Restore Build Cache → Prepare Restored Build Cache
→ Update Feeds → Custom Packages → Custom Settings → Download Packages
→ Compile Firmware → Save Build Cache → Machine Information
→ Package Firmware → Release Firmware
```

另有独立的 `cache-rollover` job 负责清理过期缓存代际。

### 缓存机制

工作流会把编译中间产物缓存起来，下次编译直接复用，省掉大量重复编译时间：

- 缓存键由 `WRT_SUBTARGET` + `WRT_CACHE_PREFIX` 计算得出，每次上游源码有更新就会换一个新代际
- `Restore Build Cache` 只恢复不保存，`Save Build Cache` 在编译成功后写入
- 缓存写满 GitHub 的 10GB 配额后由 `cache-rollover` job 回收旧代际

### 本地定制（相对上游的差异）

以下三处是本仓库相对上游的**有意改动**，同步上游代码时不要丢掉：

1. **`Update Feeds` 步骤**：注入 `kenzok8/small-package` 第三方源，并删除其中会覆盖核心的基础包、Docker 同名包，以及官方 `luci`/`packages` feed 中与 kenzok8 重名的插件包
2. **`Custom Packages` 步骤**：必须 `cd ./wrt/package/` 再执行 —— `Packages.sh` 里用的是 `../feeds/` 相对路径
3. **`Scripts/Handles.sh`**：新增了去掉 homeproxy 对 sing-box 版本下限的守卫（原因见下方「已知坑」）

## 使用方法

### 手动编译

1. 打开仓库 **Actions** 页面
2. 左侧选择 **QCA-ALL**
3. 点击 **Run workflow**
   - `PACKAGE`：可临时追加编译的插件（多行分隔）
   - `TEST`：勾选后**只输出 `.config` 配置文件、不编译固件**，用于验证配置是否正确

> 改完 `Config/` 里的配置后，建议先用 `TEST=true` 跑一遍，确认没有包被静默丢弃，再跑正式编译。

### 自动编译

需先在 Actions 页面启用 `Auto-Clean`。启用后它每天 05:00（北京时间）运行，清理旧 Release 与工作流记录，完成后通过 `workflow_run` 自动触发 `QCA-ALL`，产物发布到 **Releases**（每个配置一个 tag）。

### 刷机

- **首次刷入**（当前为原厂系统）：进入 U-Boot 刷 `*squashfs-factory.bin`（RE-SS-01 需配合大分区 U-Boot）
- **已有 OpenWrt**：Web 界面直接升级 `*squashfs-sysupgrade.bin`
- 硬改 1G 内存的机器：确保已刷 1G CDT（通常商家已刷好，自带的初始系统能识别 1G 即说明 CDT 正确）

## 定制指南

### 只编译指定设备

编辑 `Config/IPQ60XX-WIFI-YES.txt`，只保留目标设备行（`=y`），其余注释掉（`#`）或置为 `=n`：

```
CONFIG_TARGET_DEVICE_qualcommax_ipq60xx_DEVICE_jdcloud_re-ss-01=y
```

### 增删插件

- **所有配置通用**：编辑 `Config/GENERAL.txt`
- **单个配置专用**：编辑对应的 `Config/XXX.txt`
- 格式：`CONFIG_PACKAGE_插件名=y` 启用，`=n` 禁用

### 调整默认 IP / WiFi / 主题

编辑 `.github/workflows/QCA-ALL.yml` 中传给核心的变量：`WRT_IP`、`WRT_SSID`、`WRT_WORD`、`WRT_THEME`、`WRT_NAME`、`WRT_PW`。

这些值由 `Scripts/Settings.sh` 在编译期落地：改默认 IP 与主机名、改 WiFi SSID/密码、把 LuCI 默认主题 `luci-theme-bootstrap` 替换成 `WRT_THEME` 指定的主题，并追加 `CONFIG_PACKAGE_luci-theme-<主题>=y` 到 `.config`。**所以主题不需要写进 `Config/*.txt`。**

### 更换源码

修改 `QCA-ALL.yml` matrix 里的 `SOURCE`（默认 `VIKINGYFY/immortalwrt`）与 `BRANCH`（默认 `main`）。

## 已知坑（改配置前请先读）

这几条都是实际踩过的，写在这里避免重复浪费几小时编译时间。

### 1. `make defconfig` 会静默丢弃不存在的包

`Config/*.txt` 里写了 `CONFIG_PACKAGE_xxx=y`，如果源码/feeds 里根本没有 `xxx` 这个包，`make defconfig` **不会报错**，只会把它丢掉。日志里唯一线索是 `Packages.sh` 打印的 `Not fonud directory: xxx`。

**所以「配置里写了」≠「固件里有」。** 想知道某个包是否真的编进去了，去编译日志里搜它有没有被 `make` 实际处理。

### 2. apk 的版本序：`_alpha` 小于正式版

OpenWrt 25.12+ 用 apk 作包管理器，**apk 把 `1.15.0_alpha3` 视为 `1.15.0` 的预发布版本，版本序更小**。所以 `Depends: sing-box (>=1.15.0)` 遇上 `sing-box 1.15.0_alpha3` 会判为不可满足，直接：

```
ERROR: unable to select packages:
  sing-box-1.15.0_alpha3-r1:
    breaks: luci-app-homeproxy-xxx[sing-box>=1.15.0]
```

注意这类错误**发生在 `make world` 的最后一步 `package/install`**，前面几小时的编译全都成功，只在打包阶段整体失败，非常浪费。`Handles.sh` 末尾的守卫就是为了拆掉这个版本下限。

### 3. `CONFIG_NSS_FIRMWARE_VERSION_*` 在源码里不存在

`package/qca-nss/nss-firmware/Makefile` 中版本是**硬编码**的：

```make
override NSS_MAJOR=12
override NSS_MINOR=5
```

即固定 **NSS 12.5**。写 `CONFIG_NSS_FIRMWARE_VERSION_12_5=y` 或 `11_4` 都会被 `defconfig` 静默忽略，写与不写效果相同。真需要换版本只能改上面那个 Makefile。

### 4. Open-Box 编不进固件（不是配置写错）

[liandu2024/Open-Box](https://github.com/liandu2024/Open-Box) 是**发布二进制 + 一键安装脚本**的分发模式，仓库里只有 `README.md` / `docs/` / `scripts/`，**一个 `Makefile` 都没有**。没有 Makefile 就没有 OpenWrt 包，`UPDATE_PACKAGE ... "pkg"` 无从提取，`CONFIG_PACKAGE_open-box=y` 只会被丢弃。

它的正确用法是刷完固件后在路由器上装，见下一节。

### 5. 上游 feed 的瞬时故障会误伤

VIKINGYFY 的 feeds 更新很频繁，偶尔出现包版本互相错位（如上面第 2 条）。这类失败**不是你的配置问题**，重跑一次往往就好了。判断方法：看失败是否发生在 `Compile Firmware` 的最后阶段、且错误信息指向依赖不可满足而非编译错误。

## 可选：Open-Box 安装

固件本身不含 Open-Box，但刷好机后可以一条命令装上（面板与内核服务都装到 `/opt/open-box`，不污染固件）。

从 [Releases](https://github.com/liandu2024/Open-Box/releases/latest) 下载 `install.sh`（或直接在路由器上 `wget`），然后：

```sh
# 直连下载
sh install.sh
# 国内建议走镜像加速（自动探测可用镜像站）
sh install.sh --mirror
# 或指定镜像前缀
sh install.sh --mirror <镜像站域名>
```

安装包是 `open-box-linux-arm64.tar.gz`（RE-SS-01 属 arm64，约 71MB）。

几点注意事项：

- 脚本要求 **≥512MB 内存**（检测阈值 ≈440MB）与 **≥512MB 可用磁盘**，硬改 1G 内存的机器完全够
- 下载临时目录默认放在 `/opt` 所在的持久化分区，**故意避开 `/tmp`** —— `/tmp` 是 tmpfs，70MB 的安装包会直接吃掉内存，低内存机器会假死
- 安装包**自带 Node 运行时**，固件里不需要预装 node
- SHA256 校验通过前不会触碰安装目录，失败时系统零改动
- 首次打开面板需要自己设密码

## 第三方软件源（可选补充）

固件刷好后可添加在线软件源，安装编译时未内置的插件：

- **JDCloud 软件源**（恩山大佬自建，8000+ 包）：`http://47.106.253.36:765/JDCloud-Packages`
  - ⚠️ **注意**：该源基于 **6.12 内核**编译，**kmod 内核模块与本固件（6.18 内核）不兼容，安装会导致死机**，仅可安装 luci 应用/工具类（非 kmod）软件包
  - 添加方法：`系统 → 软件包 → 配置`，注释 `option check_signature`，添加 `src/gz jdcloud http://47.106.253.36:765/JDCloud-Packages`，然后更新列表

## 参考链接

- 源码：<https://github.com/VIKINGYFY/immortalwrt.git>
- 原版 CI：<https://github.com/VIKINGYFY/OpenWRT-CI.git>
- 第三方插件源：<https://github.com/kenzok8/small-package.git>
- 高通 U-Boot（沉心）：<https://github.com/chenxin527/uboot-qsdk12.5-build.git>
- 高通 U-Boot（小猪）：<https://github.com/1980490718/u-boot-2016.git>
- 联发科 U-Boot：<https://github.com/VIKINGYFY/UBOOT-CI/releases>
- 本地编译工具：<https://github.com/VIKINGYFY/OWRT-Tools.git>

## 致谢

感谢 ImmortalWrt 开源项目、VIKINGYFY 的 OpenWRT-CI 模板、kenzok8 的插件源，以及恩山论坛各位大佬的分享。

> 固件仅供学习交流使用，刷机有风险，请自行承担。
