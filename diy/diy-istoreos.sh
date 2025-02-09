#!/bin/bash

# 修改默认IP
sed -i 's/192.168.100.1/192.168.2.1/g' package/istoreos-files/Makefile

# profile
# sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
# sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
# sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
# sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
# sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
# sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# 修改默认密码
sed -i 's/root:::0:99999:7:::/root:$1$5mjCdAB1$Uk1sNbwoqfHxUmzRIeuZK1:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# uwsgi
# sed -i 's,procd_set_param stderr 1,procd_set_param stderr 0,g' feeds/packages/net/uwsgi/files/uwsgi.init
# sed -i 's,buffer-size = 10000,buffer-size = 131072,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# sed -i 's,logger = luci,#logger = luci,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# sed -i '$a cgi-timeout = 600' feeds/packages/net/uwsgi/files-luci-support/luci-*.ini
# sed -i 's/threads = 1/threads = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# sed -i 's/processes = 3/processes = 4/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# sed -i 's/cheaper = 1/cheaper = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini

# rpcd
# sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
# sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# mwan3
sed -i 's/MultiWAN 管理器/负载均衡/g' feeds/luci/applications/luci-app-mwan3/po/zh_Hans/mwan3.po

# samba4
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json

# linkease调至NAS
sed -i 's/services/nas/g' feeds/nas-packages-luci/luci/luci-app-linkease/luasrc/controller/linkease.lua
sed -i 's/services/nas/g' feeds/nas-packages-luci/luci/luci-app-linkease/luasrc/view/linkease_status.htm

# 修改FileBrowser
sed -i 's/msgstr "FileBrowser"/msgstr "文件浏览器"/g' feeds/istoreos_ipk/op-fileBrowser/luci-app-filebrowser/po/zh_Hans/filebrowser.po
sed -i 's/services/nas/g' feeds/istoreos_ipk/op-fileBrowser/luci-app-filebrowser/root/usr/share/luci/menu.d/luci-app-filebrowser.json

# HD磁盘工具调至NAS
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json

# 修改socat为端口转发
sed -i 's/msgstr "Socat"/msgstr "端口转发"/g' feeds/third_party/luci-app-socat/po/zh-cn/socat.po

##加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='iStoreOS-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release

# 移除要替换的包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome}
rm -rf feeds/packages/net/alist feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/third_party/luci-app-LingTiGameAcc
rm -rf feeds/istoreos_ipk/op-daed
rm -rf feeds/third/luci-theme-argon
rm -rf feeds/istoreos_ipk/tailscale/tailscale

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# golong1.23依赖
rm -rf feeds/packages/lang/golang
# git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
git clone https://git.kejizero.online/zhao/packages_lang_golang -b 23.x feeds/packages/lang/golang

# SSRP & Passwall
git clone https://git.kejizero.online/zhao/openwrt_helloworld.git package/helloworld -b v5
rm -rf package/helloworld/luci-app-openclash

# Alist
git clone https://git.kejizero.online/zhao/luci-app-alist package/alist

# Mosdns
# git clone https://git.kejizero.online/zhao/luci-app-mosdns.git -b v5 package/mosdns
# git clone https://git.kejizero.online/zhao/v2ray-geodata.git package/v2ray-geodata

# 锐捷认证
git clone https://github.com/sbwml/luci-app-mentohust package/mentohust

# Adguardhome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome

# default-settings
# git clone --depth=1 -b dev https://github.com/oppen321/default-settings package/default-settings

# UPnP
rm -rf feeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://git.kejizero.online/zhao/miniupnpd feeds/packages/net/miniupnpd -b v2.3.7
git clone https://git.kejizero.online/zhao/luci-app-upnp feeds/luci/applications/luci-app-upnp -b master

# Lucky
# git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# luci-app-webdav
git clone https://git.kejizero.online/zhao/luci-app-webdav package/new/luci-app-webdav

# unzip
rm -rf feeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# frpc名称
sed -i 's,发送,Transmission,g' feeds/luci/applications/luci-app-transmission/po/zh_Hans/transmission.po
sed -i 's,frp 服务器,frps 服务器,g' feeds/luci/applications/luci-app-frps/po/zh_Hans/frps.po
sed -i 's,frp 客户端,frpc 客户端,g' feeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po

# 必要的补丁
# pushd feeds/luci
#     curl -s https://raw.githubusercontent.com/oppen321/path/refs/heads/main/Firewall/0001-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
# popd

# NTP
sed -i 's/0.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp2.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/time2.cloud.tencent.com/g' package/base-files/files/bin/config_generate

# 更改 banner
rm -rf package/base-files/files/etc/banner
cp -af feeds/istoreos_ipk/patch/diy/banner package/base-files/files/etc/

# 更改内核
# rm -rf include/kernel-6.6
# cp -af feeds/istoreos_ipk/patch/diy/include/6.6.73/kernel-6.6 include/

# tailscale
# rm -rf feeds/packages/net/tailscale/*
# cp -af feeds/istoreos_ipk/tailscale/tailscale/*  feeds/packages/net/tailscale/
sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile

# 增加驱动补丁
# cp -af feeds/istoreos_ipk/patch/diy/patches-6.6/993-bnx2x_warpcore_8727_2_5g_sgmii_txfault.patch target/linux/x86/patches-6.6/
# cp -af feeds/istoreos_ipk/patch/diy/patches-6.6/996-intel-igc-i225-i226-disable-eee.patch target/linux/x86/patches-6.6/

./scripts/feeds update -a
./scripts/feeds install -a
