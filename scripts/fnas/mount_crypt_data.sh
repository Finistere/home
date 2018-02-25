#!/bin/bash

set -e

echo "Opening encrypted disk"
cryptsetup luksOpen /dev/md0 data
sleep 1

echo "Activating VG"
vgchange -ay /dev/vg-data

echo "Mounting"
mount /dev/vg-data/datafs /data

echo "Done !"

