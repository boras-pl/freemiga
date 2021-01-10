# FreeMIGA - another Amiga-like clone on RPi4b
A lightweight, buildroot-based Linux operating system for Raspberry PI 4b with Amiberry and Aros OS with some WHDLoad cractros.
Visit [Releases](https://github.com/boras-pl/freemiga/releases) for the latest stable SD card image.

- Buildroot is a set of tools that automates process of cross-compilation of an operating system for embedded devices.
- Amiberry is a famous Amiga emulator
- Aros OS - an open source operating system mostly compatible with the original one
- WHDLoad is a HDD installer for games, demos and other software
- example cractros - see https://en.wikipedia.org/wiki/Crack_intro - a package distributed by the WHDLoad team.

![screenshot](screenshot.png)

FreeMIGA integrates all together and prepares a system with some unique features:
- minimal resources usage - only necessary components included
- fast boot-up
- initial config set-up 50Hz & 1080p displays (PAL emulation)
- pixel perfect scaling
- open source - anything can be changed or corrected
- this repository does not include any 3rd party s/w. All components are dynamically downloaded during the build process.
- all components have various licenses however, all of them seem to be freely redistributable under some conditions. See details and familiarize with the licenses under sites listed in the Notes section.
- the project does not provide any proprietary and paid software including but not limited to original copyrighted ROM files, operating systems, games etc. The main goal of this project is to provide a LEGAL and WORKING environment in accordance with the law.

Depending on the machine speed, the whole build process may take ~ 1h. The compilation (tested on Mint 20 and latest Ubuntu) procedure is:
```
sudo apt update
sudo apt install git
sudo apt install build-essential
git clone git://git.buildroot.net/buildroot
git clone https://github.com/boras-pl/freemiga
#correct manually the AROS_VERSION variable in freemiga/package/aros/aros.mk
#it is important as the latest sourceforge file is not always a m68k iso image.
#to check the latest date visit https://sourceforge.net/projects/aros/files/nightly2/
cd buildroot
make BR2_EXTERNAL=../freemiga raspberrypi4_64_defconfig
make BR2_EXTERNAL=../freemiga all 2>&1 | tee make.log
sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4096 #where X is your sd-card letter. Double check - all data on will be lost! Be aware of what you do. Sometimes, letters can surprise, especially when an USB flash drive is inserted while booting a system.
```

Usage:
- the emulator starts automatically, however it is possible (using the Quit button in Amiberry) to log in the system as following users:
- root, password: freemiga
- user, password: brfm
- F12 goes to the Amiberry menu
- execute ./expand_partition.sh as root to get a full size of / (there is a bug in v1.1. Check the latest script version out)

Notes:
- Should you have any questions, please visit following sites first:
  - https://buildroot.org/
  - https://github.com/midwan/amiberry
  - https://github.com/fragglet/lhasa
  - https://aros.sourceforge.io
  - http://whdload.de/
- Despite of very few resources, the work is still in progress, a lot of thing may work or not
- no other h/w except of a future Pi5 or any faster equivalent model is planned.
- recommended architecture is AARCH64. 32bit environment is very slow
- under the Amiberry emulator an ordinary Buildroot Linux is placed with a simple userspace based on Busybox. 
- the graphics is rendered with SDL2 on the top of Broadcom Fake KMS for VC4/V3D technology.
- unfortunately Aros OS is not regularly released. The latest nightly builds are integrated. If the latest Aros compilation have a serious problem, it simply won't work. Try to build on another day.
- networking initialization
- sshd server is enabled
- iptables - currently not yet configured - all ports open

TODO:
- wifi
- VICE, if possible - integration of a C64 emulator
- who knows what else...
