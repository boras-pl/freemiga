#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then

    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::wait:/bin/su -c /home/user/amiberry_start.sh user\
tty1::wait:/root/terminal_setup.sh\
tty1::respawn:/sbin/getty -L tty1 0 linux # HDMI console' ${TARGET_DIR}/etc/inittab

fi

#CTRL-ALT-DEL
sed -i 's/#::ctrlaltdel/::ctrlaltdel/' ${TARGET_DIR}/etc/inittab

# w/a for time of splash visibility - initialize FKMS as late as possible
mv ${TARGET_DIR}/etc/init.d/S10udev ${TARGET_DIR}/etc/init.d/S90udev
# network initialization in background. Does not work :(
#sed -i 's/^esac$/esac \&/' ${TARGET_DIR}/etc/init.d/S40network
#sed -i 's/^esac$/esac \&/' ${TARGET_DIR}/etc/init.d/S41dhcpcd
