# Suricata

# Main packages 
apt-get update -y

apt-get install rustc cargo make libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0  libmagic-dev libjansson-dev libjansson4 pkg-config libnss3-dev liblua5.1-dev libnspr4-dev liblz4-dev python3-yaml -y


# SURICATA
cd /tmp
wget https://www.openinfosecfoundation.org/download/suricata-6.0.5.tar.gz
tar xzvf suricata-6.0.5.tar.gz
cd /tmp/suricata-6.0.5
./configure --libdir=/usr/lib64 --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-nfqueue --enable-lua
make
make install
make install-conf

if [ ! -d "/etc/suricata" ]; then
    echo -e "\e[91mThere was a problem installing Suricata, /etc/suricata path doesn't exist\e[0m"
    exit 1
fi
mkdir /etc/suricata/rules
mkdir -p /var/lib/suricata/rules
touch /var/lib/suricata/rules/suricata.rules

