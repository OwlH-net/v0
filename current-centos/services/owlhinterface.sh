if ! yum list installed tcpreplay ; then 
    if ! yum list installed epel-release ; then 
        sudo yum --enablerepo=extras install epel-release
    fi
	sudo yum -y install tcpreplay
fi
echo 'dummy' > /etc/modules-load.d/dummy.conf
echo 'install dummy /sbin/modprobe --ignore-install dummy; /sbin/ip link set name owlh dev dummy0 ' > /etc/modprobe.d/dummy.conf

echo "
NAME=owlh
DEVICE=owlh
ONBOOT=yes
TYPE=Ethernet
NM_CONTROLLED=no
MTU=65535
" > /etc/sysconfig/network-scripts/ifcfg-dummy

/sbin/modprobe --ignore-install dummy
/sbin/ip link set name owlh dev dummy0
/sbin/ip link set owlh mtu 65535
ifup owlh
echo "NOZEROCONF=yes" >> /etc/sysconfig/network
