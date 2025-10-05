# Autologin is controlled by the display manager, and if there isn't one, 
# startx is run from this file.
# This file was manually added based on /lib/live/config/0140-xinit
# from the live-config package in Debian.
# It was modified to start /System/Library/Scripts/Gershwin.sh directly
# unlike on Debian, where
# sudo update-alternatives --install /usr/bin/x-session-manager \
#     x-session-manager /System/Library/Scripts/Gershwin.sh 40
# can be used to set the desired session manager.

if [ -z "${DISPLAY}" ] && [ $(tty) = /dev/tty1 ]
then
	while true
	do
		if grep -qs quiet /proc/cmdline
		then
			startx /System/Library/Scripts/Gershwin.sh > /dev/null 2>&1
		else
			startx /System/Library/Scripts/Gershwin.sh
		fi
	done
fi
