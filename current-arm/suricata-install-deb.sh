apt-get -y install libpcre3 libpcre3-dbg libpcre3-dev \
build-essential autoconf automake libtool libpcap-dev libnet1-dev \
libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libmagic-dev libcap-ng-dev \
libjansson-dev pkg-config rustc cargo
wget https://www.openinfosecfoundation.org/download/suricata-5.0.0-rc1.tar.gz
tar -xvzf suricata-5.0.0-rc1.tar.gz
cd suricata-5.0.0-rc1
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
make
make install
make install-conf

