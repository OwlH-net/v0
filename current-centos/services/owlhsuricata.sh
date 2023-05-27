# Suricata

# Main packages 
amazon-linux-extras install rust1 -y
yum -y install epel-release wget git
yum -y install jq openssl-devel PyYAML lz4-devel gcc libpcap-devel pcre-devel libyaml-devel file-devel zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make libnetfilter_queue-devel lua-devel cmake make gcc-c++ flex bison python-devel swig 
yum -y install rustc cargo 
yum -y install llvm7.0

# SURICATA
cd /tmp
wget https://www.openinfosecfoundation.org/download/suricata-6.0.4.tar.gz
tar xzvf suricata-6.0.4.tar.gz
cd /tmp/suricata-6.0.4
./configure --libdir=/usr/lib64 --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-nfqueue --enable-lua
make
make install
make install-conf

if [ ! -d "/etc/suricata" ]; then
    echo -e "\e[91mThere was a problem installing Suricata, /etc/suricata path doesn't exist\e[0m"
    exit 1
fi

mkdir -p /etc/suricata/rules
mkdir -p /var/lib/suricata/rules
touch /var/lib/suricata/rules/suricata.rules
touch /etc/suricata/rules/owlh.rules


