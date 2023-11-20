#!/bin/bash

set -ex

apt update

apt upgrade -y

source .env

rm -rf /tmp/latest.zip

wget https://wordpress.org/latest.zip -P /tmp

apt install unzip -y

unzip -u /tmp/latest.zip -d /tmp/

rm -rf /var/www/html/*

mv -f /tmp/wordpress/* /var/www/html

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html/

cp ../htaccess/.htaccess /var/www/html/

a2enmod rewrite

systemctl restart apache2

# Instalar con el wp plugin hide login y el config permalink
# whl_page (key)  (value)