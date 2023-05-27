#!/bin/bash
yum -y install tcpdump socat wget

mkdir -p /usr/local/owlh/src/owlhnode/conf/certs /usr/local/owlh/bin

openssl req -newkey rsa:4096 -days 3650 -nodes -x509 \
    -subj "/C=ES/ST=VLC/L=VLC/O=OwlH/CN=softwareTap" \
    -keyout /usr/local/owlh/src/owlhnode/conf/certs/ca.key \
    -out /usr/local/owlh/src/owlhnode/conf/certs/ca.crt
cat /usr/local/owlh/src/owlhnode/conf/certs/ca.key /usr/local/owlh/src/owlhnode/conf/certs/ca.crt > /usr/local/owlh/src/owlhnode/conf/certs/ca.pem
chmod +600 /usr/local/owlh/src/owlhnode/conf/certs/*

cd /opt
wget repo.owlh.net/current/stapclient.centos 
mv /opt/stapclient.centos /usr/local/owlh/bin/stapclient
chmod +x /usr/local/owlh/bin/stapclient

cat > /usr/local/owlh/bin/conf.json <<\EOF
{
  "collectorIP":"1.1.1.1",
  "collectorPort":"50010",
  "cert":"/usr/local/owlh/src/owlhnode/conf/certs/ca.pem",
  "bpf":"not port 50010 and not port 22",
  "includeInt":["en","eth"],
  "excludeInt":["lo"],
  "includeNet":["0.0.0.0/0"],
  "excludeIP":["192.168.0.1"],
  "waitTime":10
}
EOF

cat >> /etc/inittab << \EOF
owlhstap:2345:respawn:/usr/local/owlh/bin/stapclient
EOF

cat > /etc/init.d/owlhstap << \EOF
#!/bin/sh

# Copyright (C) 2019, OwlH.net
# OwlH Stap Client: controls software tap service
# Author:       owlh team <support@olwh.net>
#
# chkconfig: 2345 99 15
# description: starts and stop OwlH Sorfware TAP client
#

# Source function library.
export LANG=C

start() {
    echo -n "Starting OwlH STAP client: "
    export GOPATH=/usr/local/owlh
    cd /usr/local/owlh/bin
    /usr/local/owlh/bin/stapclient > /dev/null 2>&1 & 
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "success"
    else
        echo "failure"
    fi
    echo
    return $RETVAL
}

stop() {
    echo -n "Stopping OwlH STAP client: "
    kill -9 $(pidof stapclient) > /dev/null 2>&1
    kill -9 $(pidof tcpdump) > /dev/null 2>&1
    kill -9 $(pidof socat) > /dev/null 2>&1
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "success"
    else
        echo "failure - not runing"
    fi
    echo
    return $RETVAL
}

status() {
    ps -ef | grep stapclient
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "Stap Client is running"
    else
        echo "Stap Client not runing"
    fi
    return $RETVAL
}

case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    stop
    start
    ;;
status)
    status
    ;;
*)
    echo "*** Usage: owlhstap {start|stop|restart|status}"
    exit 1
esac

exit $?
EOF

chmod +x /etc/init.d/owlhstap
chkconfig --add owlhstap
chkconfig owlhstap on
service owlhstap start 


