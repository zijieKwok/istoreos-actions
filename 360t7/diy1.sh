#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
# echo -e "\nsrc-git Jaykwok2999 https://github.com/zijieKwok/jaykwok-ipk" >> feeds.conf.default
# Add feed sources
echo 'src-git store https://github.com/linkease/istore;main' >>feeds.conf.default
echo 'src-git linkease_nas https://github.com/linkease/nas-packages.git;master' >>feeds.conf.default
echo 'src-git linkease_nas_luci https://github.com/linkease/nas-packages-luci.git;main' >>feeds.conf.default
