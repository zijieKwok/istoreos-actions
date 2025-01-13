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

# 修改openwrt登陆地址,把下面的 192.168.10.1 修改成你想要的就可以了
sed -i 's/192.168.100.1/192.168.2.1/g' package/base-files/files/bin/config_generate
# rm -rf ./feeds/extraipk/theme
# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release
sed -i 's/fw0.koolcenter.com/ota.5588999.xyz/g' package/diy/luci-app-ota/root/bin/ota
rm -rf target/linux/x86/patches-6.6
cp -af istoreos/patches-6.6 target/linux/x86
rm -rf feeds/linkease_nas_luci/luci/luci-app-quickstart/htdocs/luci-static/quickstart/index.js
cp -af istoreos/index.js feeds/linkease_nas_luci/luci/luci-app-quickstart/htdocs/luci-static/quickstart/
rm -rf package/base-files/files/etc/banner
cp -af feeds/Jaykwok2999/patch/diy/banner  package/base-files/files/etc/banner
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang


##更新FQ
rm -rf feeds/packages/net/tailscale/*
cp -af istoreos/tailscale/*  feeds/packages/net/tailscale/
sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile
# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config

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
