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

### Network

#### VPN
With a `/etc/vpnc/work.conf` having all the configuration.
Connect: `sudo vpnc work`
Disconnect: `sudo vpnc-disconnect`

DNS can be retrieved through `systemd-resolved`. But it didn't worked very well...
Using `net-vpn/networkmanager-vpnc` and using the GUI worked.

### Monitoring

net-analyzer/nethogs
htop

### PDF utilities

`app-text/poppler` -> pdfunite


Hardware
--------

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

