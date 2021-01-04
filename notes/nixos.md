NixOs
=====

Installation
------------

1. Boot from ISO (secure boot disabled)
2. Setup disk

```bash
parted -a optimal /dev/nvme0n1
```

```
mklabel gpt
unit mib
mkpart ESP fat32 1 512
mkpart primary 512 -1
set 1 esp on
name 2 CRYPTROOT
quit
```

```bash
# Using LUKS1 for GRUB which does not support LUKS2
cryptsetup --type luks1 luksFormat /dev/nvme0n1p2
# Consider backing up the header 
# WARN: keys stored in the backup will ALWAYS be valid, whether they were removed afterwards or not
# cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file /<?>
cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
pvcreate /dev/mapper/cryptroot
vgcreate vg-nvme /dev/mapper/cryptroot
lvcreate -L60GB vg-nvme -n root
lvcreate -L160GB vg-nvme -n home
# 1.5 * RAM with hibernate, 0.5 without.
lvcreate -L24GB vg-nvme -n swap
mkfs.ext4 -L ROOT /dev/vg-nvme/root
mkfs.ext4 -L HOME /dev/vg-nvme/home
mkswap -L SWAP /dev/vg-nvme/swap
# Not sure why, had to manually format
mkfs.vfat -n ESP /dev/nvme0n1p1
# Sanity check
blkid
```

3. Setup NixOS

```bash
mount -L ROOT /mnt
mkdir -p /mnt/boot/efi
mkdir /mnt/home
mount -L ESP /mnt/boot/efi
mount -L HOME /mnt/home
swapon /dev/disk/by-label/SWAP
nixos-generate-config --root /mnt
# Fine tune the /mnt/etc/nixos/configuration.nix
nixos-install
reboot
```
