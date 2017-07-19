#! /bin/sh
# Wrapper for NHSbuntu customised ubuntu-defaults-image
# Expects ENV VAR for arch

# Usage
# $ BUILDARCH=amd64 ./build.sh

BUILDTIDY=false

export BUILD_ISO_ARCH=$BUILDARCH
export BUILD_ISO_WORKDIR=$BUILDARCH
export BUILD_ISO_FILE="NHSbuntu-$BUILD_ISO_ARCH-$(date +%Y%m%d)"
export LB_ISO_TITLE=NHSbuntu
export LB_ISO_VOLUME="NHSbuntu xenial $(date +%Y%m%d)"

echo "INFO: Build architecture is ${BUILD_ISO_ARCH}"
echo "INFO: Build workdir is ${BUILD_ISO_WORKDIR}"
echo "INFO: Build ISO filename is ${BUILD_ISO_FILE}"
echo "INFO: live-build ISO title is ${LB_ISO_TITLE}"
echo "INFO: live-build ISO volume is ${LB_ISO_VOLUME}"

echo "INFO: Installing dependencies"
apt-get install -qq -y curl git live-build cdebootstrap ubuntu-defaults-builder syslinux-utils genisoimage memtest86+ syslinux syslinux-themes-ubuntu-xenial gfxboot-theme-ubuntu livecd-rootfs

# Patch lb_binary_disk to support $LB_ISO_VOLUME
echo "INFO: Patching lb_binary_disk"
cp /usr/lib/live/build/lb_binary_disk /usr/lib/live/build/lb_binary_disk.orig
sed -i 's/TITLE="Ubuntu"/TITLE="${LB_ISO_TITLE}"/' /usr/lib/live/build/lb_binary_disk
echo "INFO: Patched lb_binary_disk"

# Do the build
echo "INFO: Running build"

if [ ! -d "$BUILD_ISO_WORKDIR" ]; then
  mkdir $BUILD_ISO_WORKDIR
fi
cd $BUILD_ISO_WORKDIR

# Choose your command!
# Uncomment this line to run 'quietly' and log to ../$BUILD_ISO_ARCH.log
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings > ../$BUILD_ISO_ARCH.log 2>&1

# Uncomment this line to run 'noisily'
../ubuntu-defaults-image --ppa nhsbuntu/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings

echo "INFO: Completed build"

if [ -e binary.hybrid.iso -a -e livecd.ubuntu-gnome.iso ]
  then
    echo "INFO: ISO files created"
    echo "INFO: Moving ISO files"
    mv binary.hybrid.iso ../$BUILD_ISO_FILE-binary.iso
    mv livecd.ubuntu-gnome.iso ../$BUILD_ISO_FILE-livecd.iso
  else
    echo "INFO: No ISO files created"
    exit 1
fi

if [ "$BUILDTIDY" = "true" ]
  then
    echo "INFO: Tidying up"
    cd ../
    rm -rf $BUILD_ISO_WORKDIR
  else
    cd ../
fi

echo "INFO: Finished"
exit 0
