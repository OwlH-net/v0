# OwlH - deployment

# OWLH NODE API Service Contron

mkdir -p /usr/local/owlh/bin

cat >> /etc/inittab << \EOF
owlhnode:2345:respawn:/usr/local/owlh/bin/manage-owlhnode.sh
EOF

cat > /etc/init.d/owlhnode <<\EOF
#!/bin/sh

# Copyright (C) 2019, OwlH.net
# OwlH Stap Client: controls owlh node service
# Author:       owlh team <support@olwh.net>
#
# chkconfig: 2345 99 15
# description: starts and stop OwlH node service
#

# Source function library.
export LANG=C

start() {
    echo -n "Starting OwlH NODE: "
    /usr/local/owlh/bin/manage-owlhnode.sh start > /dev/null
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
    echo -n "Stopping OwlH NODE: "
    /usr/local/owlh/bin/manage-owlhnode.sh stop > /dev/null
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
    /usr/local/owlh/bin/manage-owlhnode.sh status
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
    echo "*** Usage: owlh-stap {start|stop|restart|status}"
    exit 1
esac

exit $?
EOF

cat > /usr/local/owlh/bin/manage-owlhnode.sh <<\EOF
#!/bin/bash
case "$1" in
start)
  cd /usr/local/owlh/src/owlhnode/
  export GOPATH=/usr/local/owlh
  /usr/local/owlh/src/owlhnode/owlhnode > /dev/null 2>&1 &
  ;;
stop)
  if [ $(pidof owlhnode) ] ; then
     kill -9 $(pidof owlhnode)
  fi
  ;;
status)
  echo -n "OwlH Node Status -> "
  if [ $(pidof owlhnode) ] ; then
     echo -e "\e[92mRunning\e[0m PID: $(pidof owlhnode)"
     exit 0
  else
     echo -e "\e[91mNot running\e[0m"
     exit 1
  fi
esac

exit $?
EOF

chmod +x /etc/init.d/owlhnode
chmod +x /usr/local/owlh/bin/manage-owlhnode.sh
chkconfig --add owlhnode
chkconfig owlhnode on
service owlhnode start


