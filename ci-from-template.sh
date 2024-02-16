#!/bin/sh

# ./vm-from-template.sh 9000 vmtest 900 vmbr0 "10.10.9.233"

template=$1
nodename=$2
nodeid=$3
br=$4
ip=$5

echo "Create node: $nodename nodeid: $nodeid br: $br ip: $ip template: $template"

# Deploy such a template by cloning:
qm clone $template $nodeid --name $nodename
qm resize $nodeid scsi0 +15G
# Overrivde template
# qm set $nodeid --cores 2
# qm set $nodeid --memory 4096

# SSH public key used for authentication, and configure the IP setup:
qm set $nodeid --sshkey ~/.ssh/id_rsa.pub   
qm set $nodeid --ipconfig0 "ip=$ip/24,gw=10.10.9.1"

qm start $nodeid

sec=15
echo Sleep $sec sec
sleep $sec

# known_hosts
echo "Remove $ip from known_hosts"
ssh-keygen -f "/root/.ssh/known_hosts" -R "10.10.9.$ip"

# resolve.conf is placed in the template
echo "ssh -o StrictHostKeyChecking=accept-new root@$ip cat /etc/resolv.conf"
echo "scp ./resolv.conf root@$ip:/etc/resolv.conf"
echo "ssh -o StrictHostKeyChecking=accept-new root@$ip cat /etc/resolv.conf"
