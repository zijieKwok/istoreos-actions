#!/bin/bash

# ZeroWrt选项菜单
mkdir -p files/bin
curl -L -o files/bin/ZeroWrt https://git.kejizero.online/zhao/files/raw/branch/main/bin/ZeroWrt
chmod +x files/bin/ZeroWrt
mkdir -p files/root
curl -L -o files/root/version.txt https://git.kejizero.online/zhao/files/raw/branch/main/bin/version.txt
chmod +x files/root/version.txt

# Adguardhome设置
mkdir -p files/etc
curl -L -o files/etc/AdGuardHome-dnslist.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-dnslist.yaml
chmod +x files/etc/AdGuardHome-dnslist.yaml
curl -L -o files/etc/AdGuardHome-mosdns.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-mosdns.yaml
chmod +x files/etc/AdGuardHome-mosdns.yaml
curl -L -o files/etc/AdGuardHome-dns.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-dns.yaml
chmod +x files/etc/AdGuardHome-dns.yaml

# default_set
mkdir -p files/etc/config
curl -L -o files/etc/config/default_dhcp.conf https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_dhcp.conf
curl -L -o files/etc/config/default_mosdns https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_mosdns
curl -L -o files/etc/config/default_smartdns https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_smartdns
curl -L -o files/etc/config/default_AdGuardHome https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_AdGuardHome
curl -L -o files/etc/config/default_passwall https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_passwall
curl -L -o files/etc/config/default_openclash https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_openclash
chmod +x files/etc/config/default_dhcp.conf
chmod +x files/etc/config/default_mosdns
chmod +x files/etc/config/default_smartdns
chmod +x files/etc/config/default_AdGuardHome
chmod +x files/etc/config/default_passwall
chmod +x files/etc/config/default_openclash

# 更新default-settings
curl -L -o package/lean/default-settings/files/zzz-default-settings https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/zzz-default-settings
curl -L -o package/lean/default-settings/po/zh-cn/default.po https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default.po
