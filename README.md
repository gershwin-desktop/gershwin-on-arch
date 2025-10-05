# Gershwin-on-Arch Live ISO builder

Gershwin build and installation takes place in [customize_airootfs.sh](airootfs/root/customize_airootfs.sh)

Autologin is controlled by the display manager, and if there isn't one, startx is run from
`/etc/profile.d/zz-live-config_xinit.sh`. 
This file was manually added based on `/lib/live/config/0140-xinit` from the `live-config` package in Debian.

## Archiso Manual

https://wiki.archlinux.org/title/Archiso
