#!/bin/bash

# Ref.: https://github.com/red-lichtie/alpine-cloud-init

# Usage:
# ./template-create.sh 9000 900 alpinetest "10.10.9.233" "10.10.9.1" "iso/alpine-standard-3.19.1-x86_64.iso"
#

ID=$1
TMP_VM=$2
NAME=$3
TMP_IP=$4
TMP_GW=$5
IMAGE=$6

# Images that needs manual cloud-init install
# apk add cloud-init
#
# IMAGE=iso/alpine-standard-3.19.1-x86_64.iso
# IMAGE=iso/alpine-virt-3.19.1-x86_64.iso
# IMAGE=cloudinit/nocloud_alpine-3.19.1-x86_64-bios-cloudinit-r0.qcow2

qm create $ID --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single
# Set template name
cat >>/etc/pve/qemu-server/$TMP_ID.conf<<EOF
name: $TMP_NAME
EOF
qm set $ID --scsi0 local-zfs:0,import-from=/var/lib/vz/template/$IMAGE
qm set $ID --ide2 local-zfs:cloudinit
qm set $ID --boot order=scsi0


########  NB JUST FOR cloud-init ########
# Configure a serial console and use it as a display
qm set $ID --serial0 socket --vga serial0
qm set $ID --ciuser root --cipassword password --nameserver "1.1.1.1"

# Testing the container before converting it to a template
qm clone $ID $TMP_VM --name $NAME

qm resize $TMP_VM scsi0 +5G
qm set $TMP_VM --sshkey ~/.ssh/id_rsa.pub
qm set $TMP_VM --ipconfig0 "ip=$TMP_IP/24,gw=$TMP_GW"

qm start $TMP_VM

echo
echo "Created template:     $ID"
echo "Started temp. vm:     $TMP_VM ($TMP_IP/24 $TMP_GW)"
echo
echo "ssh -o StrictHostKeyChecking=accept-new root@$TMP_IP cat /etc/resolv.conf"
echo "ssh -o StrictHostKeyChecking=accept-new root@$TMP_IP ping ipinfo.io"
echo "scp ./resolv.conf root@$TMP_IP:/etc/resolv.conf"
echo "./vm-nuke.sh \"$ID $TMP_VM\""
echo
echo "WARNING!! This can not be undone: qm template $TMP_ID"
echo
