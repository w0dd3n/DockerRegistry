FROM ubuntu:22.04

LABEL author="cedric;obejero@tanooki.fr"
LABEL version="0.1"
LABEL description="Image for training purpose only \
			Image used to build customized service."

EXPOSE 666/tcp
EXPOSE 80/tcp 443/tcp

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN set -eux; \
	apt-get update;

RUN set -ex; \
	apt-get install --yes --no-install-recommends --quiet \
    		apache2 \
    		libapache2-mod-php \
    		php;

RUN set -ex; \
  	apt-get install --yes --no-install-recommends --quiet \
		mariadb-server;

# TODO - Add mysql_secure_installation script execution handling known issues
# See - https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04

RUN set -ex; \
	apt-get update; \
	apt-get install --yes --no-install-recommends --quiet \
		curl \
		php-curl \
		php-gd \
		php-mbstring \
		php-xml \
		php-xmlrpc \
 		php-mysql \
		php-soap \
 		php-intl \
		php-zip \
    		php-bz2;

RUN set -ex; \
	apt-get clean

VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2", "/var/lib/mysql"]

RUN mkdir /var/www/example.com && chown -R www-data:www-data /var/www/example.com

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
  && service apache2 restart

RUN curl https://wordpress.org/latest.tar.gz | tar -zxf -C /var/www/example.com
RUN chown -R www-data:www-data /var/www/example.com && chmod -R 755 /var/www/example.com
RUN cp /var/www/example.com/wp-config-sample.php /var/www/example.com/wp-config.php
RUN mkdir /var/www/example.com/wordpress/wp-content/upgrade
RUN find /var/www/example.com -type d -exec chmod 750 {} \ && find /var/www/example.com -type d -exec chmod 750 {} \;
RUN curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /var/tmp/wp-api.txt
RUN echo "## SECRET KEY RELEASE $(date --rfc-3339='seconds')" >> /var/tmp/wp-api.txt
RUN cp /var/www/example.com/wp-config.php /var/www/example.com/wp-config.php.old
COPY config.awk /var/tmp
RUN awk -f /var/tmp/config.awk /var/tmp/wp-api.txt /var/www/example.com/wp-config.php.old > /var/www/example.com/wp-config.php
RUN rm /var/tmp/config.awk; rm /var/tmp/wp-api.txt

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
