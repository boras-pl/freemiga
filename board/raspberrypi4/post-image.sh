#!/bin/bash

set -e

ARCH_SUFFIX=""
#as we reuse 32bit board in 64bit builds, we need to the proper genimage config architecture
if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
	ARCH_SUFFIX="-64"
fi

BOARD_DIR="$(dirname ${BR2_CONFIG})"
BOARD_DIR=${BOARD_DIR}/board/raspberrypi4
echo $BOARD_DIR
echo $BR2_CONFIG
echo $BOARD_NAME
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}${ARCH_SUFFIX}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for arg in "$@"
do
	case "${arg}" in
		--add-miniuart-bt-overlay)
		if ! grep -qE '^dtoverlay=miniuart-bt' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi (3B, 3B+, 3A+, 4B and Zero W) ttyAMA0 serial console
dtoverlay=miniuart-bt
__EOF__
		fi
		;;
		--aarch64)
		# Run a 64bits kernel (armv8)
		sed -e '/^kernel=/s,=.*,=Image,' -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		if ! grep -qE '^arm_64bit=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_64bit=1
__EOF__
		fi
		;;
		--gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
		# Set GPU memory
		gpu_mem="${arg:2}"
		sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		;;
	esac

done

# needed by Amiberry
if ! grep -qE '^dtoverlay=vc4-fkms-v3d' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
	echo "Adding av optons to config.txt."
	cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"
dtoverlay=vc4-fkms-v3d
max_framebuffers=1
dtparam=audio=on
disable_splash=1
hdmi_force_hotplug=1
hdmi_group=1
hdmi_mode=31
__EOF__
fi

#add logo and hide kernel messages - see:
# https://www.kernel.org/doc/html/v5.4/admin-guide/kernel-parameters.html
# https://www.kernel.org/doc/html/latest/fb/fbcon.html
sed -i 's/115200$/115200 fbcon=nodefer,logo-pos:center,logo-count:1 vt.color=0x00/' "${BINARIES_DIR}/rpi-firmware/cmdline.txt"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
