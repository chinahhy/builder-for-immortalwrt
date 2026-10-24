#!/bin/bash
# ============================================================
# 这个文件由「x86 软路由固件生成器」自动改写，请不要再手工编辑。
# 生成时间：2026-10-24 09:26    生成器版本：1.1.1
# 作用：被 x86-64/build25.sh 用 source 读入，里面的包会被拼进最终的
#      PACKAGES 列表，imagebuilder 编译时就会装进固件。
# 想换个组合？回网页重新点一遍，别在这里改。
#
# 说明：官方源里只写 luci-i18n-xxx-zh-cn 是原作者的写法，中文语言包
#      本身依赖主程序，装语言包会自动把 luci-app-xxx 带进来。
# ============================================================
CUSTOM_PACKAGES=""

# momo 原作者的 25.12 x86_64 APK：固定版本与 SHA256，失败立即停止编译。
(
  set -eu
  MOMO_TMP="$(mktemp -d)" || exit 1
  trap 'rm -rf "$MOMO_TMP"' EXIT
  curl -fL --retry 3 --connect-timeout 20 --max-time 180 'https://github.com/nikkinikki-org/OpenWrt-momo/releases/download/v1.2.2/momo_x86_64-openwrt-25.12.tar.gz' -o "$MOMO_TMP/momo.tar.gz" || exit 1
  echo 'e4922bb24b1ff4f009ec47fac5f6fbdbf67a33cf4c1de8ed4c03b28c9413a311  '"$MOMO_TMP/momo.tar.gz" | sha256sum -c - || exit 1
  mkdir -p extra-packages/momo || exit 1
  tar -xzf "$MOMO_TMP/momo.tar.gz" -C extra-packages/momo './momo-2026.10.14-r1.apk' './luci-app-momo-1.2.2-r1.apk' './luci-i18n-momo-zh-cn-26.287.34901~f177d79.apk' || exit 1
) || { echo "momo APK 下载或校验失败，停止构建" >&2; exit 1; }

# ---------- 上网代理：OpenClash ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash luci-compat kmod-tun kmod-inet-diag kmod-nft-tproxy bash curl ip-full unzip"

# ---------- 上网代理：HomeProxy ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-homeproxy-zh-cn"

# ---------- 上网代理：Nikki ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-nikki-zh-cn"

# ---------- 上网代理：PassWall2 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES geoview xray-core sing-box hysteria kmod-nft-socket kmod-nft-tproxy luci-app-passwall2 luci-i18n-passwall2-zh-cn"

# ---------- 上网代理：daed ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-daed-zh-cn"

# ---------- 上网代理：momo ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES momo luci-app-momo luci-i18n-momo-zh-cn"

# ---------- DNS 与去广告：AdGuardHome ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES adguardhome luci-app-adguardhome"

# ---------- DNS 与去广告：MosDNS ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-mosdns luci-i18n-mosdns-zh-cn"

# ---------- DNS 与去广告：NextDNS ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-nextdns-zh-cn"

# ---------- DNS 与去广告：SmartDNS ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-smartdns-zh-cn"

# ---------- 文件与共享：文件管理器 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES bash quickfile luci-app-quickfile luci-i18n-quickfile-zh-cn"

# ---------- 远程与穿透：Cloudflare 隧道 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-cloudflared-zh-cn"

# ---------- 远程与穿透：Lucky 内网穿透 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-lucky lucky luci-i18n-lucky-zh-cn"

# ---------- 远程与穿透：SSH 隧道 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-sshtunnel-zh-cn"

# ---------- 远程与穿透：WireGuard ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-proto-wireguard"

# ---------- 系统工具：ACME 证书 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-acme-zh-cn"

# ---------- 系统工具：IP 黑名单 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-banip-zh-cn"

# ---------- 系统工具：Run 安装器 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-run"

# ---------- 系统工具：UPnP 端口映射 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-upnp-zh-cn"

# ---------- 系统工具：流量看板 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES bandix luci-app-bandix luci-i18n-bandix-zh-cn"

# ---------- 系统工具：流量统计 (statistics) ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-statistics-zh-cn"

# ---------- 系统工具：网页终端 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-ttyd-zh-cn"

# ---------- 仓库里的其他软件：802.1x 认证 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-cd8021x-zh-cn"

# ---------- 仓库里的其他软件：KMS 激活 ----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-vlmcsd-zh-cn"

# 最终一共 48 个包
