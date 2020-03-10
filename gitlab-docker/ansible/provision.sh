#!/bin/bash
#===================VARIBLES========================
    vagrant_dir="${vagrant_work_dir:-}" # /vagrant/'MashineName'
    work_dir="/ansible"


#===================Понеслася========================
#Устанавливаем ansible
yum install -y epel-release
yum install -y ansible mc

#делаем правильные права для приватного ключа
chmod 0600 /vagrant/ansible.pem

# т.к. в сети нет DNS добавляем все переменные в hosts
cd /vagrant/ansible/roles
cat << EOF >> /etc/hosts
10.123.19.1 router1
10.123.18.2 router2
10.123.20.3 router3

EOF

ansible-playbook install_all.yml

#Нужно неск сек после развертывания что бы роутеры успели обменяться маршрутами.
echo "Please wait"
sleep 20




