change profile

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


Hardware
--------

### Bluetooth

[Handbook](https://wiki.gentoo.org/wiki/Bluetooth#Device_pairing)


Work
----

### Onedrive

[Github](https://github.com/skilion/onedrive)
[net-mics/onedrive](https://gpo.zugaina.org/net-misc/onedrive) overlay from dlang


