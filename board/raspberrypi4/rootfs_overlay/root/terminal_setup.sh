#!/bin/sh

setterm --term linux --background 7 --foreground 0 --store < /dev/tty1

if [ -f /usr/share/amigafonts/TopazPlus_a1200_v1.0.psf ]
then
    loadfont < /usr/share/amigafonts/TopazPlus_a1200_v1.0.psf
fi

clear
