### Enable sysrq

  sudo echo 'kernel.sysrq=1' >> /etc/sysctl.d/90-sysrq.conf

### Checkout socket information

  lsof -i -a -p $PID

### GDB

https://github.com/cyrus-and/gdb-dashboard

### Wget

```bash
wget -r -l1 -k -nc -N --no-parent https://example.com/XXX
# -r           recursive
# -l1          depth=1
# -k           convert links for local viewing
# -nc          If file is the same, don't change existing ones.
# -N           If timtestamp is the same, don't download further
# --no-parant  Prevents download parent path.
```
