#!/bin/bash

set -ex

apt update

apt upgrade -y
 
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

apt install mysql-server -y

DB_USER=usuario
DB_PASSWD=contraseña

mysql -u $DB_USER -p$DB_PASSWD < ../sql/database.sql

chown -R www-data:www-data /var/www/html