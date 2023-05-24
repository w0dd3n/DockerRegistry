FROM ubuntu:22.04
RUN set -eux; \
  apt-get update; \
  apt-get install --yes --no-install-recommends apache2;
RUN set -ex; \
  apt-get install --yes --no-install-recommends mysql-server;
RUN set -ex; \
  apt-get install --yes --no-install-recommends \
    php \
    libapache2-mod-php \
    php-mysql;
    
