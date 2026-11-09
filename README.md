# buildOpenwrt — OpenWrt 多设备云编译（ImmortalWrt 主线 + H28K LEDE）

基于 GitHub Actions 的 OpenWrt 自动编译仓库：ImmortalWrt 作为 x86/R2S/R3S 主线，H28K 因上游支持情况继续使用 LEDE，提供 x86 虚拟机和 ARM 软路由通用基础镜像。

## 支持设备

| 设备 | 配置文件 | 产物 | 刷机方式 |
|---|---|---|---|
| x86_64（PVE/KVM/实体机） | `configs/x86.seed` | `*-x86-64-generic-ext4-combined.img.gz` | 导盘建 VM / dd 写盘 |
| NanoPi R2S | `configs/r2s.seed` | `*-nanopi-r2s-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |
| NanoPi R3S | `configs/r3s.seed` | `*-nanopi-r3s-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |
| HinLink H28K | `configs/h28k.seed` | `*-opc-h28k-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |
| 上表三台的 ImmortalWrt 主线版 | `configs/*-imm.seed` | Release 中按设备名区分 | 同上 |

`configs/*.seed` 为精简 seed 配置（约百行），编译时 `make defconfig` 自动展开补全依赖。

## 双源体系（`-imm` 后缀）

当前主矩阵按设备选择源码：

| | ImmortalWrt 主线（x86/r2s/r3s） | H28K LEDE 特例 |
|---|---|---|
| 源码 | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) **v24.10.6 官方 tag**（内核 6.6） | [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) master（锚定 commit，内核 6.18） |
| opkg 官方源直连 | ✅ downloads.immortalwrt.org 直连 | ❌（用 Release 自带 packages-*.tar.gz 本地源） |
| 特点 | 版本锚定、官方安全更新、官方 opkg 源 | 最新硬件驱动，滚动快照，自建匹配包仓 |
| H28K | ✗（ImmortalWrt 未支持该设备） | ✓ |

### ImmortalWrt 主线的软件安装与加速

ImmortalWrt 主线固件的 opkg 已默认指向官方源，设备上直接：

```bash
opkg update && opkg install <包名>     # kmod 亦可（同源编译，vermagic 一致）
```

官方源在国内可能较慢，换国内镜像（中科大/北大，二选一）：

```bash
sed -i 's|downloads.immortalwrt.org|mirrors.ustc.edu.cn/immortalwrt|g' /etc/opkg/distfeeds.conf
opkg update
```

官方资源：
- 源码：https://github.com/immortalwrt/immortalwrt
- 官方包仓（本固件对应）：https://downloads.immortalwrt.org/releases/24.10.6/
- 官网/文档：https://immortalwrt.org
- 固件选择器（官方原版固件）：https://firmware-selector.immortalwrt.org

## 镜像内容

**包含**：
- LuCI 全家 + **Argon 主题** + argon-config（全中文）
- **Docker** + docker-compose + **dockerman 网页管理**（中文）
- **xray-core** 核心（科学上网前端自选）
- 磁盘/运维工具：bash curl jq socat rsyslog smartmontools parted fdisk e2fsprogs btrfs-progs 等
- 驱动：x86（virtio/igb/igc/e1000/r8169/r8125/nvme）、R2S/R3S（RTL8152 USB 千兆）、H28K（r8169/r8125 2.5G）
- PPPoE / IPv6 全支持

**初始状态**：LAN `192.168.1.1`（静态，eth0），root 密码为空，首登 LuCI 或 SSH 后自行设置。无任何预烧配置。

## 软件安装（opkg）—— ImmortalWrt 主线

ImmortalWrt 主线默认使用官方包源。带宽监控和 UPnP IGD/PCP 不预装，需要时按需安装：

```bash
opkg update
opkg install nlbwmon luci-app-nlbwmon       # 带宽统计（按需）
opkg install miniupnpd luci-app-upnp        # UPnP IGD/PCP（按需）
```

当前固件也不预装 fail2ban；如确有需要，可从官方源按需安装：

```bash
opkg update
opkg install fail2ban
```

## 软件安装（opkg）—— H28K LEDE 版

LEDE 版内核与包均为自编译，**官方 opkg 源与其不兼容**（kmod 因内核版本不符无法安装，普通包有依赖冲突风险），镜像内 `/etc/opkg/distfeeds.conf` 已默认禁用全部官方源。

安装软件请使用 Release 中的 **`packages-<device>.tar.gz`**（与本镜像同批编译的全套 ipk + 索引，内核/ABI 完全匹配）：

```bash
tar xzf packages-x86.tar.gz -C /opt
for f in "" base luci packages helloworld; do
  echo "src/gz my$f file:///opt/packages/$f" >> /etc/opkg/customfeeds.conf
done
opkg update && opkg install <包名>
```

无网络环境也可直接 `opkg install /opt/packages/**/xxx.ipk`。

### 从 GitHub Release 获取匹配的包仓

本项目暂不维护独立的在线软件仓，也不会在固件中写入私人域名。LEDE 软件包随对应设备的 GitHub Release 一起发布，使用前请确认：

- 固件和 `packages-<device>.tar.gz` 来自同一个 Release；
- `<device>` 与设备型号一致；
- 不要把 x86、R2S、R3S、H28K 的包仓混用；
- 不要把 LEDE 包仓与 ImmortalWrt 官方包仓混用；
- 安装 `kmod-*` 前尤其要确认内核版本和 ABI 匹配。

示例（请把 URL 替换为对应 Release 的真实下载地址）：

```bash
mkdir -p /tmp/lede-packages
cd /tmp/lede-packages
wget -O packages-x86.tar.gz \
  https://github.com/Roubaomo/buildOpenwrt/releases/download/<release-tag>/packages-x86.tar.gz
sha256sum packages-x86.tar.gz
# 与同一 Release 的 sha256sums 文件核对后再解压
mkdir -p /opt/packages
tar xzf packages-x86.tar.gz -C /opt/packages

for f in "" base luci packages helloworld; do
  echo "src/gz my$f file:///opt/packages/$f" >> /etc/opkg/customfeeds.conf
done
opkg update
opkg install <包名>
```

如果设备可以访问 GitHub，也可以将压缩包解压到设备本地；如果设备无法直接下载大文件，先在电脑或 NAS 下载并校验，再通过 SCP/U 盘传入。不要直接使用网上其他 OpenWrt/LEDE 源替代本项目包仓。

**Fork 安全说明**：Fork 项目可以自行编译和发布自己的固件/包仓，但本仓库不会自动把包上传到第三方服务器，也不会把任何私有部署地址、SSH 凭据或部署密钥写入 workflow。未来如增加自动部署，应只允许原仓库受保护的 `main` 分支执行，并将部署凭据放在 GitHub Environment Secrets 中。

## 如何编译

- **push 到 main** → 自动编译 x86-imm（日常迭代用）
- **手动编译** → Actions → Build OpenWrt → Run workflow → `devices` 填：
  - 单台：`x86-imm` / `r2s-imm` / `r3s-imm`（ImmortalWrt 主线），或 `h28k`（LEDE 特例）
  - 全部四台并行：`all`
- **只推代码不编译** → 提交信息带 `[skip ci]`
- 编译产物自动发布到 Releases（每设备一个 Release，含 sha256sums 校验与 manifest 包清单）
- toolchain 已缓存（按设备分 key），日常重编约 1 小时；首编/缓存失效约 3 小时

**源码版本均已锚定，可复现**：x86/R2S/R3S 使用 ImmortalWrt 官方 tag `v24.10.6`；H28K 使用 LEDE 锚定快照（workflow `COMMIT_ID` 默认值）。升级时先单设备验证，再更新固定版本。

## 刷机指引

### x86（PVE / KVM / 实体机）

镜像解压后是完整盘镜像（含 GRUB 引导），三种用法：

**实体机**：`gunzip` 后 dd 写整盘（或 balenaEtcher），BIOS/UEFI 均可启动（另有 `combined-efi` 变体供纯 UEFI 机器）。

**PVE 建虚拟机**（VMID / 存储名 / 桥名按自己环境替换）：

```
gunzip openwrt-x86-64-generic-ext4-combined.img.gz
qm create <VMID> --name openwrt --memory 1024 --cores 2 --machine q35 --ostype l26 \
  --scsihw virtio-scsi-single \
  --net0 virtio,bridge=<隔离桥> --net1 virtio,bridge=<上级网络桥>
qm disk import <VMID> openwrt-...-combined.img <存储名> --target-disk scsi0
qm set <VMID> --scsi0 <存储名>:vm-<VMID>-disk-0 --boot order=scsi0
qm start <VMID>
```

⚠️ `--scsihw virtio-scsi-single` 必须显式指定：PVE 默认给 LSI Logic 控制器，本固件无该驱动会 kernel panic（黑屏不起）。用 virtio0 总线亦可。

⚠️ **重要：eth0 默认是 LAN（192.168.1.1）且自带 DHCP 服务**。第一块网卡（net0）**不要直接接在正在使用的网络里**——它会向该二层广播 DHCP 应答，干扰现有网络。正确做法：
- `net0`（eth0/LAN）→ 接一个空桥/隔离网络（PVE 新建一个不绑物理口的桥即可）
- `net1`（eth1/WAN，DHCP 客户端）→ 接需要上网的网络，自动从上级路由获取地址

在宿主机给隔离桥临时加个同网段 IP，即可 SSH/Browser 访问 192.168.1.1 完成初始配置，改好 LAN 地址后再按需迁移网络。

想在上级网络直接 SSH 该设备的 WAN 地址，需放行 WAN 入站：

```
uci add firewall rule; uci set firewall.@rule[-1].name='allow-wan-ssh'
uci set firewall.@rule[-1].src='wan'; uci set firewall.@rule[-1].dest_port='22'
uci set firewall.@rule[-1].proto='tcp'; uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall; /etc/init.d/firewall restart
```

### ARM（R2S / R3S / H28K）

**SD 卡**：`sysupgrade.img.gz` 直接用 balenaEtcher / dd 写卡即用。

**eMMC（推荐 SD 中转）**：

1. sysupgrade 镜像先写 SD 卡，上电验证系统正常
2. SSH 进 SD 系统，把镜像传到 /tmp，dd 进 eMMC：

```
ls /dev/mmcblk*                       # 确认 eMMC 与 SD 各自的设备名，别搞反
cat /sys/block/mmcblk0/device/name
gunzip -c /tmp/openwrt-*-sysupgrade.img.gz | dd of=/dev/mmcblkX bs=1M conv=fsync
sync && reboot
```

3. **关机取下 SD 卡**再上电（RK 平台 SD 启动优先，不取卡不会走 eMMC）

刷后扩容（镜像 rootfs 2G，eMMC 常见 8G）：`cfdisk` 扩 root 分区 → `resize2fs /dev/mmcblkXp2`

⚠️ H28K 若在跑原厂系统，不要用 RKDevTool 线刷本镜像（分区参数不匹配易变砖），走 SD→dd 路线。

## 定制

| 需求 | 做法 | 耗时 |
|---|---|---|
| 改包/加包 | 编辑 `configs/*.seed` → push 或 dispatch | ~1 小时（有缓存） |
| 换/加设备 | 复制一份 seed 改 target → workflow matrix 的设备列表加一行 | 同上 |
| 初始 IP / 密码 / 预烧配置 | **不必重编**：下载 Release 镜像，本地 loop 挂载改 `/etc/uci-defaults/99-custom`、`/etc/shadow`，几分钟出定制版 | 几分钟 |

## 仓库结构

```
configs/           # 各设备 seed 配置（x86/r2s/r3s 的 -imm 主线 + h28k LEDE 特例，旧 seed 暂保留作迁移回滚）
files/             # 直写镜像的文件（LEDE 版 opkg distfeeds.conf 禁用官方源）
diy-package.sh     # 编译期定制：vsftpd/udpxy/vlmcsd 汉化修补等
diy-feed.sh        # feed 定制（当前为空）
.github/workflows/ # Actions 流水线（双源路由 + matrix 多设备并行）
tools/             # SSH 调试用（tmate）
```
