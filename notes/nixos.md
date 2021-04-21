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
```

3. Configure LVM

```bash
pvcreate /dev/mapper/cryptroot
vgcreate vg-laptop /dev/mapper/cryptroot
lvcreate -L60GB vg-laptop -n root
lvcreate -L160GB vg-laptop -n home
# 1.5 * RAM with hibernate, 0.5 without.
lvcreate -L24GB vg-laptop -n swap
mkfs.ext4 -L ROOT /dev/vg-laptop/root
mkfs.ext4 -L HOME /dev/vg-laptop/home
mkswap -L SWAP /dev/vg-laptop/swap
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

```bash
# Create keyfile to unlock to avoid repeating password for GRUB and the initramfs
mkdir -p /mnt/etc/secrets/initrd
chmod -R 700 /mnt/etc/secrets
dd bs=1024 count=4 if=/dev/random of=/mnt/etc/secrets/initrd/cryptroot.keyfile iflag=fullblock
chmod 600 /mnt/etc/secrets/initrd/cryptroot.keyfile
```

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

Nix
---

### Utils

#### Use unstable packages

```bash
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --update
```

```nix
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  environment.systemPackages = with pkgs; [
    unstable.X
  ];
}
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
  # Display-link is not free
  nixpkgs.config.allowUnfree = true;
  services.xserver = {
    videoDrivers = [ "displaylink" "modesetting" ];
    displayManager.sessionCommands = ''
        # Add second display link monitor
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
      '';
  };
  hardware.pulseaudio.extraConfig = ''
      # Pulseaudio is suspending the dock
      unload-module module-suspend-on-idle
  '';
}
```

```bash
# Accept EULA at https://www.displaylink.com/downloads/ubuntu and copy download URL
nix-prefetch-url --name displaylink.zip <URL>
nixos-rebuild switch
```

```bash
# Activate immediately
xrandr --setprovideroutputsource 1 0  # first monitor
xrandr --setprovideroutputsource 2 0  # second monitor
xrandr --auto
```

Source: 
- https://nixos.wiki/wiki/Displaylink


#### Microphone

```nix
{
  # Latest Kernel necessary for Sound Open Firmware
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  # throttled issue with 5.9
  # https://github.com/erpalma/throttled/issues/215
  boot.kernelParams = [ "msr.allow_writes=on" ];
  # Microphone not properly found, to be checked
  boot.extraModprobeConfig = ''
    snd_intel_dspcfg dsp_driver=1
  '';
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      # Add noise cancellation
      load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1" 
    '';
  };
}
```

How to debug:
```bash
# Disable pulseaudio in Systemd
systemctl --user mask pulseaudio.socket
pulseaudio -k 
# Do modification
pulseaudio -D
pavucontrol

# Disable kernel MOD
rmmod X
# Enable
modprobe X

# list input devices
arecord -l
# output
aplay -l
# ALSA
alsamixer
```

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

### Java

```nix
{ pkgs ? import <nixpkgs> {},
  unstable ? import <nixos-unstable> {}}:

pkgs.mkShell {
  nativeBuildInputs = [
    unstable.jdk
  ];
  shellHook = ''
    ln -sf '${unstable.jdk.home}' .jdk
  '';
  JAVA_HOME = "${unstable.jdk.home}";
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
