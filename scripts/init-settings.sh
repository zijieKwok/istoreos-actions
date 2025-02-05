#!/bin/sh

. /etc/os-release
. /lib/functions/uci-defaults.sh

# 设置默认密码
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# 设置默认主题为argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# 切换opkg源
sed -i 's,downloads.openwrt.org,mirrors.pku.edu.cn/openwrt,g' /etc/opkg/distfeeds.conf

# 设置LAN口DNS
uci set network.lan.dns='127.0.0.1'
uci commit network
/etc/init.d/network restart

# 默认wan口防火墙打开
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall

# 设置主机名映射，解决安卓原生TV首次连不上网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"
uci commit dhcp

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit

# Docker换源
uci add_list dockerd.globals.registry_mirrors="https://docker.m.daocloud.io"
uci commit dockerd

# Smartdns相关设置
uci set smartdns.@smartdns[0].prefetch_domain='1'
uci set smartdns.@smartdns[0].port='6053'
uci set smartdns.@smartdns[0].seconddns_port='5335'
uci set smartdns.@smartdns[0].seconddns_no_rule_addr='0'
uci set smartdns.@smartdns[0].seconddns_no_rule_nameserver='0'
uci set smartdns.@smartdns[0].seconddns_no_rule_ipuci set='0'
uci set smartdns.@smartdns[0].seconddns_no_rule_soa='0'
uci set smartdns.@smartdns[0].tcp_server='1'
uci set smartdns.@smartdns[0].rr_ttl='600'
uci set smartdns.@smartdns[0].seconddns_enabled='1'
uci set smartdns.@smartdns[0].server_name='smartdns-China'
uci set smartdns.@smartdns[0].seconddns_tcp_server='1'
uci set smartdns.@smartdns[0].seconddns_server_group='smartdns-Overseas'
uci set smartdns.@smartdns[0].rr_ttl_min='5'
uci set smartdns.@smartdns[0].seconddns_no_speed_check='0'
uci set smartdns.@smartdns[0].cache_size='190150'
uci set smartdns.@smartdns[0].serve_expired='0'
uci set smartdns.@smartdns[0].auto_set_dnsmasq='0'
uci set smartdns.@smartdns[0].ipv6_server='1'
uci set smartdns.@smartdns[0].dualstack_ip_selection='1'
uci set smartdns.@smartdns[0].force_aaaa_soa='0'
uci set smartdns.@smartdns[0].coredump='1'
uci set smartdns.@smartdns[0].speed_check_mode='tcp:443,tcp:80,ping'
uci set smartdns.@smartdns[0].resolve_local_hostnames='1'
uci set smartdns.@smartdns[0].seconddns_force_aaaa_soa='0'
uci set smartdns.@smartdns[0].enable_auto_update='0'
uci set smartdns.@smartdns[0].enabled='1'
uci set smartdns.@smartdns[0].bind_device='1'
uci set smartdns.@smartdns[0].cache_persist='1'
uci set smartdns.@smartdns[0].force_https_soa='0'
uci set smartdns.@smartdns[0].seconddns_no_dualstack_selection='0'
uci set smartdns.@smartdns[0].seconddns_no_cache='0'
uci add smartdns server
uci set smartdns.@server[0].enabled='1'
uci set smartdns.@server[0].type='udp'
uci set smartdns.@server[0].name='清华大学TUNA协会'
uci set smartdns.@server[0].ip='101.6.6.6'
uci set smartdns.@server[0].server_group='smartdns-China'
uci set smartdns.@server[0].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[1].enabled='1'
uci set smartdns.@server[1].type='udp'
uci set smartdns.@server[1].name='114'
uci set smartdns.@server[1].ip='114.114.114.114'
uci set smartdns.@server[1].server_group='smartdns-China'
uci set smartdns.@server[1].blacklist_ip='0'
uci set smartdns.@server[1].port='53'
uci add smartdns server
uci set smartdns.@server[2].enabled='1'
uci set smartdns.@server[2].type='udp'
uci set smartdns.@server[2].name='ail dns ipv4'
uci set smartdns.@server[2].ip='223.5.5.5'
uci set smartdns.@server[2].port='53'
uci set smartdns.@server[2].server_group='smartdns-China'
uci set smartdns.@server[2].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[3].enabled='1'
uci set smartdns.@server[3].name='Ali DNS'
uci set smartdns.@server[3].ip='https://dns.alidns.com/dns-query'
uci set smartdns.@server[3].type='https'
uci set smartdns.@server[3].no_check_certificate='0'
uci set smartdns.@server[3].server_group='smartdns-China'
uci set smartdns.@server[3].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[4].enabled='1'
uci set smartdns.@server[4].name='360 Secure DNS'
uci set smartdns.@server[4].type='https'
uci set smartdns.@server[4].no_check_certificate='0'
uci set smartdns.@server[4].server_group='smartdns-China'
uci set smartdns.@server[4].blacklist_ip='0'
uci set smartdns.@server[4].ip='https://doh.360.cn/dns-query'
uci add smartdns server
uci set smartdns.@server[5].enabled='1'
uci set smartdns.@server[5].name='DNSPod Public DNS+'
uci set smartdns.@server[5].ip='https://doh.pub/dns-query'
uci set smartdns.@server[5].type='https'
uci set smartdns.@server[5].no_check_certificate='0'
uci set smartdns.@server[5].server_group='smartdns-China'
uci set smartdns.@server[5].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[6].enabled='1'
uci set smartdns.@server[6].type='udp'
uci set smartdns.@server[6].name='baidu dns'
uci set smartdns.@server[6].ip='180.76.76.76'
uci set smartdns.@server[6].port='53'
uci set smartdns.@server[6].server_group='smartdns-China'
uci set smartdns.@server[6].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[7].enabled='1'
uci set smartdns.@server[7].type='udp'
uci set smartdns.@server[7].name='360dns'
uci set smartdns.@server[7].ip='101.226.4.6'
uci set smartdns.@server[7].port='53'
uci set smartdns.@server[7].server_group='smartdns-China'
uci set smartdns.@server[7].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[8].enabled='1'
uci set smartdns.@server[8].type='udp'
uci set smartdns.@server[8].name='dnspod'
uci set smartdns.@server[8].ip='119.29.29.29'
uci set smartdns.@server[8].port='53'
uci set smartdns.@server[8].blacklist_ip='0'
uci set smartdns.@server[8].server_group='smartdns-China'
uci add smartdns server
uci set smartdns.@server[9].enabled='1'
uci set smartdns.@server[9].name='Cloudflare-tls'
uci set smartdns.@server[9].ip='1.1.1.1'
uci set smartdns.@server[9].type='tls'
uci set smartdns.@server[9].server_group='smartdns-Overseas'
uci set smartdns.@server[9].exclude_default_group='0'
uci set smartdns.@server[9].blacklist_ip='0'
uci set smartdns.@server[9].no_check_certificate='0'
uci set smartdns.@server[9].port='853'
uci set smartdns.@server[9].spki_pin='GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg='
uci add smartdns server
uci set smartdns.@server[10].enabled='1'
uci set smartdns.@server[10].name='Google_DNS-tls'
uci set smartdns.@server[10].type='tls'
uci set smartdns.@server[10].server_group='smartdns-Overseas'
uci set smartdns.@server[10].exclude_default_group='0'
uci set smartdns.@server[10].blacklist_ip='0'
uci set smartdns.@server[10].no_check_certificate='0'
uci set smartdns.@server[10].port='853'
uci set smartdns.@server[10].ip='8.8.4.4'
uci set smartdns.@server[10].spki_pin='r/fTokourI3+um9Rws4XrHG6fWEmHpZ8iWnOUjzwwjQ='
uci add smartdns server
uci set smartdns.@server[11].enabled='1'
uci set smartdns.@server[11].name='Quad9-tls'
uci set smartdns.@server[11].ip='9.9.9.9'
uci set smartdns.@server[11].type='tls'
uci set smartdns.@server[11].server_group='smartdns-Overseas'
uci set smartdns.@server[11].exclude_default_group='0'
uci set smartdns.@server[11].blacklist_ip='0'
uci set smartdns.@server[11].no_check_certificate='0'
uci set smartdns.@server[11].port='853'
uci set smartdns.@server[11].spki_pin='/SlsviBkb05Y/8XiKF9+CZsgCtrqPQk5bh47o0R3/Cg='
uci add smartdns server
uci set smartdns.@server[12].enabled='1'
uci set smartdns.@server[12].name='quad9-ipv6'
uci set smartdns.@server[12].ip='2620:fe::fe'
uci set smartdns.@server[12].port='9953'
uci set smartdns.@server[12].type='udp'
uci set smartdns.@server[12].server_group='smartdns-Overseas'
uci set smartdns.@server[12].exclude_default_group='0'
uci set smartdns.@server[12].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[13].enabled='1'
uci set smartdns.@server[13].name='谷歌DNS'
uci set smartdns.@server[13].ip='https://dns.google/dns-query'
uci set smartdns.@server[13].type='https'
uci set smartdns.@server[13].no_check_certificate='0'
uci set smartdns.@server[13].server_group='smartdns-Overseas'
uci set smartdns.@server[13].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[14].enabled='1'
uci set smartdns.@server[14].name='Cloudflare DNS '
uci set smartdns.@server[14].ip='https://dns.cloudflare.com/dns-query'
uci set smartdns.@server[14].type='https'
uci set smartdns.@server[14].no_check_certificate='0'
uci set smartdns.@server[14].server_group='smartdns-Overseas'
uci set smartdns.@server[14].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[15].enabled='1'
uci set smartdns.@server[15].name='CIRA Canadian Shield DNS'
uci set smartdns.@server[15].ip='https://private.canadianshield.cira.ca/dns-query'
uci set smartdns.@server[15].type='https'
uci set smartdns.@server[15].no_check_certificate='0'
uci set smartdns.@server[15].server_group='smartdns-Overseas'
uci set smartdns.@server[15].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[16].enabled='1'
uci set smartdns.@server[16].name='Restena DNS'
uci set smartdns.@server[16].ip='https://kaitain.restena.lu/dns-query'
uci set smartdns.@server[16].type='https'
uci set smartdns.@server[16].no_check_certificate='0'
uci set smartdns.@server[16].server_group='smartdns-Overseas'
uci set smartdns.@server[16].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[17].enabled='1'
uci set smartdns.@server[17].name='Quad9 DNS'
uci set smartdns.@server[17].ip='https://dns.quad9.net/dns-query'
uci set smartdns.@server[17].type='https'
uci set smartdns.@server[17].no_check_certificate='0'
uci set smartdns.@server[17].server_group='smartdns-Overseas'
uci set smartdns.@server[17].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[18].enabled='1'
uci set smartdns.@server[18].name='CZ.NIC ODVR'
uci set smartdns.@server[18].ip='https://odvr.nic.cz/doh'
uci set smartdns.@server[18].type='https'
uci set smartdns.@server[18].no_check_certificate='0'
uci set smartdns.@server[18].server_group='smartdns-Overseas'
uci set smartdns.@server[18].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[19].enabled='1'
uci set smartdns.@server[19].name='AhaDNS-Spain'
uci set smartdns.@server[19].ip='https://doh.es.ahadns.net/dns-query '
uci set smartdns.@server[19].type='https'
uci set smartdns.@server[19].no_check_certificate='0'
uci set smartdns.@server[19].server_group='smartdns-Overseas'
uci set smartdns.@server[19].blacklist_ip='0'
uci commit smartdns
/etc/init.d/smartdns restart

# 自动设置 Dnsmasq
# uci set smartdns.@smartdns[0].auto_set_dnsmasq='1'
# /etc/init.d/smartdns restart

# Dnsmasq设置
uci set dhcp.@dnsmasq[0].cachesize='0'
uci commit dhcp
/etc/init.d/dnsmasq restart

### Adguardhome设置
uci set AdGuardHome.AdGuardHome.enabled='1'
uci set AdGuardHome.AdGuardHome.redirect='dnsmasq-upstream'
uci commit AdGuardHome
/etc/init.d/AdGuardHome restart

# 设置Adguardhome上游服务器
chmod +x /etc/AdGuardHome.yaml
# sed -i 's|- 223.5.5.5|- 127.0.0.1:6053|' /etc/AdGuardHome.yaml
# sed -i '/upstream_dns:/a\    - 127.0.0.1:5335' /etc/AdGuardHome.yaml
sed -i 's|upstream_dns_file: ""|upstream_dns_file: "/etc/AdGuardHome-dnslist.yaml"|' /etc/AdGuardHome.yaml
# 并行请求
sed -i 's/upstream_mode: .*/upstream_mode: parallel/' /etc/AdGuardHome.yaml
# 设置缓存
sed -i 's/cache_size: .*/cache_size: 0/' /etc/AdGuardHome.yaml
# 重启服务
/etc/init.d/AdGuardHome restart

### Passwall设置
uci set passwall.@global[0].dns_shunt='dnsmasq'
uci set passwall.@global[0].remote_dns='127.0.0.1:5553'
uci set passwall.@global[0].dns_mode='udp'
uci commit passwall
/etc/init.d/passwall restart

### OpenClash设置
# 禁用默认DNS配置
n=0
while [ "$n" -lt $(uci show openclash|grep -c "^openclash.@dns_servers\[[0-9]\{1,10\}\]=dns_servers") ]; do
  uci set openclash.@dns_servers[$n].enabled='0'
  n=$((n + 1))
done
# 设置DNS
uci add openclash dns_servers
uci set openclash.@dns_servers[-1].enabled='1'
uci set openclash.@dns_servers[-1].group='nameserver'
uci set openclash.@dns_servers[-1].type='udp'
uci set openclash.@dns_servers[-1].ip='127.0.0.1'
uci set openclash.@dns_servers[-1].port='5553'
uci add openclash dns_servers
uci set openclash.@dns_servers[-1].enabled='1'
uci set openclash.@dns_servers[-1].group='fallback'
uci set openclash.@dns_servers[-1].type='udp'
uci set openclash.@dns_servers[-1].ip='127.0.0.1'
uci set openclash.@dns_servers[-1].port='5553'
uci set openclash.config.enable_custom_dns='1'
# 模式设置
uci set openclash.config.en_mode='fake-ip-tun'
# 自定义上游DNS服务器
uci set openclash.config.enable_custom_dns='1'
# Fake-IP持久化
uci set openclash.config.store_fakeip='1'
# 启用Fake-IP 过滤器
uci set openclash.config.custom_fakeip_filter='1'
# 开启绕过服务器地址
uci set openclash.config.bypass_gateway_compatible='1'
# 禁用本地 DNS 劫持
uci set openclash.config.enable_redirect_dns='0'
# 开启 GeoIP MMDB 自动更新
uci set openclash.config.geoip_auto_update='1'
uci set openclash.config.geoip_update_week_time='*'  # 每周更新
uci set openclash.config.geoip_update_day_time='3'  # 每周的第 3 天（可以根据需求修改）
# 开启 GeoIP Dat 自动更新
uci set openclash.config.geo_auto_update='1'
uci set openclash.config.geo_update_week_time='*'  # 每周更新
uci set openclash.config.geo_update_day_time='1'  # 每周的第 1 天（可以根据需求修改）
# 开启 GeoSite 数据库自动更新
uci set openclash.config.geosite_auto_update='1'
uci set openclash.config.geosite_update_week_time='*'  # 每周更新
uci set openclash.config.geosite_update_day_time='4'  # 每周的第 4 天（可以根据需求修改）
# 启用大陆白名单订阅自动更新
uci set openclash.config.chnr_auto_update='1'  # 开启大陆白名单订阅自动更新
uci set openclash.config.chnr_update_week_time='*'  # 每周更新
uci set openclash.config.chnr_update_day_time='5'  # 每周的第 5 天（可以根据需求修改）
uci commit openclash

### 无线设置
# 删除现有无线配置
uci -q del wireless.default_radio2
uci -q del wireless.default_radio1
uci -q del wireless.default_radio0
uci -q del wireless.wifinet0
uci -q del wireless.wifinet1
uci -q del wireless.wifinet2

# 配置 5GHz 无线接口 (wifinet0)
uci -q set wireless.wifinet0=wifi-iface
uci -q set wireless.wifinet0.device='radio0'
uci -q set wireless.wifinet0.mode='ap'
uci -q set wireless.wifinet0.ssid='OpenWrt_5G'
uci -q set wireless.wifinet0.encryption='none'
uci -q set wireless.wifinet0.network='lan'

# 配置 5GHz 无线电 (radio0)
uci -q set wireless.radio0.htmode='VHT80'
uci -q set wireless.radio0.channel='36'   # 你可以选择合适的频道
uci -q set wireless.radio0.country='AU'   # 根据需要更改国家
uci -q set wireless.radio0.cell_density='3'
uci -q set wireless.radio0.disabled=0     # 启用 radio0

# 配置 2.4GHz 无线接口 (wifinet1)
uci -q set wireless.wifinet1=wifi-iface
uci -q set wireless.wifinet1.device='radio1'
uci -q set wireless.wifinet1.mode='ap'
uci -q set wireless.wifinet1.ssid='OpenWrt_2.4G'
uci -q set wireless.wifinet1.encryption='none'
uci -q set wireless.wifinet1.network='lan'

# 配置 2.4GHz 无线电 (radio1)
uci -q set wireless.radio1.htmode='HT40'
uci -q set wireless.radio1.channel='1'    # 你可以选择合适的频道
uci -q set wireless.radio1.country='AU'   # 根据需要更改国家
uci -q set wireless.radio1.cell_density='3'
uci -q set wireless.radio1.disabled=0     # 启用 radio1

# 提交更改并应用
uci commit wireless

exit 0
