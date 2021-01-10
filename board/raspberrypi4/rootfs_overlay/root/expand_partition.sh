#!/bin/sh

EXPECTED_DEVICE=mmcblk0
PARTNUM=`fdisk -l /dev/${EXPECTED_DEVICE} | grep ${EXPECTED_DEVICE}p | wc -l`

#if two partitions on SD card are found
if [ ${PARTNUM} -eq 2 ]
then
    #let's check their names and type
    PART2RESIZE=`fdisk -l /dev/${EXPECTED_DEVICE} | grep Linux | awk '{print $1}'`
    #we ensure that the only Linux partition is 2
    if [ "${PART2RESIZE}" == "/dev/${EXPECTED_DEVICE}p2" ]
    then
        fdisk /dev/${EXPECTED_DEVICE} << PARTCMD
p
d
2
n
p
2


w
PARTCMD

        cat <<EOF > /etc/init.d/S91_resize2fs_once
#!/bin/sh

case "\$1" in
  start)
        /sbin/resize2fs /dev/mmcblk0p2
        # do not start it again
        mv /etc/init.d/S91_resize2fs_once /etc/init.d/_S91_resize2fs_once
        sleep 1
        ;;
  stop)
        ;;
  restart|reload)
        "\$0" stop
        "\$0" start
        ;;
  *)
        echo "Usage: \$0 {start|stop|restart}"
        exit 1
esac

EOF
        chmod 755 /etc/init.d/S91_resize2fs_once
        echo "Reboot is needed..."
        sleep 1
        reboot
    fi
fi
