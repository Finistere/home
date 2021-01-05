NixOs
=====

Installation
------------

1. Boot from ISO (secure boot disabled)
2. Partition disk with `parted -a optimal /dev/nvme0n1`

```
mklabel gpt
unit mib
mkpart ESP fat32 1 512
mkpart primary 512 -1
set 1 esp on
name 2 CRYPTROOT
quit
```

3. Configure LUKS

```bash
# Using LUKS1 for GRUB which does not support LUKS2
cryptsetup --type luks1 luksFormat /dev/nvme0n1p2
# Consider backing up the header 
# WARN: keys stored in the backup will ALWAYS be valid, whether they were removed afterwards or not
# cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file /<?>
cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
# Create keyfile to unlock to avoid repeating password for GRUB and the initramfs
mkdir -p /etc/secrets/initrd
chmod -R 700 /etc/secrets
dd bs=1024 count=4 if=/dev/random of=/etc/secrets/initrd/cryptroot.keyfile iflag=fullblock
chmod 600 /etc/secrets/initrd/cryptroot.keyfile
```

3. Configure LVM

```bash
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

4. Configure hardware configution

```bash
mount -L ROOT /mnt
mkdir -p /mnt/boot/efi
mkdir /mnt/home
mount -L ESP /mnt/boot/efi
mount -L HOME /mnt/home
swapon /dev/disk/by-label/SWAP
nixos-generate-config --root /mnt
```

5. Boot configuration

```nix
# /mnt/etc/nixos/configuration.nix
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true; 
  };
  boot.initrd = {
    secrets = {
      "cryptroot.keyfile" = "/etc/secrets/initrd/cryptroot.keyfile";
    };
    luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-partlabel/CRYPTROOT";
        keyFile = "cryptroot.keyfile";
        preLVM = true;
      };
    };
  };
  fileSystems = {
    "/".label = "ROOT";
    "/boot/efi" = {
      label = "ESP";
      fsType = "vfat";
    };
    "/home".label = "HOME";
  };
  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];
}
```

6. User configuration

```nix
{
  users = {
    mutableUsers = false;
    users.brabier = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = "";  # create me later with `mkpasswd -m sha-512`
      home = "/home/brabier";
      extraGroups = [ "wheel" "networkmanager" "audio"];
    };
  };
}
```

7. Installation !

```bash
nixos-install
reboot
```

System
------

### Hardware

Use the hardware channel: https://github.com/NixOS/nixos-hardware

### Desktop

```nix
{
  # KDE
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # NetworkManager, not included by default in KDE
  networking.networkmanager.enable = true;
  
  # Pulseaudio with bluetooh
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;
  
  # Correct timezone
  time.timeZone = "Europe/Paris";
}
```
