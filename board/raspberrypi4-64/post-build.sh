#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then

    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty3::once:-/bin/login -f user\
tty1::respawn:/sbin/getty -L tty1 0 linux # HDMI console' ${TARGET_DIR}/etc/inittab

fi

#CTRL-ALT-DEL
sed -i 's/#::ctrlaltdel/::ctrlaltdel/' ${TARGET_DIR}/etc/inittab

#w/a for long splash visibility - initialize FKMS as late as possible
if [ -e ${TARGET_DIR}/etc/init.d/S10udev ]; then
	mv ${TARGET_DIR}/etc/init.d/S10udev ${TARGET_DIR}/etc/init.d/S60udev
fi
