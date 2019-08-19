General upgrade guide: https://wiki.gentoo.org/wiki/Kernel/Upgrade

Gentoo
======

Software
--------

### Emerge

```bash
# Update repositories
emerge --sync
# Update everything
emerge -aquDU --keep-going --with-bdeps=y @world
```

### Kernel

```
cd /usr/src/linux
make menuconfig
make -j5
make modules_install && make install
```

```
genkernel --install initramfs
```

### vpnc

Connect: `sudo vpnc [default.conf]`
Disconnect: `sudo vpnc-disconnect`


Hardware
--------

### Bluetooth

[Handbook](https://wiki.gentoo.org/wiki/Bluetooth#Device_pairing)


Work
----

### Onedrive

[Github](https://github.com/skilion/onedrive)
[net-mics/onedrive](https://gpo.zugaina.org/net-misc/onedrive) overlay from dlang
```
systemctl --user stop onedrive
rm -r .config/ondrive
onedrive --synchronize
systemctl --user enable onedrive
systemctl --user start onedrive
```


