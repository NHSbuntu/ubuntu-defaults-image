#! /bin/sh
# Wrapper for NHSbuntu customised ubuntu-defaults-image

WORKDIR=amd64
export LB_ISO_TITLE="NHSbuntu"
export LB_ISO_VOLUME="NHSbuntu xenial $(date +%Y%m%d)"
export BUILD_ISO_FILENAME="NHSbuntu-$1-$(date +%Y%m%d)"

apt-get install -y chroot curl git live-build cdebootstrap ubuntu-defaults-builder syslinux-utils genisoimage memtest86+ syslinux syslinux-themes-ubuntu-xenial gfxboot-theme-ubuntu livecd-rootfs

mkdir $WORKDIR
cd $WORKDIR
../ubuntu-defaults-image --ppa nhsbuntu/ppa --package nhsbuntu-default-settings --arch amd64 --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings
mv binary.hybrid.iso ../$BUILD_ISO_FILENAME-binary.iso
mv livecd.ubuntu-gnome.iso ../$BUILD_ISO_FILENAME-livecd.iso
cd ../
rm -rf $WORKDIR
