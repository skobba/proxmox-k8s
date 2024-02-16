#!/bin/bash

# ./vm-nuke.sh 500
# ./vm-nuke.sh "500 501 9000 9001 9002"

IDS=$1

for ID in $IDS
do
    echo "Thermonuclear target ==> $ID" 
    echo "nuke -> /var/lock/qemu-server/lock-$ID.conf"
    rm /var/lock/qemu-server/lock-$ID.conf

    qm unlock $ID
    echo "vm unlocked!"

    echo "vm stoped!"
    qm stop $ID

    qm destroy $ID
    echo "****** $ID NUKED ******"

done
