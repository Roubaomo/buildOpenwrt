# buildOpenwrt — LEDE 多设备云编译

基于 GitHub Actions 的 OpenWrt（Lean's LEDE）自动编译仓库，产出 x86 虚拟机 + ARM 软路由一体化的**通用基础镜像**。

## 支持设备

| 设备 | 配置文件 | 产物 | 刷机方式 |
|---|---|---|---|
| x86_64（PVE/KVM/实体机） | `configs/x86.seed` | `*-x86-64-generic-ext4-combined.img.gz` | 导盘建 VM / dd 写盘 |
| NanoPi R2S | `configs/r2s.seed` | `*-nanopi-r2s-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |
| NanoPi R3S | `configs/r3s.seed` | `*-nanopi-r3s-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |
| HinLink H28K | `configs/h28k.seed` | `*-opc-h28k-ext4-sysupgrade.img.gz` | 写 SD 卡 / dd 进 eMMC |

`configs/*.seed` 为精简 seed 配置（约百行），编译时 `make defconfig` 自动展开补全依赖。四份 seed 同源，差异仅 target 与网卡驱动。

## 镜像内容

**包含**：
- LuCI 全家 + **Argon 主题** + argon-config（全中文）
- **Docker** + docker-compose + **dockerman 网页管理**（中文）
- **xray-core**（建节点用，helloworld feed）
- 磁盘/运维工具：bash curl jq socat rsyslog smartmontools parted fdisk e2fsprogs btrfs-progs 等
- 驱动：x86（virtio/igb/igc/e1000/r8169/r8125/nvme）、R2S/R3S（RTL8152 USB 千兆）、H28K（r8169/r8125 2.5G）
- lean 功能集：autocore / automount / default-settings / ipv6helper
- PPPoE / IPv6 全支持

**不包含**（刻意精简）：
- passwall2 等科学上网前端（只带 xray-core 核心，前端自选）
- fail2ban（LEDE 源无此包且 python 构建框架不兼容，装好系统后离线搬 ipk 即可，纯 python 跨发行版可跑）
- ddns / acme（按需 docker 部署，如 ddns-go 容器）
- 任何预烧网络配置

**初始状态**：LAN `192.168.1.1`（静态，eth0），root 密码为空，首登 LuCI 或 SSH 后自行设置。

## 如何编译

- **push 到 main** → 自动编译 x86（日常迭代用）
- **手动全编** → Actions → Build OpenWrt → Run workflow → `devices` 填：
  - 单台：`x86` / `r2s` / `r3s` / `h28k`
  - 四台并行：`all`
- **只推代码不编译** → 提交信息带 `[skip ci]`
- 编译产物自动发布到 Releases（每设备一个 Release，含 sha256sums 校验与 manifest 包清单）
- toolchain 已缓存（按设备分 key），日常重编约 1 小时；首编/缓存失效约 3 小时

**源码版本已锚定**：workflow 的 `env.COMMIT_ID` 固定了验证编译通过的 lede master 快照，保证可复现；想跟进上游时手动更新该值（锚点更新建议先单编 x86 验证再 all）。

## 刷机指引

### x86（PVE 场景）

```
gunzip openwrt-x86-64-generic-ext4-combined.img.gz
qm create 106 --name lede-test --memory 1024 --cores 2 \
  --net0 virtio,bridge=vmbr9 --net1 virtio,bridge=vmbr1
qm disk import 106 openwrt-...-combined.img local-lvm --target-disk scsi0
qm set 106 --scsi0 local-lvm:vm-106-disk-0 --boot order=scsi0
qm start 106
```

⚠️ **eth0 默认 LAN(192.168.1.1) 且带 DHCP 服务**，net0 绝不能直接挂主网桥（会与主网网关抢答 DHCP）。推荐双网卡：
- `net0`（eth0/LAN）→ 空桥 vmbr9（隔离）
- `net1`（eth1/WAN，DHCP 客户端）→ 主网桥，从上级路由拿地址

PVE 上临时给 vmbr9 加 IP 即可 SSH 进 192.168.1.1：`ip addr add 192.168.1.250/24 dev vmbr9`

想在主网直接 SSH 该设备的 WAN 地址，需放行 WAN 入站：

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
configs/           # 各设备 seed 配置（x86 / r2s / r3s / h28k）
diy-package.sh     # 编译期定制：vsftpd/udpxy/vlmcsd 汉化修补等
diy-feed.sh        # feed 定制（当前为空）
.github/workflows/ # Actions 流水线（matrix 多设备并行）
tools/             # SSH 调试用（tmate）
```
