#!/bin/bash

set -ex

# Prepare Arch Linux Pacman directory
# in an effort to fix "not enough free disk space" error
sed -i -e 's|^CheckSpace|# CheckSpace|g' /etc/pacman.conf # Comment out CheckSpace
pacman -Scc --noconfirm
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring --noconfirm

# Some GNUstep build scripts need /proc
mount -t proc proc /proc

mkdir -p /root
cd /root

# https://github.com/gershwin-desktop/gershwin-build
git clone https://github.com/gershwin-desktop/gershwin-build.git && cd gershwin-build
./bootstrap.sh
./checkout.sh
sudo -E make install
cd /root

. /System/Library/Makefiles/GNUstep.sh

# Everything that comes with the System should be in /System
mkdir -p /System/Applications /System/Library/Tools
sudo mv /Local/Applications/* /System/Applications || true
sudo mv /Local/Library/Tools/* /System/Library/Tools || true

# Otherwise ISO creation fails
umount /proc

# Set boot splash theme
plymouth-set-default-theme spinner -R
