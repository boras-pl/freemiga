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

# infinite dhcp in background
if [ `cat ${TARGET_DIR}/etc/network/interfaces | grep udhcpc_opts | wc -l` -eq 0 ]
then
	sed -i "s/iface eth0 inet dhcp/iface eth0 inet dhcp\\n  udhcpc_opts -t 1 -b/" ${TARGET_DIR}/etc/network/interfaces

	cat <<- EOF >> ${TARGET_DIR}/etc/network/interfaces

auto wlan0
iface wlan0 inet dhcp
  udhcpc_opts -t 1 -b
  pre-up wpa_supplicant -B -Dnl80211 -iwlan0 -c/etc/wpa_supplicant.conf
  post-down killall -q wpa_supplicant
  wait-delay 15
  hostname \$(hostname)

iface default inet dhcp
EOF
fi

if [ `cat ${TARGET_DIR}/etc/init.d/S40network | grep nohup | wc -l` -eq 0 ]
then
	sed -i 's/^\t\/sbin\/ifup -a$/\t#nohup - we save approx. 5 seconds of boot time\n\t\/usr\/bin\/nohup & \&/' ${TARGET_DIR}/etc/init.d/S40network
fi

if [ `cat ${TARGET_DIR}/etc/fstab | grep '/boot' | wc -l` -eq 0 ]
then
	echo "/dev/mmcblk0p1	/boot		vfat	defaults	0	2" >> ${TARGET_DIR}/etc/fstab
fi
