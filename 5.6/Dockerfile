###
# Version APACHE
##
FROM php:5.6-apache AS apache

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets PHP supplémentaires
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libldap2-dev \
    wget zip unzip git pdftk && \
    docker-php-ext-configure gd && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install -j$(nproc) pdo_mysql exif gd ldap zip xml intl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configuration d'apache
ADD 5.6/apache.conf /etc/apache2/conf-enabled/exploit.conf

# Activation des modules Apache
RUN a2enmod rewrite include info

# Configuration de php
ADD 5.6/php.ini $PHP_INI_DIR/conf.d/spiderman.ini

# Installation de composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && chmod +x /usr/local/bin/composer



###
# Version CLI
##
FROM php:5.6-cli AS cli

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets PHP supplémentaires
#  - Modules PHP : pdo_mysql gd ldap
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libldap2-dev \
    wget zip unzip git && \
    docker-php-ext-configure gd && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install -j$(nproc) pdo_mysql exif gd ldap zip xml intl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Installation du cron
RUN apt-get install -y cron

# Création du fichier de cron et de log et prise en compte de la crontab
RUN touch /etc/cron.d/crontabs \
    && mkdir /var/log/cron \
    && touch /var/log/cron/schedule.log

# Configuration de php
ADD 5.6/php.ini $PHP_INI_DIR/conf.d/spiderman.ini

# Installation de composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && chmod +x /usr/local/bin/composer

# Dossier de travail
WORKDIR /var/www/html
