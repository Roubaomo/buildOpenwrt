#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 添加luci-lib-fs
#echo "src-git corelabs https://github.com/core-labs/openwrt-feeds.git" >> feeds.conf.default

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# 添加OpenClash
# echo src-git openclash https://github.com/vernesong/OpenClash.git >> feeds.conf.default

# 添加PassWall
# echo src-git passwall https://github.com/xiaorouji/openwrt-passwall-packages.git >> feeds.conf.default
