chmod +x run.sh;
wget -c https://github.com/ArielFMartins/Zabbix/raw/main/zabbix.sh;
wget -c https://github.com/ArielFMartins/Zabbix/raw/main/apache.conf;
wget -c https://github.com/ArielFMartins/Zabbix/raw/main/zabbix_server.conf;
chmod +x zabbix.sh;
sudo ./zabbix.sh
