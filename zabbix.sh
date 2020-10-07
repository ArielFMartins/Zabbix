#!/bin/bash

wget https://repo.zabbix.com/zabbix/5.1/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.1-1+ubuntu20.04_all.deb;
sudo dpkg -i zabbix-release_5.1-1+ubuntu20.04_all.deb;
sudo apt install xdotool;
sudo apt update;
sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent;
sudo apt -y install mariadb-common mariadb-server mariadb-client;

sudo apt install aptitude;

sudo aptitude -y install expect;

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"rootDBpass\r\"
expect \"Re-enter new password:\"
send \"rootDBpass\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

aptitude -y purge expect;

sudo mysql -uroot -p'rootDBpass' -e "create database zabbix character set utf8 collate utf8_bin;";
sudo mysql -uroot -p'rootDBpass' -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixDBpass';";

sudo mysql -uroot -p'rootDBpass' zabbix -e "set global innodb_strict_mode='OFF';";

sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p'zabbixDBpass' zabbix;

sudo mysql -uroot -p'rootDBpass' zabbix -e "set global innodb_strict_mode='ON';";
