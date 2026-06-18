#!/bin/bash

set -ex

# Prepare Arch Linux Pacman directory
# in an effort to fix "not enough free disk space" error
sed -i -e 's|^CheckSpace|# CheckSpace|g' /etc/pacman.conf # Comment out CheckSpace
pacman -Scc --noconfirm
pacman-key --init
pacman-key --populate archlinux

# Some GNUstep build scripts need /proc
mount -t proc proc /proc

# https://github.com/gershwin-desktop/gershwin-developer
git clone https://github.com/gershwin-desktop/gershwin-developer.git /Developer
/Developer/Library/Scripts/Bootstrap.sh
/Developer/Library/Scripts/Checkout.sh
cd /Developer && sudo -E make install

. /System/Library/Makefiles/GNUstep.sh

# Everything that comes with the System should be in /System
mkdir -p /System/Applications /System/Library/Tools
sudo mv /Local/Applications/* /System/Applications || true
sudo mv /Local/Library/Tools/* /System/Library/Tools || true

# Initialize Directory Services (creates built-in admin user with no password)
dscli init

# Enable services for the live session
systemctl enable gdomap dshelper loginwindow avahi-daemon

# Configure LoginWindow for auto-login
mkdir -p /Local/Library/Preferences
cat > /Local/Library/Preferences/LoginWindow.plist <<\EOF
{
    lastLoggedInUser = admin;
    lastSession = "/System/Library/Scripts/Gershwin.sh";
}
EOF

# Otherwise ISO creation fails
umount /proc

# Set boot splash theme
plymouth-set-default-theme spinner -R
