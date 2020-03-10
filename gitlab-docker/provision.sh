#!/bin/bash
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

#Копируем ключи для ansible
cat /vagrant/ansible.pub >> ~vagrant/.ssh/authorized_keys
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
#ставим ну почти необходимое для работы ansible и не только
yes| yum install epel-release
#yum update -y
yum install -y python python-apt mc tcpdump mtr


# Отключаю SELinux, ничего личного.
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Везде поставим nmap что бы можно было постучаться на роутер
#yes | yum install -y -q nmap
#Отключаю сразу, что бы не перезагружаться.
setenforce 0
