#!/bin/sh

# Ref.: https://twdev.blog/2023/11/alpine_cloudinit/

cat >/etc/apk/repositories<<EOF
http://dl-cdn.alpinelinux.org/alpine/v3.19/main
http://dl-cdn.alpinelinux.org/alpine/v3.19/community
EOF

apk add \
    util-linux \
    e2fsprogs-extra \
    qemu-guest-agent \
    sudo

rc-update add qemu-guest-agent

apk add py3-netifaces
apk add cloud-init


# Remove unnececary sources from: datasource_list: ['NoCloud', 'ConfigDrive', 'LXD', ...]
# vi /etc/cloud/cloud.cfg
sed -i '/datasource_list/d' ./cloud.cfg
echo "datasource_list: ['NoCloud']" >> ./cloud.cfg

passwd -d root
setup-cloud-init
poweroff

qm set 8000 --sshkey ~/.ssh/id_rsa.pub
qm set 8000 --ipconfig0 "ip=10.10.9.80/24,gw=10.10.9.1"
ssh-keygen -f "/root/.ssh/known_hosts" -R "10.10.9.80"

apk --update --no-cache add python3~3.10   --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main