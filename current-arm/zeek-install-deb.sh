sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev git
cd /tmp
git clone --recursive https://github.com/zeek/zeek
cd /tmp/zeek/
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
./configure
make
make install
export PATH=/usr/local/zeek/bin:$PATH