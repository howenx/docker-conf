#!/bin/sh

mysql_install_db > /dev/null 2>&1
echo "=> Done!"
echo "=> Creating admin user ..."

/usr/bin/mysqld_safe > /dev/null 2>&1 &
RET=1
while [[ RET -ne 0 ]]; do
   echo "=> Waiting for confirmation of MySQL service startup"
   sleep 5
   mysql -uroot -e "status" > /dev/null 2>&1
   RET=$?
done

mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'kakaogift';"&&\
mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'kakaogift';"&&\
mysql -u root -pkakaogift -e "show databases;"

mysqladmin -uroot shutdown

echo "=> Done!"