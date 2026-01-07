#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"

# ==============================
# 1️⃣ 预置 HomeProxy 数据
# ==============================
if [ -d *"homeproxy"* ]; then
    echo "Updating HomeProxy data..."

    HP_RULE="surge"
    HP_PATH="homeproxy/root/etc/homeproxy"

    # 清空旧资源
    rm -rf ./$HP_PATH/resources/*

    # 拉取最新规则
    git clone -q --depth=1 --single-branch --branch "release" \
        "https://github.com/Loyalsoldier/surge-rules.git" ./$HP_RULE/

    cd ./$HP_RULE/ || exit
    RES_VER=$(git log -1 --pretty=format:'%s' | grep -o "[0-9]*")

    # 输出版本号
    echo "$RES_VER" | tee china_ip4.ver china_ip6.ver china_list.ver gfw_list.ver

    # 生成不同列表文件
    awk -F, '/^IP-CIDR,/{print $2 > "china_ip4.txt"} /^IP-CIDR6,/{print $2 > "china_ip6.txt"}' cncidr.txt
    sed 's/^\.//g' direct.txt > china_list.txt
    sed 's/^\.//g' gfw.txt > gfw_list.txt

    # 移动到 HomeProxy 资源目录
    mv -f ./{china_*,gfw_list}.{ver,txt} ../$HP_PATH/resources/

    # 清理临时目录
    cd .. || exit
    rm -rf ./$HP_RULE/

    cd "$PKG_PATH" || exit
    echo "✅ HomeProxy data updated!"
fi

# ==============================
# 2️⃣ Argon 主题字体与颜色修改
# ==============================
if [ -d *"luci-theme-argon"* ]; then
    echo "Fixing Argon theme..."

    cd ./luci-theme-argon/ || exit
    sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" \
        ./luci-app-argon-config/root/etc/config/argon

    cd "$PKG_PATH" || exit
    echo "✅ Argon theme fixed!"
fi

# ==============================
# 3️⃣ 修改 QCA-NSS 启动顺序
# ==============================
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
    echo "Fixing qca-nss-drv start order..."
    sed -i 's/START=.*/START=85/g' "$NSS_DRV"
    cd "$PKG_PATH" || exit
    echo "✅ qca-nss-drv fixed!"
fi

NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
    echo "Fixing qca-nss-pbuf start order..."
    sed -i 's/START=.*/START=86/g' "$NSS_PBUF"
    cd "$PKG_PATH" || exit
    echo "✅ qca-nss-pbuf fixed!"
fi

# ==============================
# 4️⃣ 修复 Tailscale 配置冲突
# ==============================
TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
    echo "Fixing Tailscale Makefile..."
    sed -i '/\/files/d' "$TS_FILE"
    cd "$PKG_PATH" || exit
    echo "✅ Tailscale fixed!"
fi

# ==============================
# 5️⃣ 修复 Rust 编译问题
# ==============================
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
    echo "Fixing Rust Makefile..."
    sed -i 's/ci-llvm=true/ci-llvm=false/g' "$RUST_FILE"
    cd "$PKG_PATH" || exit
    echo "✅ Rust fixed!"
fi

# ==============================
# 6️⃣ 修复 DiskMan 编译失败（禁用 NTFS）
# ==============================
DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
if [ -f "$DM_FILE" ]; then
    echo "Fixing DiskMan (no NTFS)..."

    # 精确删除 NTFS 相关依赖
    sed -i '/kmod-fs-ntfs/d' "$DM_FILE"
    sed -i '/kmod-fs-ntfs3/d' "$DM_FILE"
    sed -i '/ntfs-3g/d' "$DM_FILE"

    cd "$PKG_PATH" || exit
    echo "✅ DiskMan (no NTFS) fixed!"
fi

# ==============================
# 7️⃣ 修复 luci-app-netspeedtest 问题
# ==============================
if [ -d *"luci-app-netspeedtest"* ]; then
    echo "Fixing netspeedtest..."
    cd ./luci-app-netspeedtest/ || exit

    # 防止重复执行报错
    sed -i '$a\exit 0' ./netspeedtest/files/99_netspeedtest.defaults
    sed -i 's/ca-certificates/ca-bundle/g' ./speedtest-cli/Makefile

    cd "$PKG_PATH" || exit
    echo "✅ netspeedtest fixed!"
fi
