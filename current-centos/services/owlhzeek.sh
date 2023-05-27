# Zeek


# Main packages 
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install wget git
yum -y install jq openssl-devel PyYAML lz4-devel gcc libpcap-devel pcre-devel libyaml-devel file-devel zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make libnetfilter_queue-devel lua-devel cmake make gcc-c++ flex bison python-devel swig 

# ZEEK
cd /tmp
wget https://old.zeek.org/downloads/zeek-3.0.3.tar.gz
tar xzvf zeek-3.0.3.tar.gz
cd /tmp/zeek-3.0.3

./configure
make 
make install

if [ ! -d "/usr/local/zeek" ]; then
    echo -e "\e[91mThere was a problem installing Zeek, /usr/local/zeek path doesn't exist\e[0m"
    exit 1
fi

cat >> /usr/local/zeek/share/zeek/site/local.zeek <<\EOF
@load policy/tuning/json-logs.zeek
@load owlh.zeek
EOF

cat >> /usr/local/zeek/share/zeek/site/owlh.zeek <<\EOF
redef record DNS::Info += {
    bro_engine:    string    &default="DNS"    &log;
};
redef record Conn::Info += {
    bro_engine:    string    &default="CONN"    &log;
};
redef record Weird::Info += {
    bro_engine:    string    &default="WEIRD"    &log;
};
redef record SSL::Info += {
    bro_engine:    string    &default="SSL"    &log;
};
redef record SSH::Info += {
    bro_engine:    string    &default="SSH"    &log;
};
EOF

/usr/local/zeek/bin/zeekctl deploy

(sudo crontab -l ; echo "*/5 * * * * /usr/local/zeek/bin/zeekctl cron ") | crontab -




