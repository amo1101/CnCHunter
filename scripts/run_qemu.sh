#!/bin/bash
DIR_TO_PCAP=$1
FS_MALWARE_NAME=$2
DEBIAN=$3
ROOT_DIR=$4
MAC_WAN=$5
EMULATOR=$6
KERNEL_IMG=$7
ROOT_DEV=$8
MACH=$9
NET_DEV=${10}

BR_WAN="br-wan"
IF_INET="eth0"
QEMU_ROOT=$ROOT_DIR/../qemu/build

# - qemu-bridge-help has to be root setuid program.
#HELPER="/root/Desktop/qemu/build/qemu-bridge-helper"
HELPER="$QEMU_ROOT/qemu-bridge-helper"
mac_rand() {
        hexdump -n 3 -e '"52:54:00:" 2/1 "%02x:" 1/1 "%02x"' /dev/urandom
}

#MAC_WAN="$(mac_rand)"

echo $MAC_WAN > $DIR_TO_PCAP/mac_addr
if [ $DEBIAN == "False" ]; then
#/root/Desktop/qemu/build/mips-softmmu/qemu-system-mips \
$QEMU_ROOT/$EMULATOR \
	-M $MACH -nographic -m 1024 \
	-kernel $ROOT_DIR/kernels/$KERNEL_IMG \
	-drive file=$FS_MALWARE_NAME,index=0,media=disk,format=raw -append "root=$ROOT_DEV" \
    -netdev bridge,id=wan,br="$BR_WAN,helper=$HELPER" -device $NET_DEV,netdev=wan,mac="$MAC_WAN" \
	-object filter-dump,id=wan,netdev=wan,file=$DIR_TO_PCAP/qemu_wan.pcap
else
cp $ROOT_DIR/debian/debian_kernel $ROOT_DIR/debian/$FS_MALWARE_NAME
cp $ROOT_DIR/debian/debian.qcow2 $ROOT_DIR/debian/$FS_MALWARE_NAME.qcow2

KERNEL="$ROOT_DIR/debian/$FS_MALWARE_NAME"
HDA="$ROOT_DIR/debian/$FS_MALWARE_NAME.qcow2"
#/root/Desktop/qemu/build/mips-softmmu/qemu-system-mips \
$ROOT_DIR/Qemu/build/mips-softmmu/qemu-system-mips \
        -M malta \
        -kernel $KERNEL \
        -hda $HDA \
        -append "root=/dev/sda1 console=tty0" \
        -m 1024 \
        -netdev bridge,id=lan,br="$BR_WAN,helper=$HELPER" \
        -device virtio-net-pci,id=devlan,netdev=lan,mac="$MAC_WAN"
fi
