#!/bin/bash

set -ex

export http_proxy=http://localhost:3128

SCRIPT=$(readlink -f "$0")
TOPDIR=$(dirname "$SCRIPT")
BINDIR=bin/ar71xx/

URL="https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/nand/OpenWrt-ImageBuilder-15.05-ar71xx-nand.Linux-x86_64.tar.bz2"
FILE=$(basename $URL)
DIR=${FILE%.tar.bz2}

PROFILE=WNDR4300

PACKAGES="wget luci luci-theme-bootstrap iptables-mod-nat-extra ipset libopenssl shadowsocks-libev -dnsmasq dnsmasq-full pdnsd luci-app-upnp"

if [ ! -e $FILE ]; then
    wget $URL
fi

rm -rf build
mkdir -p build
cd build

tar xvfj $TOPDIR/$FILE

cd $DIR

for patch in $TOPDIR/patches/*.patch; do
    patch -p1 < $patch
done
    
make image PROFILE="$PROFILE" PACKAGES="$(echo $PACKAGES)"
cp $BINDIR/*.{tar,img} $TOPDIR

cd $TOPDIR
#rm -r build
