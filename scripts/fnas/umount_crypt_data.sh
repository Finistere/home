#!/bin/bash

set -e

echo "Unmounting"
umount /data

echo "Deactivating VG"
vgchange -an /dev/vg-data

echo "Closing encrypted disk"
cryptsetup luksClose data

echo "Done !"

