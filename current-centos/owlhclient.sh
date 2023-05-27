#!/bin/bash
yum -y install tcpdump socat wget

mkdir -p /usr/local/owlh/src/owlhnode/conf/certs /usr/local/owlh/bin /owlh

openssl req -newkey rsa:4096 -days 3650 -nodes -x509 \
    -subj "/C=ES/ST=VLC/L=VLC/O=OwlH/CN=softwareTap" \
    -keyout /usr/local/owlh/src/owlhnode/conf/certs/ca.key \
    -out /usr/local/owlh/src/owlhnode/conf/certs/ca.crt

cat /usr/local/owlh/src/owlhnode/conf/certs/ca.key /usr/local/owlh/src/owlhnode/conf/certs/ca.crt > /usr/local/owlh/src/owlhnode/conf/certs/ca.pem

cd /owlh
wget repo.owlh.net/current-centos/stapclient.centos 
mv /owlh/stapclient.centos /usr/local/owlh/bin/stapclient
chmod +x /usr/local/owlh/bin/stapclient

cat > /usr/local/owlh/bin/conf.json <<\EOF
{
  "collectorIP":"10.13.1.13",
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

cat > /etc/systemd/system/owlhstap.service << \EOF
# Copyright (C) 2019, OwlH.net
# OwlH Stap Client: controls software tap service
# Author:       owlh team <support@olwh.net>
#
# description: starts and stop OwlH Sorfware TAP client
#

[Unit]
Description=owlhclient service

[Service]
Type=simple
ExecStart=/bin/sh -c '/usr/local/owlh/bin/stapclient > /dev/null 2>&1'
Restart=on-failure
RestartSec=5
WorkingDirectory=/usr/local/owlh/bin

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable owlhstap 
systemctl start owlhstap

rm -rf /owlh
