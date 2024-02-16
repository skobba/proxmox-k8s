#!/bin/sh

# Run remotly with ssh
# ssh -o StrictHostKeyChecking=accept-new root@10.10.9.90 'sh -s' < vm-setup-worker.sh

cat >/etc/apk/repositories<<EOF
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF

apk update

echo "br_netfilter" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter
modprobe overlay
echo 1 > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/vm/swappiness
swapoff -a

# Fix flannel
ln -s /usr/libexec/cni/flannel-amd64 /usr/libexec/cni/flannel

# Kernel stuff
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl net.bridge.bridge-nf-call-iptables=1

# Enable Linux IP forwarding
sysctl -w net.ipv4.ip_forward=1
apk add flannel
apk add flannel-contrib-cni
apk add kubelet
apk add kubeadm
apk add kubectl
apk add containerd
apk add uuidgen
apk add nfs-utils

mount --make-rshared /

# Register service
rc-update add containerd
rc-update add kubelet

# Sync time
rc-update add ntpd
rc-service ntpd start
rc-service containerd start

# Pin your versions! If you update and the nodes get out of sync, it implodes. 
# apk add 'kubelet=~1.27'
# apk add 'kubeadm=~1.27'
# apk add 'kubectl=~1.27'
