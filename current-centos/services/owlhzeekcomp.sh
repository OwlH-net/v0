TMP=/tmp
cd $TMP

#download zeek folder and install 
wget repo.owlh.net/current-centos/services/zeek-3.0.3-centos7.tar.gz
tar -C / -xf $TMP/zeek-3.0.3-centos7.tar.gz
