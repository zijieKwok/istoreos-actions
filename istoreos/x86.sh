#!/bin/bash

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 输出颜色信息
echo -e "${GREEN}开始设置环境并更新系统...${NC}"

# 设置环境并更新系统
sudo apt-get install -y curl
sudo rm -rf /etc/apt/sources.list.d
sudo bash -c "curl -skL https://git.kejizero.online/zhao/files/raw/branch/main/Rely/sources-24.04.list > /etc/apt/sources.list"
sudo apt-get update

# 安装依赖包
echo -e "${BLUE}安装所需的依赖包...${NC}"
sudo apt-get install -y build-essential flex bison cmake g++ gawk gcc-multilib g++-multilib gettext git gnutls-dev \
  libfuse-dev libncurses5-dev libssl-dev python3 python3-pip python3-ply python3-pyelftools rsync unzip zlib1g-dev \
  file wget subversion patch upx-ucl autoconf automake curl asciidoc binutils bzip2 lib32gcc-s1 libc6-dev-i386 uglifyjs \
  msmtp texinfo libreadline-dev libglib2.0-dev xmlto libelf-dev libtool autopoint antlr3 gperf ccache swig coreutils \
  haveged scons libpython3-dev rename qemu-utils jq

# 清理 apt 缓存
sudo apt-get clean

# 克隆 OpenWrt 源码
echo -e "${YELLOW}克隆 OpenWrt 源码...${NC}"
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/openwrt/openwrt

# 更新 feeds 并安装
cd openwrt || exit
echo -e "${GREEN}更新并安装 feeds...${NC}"
./scripts/feeds update -a
./scripts/feeds install -a

# 修改默认IP
echo -e "${YELLOW}修改默认IP${NC}"
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# profile
echo -e "${YELLOW}profile${NC}"
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# TTYD
echo -e "${YELLOW}TTYD${NC}"
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# bash
echo -e "${YELLOW}Bash${NC}"
sed -i 's#ash#bash#g' package/base-files/files/etc/passwd
sed -i '\#export ENV=/etc/shinit#a export HISTCONTROL=ignoredups' package/base-files/files/etc/profile
mkdir -p files/root
curl -so files/root/.bash_profile https://git.kejizero.online/zhao/files/raw/branch/main/root/.bash_profile
curl -so files/root/.bashrc https://git.kejizero.online/zhao/files/raw/branch/main/root/.bashrc

# Nginx
echo -e "${YELLOW}Nginx${NC}"
sed -i "s/large_client_header_buffers 2 1k/large_client_header_buffers 4 32k/g" feeds/packages/net/nginx-util/files/uci.conf.template
sed -i "s/client_max_body_size 128M/client_max_body_size 2048M/g" feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/client_max_body_size/a\\tclient_body_buffer_size 8192M;' feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/client_max_body_size/a\\tserver_names_hash_bucket_size 128;' feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 600;' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -ri "/luci-webui.socket/i\ \t\tuwsgi_send_timeout 600\;\n\t\tuwsgi_connect_timeout 600\;\n\t\tuwsgi_read_timeout 600\;" feeds/packages/net/nginx/files-luci-support/luci.locations
sed -ri "/luci-cgi_io.socket/i\ \t\tuwsgi_send_timeout 600\;\n\t\tuwsgi_connect_timeout 600\;\n\t\tuwsgi_read_timeout 600\;" feeds/packages/net/nginx/files-luci-support/luci.locations

# uwsgi
echo -e "${YELLOW}uwsgi${NC}"
sed -i 's,procd_set_param stderr 1,procd_set_param stderr 0,g' feeds/packages/net/uwsgi/files/uwsgi.init
sed -i 's,buffer-size = 10000,buffer-size = 131072,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's,logger = luci,#logger = luci,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i '$a cgi-timeout = 600' feeds/packages/net/uwsgi/files-luci-support/luci-*.ini
sed -i 's/threads = 1/threads = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/processes = 3/processes = 4/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/cheaper = 1/cheaper = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini

# rpcd
echo -e "${YELLOW}rpcd${NC}"
sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# mwan3
echo -e "${YELLOW}负载均衡${NC}"
sed -i 's/MultiWAN 管理器/负载均衡/g' feeds/luci/applications/luci-app-mwan3/po/zh_Hans/mwan3.po

##加入作者信息
echo -e "${YELLOW}加入作者信息${NC}"
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By JayKwok'/g" package/base-files/files/etc/openwrt_release

# 更换为 ImmortalWrt Uboot 以及 Target
echo -e "${YELLOW}更换为 ImmortalWrt Uboot 以及 Target${NC}"
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt immortalwrt
rm -rf ./target/linux/rockchip
cp -rf immortalwrt/target/linux/rockchip target/linux/rockchip
curl -L -o target/linux/rockchip/patches-6.6/014-rockchip-add-pwm-fan-controller-for-nanopi-r2s-r4s.patch https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/PATCH/kernel/rockchip/014-rockchip-add-pwm-fan-controller-for-nanopi-r2s-r4s.patch
curl -L -o target/linux/rockchip/patches-6.6/702-general-rk3328-dtsi-trb-ent-quirk.patch https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/PATCH/kernel/rockchip/702-general-rk3328-dtsi-trb-ent-quirk.patch
curl -L -o target/linux/rockchip/patches-6.6/703-rk3399-enable-dwc3-xhci-usb-trb-quirk.patch https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/PATCH/kernel/rockchip/703-rk3399-enable-dwc3-xhci-usb-trb-quirk.patch
curl -L -o target/linux/rockchip/patches-6.6/991-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch https://github.com/immortalwrt/immortalwrt/raw/refs/heads/openwrt-23.05/target/linux/rockchip/patches-5.15/991-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch
rm -rf package/boot/{rkbin,uboot-rockchip,arm-trusted-firmware-rockchip}
cp -rf immortalwrt/package/boot/uboot-rockchip package/boot/uboot-rockchip
cp -rf immortalwrt/package/boot/arm-trusted-firmware-rockchip package/boot/arm-trusted-firmware-rockchip
sed -i '/REQUIRE_IMAGE_METADATA/d' target/linux/rockchip/armv8/base-files/lib/upgrade/platform.sh
rm -rf immortalwrt

# Patch arm64 型号名称
echo -e "${YELLOW}arm64 型号名称${NC}"
curl -L -o target/linux/generic/hack-6.6/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/PATCH/kernel/arm/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch

# 移除要替换的包
echo -e "${YELLOW}移除要替换的包${NC}"
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,socat}
rm -rf feeds/packages/net/alist feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang

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
echo -e "${YELLOW}golong1.23依赖${NC}"
#git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
git clone https://git.kejizero.online/zhao/packages_lang_golang -b 23.x feeds/packages/lang/golang

# SSRP & Passwall
echo -e "${YELLOW}SSRP & Passwall${NC}"
git clone https://git.kejizero.online/zhao/openwrt_helloworld.git package/helloworld -b v5

# Alist
echo -e "${YELLOW}Alist${NC}"
git clone https://git.kejizero.online/zhao/luci-app-alist package/alist

# Mosdns
echo -e "${YELLOW}Mosdns${NC}"
git clone https://git.kejizero.online/zhao/luci-app-mosdns.git -b v5 package/mosdns
git clone https://git.kejizero.online/zhao/v2ray-geodata.git package/v2ray-geodata

# 锐捷认证
echo -e "${YELLOW}锐捷认证${NC}"
git clone https://github.com/sbwml/luci-app-mentohust package/mentohust

# Realtek 网卡 - R8168 & R8125 & R8126 & R8152 & R8101
echo -e "${YELLOW}Realtek 网卡 - R8168 & R8125 & R8126 & R8152 & R8101${NC}"
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone https://git.kejizero.online/zhao/package_kernel_r8168 package/kernel/r8168
git clone https://git.kejizero.online/zhao/package_kernel_r8152 package/kernel/r8152
git clone https://git.kejizero.online/zhao/package_kernel_r8101 package/kernel/r8101
git clone https://git.kejizero.online/zhao/package_kernel_r8125 package/kernel/r8125
git clone https://git.kejizero.online/zhao/package_kernel_r8126 package/kernel/r8126

# Adguardhome
echo -e "${YELLOW}Adguardhome${NC}"
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome

# iStore
echo -e "${YELLOW}iStore${NC}"
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# Docker
echo -e "${YELLOW}Docker${NC}"
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://git.kejizero.online/zhao/luci-app-dockerman -b 24.10 feeds/luci/applications/luci-app-dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://git.kejizero.online/zhao/packages_utils_docker feeds/packages/utils/docker
git clone https://git.kejizero.online/zhao/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://git.kejizero.online/zhao/packages_utils_containerd feeds/packages/utils/containerd
git clone https://git.kejizero.online/zhao/packages_utils_runc feeds/packages/utils/runc
sed -i '/sysctl.d/d' feeds/packages/utils/dockerd/Makefile
pushd feeds/packages
    curl -s https://init.cooluc.com/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch | patch -p1
    curl -s https://init.cooluc.com/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch | patch -p1
    curl -s https://init.cooluc.com/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch | patch -p1
popd

# UPnP
echo -e "${YELLOW}UPnP${NC}"
rm -rf feeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://git.kejizero.online/zhao/miniupnpd feeds/packages/net/miniupnpd -b v2.3.7
git clone https://git.kejizero.online/zhao/luci-app-upnp feeds/luci/applications/luci-app-upnp -b master

# Zero-package
echo -e "${YELLOW}Zero-package${NC}"
git clone --depth=1 https://github.com/oppen321/Zero-package package/Zero-package

# 一键配置拨号
echo -e "${YELLOW}一键配置拨号${NC}"
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard package/luci-app-netwizard

# 修改名称
echo -e "${YELLOW}修改名称${NC}"
sed -i 's/OpenWrt/iStoreOS/' package/base-files/files/bin/config_generate

# Theme
echo -e "${YELLOW}Theme${NC}"
git clone https://github.com/sirpdboy/luci-theme-kucat package/luci-theme-kucat -b js

# default-settings
echo -e "${YELLOW}default-settings${NC}"
git clone --depth=1 -b main https://github.com/oppen321/default-settings package/default-settings

# Lucky
echo -e "${YELLOW}Lucky${NC}"
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# OpenAppFilter
echo -e "${YELLOW}OpenAppFilter${NC}"
git clone https://git.kejizero.online/zhao/OpenAppFilter --depth=1 package/OpenAppFilter

# luci-app-partexp
echo -e "${YELLOW}luci-app-partexp${NC}"
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp

# 进阶设置
echo -e "${YELLOW}进阶设置${NC}"
git clone https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus

# luci-app-webdav
echo -e "${YELLOW}luci-app-webdav${NC}"
git clone https://git.kejizero.online/zhao/luci-app-webdav package/new/luci-app-webdav

# unzip
echo -e "${YELLOW}unzip${NC}"
rm -rf feeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# frpc名称
echo -e "${YELLOW}frpc名称${NC}"
sed -i 's,发送,Transmission,g' feeds/luci/applications/luci-app-transmission/po/zh_Hans/transmission.po
sed -i 's,frp 服务器,FRP 服务器,g' feeds/luci/applications/luci-app-frps/po/zh_Hans/frps.po
sed -i 's,frp 客户端,FRP 客户端,g' feeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po

# 必要的补丁
echo -e "${YELLOW}必要的补丁${NC}"
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/oppen321/path/refs/heads/main/Firewall/0001-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

# NTP
echo -e "${YELLOW}NTP${NC}"
sed -i 's/0.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp2.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/time2.cloud.tencent.com/g' package/base-files/files/bin/config_generate

# ZeroWrt选项菜单
echo -e "${YELLOW}iStoreOS选项菜单${NC}"
mkdir -p files/bin
curl -L -o files/bin/ZeroWrt https://git.kejizero.online/zhao/files/raw/branch/main/bin/ZeroWrt
chmod +x files/bin/ZeroWrt
mkdir -p files/root
curl -L -o files/root/version.txt https://git.kejizero.online/zhao/files/raw/branch/main/bin/version.txt
chmod +x files/root/version.txt

# Adguardhome设置
echo -e "${YELLOW}Adguardhome设置${NC}"
mkdir -p files/etc
curl -L -o files/etc/AdGuardHome-dnslist.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-dnslist.yaml
chmod +x files/etc/AdGuardHome-dnslist.yaml
curl -L -o files/etc/AdGuardHome-mosdns.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-mosdns.yaml
chmod +x files/etc/AdGuardHome-mosdns.yaml

# Nginx
echo -e "${YELLOW}Nginx${NC}"
mkdir -p files/etc/config
curl -L -o files/etc/config/nginx https://git.kejizero.online/zhao/files/raw/branch/main/etc/nginx/nginx

./scripts/feeds update -a
./scripts/feeds install -a

# 加载 .config
echo -e "${YELLOW}加载 .config${NC}"
echo -e "${YELLOW}加载自定义配置...${NC}"
curl -skL https://raw.githubusercontent.com/zijieKwok/istoreos-actions/refs/heads/main/.config -o .config

# 生成默认配置
echo -e "${GREEN}生成默认配置...${NC}"
make defconfig

# 编译 ZeroWrt
echo -e "${BLUE}开始编译 iStoreOS...${NC}"
echo -e "${YELLOW}使用所有可用的 CPU 核心进行并行编译...${NC}"
make -j$(nproc) || \
  echo -e "${RED}并行编译失败，回退到单核编译...${NC}" && make -j1 || \
  echo -e "${RED}单核编译失败，启用详细输出调试...${NC}" && make -j1 V=s
  
# 输出编译完成的固件路径
echo -e "${GREEN}编译完成！固件已生成至：${NC} bin/targets"
