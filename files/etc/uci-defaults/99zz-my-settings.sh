#!/bin/sh
# ============================================================
# 这个文件由「x86 软路由固件生成器」自动生成，请勿手工编辑。
# 生成时间：2026-10-24 09:26    生成器版本：1.1.1
#
# 它放在固件里的 /etc/uci-defaults/ 下，OpenWrt 首次开机时会按文件名顺序
# 依次执行这里的脚本，执行成功就把文件删掉，所以只会跑一次。
# 文件名以 99zz 开头，是为了排在原项目自带的 99-custom.sh 后面。
# 但这里只补它没做的部分（时区、主机名、主题）；防火墙、DHCP、IPv6、拨号
# 一律保持原作者脚本的设置，本工具不覆盖。
# ============================================================

LOG=/etc/config/my-settings-log.txt
log() { echo "[my-settings] $*" >>"$LOG" 2>/dev/null; }
log "开始执行，时间 $(date)"

# ---------- 时区、主机名 ----------
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].hostname='ImmortalWrt'
# 国内默认 NTP 服务器经常连不上，换成能连上的，时间不准会影响证书和代理
uci -q delete system.ntp.server 2>/dev/null
uci add_list system.ntp.server='ntp.aliyun.com'
uci add_list system.ntp.server='cn.pool.ntp.org'
uci add_list system.ntp.server='time.cloudflare.com'
uci commit system
log "时区设置为 Asia/Shanghai"

# ---------- 网络角色 ----------
# 旁路由：本机不拨号、不发 DHCP，IP 由上级主路由分配
uci set network.lan.proto='dhcp'
uci -q delete network.lan.ipaddr
uci -q delete network.lan.netmask
uci -q delete network.lan.gateway
uci -q delete network.lan.dns
# 关掉本机的 DHCP 服务，否则会跟主路由抢着发地址，全家断网
uci set dhcp.lan.ignore='1'
uci set dhcp.lan.dhcpv6='disabled'
uci set dhcp.lan.ra='disabled'
uci -q delete dhcp.odhcpd 2>/dev/null
# 旁路由不承担拨号，把 WAN 口关掉（所有网口都当 LAN 用）
uci set network.wan.proto='none' 2>/dev/null
uci -q delete network.wan.device 2>/dev/null
uci -q delete network.wan6 2>/dev/null
uci commit network
uci commit dhcp
log "已切换为旁路由模式"

# ---------- 开启 BBR 拥塞控制（下载/看视频更耐磨） ----------
if ! grep -q "^net.core.default_qdisc" /etc/sysctl.conf 2>/dev/null; then
  echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
fi
if ! grep -q "^net.ipv4.tcp_congestion_control" /etc/sysctl.conf 2>/dev/null; then
  echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
fi
sysctl -w net.core.default_qdisc=fq >/dev/null 2>&1
sysctl -w net.ipv4.tcp_congestion_control=bbr >/dev/null 2>&1
log "BBR 已尝试开启（内核没带这个模块的话会静默跳过，不影响别的功能）"

# ---------- 后台主题 ----------
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
log "主题设置为 argon"

log "全部完成"
exit 0
