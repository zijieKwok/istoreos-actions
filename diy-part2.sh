#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改iStoreOS登陆ip,把下面的 192.168.100.1 修改成192.168.2.1
# sed -i 's/192.168.100.1/192.168.2.1/g' package/istoreos-files/Makefile
rm -rf feeds/third_party/luci-app-LingTiGameAcc
# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release
# rm -rf package/diy/luci-app-ota/root/bin/ota
# cp -af feeds/istoreos_ipk/patch/diy/ota package/diy/luci-app-ota/root/bin/
# rm -rf package/base-files/files/etc/banner
# cp -af feeds/istoreos_ipk/patch/diy/banner package/base-files/files/etc/
# rm -rf feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# cp -af feeds/istoreos_ipk/patch/diy/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/
# rm -rf package/base-files/files/etc/passwd
# cp -af feeds/istoreos_ipk/patch/diy/passwd package/base-files/files/etc/
# rm -rf package/base-files/files/etc/shadow
# cp -af feeds/istoreos_ipk/patch/diy/shadow package/base-files/files/etc/


##更新tailscale
# rm -rf feeds/packages/net/tailscale/*
# cp -af feeds/istoreos_ipk/tailscale/tailscale/*  feeds/packages/net/tailscale/
# sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile
# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config


##带sfe:turboacc替换firewall4、libnftnl、nftables并打上952、613、953补丁
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

##MosDNS
# rm -rf feeds/packages/net/mosdns/*
# cp -af feeds/istoreos_ipk/op-mosdns/mosdns/* feeds/packages/net/mosdns/
# rm -rf feeds/istoreos_ipk/net/v2ray-geodata/*
# cp -af feeds/istoreos_ipk/op-mosdns/v2ray-geodata/* feeds/packages/net/v2ray-geodata/

# rm -rf feeds/luci/applications/luci-app-openclash/*
# cp -af feeds/istoreos_ipk/patch/wall-luci/luci-app-openclash/*  feeds/luci/applications/luci-app-openclash/

# 添加自定义软件包
# echo '
# CONFIG_PACKAGE_luci-app-mosdns=y
# CONFIG_PACKAGE_luci-app-adguardhome=y
# CONFIG_PACKAGE_luci-app-openclash=y
# ' >> .config
