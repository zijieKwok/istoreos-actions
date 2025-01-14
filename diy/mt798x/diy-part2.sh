#!/bin/bash
#=================================================
# DaoDao's script
#=================================================             


##
echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

#echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
#echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

#echo -e "\nmsgid \"VPN\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
#echo -e "msgstr \"魔法网络\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

##配置IP
sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.2.1/g' package/base-files/files/bin/config_generate

##
# rm -rf ./feeds/extraipk/theme/luci-theme-argon-18.06
# rm -rf ./feeds/extraipk/theme/luci-app-argon-config-18.06
# rm -rf ./feeds/extraipk/theme/luci-theme-design
# rm -rf ./feeds/extraipk/theme/luci-theme-edge
# rm -rf ./feeds/extraipk/theme/luci-theme-ifit
# rm -rf ./feeds/extraipk/theme/luci-theme-opentopd
# rm -rf ./feeds/extraipk/theme/luci-theme-neobird

# rm -rf ./package/feeds/extraipk/luci-theme-argon-18.06
# rm -rf ./package/feeds/extraipk/luci-app-argon-config-18.06
# rm -rf ./package/feeds/extraipk/theme/luci-theme-design
# rm -rf ./package/feeds/extraipk/theme/luci-theme-edge
# rm -rf ./package/feeds/extraipk/theme/luci-theme-ifit
# rm -rf ./package/feeds/extraipk/theme/luci-theme-opentopd
# rm -rf ./package/feeds/extraipk/theme/luci-theme-neobird


##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

##更改主机名
sed -i "s/hostname='.*'/hostname='iStoreOS'/g" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='TP-Link_TL-XDR6086-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
##加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release
cp -af feeds/Jaykwok2999/patch/diy/banner  package/base-files/files/etc/banner

sed -i "2iuci set istore.istore.channel='istoreos_jaykwok'" package/emortal/default-settings/files/99-default-settings
sed -i "3iuci commit istore" package/emortal/default-settings/files/99-default-settings


##WiFi
# sed -i "s/MT7986_AX6000_2.4G/ImmortalWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
# sed -i "s/MT7986_AX6000_5G/ImmortalWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat

# sed -i "s/MT7981_AX3000_2.4G/ImmortalWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
# sed -i "s/MT7981_AX3000_5G/ImmortalWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat

##New WiFi
# sed -i "s/ImmortalWrt-2.4G/ImmortalWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
# sed -i "s/ImmortalWrt-5G/ImmortalWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh


##更新FQ
# rm -rf feeds/luci/applications/luci-app-passwall/*
# cp -af feeds/Jaykwok2999/patch/wall-luci/luci-app-passwall/*  feeds/luci/applications/luci-app-passwall/

# rm -rf feeds/luci/applications/luci-app-ssr-plus/*
# cp -af feeds/Jaykwok2999/patch/wall-luci/luci-app-ssr-plus/*  feeds/luci/applications/luci-app-ssr-plus/

# rm -rf feeds/luci/applications/luci-app-openclash/*
# cp -af feeds/Jaykwok2999/patch/wall-luci/luci-app-openclash/*  feeds/luci/applications/luci-app-openclash/


##MosDNS
# rm -rf feeds/packages/net/mosdns/*
# cp -af feeds/Jaykwok2999/op-mosdns/mosdns/* feeds/packages/net/mosdns/
rm -rf feeds/packages/net/v2ray-geodata/*
cp -af feeds/Jaykwok2999/op-mosdns/v2ray-geodata/* feeds/packages/net/v2ray-geodata/

##Adblock
# rm -rf feeds/luci/applications/luci-app-adblock/*
# cp -af feeds/Jaykwok2999/luci-app-adblock/*  feeds/luci/applications/luci-app-adblock/

##FQ全部调到VPN菜单
