# ImmortalWrt x86_64 自编译固件

基座 **ImmortalWrt 24.10.6**（内核 6.6.133）｜ 目标 `x86/64 Generic` ｜ 用 GitHub Actions 云编译。

## 用途

PVE 虚拟机 / x86 小主机的旁路由固件，兼做主路由。

- 默认 LAN：`192.168.50.8/24`
- 默认旁路由：关 DHCP，网关与 DNS 指向 `192.168.50.1`
- 默认主题：argon（另有 aurora / bootstrap / material）
- 默认中文
- 四套代理全部编入，但**默认全部不启用**，面板里按需开

## 编译

推送到 `main` 或手动 `workflow_dispatch` 即可。产物在 Actions 的 `immortalwrt-images` artifact 里：

- `...-squashfs-combined.img.gz`（BIOS 引导，PVE 用）
- `...-squashfs-combined-efi.img.gz`（UEFI）
- `sha256sums.txt`

## 改配置

改 `configs/packages.list` 增删软件包；改 `files/etc/uci-defaults/99-immortalwrt-custom` 调整开机默认值；改 `configs/base.config` 调分区大小。

编译时会输出「缺失包检查」，列在 artifact 的 `missing.txt` 里——出现在那里说明包名写错或该包在当前分支不存在。

## PVE 部署

```sh
gunzip immortalwrt-24.10.6-x86-64-generic-squashfs-combined.img.gz
qm importdisk 200 immortalwrt-24.10.6-x86-64-generic-squashfs-combined.img local-lvm
qm set 200 --name immortalwrt --memory 2048 --cores 2
qm set 200 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-200-disk-0
qm set 200 --boot order=scsi0 --bootdisk scsi0
qm set 200 --net0 virtio,bridge=vmbr0
qm set 200 --serial0 socket --vga serial0 --onboot 1
```

PVE 虚拟机的「防火墙」勾选框要取消。
