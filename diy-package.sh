#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
#luci-theme-argon 
rm -rf feeds/luci/themes/luci-theme-argon  
git clone -b master https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon 

#luci-app-vsftpd
sed -i '/NAS/d' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/model/cbi/vsftpd/item.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-vsftpd/luasrc/model/cbi/vsftpd/users.lua
sed -i 's/msgid "NAS"//g' feeds/luci/applications/luci-app-vsftpd/po/zh-cn/vsftpd.po
sed -i 's/msgstr "网络存储"//g' feeds/luci/applications/luci-app-vsftpd/po/zh-cn/vsftpd.po
sed -i 's/msgstr "FTP 服务器"/msgstr "FTP设置"/g' feeds/luci/applications/luci-app-vsftpd/po/zh-cn/vsftpd.po

#luci-app-vlmcsd
sed -i 's/KMS 服务器/微软激活/g' feeds/luci/applications/luci-app-vlmcsd/po/zh-cn/vlmcsd.po

#luci-app-dockerman
sed -i '/Docker - Container (%s)/{n;s/""/"Docker-容器"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Container/{n;s/""/"Docker-容器"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Images/{n;s/""/"Docker-镜像"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Network/{n;s/""/"Docker-网络"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Networks/{n;s/""/"Docker-网络"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Overview/{n;s/""/"Docker-概览"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i '/Docker - Volumes/{n;s/""/"Docker-存储"/g}' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i 's/存储卷/存储/g' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i 's/存储卷/存储/g' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po
sed -i 's/msgstr "Docker"/msgstr "容器"/g' feeds/luci/applications/luci-app-dockerman/po/zh-cn/dockerman.po

#luci-app-udpxy
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

#luci-app-ssr
sed -i 's/ShadowSocksR Plus+/翻墙工具/g' feeds/helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua 

#kernel-graphics
ver=$(cat target/linux/x86/Makefile | grep KERNEL_PATCHVER | cut -d '=' -f2)
echo CONFIG_DRM=y >>target/linux/x86/config-${ver}
echo CONFIG_DRM_I915=y >>target/linux/x86/config-${ver}
echo CONFIG_DRM_I915_ALPHA_SUPPORT=y >>target/linux/x86/config-${ver}
echo CONFIG_DRM_I915_CAPTURE_ERROR=y >>target/linux/x86/config-${ver}
echo CONFIG_DRM_I915_COMPRESS_ERROR=y >>target/linux/x86/config-${ver}
echo CONFIG_DRM_I915_USERPTR=y >>target/linux/x86/config-${ver}
echo CONFIG_APERTURE_HELPERS=y >>target/linux/x86/config-${ver}
echo CONFIG_CC_NO_ARRAY_BOUNDS=y >>target/linux/x86/config-${ver}
echo CONFIG_CGROUPS=y >>target/linux/x86/config-${ver}
echo CONFIG_CGROUP_SCHED=y >>target/linux/x86/config-${ver}
echo CONFIG_CGROUP_WRITEBACK=y >>target/linux/x86/config-${ver}
echo CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1 >>target/linux/x86/config-${ver}
echo CONFIG_CONTEXT_TRACKING=y >>target/linux/x86/config-${ver}
echo CONFIG_CONTEXT_TRACKING_IDLE=y >>target/linux/x86/config-${ver}
echo CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y >>target/linux/x86/config-${ver}
echo CONFIG_CRYPTO_LIB_SHA1=y >>target/linux/x86/config-${ver}
echo CONFIG_CRYPTO_LIB_UTILS=y >>target/linux/x86/config-${ver}
echo CONFIG_FAIR_GROUP_SCHED=y >>target/linux/x86/config-${ver}
echo CONFIG_FRAME_WARN=1024 >>target/linux/x86/config-${ver}
echo CONFIG_GCC11_NO_ARRAY_BOUNDS=y >>target/linux/x86/config-${ver}
echo CONFIG_GPIO_ACPI=y >>target/linux/x86/config-${ver}
echo CONFIG_GPIO_CDEV=y >>target/linux/x86/config-${ver}
echo CONFIG_HZ_PERIODIC=y >>target/linux/x86/config-${ver}
echo CONFIG_MEMCG=y >>target/linux/x86/config-${ver}
echo CONFIG_MEMCG_KMEM=y >>target/linux/x86/config-${ver}
echo CONFIG_NET_PTP_CLASSIFY=y >>target/linux/x86/config-${ver}
echo CONFIG_PAGE_COUNTER=y >>target/linux/x86/config-${ver}
echo CONFIG_PARAVIRT=y >>target/linux/x86/config-${ver}
echo CONFIG_PPS=y >>target/linux/x86/config-${ver}
echo CONFIG_PTP_1588_CLOCK=y >>target/linux/x86/config-${ver}
echo CONFIG_SCHED_AUTOGROUP=y >>target/linux/x86/config-${ver}
echo CONFIG_SERIAL_MCTRL_GPIO=y >>target/linux/x86/config-${ver}
echo CONFIG_SOFTIRQ_ON_OWN_STACK=y >>target/linux/x86/config-${ver}
echo CONFIG_UCS2_STRING=y >>target/linux/x86/config-${ver}
echo CONFIG_VMAP_PFN=y >>target/linux/x86/config-${ver}
echo CONFIG_X86_HV_CALLBACK_VECTOR=y >>target/linux/x86/config-${ver}
