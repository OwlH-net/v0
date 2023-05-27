cd /tmp
sudo yum -y install httpd mod_ssl wget

sudo mkdir -p /var/www/owlh
sudo chmod 755 /var/www/owlh/

SELINUX=${sestatus | grep status | awk '{print $3}'}
if [ $SELINUX = "enabled" ]; then
  echo "SELINUX ENABLED"
  sudo chcon -R -t httpd_sys_content_t /var/www/owlh
  sudo setsebool -P httpd_can_network_connect 1
fi

sudo cat > /etc/httpd/conf.d/owlh.conf <<\EOF
<VirtualHost *:80>
   ServerName master.owlh.net
   Redirect / https://localhost/
</VirtualHost>

<VirtualHost *:443>
        SSLEngine on
        SSLProtocol -all +TLSv1.2
        SSLCipherSuite HIGH:!MEDIUM:!aNULL:!MD5:!SEED:!IDEA
        SSLHonorCipherOrder on
        SSLCertificateFile /usr/local/owlh/src/owlhmaster/conf/certs/ca.crt
        SSLCertificateKeyFile /usr/local/owlh/src/owlhmaster/conf/certs/ca.key
        <Directory /var/www/owlh>
           Header set Access-Control-Allow-Origin "*"
           DirectoryIndex index.html index.php
           FileETag -INode
           AllowOverride AuthConfig
        </Directory>
        DocumentRoot /var/www/owlh
        ServerName master.owlh.net
</VirtualHost>
EOF

[ ! -z "$1" ] && sed -i "s/<MASTERIP>/$1/g" /var/www/owlh/conf/ui.conf

#systemd
systemctl daemon-reload
systemctl enable httpd
systemctl start httpd
