NixOS
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
  # Automatically open encrypted partition in the initramfs, we already gave the password
  # in GRUB, no need to do it twice. And with LUKS1 with the key is accessible to any user anyway.
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
  
  # Not really necessary as it should be included in hardware-configuration.nix
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
      hashedPassword = "";  # create me `mkpasswd -m sha-512` in the livecd
      home = "/home/brabier";
      extraGroups = [ "wheel" "networkmanager" "audio"];  # wheel gives sudo access
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

#### Hardware channel

Use the hardware channel: https://github.com/NixOS/nixos-hardware

#### Firmware update

```nix
{
  services.fwupd.enable = true;
}
```

See https://wiki.archlinux.org/index.php/fwupd

```bash
# List detected devices
fwupdmgr get-devices
# Load latest metadata
fwupdmgr refresh
# List available updates
fwupdmgr get-updates
# Install updates
fwupdmgr update
```

During reboot, had to select booting device "Linux Firmware Update" for the updates, or some at least, to be applied.


#### Display Link

```nix
{
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  nixpkgs.config.allowUnfree = true;
}
```


```bash
# Accept EULA at https://www.displaylink.com/downloads/ubuntu and copy download URL
nix-prefetch-url --name displaylink.zip <URL>
```

```bash
xrandr --setprovideroutputsource 1 0  # first monitor
xrandr --setprovideroutputsource 2 0  # second monitor
```

Source: 
- https://nixos.wiki/wiki/Displaylink

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

#### Auto-login

Didn't worked at first try, may need to login manually first ?

```nix
{
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "X";
  };
}
```

#### Shell

Use zsh by default for everyone, with a decent red prompt.

```nix
{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    promptInit = ''
      # Note that to manually override this in ~/.zshrc you should run `prompt off`
      # before setting your PS1 and etc. Otherwise this will likely to interact with
      # your ~/.zshrc configuration in unexpected ways as the default prompt sets
      # a lot of different prompt variables.
      autoload -U promptinit && promptinit && prompt walters && setopt prompt_sp
      export PROMPT='%F{red}%B%(?..[%?] )%b%n@%U%m%u:%~ > %f'
    '';
  };
}
```

Devlopment
----------

Create isolated environments with direnv and nix-shell:

```bash
nix-env -iA nixos.direnv
```

Create a `.envrc` in the project root. This will activate a nix-shell automatically:

```
use_nix
```

One only need to activate it once with `direnv allow .` and create the `shell.nix`:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = [];
  shellHook = ''
  '';
}
```


### Python

Here is the `shell.nix` for Antidote:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.python39
    pkgs.python39Packages.virtualenv
    pkgs.python36
    pkgs.python37
    pkgs.python38
    pkgs.pypy3
  ];
  shellHook = ''
    # set SOURCE_DATE_EPOCH so that we can use python wheels
    SOURCE_DATE_EPOCH=$(date +%s)
    # Create venv if it does not exist yet.
    if [[ ! -d .venv ]]; then
      virtualenv -q .venv
      source ./.venv/bin/activate
      pip install -r requirements/dev.txt
    else
      source ./.venv/bin/activate
    fi;
  '';
}
```
