#!/bin/bash

set -ex

apt update

#apt upgrade -y

source .env

rm -rf /tmp/latest.zip

wget https://wordpress.org/latest.zip -P /tmp

apt install unzip -y

unzip -u /tmp/latest.zip -d /tmp/

rm -rf /var/www/html/*

rm -rf /tmp/wp-cli.phar

mv -f /tmp/wordpress/* /var/www/html

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html/

cp ../htaccess/.htaccess /var/www/html/

a2enmod rewrite

systemctl restart apache2

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp

wp core download --locale=es_ES --path=/var/www/html --allow-root

rm -rf /var/www/html/wp-config.php

wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$WORDPRESS_DB_HOST \
  --path=/var/www/html \
  --allow-root


wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITTLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root

# Instalar con el wp plugin hide login y el config permalink
# Instalar el plugin WPS Hide Login
wp plugin install wps-hide-login --activate
# Configurar la estructura de permalinks
wp rewrite structure '/estructura-permalinks/'
# Guardar los cambios de permalinks
wp rewrite flush

# whl_page (key)  (value)