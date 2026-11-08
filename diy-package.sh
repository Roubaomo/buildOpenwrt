#!/bin/bash
#=================================================
# Description: DIY script（合并版：fail2ban 引入 + vsftpd/udpxy/vlmcsd 汉化修补）
# Lisence: MIT
#=================================================

# ===== 引入 ImmortalWrt 的 fail2ban（LEDE/openwrt 官方源无此包）=====
# 注意：该包 Makefile 用相对路径 include ../../lang/python/python3-package.mk，
# 必须放进 feeds/packages/net/ 保持 feed 布局（拷到树内 package/ 会因路径断裂编译失败）
if [ ! -d feeds/packages/net/fail2ban ]; then
    rm -rf /tmp/immortalwrt-pkgs
    git clone --depth 1 --filter=blob:none --sparse https://github.com/immortalwrt/packages.git /tmp/immortalwrt-pkgs
    git -C /tmp/immortalwrt-pkgs sparse-checkout set net/fail2ban
    cp -r /tmp/immortalwrt-pkgs/net/fail2ban feeds/packages/net/
    rm -rf /tmp/immortalwrt-pkgs
    # fail2ban 1.1.0 的 setup.py 用了已被新版 setuptools 移除的 test_suite 关键字，
    # LEDE master 的 host setuptools 过新会报 AttributeError: check_test_suite，
    # 加 patch 删掉该行（ImmortalWrt 能编是因其 setuptools 版本旧）
    cat > feeds/packages/net/fail2ban/patches/030-remove-test-suite.patch <<'PATCH_EOF'
--- a/setup.py
+++ b/setup.py
@@ -171,7 +171,6 @@
 
 if setuptools:
 	setup_extra = {
-		'test_suite': "fail2ban.tests.utils.gatherTests",
 	}
 else:
 	setup_extra = {}
PATCH_EOF
    # 重建该 feed 索引：feeds update -a 时 fail2ban 还不存在，index 里没有，
    # 不重建则 install 找不到包、CONFIG_PACKAGE_fail2ban 被静默丢弃
    ./scripts/feeds update -i packages
    ./scripts/feeds install fail2ban
    echo "fail2ban package imported into feeds and installed"
fi

# ===== 把 host setuptools 钉回 68.2.2（openwrt 23.05 官方验证版本）=====
# LEDE master 自带 84.x，已移除 test_suite 关键字支持，fail2ban 1.1.0 编译必挂
# （AttributeError: check_test_suite）。68.2.2 是 python3.11 黄金搭档，仅影响编译期，
# 不影响路由器运行时的 python3。版本与 hash 来自 openwrt 23.05 官方分支。
ST_MK=feeds/packages/lang/python/python-setuptools/Makefile
if grep -q "PKG_VERSION:=84" $ST_MK 2>/dev/null; then
    sed -i "s/^PKG_VERSION:=.*/PKG_VERSION:=68.2.2/" $ST_MK
    sed -i "s/^PKG_HASH:=.*/PKG_HASH:=4ac1475276d2f1c48684874089fefcd83bd7162ddaafb81fac866ba0db282a87/" $ST_MK
    echo "host setuptools pinned to 68.2.2"
fi

# ===== vsftpd 菜单汉化修补（沿用原仓库定制）=====
sed -i '/NAS/d' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/model/cbi/vsftpd/item.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/model/cbi/vsftpd/users.lua
sed -i 's/msgid "NAS"//g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po
sed -i 's/msgstr "网络存储"//g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po
sed -i 's/msgstr "FTP 服务器"/msgstr "FTP设置"/g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po

# ===== vlmcsd 菜单汉化（沿用原仓库定制，包未选中时加存在性保护）=====
if [ -f feeds/luci/applications/luci-app-vlmcsd/po/zh_Hans/vlmcsd.po ]; then
    sed -i 's/KMS 服务器/微软激活/g' feeds/luci/applications/luci-app-vlmcsd/po/zh_Hans/vlmcsd.po
fi

# ===== udpxy 菜单汉化（沿用原仓库定制，包未选中时加存在性保护）=====
if [ -f feeds/luci/applications/luci-app-udpxy/luasrc/controller/udpxy.lua ]; then
    sed -i 's/udpxy"))/组播转发"))/g' feeds/luci/applications/luci-app-udpxy/luasrc/controller/udpxy.lua
    sed -i 's/udpxy is a UDP-to-HTTP multicast traffic relay daemon, here you can configure the settings./UDPXY是UDP到HTTP的组播流量中继守护程序，您可以在此处配置设置。/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Respawn/刷新/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Bind IP\/Interface/绑定IP\/接口/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Source IP\/Interface/源IP\/接口/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Buffer size/缓冲区大小/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Buffer messages/缓冲区消息/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Buffer time/缓冲时间/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Nice increment/优先级增量/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
    sed -i 's/Multicast subscription renew/组播订阅续订/g' feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi/udpxy.lua
fi
