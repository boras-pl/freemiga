# FreeMIGA
A lightweight, buildroot-based Linux operating system for Raspberry PI 4b with Amiberry.
- Buildroot is a set of tools that automates process of cross-compilation of an operating system for embedded devices.
- Amiberry is a famous Amiga emulator

FreeMIGA integrates all together and prepares a system with some unique features:
- minimal resources usage - only necessary components included
- fast boot-up
- open source - anything can be changed or corrected

- git clone git://git.buildroot.net/buildroot
- git clone https://github.com/boras-pl/freemiga
- cd buildroot
- make BR2_EXTERNAL=../freemiga raspberrypi4_64_defconfig
- make BR2_EXTERNAL=../freemiga all
- sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4096 #where X is your sd-card letter. All data on will be lost! Be aware of what you do.

- the emulator starts automatically, however it is possible to log in the system as following users:
- root, password: freemiga
- user, password: brfm

Note: It won't work without proprietary and copyrighted ROM files in the ~/rom directory.

Should you have any questions, please visit https://buildroot.org/ and https://github.com/midwan/amiberry first.

Work still in progress...

TODO:
- boot menu
- some networking, maybe wifi
- initial config for 50Hz & 1080p displays (PAL emulation)
- some tuning of Amiberry
- who knows what else...
