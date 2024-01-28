#!/bin/sh

ABS_PATH=$1
PCAP_DIR=$2
FS_FILE=$3
DEBIAN=$4
MAC_ADDR=$5
EMULATOR=$6
KERNEL_IMG=$7
ROOT_DEV=$8
MACH=$9
NET_DEV=${10}
screen -dmS CnCHunter ${ABS_PATH}/scripts/run_qemu.sh ${PCAP_DIR} ${FS_FILE} ${DEBIAN} ${ABS_PATH} ${MAC_ADDR} ${EMULATOR} ${KERNEL_IMG} ${ROOT_DEV} ${MACH} ${NET_DEV}
