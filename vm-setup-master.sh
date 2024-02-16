#!/bin/sh

# Run remotly with ssh
# ssh -o StrictHostKeyChecking=accept-new root@10.10.9.90 'sh -s' < vm-setup-master.sh

# From https://dev.to/xphoniex/how-to-create-a-kubernetes-cluster-on-alpine-linux-kcg 
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories

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
echo "net.bridge.bridge-nf-call-iptables=1" > /etc/sysctl.conf
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
apk add helm

mount --make-rshared /

# Resgister service
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

# Start the cluster - Do not change subnet!
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name=$(hostname)

mkdir ~/.kube
ln -s /etc/kubernetes/admin.conf /root/.kube/config

echo "Generate and save cluster join command to /joincluster.sh"
joinCommand=$(kubeadm token create --print-join-command 2>/dev/null) 
echo "$joinCommand --ignore-preflight-errors=all" > /joincluster.sh

echo "Setup flannel"
mkdir -p /run/flannel
cat >>/run/flannel/subnet.env<<EOF
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
EOF
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml


