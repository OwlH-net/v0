TMP=/tmp
cd $TMP

#download binaries, configuration, libraries
wget repo.owlh.net/current-centos/services/suricata-5.0.3-centos7.tar.gz
mkdir suricata
cd suricata 
tar -xf $TMP/suricata-5.0.3-centos7.tar.gz


#extract binaries
tar -C /usr/bin/ -xf $TMP/suricata/suribin/suricatabin.tar.gz
#extract configuration
tar -C / -xf $TMP/suricata/suriconfig/suricataconfig.tar.gz
#extract libraries 
tar -C / -xf $TMP/suricata/surilib/suricatalib.tar.gz

#copy libraries
ln -s /usr/lib64/libhtp.so.2.0.0 /usr/lib64/libhtp.so
ln -s /usr/lib64/libhtp.so.2.0.0 /usr/lib64/libhtp.so.2 

ln -s /usr/lib64/libnetfilter_queue.so.1.3.0 /usr/lib64/libnetfilter_queue.so
ln -s /usr/lib64/libnetfilter_queue.so.1.3.0 /usr/lib64/libnetfilter_queue.so.1

ln -s /usr/lib64/libnet.so.1.7.0 /usr/lib64/libnet.so
ln -s /usr/lib64/libnet.so.1.7.0 /usr/lib64/libnet.so.1

#other stuff
mkdir /var/log/suricata
