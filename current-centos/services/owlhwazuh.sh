rpm --import http://packages.wazuh.com/key/GPG-KEY-WAZUH
cat > /etc/yum.repos.d/wazuh.repo <<\EOF
[wazuh_repo]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=Wazuh repository
baseurl=https://packages.wazuh.com/3.x/yum/
protect=1
EOF
yum -y install wazuh-agent

if [ ! -d "/var/ossec" ]; then
    echo -e "\e[91mThere was a problem installing Wazuh-Agent, /var/ossec path doesn't exist\e[0m"
    exit 1
fi

sed -i "s/^enabled=1/enabled=0/" /etc/yum.repos.d/wazuh.repo

