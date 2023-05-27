
systemctl enable rc-local
cat > /etc/rc.local <<\EOF
#!/bin/sh -e
modprobe -v dummy numdummies=0
ip link add owlh type dummy
ip link set owlh mtu 65535
ip link set owlh up
EOF
chmod 755 /etc/rc.local 
modprobe -v dummy numdummies=0
ip link add owlh type dummy
ip link set owlh mtu 65535
ip link set owlh up
