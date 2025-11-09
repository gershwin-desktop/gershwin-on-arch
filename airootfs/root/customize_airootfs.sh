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

# Workaround for https://github.com/gershwin-desktop/gershwin-on-arch/issues/1
pacman -Sy core/mkinitcpio

# https://github.com/gershwin-desktop/gershwin-build
git clone https://github.com/gershwin-desktop/gershwin-build.git && cd gershwin-build
./bootstrap.sh
./checkout.sh
sudo -E make install
cd /root

. /System/Library/Makefiles/GNUstep.sh

# TODO: Move to gershwin-build
git clone --recursive https://github.com/probonopd/gershwin-components && cd gershwin-components
sudo pacman -Syu dbus pam pkgconf --noconfirm
cp -r /usr/lib/dbus-1.0/include/dbus /usr/include/ || true # Arch Linux; FIXME: Find a better way
cp -r /usr/lib/*-linux-gnu/dbus-1.0/include/dbus /usr/include/ || true # Debian; FIXME: Find a better way
find /usr/include -name "dbus-arch-deps.h"
cd Menu
make -j$(nproc)
sudo -E make install
cd -
cd LoginWindow
make -j$(nproc)
sudo -E make install
cd -

# Everything that comes with the System should be in /System
mkdir -p /System/Applications /System/Library/Tools
sudo mv /Local/Applications/* /System/Applications || true
sudo mv /Local/Library/Tools/* /System/Library/Tools || true

# Otherwise ISO creation fails
umount /proc

# Set boot splash theme
plymouth-set-default-theme spinner -R
