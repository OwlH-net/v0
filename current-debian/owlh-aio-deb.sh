
apt-get update
apt-get install sqlite3

cd /tmp
wget repo.owlh.net/current-debian/owlhinstaller.tar.gz
mkdir owlhinstaller
tar -C owlhinstaller -xf owlhinstaller.tar.gz

cd /tmp/owlhinstaller

sed -i -e 's/update/install/'  /tmp/owlhinstaller/config.json

./owlhinstaller 

cp /usr/local/owlh/src/owlhnode/conf/service/owlhnode.service /etc/systemd/system/
cp /usr/local/owlh/src/owlhmaster/conf/service/owlhmaster.service /etc/systemd/system/
rm -rf /usr/local/owlh/src/owlhmaster/conf/*.db
rm -rf /usr/local/owlh/src/owlhnode/conf/*.db


cd /tmp
wget repo.owlh.net/current-debian/services/owlhui-httpd.sh
bash owlhui-httpd.sh

systemctl daemon-reload
systemctl enable apache2
systemctl enable owlhnode
systemctl enable owlhmaster
systemctl restart owlhnode
systemctl restart owlhmaster
systemctl restart apache2
