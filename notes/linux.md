### Enable sysrq

  sudo echo 'kernel.sysrq=1' >> /etc/sysctl.d/90-sysrq.conf

### Checkout socket information

  lsof -i -a -p $PID


