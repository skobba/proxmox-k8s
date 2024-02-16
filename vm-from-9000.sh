#!/bin/sh

# ./vm-from-9000.sh c3n1 131 vmbr0

nodename=$1
nodeid=$2
br=$3

echo "Create k8s-node: $nodename nodeid: $nodeid br: $br"

qm clone 9000 $nodeid --name $nodename
qm resize $nodeid scsi0 +15G

qm start $nodeid

ssh-keygen -f "/root/.ssh/known_hosts" -R "10.10.9.90"


echo "cat >/etc/network/interfaces<<EOF"
echo "auto eth0"
echo "  iface eth0 inet static"
echo "  address 10.10.9.131/24"
echo "  gateway 10.10.9.1"
echo "EOF"


cat <<EOF

echo $nodeid > /etc/hostname

uuidgen > /etc/machine-id


reboot

ssh -o StrictHostKeyChecking=accept-new root@10.10.9.90
ssh-copy-id -o StrictHostKeyChecking=accept-new root@10.10.9.$nodeid

EOF
