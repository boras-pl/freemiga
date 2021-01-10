#!/bin/sh

cd `/usr/bin/dirname $0`
export PATH=~/bin:$PATH

amiberry --config conf/A4000RTG.uae -s use_gui=no
