#!/bin/bash
STAPPORT=50010
source env.conf

if ! yum list installed socat ; then
  sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum -y install socat
fi
if ! yum list installed tcpdump ; then
  sudo yum -y install tcpdump
fi


mkdir -p /usr/local/owlh/src/owlhmaster/conf/certs /usr/local/owlh/bin /opt/pcapin/

cat /usr/local/owlh/src/owlhmaster/conf/certs/ca.key /usr/local/owlh/src/owlhmaster/conf/certs/ca.crt > /usr/local/owlh/src/owlhmaster/conf/certs/ca.pem
chmod +600 /usr/local/owlh/src/owlhmaster/conf/certs/*

cat > /usr/local/owlh/src/owlhmaster/conf/stap-init.conf <<\EOF
PORT="VSTAPPORT"
CERT="/usr/local/owlh/src/owlhmaster/conf/certs/ca.pem"
EOF

sed -i "s/VSTAPPORT/$STAPPORT/" /usr/local/owlh/src/owlhmaster/conf/stap-init.conf

cat >> /etc/inittab << \EOF
owlhstapserver:2345:respawn:/usr/local/owlh/bin/manage-stap.sh
EOF

cat > /etc/init.d/owlhstapserver << \EOF
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
    echo -n "Starting OwlH STAP Server: "
    /usr/local/owlh/bin/manage-stap.sh start > /dev/null
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
    echo -n "Stopping OwlH STAP Server: "
    /usr/local/owlh/bin/manage-stap.sh stop > /dev/null
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "success"
    else
        echo "failure"
    fi
    echo
    return $RETVAL
}

status() {
    /usr/local/owlh/bin/manage-stap.sh status
    RETVAL=$?
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
    echo "*** Usage: owlhstapserver {start|stop|restart|status}"
    exit 1
esac

exit $?
EOF

chmod +x /etc/init.d/owlhstapserver

cat > /usr/local/owlh/bin/manage-stap.sh <<\EOF
#!/bin/bash
case "$1" in
start)
  source /usr/local/owlh/src/owlhmaster/conf/stap-init.conf
  /usr/bin/socat -d OPENSSL-LISTEN:$PORT,reuseaddr,pf=ip4,fork,cert=$CERT,verify=0 SYSTEM:"tcpdump -n -r - -s 0 -G 50 -W 100 -w /tmp/dispatcher/remote-%d%m%Y%H%M%S.pcap" >> /dev/null 2>&1 &
  ;;
stop)
  if [ $(pidof socat) ] ; then
     kill -9 $(pidof socat)
  fi
  ;;
status)
  echo -n "OwlH STAP Server status -> "
  if [ $(pidof socat) ] ; then
     echo -e "\e[92mRunning\e[0m"
     exit 0
  else
     echo -e "\e[91mNot running\e[0m"
     exit 1
  fi
esac

exit $?


EOF

chmod +x /usr/local/owlh/bin/manage-stap.sh

chkconfig --add owlhstapserver
chkconfig owlhstapserver on
service owlhstapserver start

