#!/bin/bash
yum update -y
wget http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-9.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install mysql-community-server -y
sudo systemctl start mysqld.service
MySQLPass=$(sudo grep \'temporary password\' /var/log/mysqld.log | rev | cut -d" " -f1 | rev | tr -d ".")
mysql -u root -p"${MySQLPass}"
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Password42!';
exit;
wget https://d6opu47qoi4ee.cloudfront.net/install_mysql_linux.sh
sudo yum install dos2unix -y
sudo dos2unix install_mysql_linux.sh

chmod 777 install_mysql_linux.sh
sudo ./install_mysql_linux.sh