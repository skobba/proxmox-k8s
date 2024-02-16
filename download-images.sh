#!/bin/bash

# Ref.:
# https://alpinelinux.org/downloads/ - Standard
# https://alpinelinux.org/cloud/ - cloud-init

mkdir /var/lib/vz/template/cloudinit

# cloud-init
pushd /var/lib/vz/template/cloudinit
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/cloud/nocloud_alpine-3.19.1-x86_64-bios-cloudinit-r0.qcow2
popd

# Standard
pushd /var/lib/vz/template/iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-standard-3.17.7-x86_64.iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-extended-3.18.6-x86_64.iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-extended-3.19.1-x86_64.iso
popd