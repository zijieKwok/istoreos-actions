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
sed -i 's/192.168.100.1/192.168.2.1/g' package/istoreos-files/Makefile

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release
# sed -i 's/fw0.koolcenter.com/ota.5588999.xyz/g' package/diy/luci-app-ota/root/bin/ota
# rm -rf feeds/Jaykwok2999/luci-app-bypass
# rm -rf feeds/third_party/luci-app-LingTiGameAcc
# rm -rf feeds/Jaykwok2999/luci-app-ssr-plus
# rm -rf feeds/Jaykwok2999/luci-app-turboacc
# rm -rf target/linux/x86/patches-6.6/*
# cp -af $GITHUB_WORKSPACE/istoreos/patches-6.6/* target/linux/x86/patches-6.6/
rm -rf feeds/linkease_nas_luci/luci/luci-app-quickstart/htdocs/luci-static/quickstart/index.js
cp -af $GITHUB_WORKSPACE/istoreos/index.js feeds/linkease_nas_luci/luci/luci-app-quickstart/htdocs/luci-static/quickstart/
rm -rf package/base-files/files/etc/banner
cp -af feeds/Jaykwok2999/patch/diy/banner package/base-files/files/etc/
rm -rf feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -af $GITHUB_WORKSPACE/istoreos/files/www/luci-static/argon/background/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/
rm -rf package/base-files/files/etc/passwd
cp -af $GITHUB_WORKSPACE/istoreos/passwd package/base-files/files/etc/
rm -rf package/base-files/files/etc/shadow
cp -af $GITHUB_WORKSPACE/istoreos/shadow package/base-files/files/etc/
# rm -rf feeds/packages/lang/golang/*
# cp -af $GITHUB_WORKSPACE/istoreos/golang/* feeds/packages/lang/golang/


##更新tailscale
# rm -rf feeds/packages/net/tailscale/*
# cp -af $GITHUB_WORKSPACE/istoreos/tailscale/*  feeds/packages/net/tailscale/
sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile
# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config


##带sfe:turboacc替换firewall4、libnftnl、nftables并打上952、613、953补丁
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

##MosDNS
# rm -rf feeds/packages/net/mosdns/*
# cp -af feeds/Jaykwok2999/op-mosdns/mosdns/* feeds/packages/net/mosdns/
# rm -rf feeds/Jaykwok2999/net/v2ray-geodata/*
# cp -af feeds/Jaykwok2999/op-mosdns/v2ray-geodata/* feeds/packages/net/v2ray-geodata/

# rm -rf feeds/luci/applications/luci-app-openclash/*
# cp -af feeds/Jaykwok2999/patch/wall-luci/luci-app-openclash/*  feeds/luci/applications/luci-app-openclash/

# 添加自定义软件包
# echo '
# CONFIG_PACKAGE_luci-app-mosdns=y
# CONFIG_PACKAGE_luci-app-adguardhome=y
# CONFIG_PACKAGE_luci-app-openclash=y
# ' >> .config
