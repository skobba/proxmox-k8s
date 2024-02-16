#!/bin/sh

# Usage:
# ssh -o StrictHostKeyChecking=accept-new root@10.10.9.90 'sh -s' < alpine-k8s-setup.sh
# Ref.: https://wiki.alpinelinux.org/wiki/K8s

cat >/etc/apk/repositories<<EOF
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF

apk update

echo "br_netfilter" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward

apk add cni-plugin-flannel
apk add cni-plugins
apk add flannel
apk add flannel-contrib-cni
apk add kubelet
apk add kubeadm
apk add kubectl
apk add containerd
apk add uuidgen
apk add nfs-utils

# Get rid of swap on reboot
swapoff -a
sysctl vm.swappiness=1


# Get rid of swap on reboot
echo "vm.swappiness=1" >> /etc/sysctl.conf
cat /etc/fstab | grep -v swap > temp.fstab
cat temp.fstab > /etc/fstab
rm temp.fstab
mount -a

free -h
cat /etc/fstab
cat /proc/sys/vm/swappiness


# Fix prometheus errors
mount --make-rshared /

# Fix id error messages
# uuidgen > /etc/machine-id -> MOVED TO "kubeadm init" script

# Add services
rc-update add containerd default
rc-update add kubelet default

# Sync time
rc-update add ntpd
rc-service ntpd start
rc-service containerd start
rc-service kubelet start

# Fix flannel
ln -s /usr/libexec/cni/flannel-amd64 /usr/libexec/cni/flannel

# Kernel stuff
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl net.bridge.bridge-nf-call-iptables=1

cat << EOF
# Setup the Control Plane (New Cluster!) 🦾
# Run this command to start the cluster and then apply a network.
# Do not change subnet
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name=$(hostname) --ignore-preflight-errors=all -v=5

# Apply flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Create config
mkdir ~/.kube
ln -s /etc/kubernetes/admin.conf /root/.kube/config

# Get join-cluster command
kubeadm token create --print-join-comman
EOF
