FROM ubuntu:22.04
MAINTAINER cedric.obejero@tanooki.fr

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
  apt-get update;

RUN set -ex; \
  apt-get install --yes --no-install-recommends --quiet \
    apache2 \
    libapache2-mod-php \
    php;

#RUN set -ex; \
#  apt-get install --yes --no-install-recommends --quiet mariadb-server;

# TODO - Add mysql_secure_installation script execution handling known issues
# See - https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04

#RUN set -ex; \
#  apt-get install --yes --no-install-recommends --quiet \
#    php-xmlrpc \
#    php-xml \
#    php-mysqli \
#    php-intl \
#    php-zip \
#    php-bz2;

#RUN set -ex; \
#  systemctl enable mariadb \
#  && sytemctl enable apache2 \
#  && systemctl restart mariadb \
#  && systemctl restart apache2
    

#VOLUME [/var/www/example.com]

#RUN chown -R www-data:www-data /var/www/example.com

#RUN { \
#  echo '<VirtualHost *:80>'; \
#  echo '  ServerName example.com'; \
#  echo '  ServerAlias www.example.com'; \
#  echo '  ServerAdmin webmaster@example.com'; \
#  echo '  DocumentRoot /var/www/example.com'; \
#  echo '  ErrorLog /var/log/apache2/error.log'; \
#  echo '  CustomLog /var/log/apache2/access.log combined'; \
#  echo '  <Directory /var/www/example.com/>'; \
#  echo '    AllowOverride All'; \
#  echo '  </Directory>'; \
#  echo '</VirtualHost>'; \
#  } | tee /etc/apache2/sites-available/example.com.conf \
#  && a2enmod rewrite \
#  && a2ensite example.com \
#  && a2dissite 000-default \
#  && a2dissite default-ssl \
#  && apache2ctl configtest \
#  && systemctl restart apache2
