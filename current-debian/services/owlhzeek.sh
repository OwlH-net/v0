# Zeek


# Main packages 
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev  python3-git python3-semantic-version

cd /tmp
wget https://download.zeek.org/zeek-4.2.1.tar.gz
tar xzvf zeek-4.2.1.tar.gz
cd /tmp/zeek-4.2.1

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
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




