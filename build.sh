#! /bin/sh
# Wrapper for NHSbuntu using customised ubuntu-defaults-image

# Usage:
# Requires ENV VAR for arch & flavor (Gnome / Cinnamon / Mate)
# $ BUILDARCH=amd64 BUILDFLAVOUR=gnome ./build.sh

# Optional ENV VAR for logging
# $ BUILD_LOGGING=quiet BUILDARCH=amd64 BUILDFLAVOUR=gnome ./build.sh

# Set variables for script
BUILD_TIDY=false

# Set variables for live-build
export BUILD_ISO_ARCH=$BUILDARCH
export BUILD_ISO_WORKDIR=$BUILDARCH
export BUILD_ISO_FLAVOUR=$BUILDFLAVOUR
export BUILD_ISO_FILE="NHSbuntu-$BUILD_ISO_FLAVOUR-$BUILD_ISO_ARCH-$(date +%Y%m%d)"
export LB_ISO_TITLE=NHSbuntu
export LB_ISO_VOLUME="NHSbuntu $(date +%Y%m%d)"

# Set logging output
if [ "$BUILDLOG" = "quiet" ]
  then
    export BUILD_LOGGING="quiet"
    export BUILD_LOGSTATE="../$BUILD_ISO_ARCH.log"
    export BUILD_LOGOPTS=" > ../$BUILD_ISO_ARCH.log 2>&1"
  else
    export BUILD_LOGGING="normal"
    export BUILD_LOGSTATE="console"
    export BUILD_LOGOPTS=
fi

# INFO: to console
echo "INFO: Build workdir is ${BUILD_ISO_WORKDIR}"
echo "INFO: Build logging set to ${BUILD_LOGGING}"
echo "INFO: Build log output to ${BUILD_LOGSTATE}"
echo "INFO: Build architecture is ${BUILD_ISO_ARCH}"
echo "INFO: Build flavor is ${BUILD_ISO_FLAVOUR}"
echo "INFO: Build ISO filename is ${BUILD_ISO_FILE}"
echo "INFO: live-build ISO title is ${LB_ISO_TITLE}"
echo "INFO: live-build ISO volume is ${LB_ISO_VOLUME}"

# Dependencies
echo "INFO: Installing dependencies"
apt-get install -qq -y curl git live-build cdebootstrap ubuntu-defaults-builder syslinux-utils genisoimage memtest86+ syslinux syslinux-themes-ubuntu-xenial gfxboot-theme-ubuntu livecd-rootfs

# Patch lb_binary_disk to support $LB_ISO_VOLUME
echo "INFO: Patching lb_binary_disk"
cp /usr/lib/live/build/lb_binary_disk /usr/lib/live/build/lb_binary_disk.orig
sed -i 's/TITLE="Ubuntu"/TITLE="${LB_ISO_TITLE}"/' /usr/lib/live/build/lb_binary_disk
echo "INFO: Patched lb_binary_disk"

# Setup build
echo "INFO: Create workdir for build"

# Make workdir for arch
if [ ! -d "$BUILD_ISO_WORKDIR" ]; then
  mkdir $BUILD_ISO_WORKDIR
fi
cd $BUILD_ISO_WORKDIR

# Run build
echo "INFO: Run build"

# For build - ubuntu-gnome
if [ "$BUILD_ISO_FLAVOUR" = "gnome" ]; then
  echo "INFO: Building NHSbuntu - gnome"
  echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings $BUILD_LOGOPTS"
  ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}
fi

# For build - ubuntu-gnome dev
if [ "$BUILD_ISO_FLAVOUR" = "gnome-dev" ]; then
  echo "INFO: Building NHSbuntu - Gnome - Development"
  echo "INFO: ../ubuntu-defaults-image --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings-test ${BUILD_LOGOPTS}"
  ../ubuntu-defaults-image --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings-test ${BUILD_LOGOPTS}
fi

# For build - ubuntu-gnome & cinnamon dev
if [ "$BUILD_ISO_FLAVOUR" = "cinnamon-dev" ]; then
  echo "INFO: Building NHSbuntu - Cinnamon - Development"
  echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --xpackage libreoffice-style-breeze --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}"
  ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --xpackage libreoffice-style-breeze --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}
fi

# For build - ubuntu-mate dev
if [ "$BUILD_ISO_FLAVOUR" = "mate-dev" ]; then
  echo "INFO: Building NHSbuntu - Mate - Development"
  echo "INFO: ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}"
  ../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}
fi

echo "INFO: Completed build"

# Check for ISOs
BUILD_OUTISO_BINARY=$(ls -1|grep binary|grep iso)
BUILD_OUTISO_LIVECD=$(ls -1|grep livecd|grep iso)

if [ -f "$BUILD_OUTISO_BINARY" ]
  then
    echo "INFO: Found $BUILD_OUTISO_BINARY"
    echo "INFO: Moving binary ISO file"
    mv $BUILD_OUTISO_BINARY ../$BUILD_ISO_FILE-binary.iso
    BUILD_OUTISO_STATE=true
  else
    echo "INFO: binary ISO file not found"
    BUILD_OUTISO_STATE=false
fi

if [ -f "$BUILD_OUTISO_LIVECD" ]
  then
    echo "INFO: Found $BUILD_OUTISO_LIVECD"
    echo "INFO: Moving livecd ISO file"
    mv $BUILD_OUTISO_LIVECD ../$BUILD_ISO_FILE-livecd.iso
    BUILD_OUTISO_STATE=true
  else
    echo "INFO: livecd ISO file not found"
    BUILD_OUTISO_STATE=false
fi

if [ "${BUILD_OUTISO_STATE}" = true ]
  then
    echo "INFO: Built ISOs Successfully"
  else
    echo "INFO: Failed to build ISOs"
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
