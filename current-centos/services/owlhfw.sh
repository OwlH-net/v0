sudo firewall-cmd --zone=public --permanent --add-port=50001/tcp
sudo firewall-cmd --zone=public --permanent --add-port=50002/tcp
sudo firewall-cmd --zone=public --permanent --add-port=50010-50020/tcp
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload

