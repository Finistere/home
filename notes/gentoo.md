Gentoo
======

Software
--------

### Systemd

Change default app kill timeout in `/etc/systemd/system.conf` to for example `DefaultTimeoutStopSec=10s`

### Emerge

```bash
# Update repositories
emerge --sync -q
# Update everything
emerge -auDU --quiet-build --quiet-fail --keep-going --with-bdeps=y @world
# Clean-up afterwards (Be sure to have compiled new kernel before)
emerge -a --depclean
```

### Kernel

General upgrade guide: https://wiki.gentoo.org/wiki/Kernel/Upgrade

Changing the configuration :
```
cd /usr/src/linux
make MENUCONFIG_COLOR=blackbg menuconfig
make -j5
make modules_install && make install
```

Updating the kernel
```
# Backup config
cp /usr/src/linux/.config ~/kernel-config-`uname -r`
eselect kernel set <kernel number>
ln -sf /usr/src/linux-<NEW> /usr/src/linux
cp /usr/src/linux-<OLD>/.config /usr/src/linux/.config
make syncconfig
make -j5
make modules_install && make install
genkernel --install initramfs --kernel-config=/usr/src/linux/.config
grub-mkconfig -o /boot/grub/grub.cfg
```

If changing the kernel, re-build the modules:
```
emerge -aq @module-rebuild
```

Genkernel configuration : `/etc/genkernel.conf`
This should be activated:
```
LVM="yes"
LUKS="yes"
```

GRUB configuration : `/etc/default/grub`
```
GRUB_CMDLINE_LINUX="dolvm crypt_root=UUID=<DISK UID> init=/usr/lib/systemd/systemd systemd.legacy_systemd_cgroup_controller=yes"
```

### Docker

Run docker without systemd to check for errors :
```
/usr/bin/dockerd -H unix://
```

Had to add tons of modules for the kernel, probably a lot which aren't necessary (zfs, brtfs, etc...)

Necessary (?):
- kernel options `systemd.legacy_systemd_cgroup_controller=yes`
- systemd flag `sys-apps/systemd cgroup-hybrid`

Using docker with `overlay -device-mapper`
Checking kernel configuration: `/usr/share/docker/contrib/check-config.sh`
Had to use `cgroupfs-mount` from https://github.com/tianon/cgroupfs-mount (pointed out by the script above)
Had to use AUFS kernel, not sure if really necessary though, as docker seems to use overlay now. Unsure.

Systemd disables IP forwarding by default, had to explicitly activate it :
```
net.ipv4.ip_forward=1
net.ipv6.conf.default.forwarding=1
net.ipv6.conf.all.forwarding=1
```

### Systemd

Increase inotify limit for IDEs:
```
fs.inotify.max_user_watches = 524288
```


### Network

#### VPN
With a `/etc/vpnc/work.conf` having all the configuration.
Connect: `sudo vpnc work`
Disconnect: `sudo vpnc-disconnect`

DNS can be retrieved through `systemd-resolved`. But it didn't worked very well...
Using `net-vpn/networkmanager-vpnc` and using the GUI worked.

### Utilities

#### PDF

`app-text/poppler` -> pdfunite

#### Monitoring

net-analyzer/nethogs
htop

#### Command line

treeify -> `cargo install treeify`


#### GDB

Check out [gdb-dashboard](https://github.com/cyrus-and/gdb-dashboard):
```
wget -P ~ https://git.io/.gdbinit
pip install pygments
```

Hardware
--------

### Ergodox EZ

Setup:
```
cd
git clone https://github.com/zsa/qmk_firmware.git
pip install qmk

# Used the salfter overlay for teensy_loader_cli
emerge -a dev-embedded/avrdude dev-embedded/teensy_loader_cli

# Additional udev rules are necessary to flash the Keyboard as user
wget https://www.pjrc.com/teensy/49-teensy.rules
# read carefully whats in it !! and follow instructions
# update udev rules
udevadm control --reload-rules
udevadm trigger

# create a crossdev-specific overlay !
# https://wiki.gentoo.org/wiki/Custom_ebuild_repository#Crossdev
crossdev -s4 --stable --g \<9 --portage --verbose --target avr

cd
git clone https://github.com/zsa/qmk_firmware.git
pip install qmk
# will warn for some missing dependencies, can be ignored but do
# retrieve the submodules !
qmk setup

```

Updating Keyboard
```
# Download new Keyboard from Oryx
unzip -o ~/Downloads/XXXXXX.zip -d /tmp/ergodox
cp /tmp/ergodox/ergodox_ez_finistere_source/* ~/qmk_firmware/keyboards/ergodox_ez/keymaps/finistere
cd ~/qmk_firmware
make ergodox_ez:finistere:flash
```

### Bluetooth

[Handbook](https://wiki.gentoo.org/wiki/Bluetooth#Device_pairing)

### Ethernet

Add a connection with `nmtui`
Add 802.1x security with `nmcli`:
```
nmcli con edit CON_NAME
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.identity USER
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> set 802-1x.ca-cert file:///home/brabier/certificates/ROOT.cer
nmcli> save
nmcli> quit
```
Start a new connection with `nmcli con up CON_NAME --ask`

Work
----

### Onedrive

Barely works...

[Github](https://github.com/skilion/onedrive)
[net-mics/onedrive](https://gpo.zugaina.org/net-misc/onedrive) overlay from dlang

```
systemctl --user stop onedrive
rm -r .config/ondrive
onedrive --synchronize
systemctl --user enable onedrive
systemctl --user start onedrive
```

### Kerberos

Add `kerberos` flag.
Setup SSH config in `~/.ssh/config`:
```
host *.domain
    GSSAPIAuthentication yes
    GSSAPIDelegateCredentials yes
```
Add same domains to Firefoxi (about:config):
```
etwork.negotiate-auth.delegation-uris --> .domain
network.negotiate-auth.trusted-uris    --> .domain
```

### RDP

Install freerdp

```
xfreerdp +clipboard /v:<host> /u:<account> /audio-mode:1 /size:<WxH>
```

