# ./vm-mount-iso.sh alpinetest 9000 vmbr0 "iso/alpine-standard-3.19.1-x86_64.iso"

hostname=$1
vmid=$2
br=$3
iso=$4

echo "Create vmid: $vmid hostname: $hostname"

qm create $vmid --memory 4096 --cores 2 --net0 "virtio,bridge=$br" --scsihw virtio-scsi-single

# Set template name
cat >>/etc/pve/qemu-server/$vmid.conf<<EOF
name: $hostname
EOF

echo "Create zfs volumes"
zfs create -V 5G rpool/data/vm-$vmid-disk-0
mkfs.ext4 /dev/zvol/rpool/data/vm-$vmid-disk-0

echo "Attach volume"
qm set $vmid --scsi0 local-zfs:vm-$vmid-disk-0

echo "Attach iso image: $iso"
qm set $vmid --ide2 local:$iso

echo "Create and attach cloudinit cdrom"
qm set $vmid --ide1 local-zfs:cloudinit

echo "Set boot order"
qm set $vmid --boot order=ide2

echo "Set ssh key"
qm set $vmid --sshkey ~/.ssh/id_rsa.pub

qm start $vmid

# echo "Save iso"
# dd if=/dev/zvol/rpool/data/vm-$vmid-disk-0 of=./k8alpine1.iso status=progress

# echo "Convert iso to cloud-init"
# qemu-img convert -f raw -O qcow2 ./k8alpine1.iso ./k8alpine1.qcow2

# # start cloud-init
# apk add cloud-init util-linux 
# rc-update add cloud-init default
# rc-service cloud-init start


# cat >/etc/apk/repositories<<EOF
# http://dl-cdn.alpinelinux.org/alpine/v3.19/main
# http://dl-cdn.alpinelinux.org/alpine/v3.19/community
# EOF

# apk update