export LB_ISO_TITLE="NHSbuntu"
export LB_ISO_VOLUME="NHSbuntu xenial $(date +%Y%m%d)"
export BUILD_ISO_FILENAME="NHSbuntu-$1-$(date +%Y%m%d)"
./ubuntu-defaults-image --ppa nhsbuntu/ppa --package nhsbuntu-default-settings --arch $1 --release xenial --flavor $2 --repo nhsbuntu/nhsbuntu-default-settings
mv binary.hybrid.iso $BUILD_ISO_FILENAME-binary.iso
mv livecd.ubuntu-gnome.iso $BUILD_ISO_FILENAME-livecd.iso
