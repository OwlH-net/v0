# prepare OwlH master API service systemctl management.

cat > /etc/systemd/system/owlhmaster.service <<\EOF
[Unit]
Description=owlhmaster API service

[Service]
Type=simple
EnvironmentFile=/usr/local/owlh/src/owlhmaster/conf/owlhmaster-init.conf
ExecStart=/bin/sh -c '/usr/local/owlh/src/owlhmaster/owlhmaster > /dev/null 2>&1'
Restart=on-failure
RestartSec=5
WorkingDirectory=/usr/local/owlh/src/owlhmaster

[Install]
WantedBy=multi-user.target
EOF

cat > /usr/local/owlh/src/owlhmaster/conf/owlhmaster-init.conf <<\EOF
GOPATH=/usr/local/owlh
EOF

systemctl daemon-reload
systemctl enable owlhmaster
systemctl restart owlhmaster
