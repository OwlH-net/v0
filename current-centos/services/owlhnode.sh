#!/bin/bash

#deploy OwlH Node with Suricata and Zeek

# based on centOS7
yum -y update
yum -y install wget libpcap


# Node

TMP=/tmp

cd $TMP
wget repo.owlh.net/current-centos/owlhinstaller.tar.gz
mkdir $TMP/owlhinstaller
tar -C $TMP/owlhinstaller -xf $TMP/owlhinstaller.tar.gz 
cd $TMP/owlhinstaller
mv config.json config.json.orig
wget -O $TMP/owlhinstaller/config.json repo.owlh.net/current-centos/helpers/install-node-config.json
./owlhinstaller 

# Suricata
cd $TMP 
wget repo.owlh.net/current-centos/services/owlhsuricatacomp.sh
bash owlhsuricatacomp.sh

# Zeek
wget repo.owlh.net/current-centos/services/owlhzeekcomp.sh
bash owlhzeekcomp.sh

#Owlh Interface
wget repo.owlh.net/current-centos/services/owlhinterface.sh
bash owlhinterface.sh

#clean temp files and folders
rm -rf $TMP/owlh*
rm -rf $TMP/*
