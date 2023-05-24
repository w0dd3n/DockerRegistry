FROM ubuntu:22.04

RUN set -eux; \
  apt-get update; \
  apt-get install --yes --no-install-recommends apache2;

RUN set -ex; \
  apt-get install --yes --no-install-recommends mysql-server;

# TODO - Add mysql_secure_installation script execution handling known issues
# See - https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04

RUN set -ex; \
  apt-get install --yes --no-install-recommends \
    php \
    libapache2-mod-php \
    php-mysql;

VOLUME [/var/www/example.com]

RUN chown -R www-data:www-data /var/www/example.com

RUN { \
  echo '<VirtualHost *:80>'; \
  echo '  ServerName example.com'; \
  echo '  ServerAlias www.example.com'; \
  echo '  ServerAdmin webmaster@example.com'; \
  echo '  DocumentRoot /var/www/example.com'; \
  echo '  ErrorLog /var/log/apache2/error.log'; \
  echo '  CustomLog /var/log/apache2/access.log combined'; \
  echo '  <Directory /var/www/example.com/>'; \
  echo '    AllowOverride All'; \
  echo '  </Directory>'; \
  echo '</VirtualHost>'; \
  } | tee /etc/apache2/sites-available/example.com.conf \
  && a2enmod rewrite \
  && a2ensite example.com \
  && a2dissite 000-default \
  && a2dissite default-ssl \
  && apache2ctl configtest \
  && systemctl restart apache2