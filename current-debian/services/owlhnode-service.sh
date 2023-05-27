# prepare OwlH node API service systemctl management.

cat > /etc/systemd/system/owlhnode.service <<\EOF
[Unit]
Description=owlhnode API service

[Service]
Type=simple
EnvironmentFile=/usr/local/owlh/src/owlhnode/conf/owlhnode-init.conf
ExecStart=/bin/sh -c '/usr/local/owlh/src/owlhnode/owlhnode > /dev/null 2>&1'
Restart=on-failure
RestartSec=5
WorkingDirectory=/usr/local/owlh/src/owlhnode

[Install]
WantedBy=multi-user.target
EOF

cat > /usr/local/owlh/src/owlhnode/conf/owlhnode-init.conf <<\EOF
GOPATH=/usr/local/owlh
EOF

systemctl daemon-reload
systemctl enable owlhnode
systemctl restart owlhnode
