#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
#luci-theme-argon 
#rm -rf feeds/luci/themes/luci-theme-argon  
#git clone -b master https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon 

#kernel-graphics
#ver=$(cat target/linux/x86/Makefile | grep KERNEL_PATCHVER | cut -d '=' -f2)
#echo CONFIG_DRM=y >>target/linux/x86/config-${ver}
#echo CONFIG_DRM_I915=y >>target/linux/x86/config-${ver}
#echo CONFIG_DRM_I915_ALPHA_SUPPORT=y >>target/linux/x86/config-${ver}
#echo CONFIG_DRM_I915_CAPTURE_ERROR=y >>target/linux/x86/config-${ver}
#echo CONFIG_DRM_I915_COMPRESS_ERROR=y >>target/linux/x86/config-${ver}
#echo CONFIG_DRM_I915_USERPTR=y >>target/linux/x86/config-${ver}
#echo CONFIG_APERTURE_HELPERS=y >>target/linux/x86/config-${ver}
#echo CONFIG_CC_NO_ARRAY_BOUNDS=y >>target/linux/x86/config-${ver}
#echo CONFIG_CGROUPS=y >>target/linux/x86/config-${ver}
#echo CONFIG_CGROUP_SCHED=y >>target/linux/x86/config-${ver}
#echo CONFIG_CGROUP_WRITEBACK=y >>target/linux/x86/config-${ver}
#echo CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1 >>target/linux/x86/config-${ver}
#echo CONFIG_CONTEXT_TRACKING=y >>target/linux/x86/config-${ver}
#echo CONFIG_CONTEXT_TRACKING_IDLE=y >>target/linux/x86/config-${ver}
#echo CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y >>target/linux/x86/config-${ver}
#echo CONFIG_CRYPTO_LIB_SHA1=y >>target/linux/x86/config-${ver}
#echo CONFIG_CRYPTO_LIB_UTILS=y >>target/linux/x86/config-${ver}
#echo CONFIG_FAIR_GROUP_SCHED=y >>target/linux/x86/config-${ver}
#echo CONFIG_FRAME_WARN=1024 >>target/linux/x86/config-${ver}
#echo CONFIG_GCC11_NO_ARRAY_BOUNDS=y >>target/linux/x86/config-${ver}
#echo CONFIG_GPIO_ACPI=y >>target/linux/x86/config-${ver}
#echo CONFIG_GPIO_CDEV=y >>target/linux/x86/config-${ver}
#echo CONFIG_HZ_PERIODIC=y >>target/linux/x86/config-${ver}
#echo CONFIG_MEMCG=y >>target/linux/x86/config-${ver}
#echo CONFIG_MEMCG_KMEM=y >>target/linux/x86/config-${ver}
#echo CONFIG_NET_PTP_CLASSIFY=y >>target/linux/x86/config-${ver}
#echo CONFIG_PAGE_COUNTER=y >>target/linux/x86/config-${ver}
#echo CONFIG_PARAVIRT=y >>target/linux/x86/config-${ver}
#echo CONFIG_PPS=y >>target/linux/x86/config-${ver}
#echo CONFIG_PTP_1588_CLOCK=y >>target/linux/x86/config-${ver}
#echo CONFIG_SCHED_AUTOGROUP=y >>target/linux/x86/config-${ver}
#echo CONFIG_SERIAL_MCTRL_GPIO=y >>target/linux/x86/config-${ver}
#echo CONFIG_SOFTIRQ_ON_OWN_STACK=y >>target/linux/x86/config-${ver}
#echo CONFIG_UCS2_STRING=y >>target/linux/x86/config-${ver}
#echo CONFIG_VMAP_PFN=y >>target/linux/x86/config-${ver}
#echo CONFIG_X86_HV_CALLBACK_VECTOR=y >>target/linux/x86/config-${ver}
