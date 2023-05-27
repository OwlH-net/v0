# OWLH MASTER UI - APACHE2

apt-get install -y apache2
a2enmod ssl
a2enmod headers
cat > /etc/apache2/sites-available/owlh.conf <<\EOF
<VirtualHost *:80>
   ServerName master.owlh.net
   Redirect / https://localhost/
</VirtualHost>

<VirtualHost *:443>
        SSLEngine on
        SSLCertificateFile /usr/local/owlh/src/owlhmaster/conf/certs/ca.crt
        SSLCertificateKeyFile /usr/local/owlh/src/owlhmaster/conf/certs/ca.key
        <Directory /var/www/owlh>
           Header set Access-Control-Allow-Origin "*"
           DirectoryIndex index.html index.php
           AllowOverride All
        </Directory>
        DocumentRoot /var/www/owlh
        ServerName master.owlh.net
</VirtualHost>
EOF
a2ensite owlh
[ ! -z "$1" ] && sed -i "s/<MASTERIP>/$1/g" /var/www/owlh/conf/ui.conf
systemctl daemon-reload
systemctl enable apache2
systemctl restart apache2

