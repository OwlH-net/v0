cd /tmp
mkdir -p /tmp/owlhinstaller
wget http://repo.owlh.net/current-centos/owlhinstaller.tar.gz
tar -C /tmp/owlhinstaller -zxvf /tmp/owlhinstaller.tar.gz

wget http://repo.owlh.net/current-centos/deploy/config.json
mv config.json /tmp/owlhinstaller/config.json

cd /tmp/owlhinstaller
/tmp/owlhinstaller/owlhinstaller

# download script files
cd /tmp
wget http://repo.owlh.net/current-centos/services/owlhscripts.tar.gz
mkdir -p /tmp/owlhscripts
tar -C /tmp/owlhscripts -zxvf /tmp/owlhscripts.tar.gz

cp /usr/local/owlh/src/owlhmaster/conf/service/owlhmaster.service /etc/systemd/system/
cp /usr/local/owlh/src/owlhnode/conf/service/owlhnode.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable owlhnode
systemctl enable owlhmaster

bash /tmp/owlhscripts/owlhinterface.sh
bash /tmp/owlhscripts/owlhui-httpd.sh
#bash /tmp/owlhscripts/owlhsuricata.sh
#bash /tmp/owlhscripts/owlhzeek.sh
bash /tmp/owlhscripts/owlhwazuh.sh

