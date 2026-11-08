#!/bin/bash
#=================================================
# Description: DIY script（vsftpd/udpxy/vlmcsd 汉化修补）
# Lisence: MIT
#=================================================

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
