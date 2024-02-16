#!/bin/sh

# Usage:
# ssh -o StrictHostKeyChecking=accept-new root@10.10.9.90 'sh -s' < alpine-k8s-init.sh

# Do not change subnet
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name=c3n1 --ignore-preflight-errors=all -v=5

# Create config
mkdir ~/.kube
ln -s /etc/kubernetes/admin.conf /root/.kube/config

# Apply flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
