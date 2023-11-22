#!/bin/bash
set -ex

apt-get update

apt-get upgrade -y

apt-get install mysql-server -y

sed -i "s/127.0.0.1/$WORDPRESS_DB_HOST/" /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql