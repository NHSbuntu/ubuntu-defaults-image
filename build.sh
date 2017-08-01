#! /bin/sh
# Wrapper for NHSbuntu using customised ubuntu-defaults-image

# Usage:
# Requires ENV VAR for arch
# $ BUILDARCH=amd64 ./build.sh

# Optional ENV VAR for logging
# $ BUILD_LOGGING=quiet ./build.sh

BUILD_TIDY=false

export BUILD_ISO_ARCH=$BUILDARCH
export BUILD_ISO_WORKDIR=$BUILDARCH
export BUILD_ISO_FILE="NHSbuntu-$BUILD_ISO_ARCH-$(date +%Y%m%d)"
export LB_ISO_TITLE=NHSbuntu
export LB_ISO_VOLUME="NHSbuntu Xenial $(date +%Y%m%d)"

if [ "$BUILD_LOG" = "quiet" ]
  then
    export BUILD_LOGGING="quiet"
    export BUILD_LOGOPTS=" > ../$BUILD_ISO_ARCH.log 2>&1"
  else
    export BUILD_LOGGING="normal"
fi

echo "INFO: Build architecture is ${BUILD_ISO_ARCH}"
echo "INFO: Build workdir is ${BUILD_ISO_WORKDIR}"
echo "INFO: Build ISO filename is ${BUILD_ISO_FILE}"
echo "INFO: Build log level set to ${BUILD_LOGGING}"
echo "INFO: Build log opts are \"${BUILD_LOGOPTS}\""
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
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --xpackage libreoffice-style-breeze --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings > ../$BUILD_ISO_ARCH.log 2>&1

# Uncomment this line to run 'noisily'
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings

# BUILD_LOGOPTS from BUILD_LOGGING
echo "INFO: Build commands follow"

# For ubuntu-gnome
echo "INFO: NHSbuntu - gnome"
echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings $BUILD_LOGOPTS"
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}

# For ubuntu-gnome
echo "INFO: NHSbuntu - cinnamon"
echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --xpackage libreoffice-style-breeze --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings $BUILD_LOGOPTS"
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --xpackage libreoffice-style-breeze --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}

# For ubuntu-mate
echo "INFO: NHSbuntu - mate"
echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings $BUILD_LOGOPTS"
#../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}

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

if [ "$BUILD_TIDY" = "true" ]
  then
    echo "INFO: Tidying up"
    cd ../
    rm -rf $BUILD_ISO_WORKDIR
  else
    cd ../
fi

echo "INFO: Finished"
exit 0
