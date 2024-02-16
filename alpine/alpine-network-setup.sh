cat >/etc/network/interfaces<<EOF
auto eth0
    iface eth0 inet static
    address 10.10.9.111/24
    gateway 10.10.9.1
EOF

echo c1n1 > /etc/hostname

uuidgen > /etc/machine-id

service networking restart
