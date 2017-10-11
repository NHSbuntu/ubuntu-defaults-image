#! /bin/sh
# Use qemu to test an ISO created by ubuntu-defaults-image

# Usage:
# ./test-with-qemu.sh ISO ACTION

# Examples:
# To install from ISO
# ./test-with-qemu.sh ~/path/to/NHSbuntu-gnome-i386-20171009-binary.iso install
# To boot from installed system
# ./test-with-qemu.sh ~/path/to/NHSbuntu-gnome-i386-20171009-binary.iso boot

# Set variables for script
TEST_ISO_PATH=$1
TEST_ACTION=$2
TEST_ISO_NAME=`echo "$TEST_ISO_PATH" |rev|cut -d'/' -f 1|rev|cut -d'.' -f 1`
TEST_QCOW2_IMG=$TEST_ISO_NAME.img
TEST_QCOW2_SIZE=8
TEST_QEMU_RAM=2048

case "$TEST_ISO_NAME" in
  *amd64*)
    TEST_CPU_ARCH=x86_64
    ;;
  *i386*)
    TEST_CPU_ARCH=i386
    ;;
esac

echo "INFO: Starting $TEST_ACTION of $TEST_ISO_NAME"
echo "INFO: ISO architecture is $TEST_CPU_ARCH"

case "$TEST_ACTION" in
  install)
    echo "INFO: Removing prior disk image"
    if [ -f "$TEST_QCOW2_IMG" ]
      then rm -f $TEST_QCOW2_IMG
    fi
    if [ ! -f "$TEST_QCOW2_IMG" ]
      then
      echo "INFO: Creating new disk image"
      qemu-img create -f qcow2 $TEST_QCOW2_IMG ${TEST_QCOW2_SIZE}G > /dev/null
    fi
    echo "INFO: Starting QEMU $TEST_ACTION"
    eval qemu-system-$TEST_CPU_ARCH -enable-kvm -m ${TEST_QEMU_RAM}M -drive file=$TEST_QCOW2_IMG,if=virtio,format=qcow2,media=disk -cdrom $TEST_ISO_PATH -vga qxl &
    ;;
  boot)
    echo "INFO: Starting QEMU $TEST_ACTION"
    eval qemu-system-$TEST_CPU_ARCH -enable-kvm -m ${TEST_QEMU_RAM}M -drive file=$TEST_QCOW2_IMG,if=virtio,format=qcow2,media=disk -vga qxl &
    ;;
esac

echo "INFO: Started $TEST_ACTION"
exit 0
