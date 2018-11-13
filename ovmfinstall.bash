#!/bin/bash

LIBVIRT='ebtables dnsmasq bridge-utils openbsd-netcat virt-viewer virt-manager ovmf'
QEMU='qemu-arch-extra qemu-block-gluster qemu-block-iscsi qemu-block-rbd'

#systemctl enable libvirtd.service

#/etc/libvirt/qemu.conf
#
#nvram = [
#	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
#]
