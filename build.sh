#! /bin/sh
# Wrapper for NHSbuntu using customised ubuntu-defaults-image

# Usage:
# Run with sudo -E

# Requires ENV VAR for arch & flavor (Gnome / Cinnamon / Mate)
# $ BUILDARCH=amd64 BUILDFLAVOUR=gnome sudo -E ./build.sh

# Optional ENV VAR for logging
# $ BUILDLOG=quiet BUILDARCH=amd64 BUILDFLAVOUR=gnome sudo -E ./build.sh

# Set variables for script
BUILD_TIDY=false

if [ -z "$BUILDFLAVOUR" ]; then
  BUILDFLAVOUR=gnome
fi

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

# Install dependencies
# These dependencies are installed in our Docker image
echo "INFO: Checking / installing dependencies"
apt-get install -qq -y curl git live-build cdebootstrap ubuntu-defaults-builder syslinux-utils genisoimage memtest86+ syslinux syslinux-themes-ubuntu-xenial gfxboot-theme-ubuntu livecd-rootfs

# Patch lb_binary_disk to support $LB_ISO_VOLUME
echo "INFO: Checking lb_binary_disk"
grep LB_ISO_TITLE /usr/lib/live/build/lb_binary_disk > /dev/null
if [ $? -eq 0 ]; then
    echo "INFO: Checked lb_binary_disk"
else
  echo "INFO: Patching lb_binary_disk"
  cp /usr/lib/live/build/lb_binary_disk /usr/lib/live/build/lb_binary_disk.orig
  sed -i 's/TITLE="Ubuntu"/TITLE="${LB_ISO_TITLE}"/' /usr/lib/live/build/lb_binary_disk
fi
echo "INFO: Verified lb_binary_disk"

# Setup build
echo "INFO: Create workdir for build"

# Make workdir for arch
if [ ! -d "$BUILD_ISO_WORKDIR" ]; then
  mkdir $BUILD_ISO_WORKDIR
fi
cd $BUILD_ISO_WORKDIR

# Run build
echo "INFO: Build started"

# For build - ubuntu-gnome
if [ "$BUILD_ISO_FLAVOUR" = "gnome" ]; then
  echo "INFO: Building NHSbuntu - gnome"
  # Start build with options
  BUILD_ISO_CMD="../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome ${BUILD_LOGOPTS}"
  echo "EXEC: $BUILD_ISO_CMD"
  $BUILD_ISO_CMD
fi

# For build - ubuntu-gnome-nightly
if [ "$BUILD_ISO_FLAVOUR" = "gnome-nightly" ]; then
  echo "INFO: Building NHSbuntu - gnome-nightly"
  # Start build with options
  BUILD_ISO_CMD="../ubuntu-defaults-image --ppa nhsbuntu/ppa --ppa libreoffice/ppa --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings ${BUILD_LOGOPTS}"
  echo "EXEC: $BUILD_ISO_CMD"
  $BUILD_ISO_CMD
fi

# For build - ubuntu-gnome dev
if [ "$BUILD_ISO_FLAVOUR" = "gnome-dev" ]; then
  echo "INFO: Building NHSbuntu - Gnome - Development"
  # Start build with options
  BUILD_ISO_CMD="../ubuntu-defaults-image --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings-dev ${BUILD_LOGOPTS}"
  echo "EXEC: $BUILD_ISO_CMD"
  $BUILD_ISO_CMD
fi

# For build - ubuntu-gnome & cinnamon dev
if [ "$BUILD_ISO_FLAVOUR" = "cinnamon-dev" ]; then
  echo "INFO: Building NHSbuntu - Cinnamon - Development"
  # Start build with options
  BUILD_ISO_CMD="../ubuntu-defaults-image --ppa embrosyn/cinnamon --package nhsbuntu-default-settings --xpackage cinnamon --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings-dev ${BUILD_LOGOPTS}"
  echo "EXEC: $BUILD_ISO_CMD"
  $BUILD_ISO_CMD
fi

# For build - ubuntu-mate dev
if [ "$BUILD_ISO_FLAVOUR" = "mate-dev" ]; then
  echo "INFO: Building NHSbuntu - Mate - Development"
  # Start build with options
  BUILD_ISO_CMD="../ubuntu-defaults-image --ppa ubuntu-x-swat/updates --package nhsbuntu-default-settings --arch $BUILD_ISO_ARCH --release xenial --flavor ubuntu-mate --repo nhsbuntu/nhsbuntu-default-settings-dev ${BUILD_LOGOPTS}"
  echo "EXEC: $BUILD_ISO_CMD"
  $BUILD_ISO_CMD
fi

echo "INFO: Build ended"

# Check for ISOs
BUILD_OUTISO_BINARY=$(ls -1|grep binary|grep iso)
BUILD_OUTISO_LIVECD=$(ls -1|grep livecd|grep iso)

if [ -f "$BUILD_OUTISO_BINARY" ]
  then
    echo "INFO: Found $BUILD_OUTISO_BINARY"
    echo "INFO: Moving binary ISO file"
    mv $BUILD_OUTISO_BINARY ../$BUILD_ISO_FILE-binary.iso
    cd ../
    echo "INFO: Generating checksums"
    md5sum $BUILD_ISO_FILE-binary.iso > $BUILD_ISO_FILE-binary.iso.checksum
    sha1sum $BUILD_ISO_FILE-binary.iso >> $BUILD_ISO_FILE-binary.iso.checksum
    sha256sum $BUILD_ISO_FILE-binary.iso >> $BUILD_ISO_FILE-binary.iso.checksum
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
    cd ../
    echo "INFO: Generating checksums"
    md5sum $BUILD_ISO_FILE-livecd.iso > $BUILD_ISO_FILE-livecd.iso.checksum
    sha1sum $BUILD_ISO_FILE-livecd.iso >> $BUILD_ISO_FILE-livecd.iso.checksum
    sha256sum $BUILD_ISO_FILE-livecd.iso >> $BUILD_ISO_FILE-livecd.iso.checksum
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
