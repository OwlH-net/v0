#Deb Ubuntu18
apt-get -y install libwww-perl libjson-perl libyaml-dev
apt --fix-broken install
wget https://files.molo.ch/builds/ubuntu-18.04/moloch_2.2.2-1_amd64.deb
dpkg -i moloch_2.2.2-1_amd64.deb
READ /data/moloch/README.txt and RUN /data/moloch/bin/Configure

