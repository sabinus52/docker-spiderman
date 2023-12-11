###
# Version APACHE
##
FROM php:7.4-apache AS apache

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets PHP supplémentaires
#  - Modules PHP : pdo_mysql gd ldap zip xml intl
#  - Git
#  - MariaDB client
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libldap2-dev \
    wget zip unzip git mariadb-client && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install pdo_mysql exif gd ldap zip xml intl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configuration d'apache
ADD 7.4/apache.conf /etc/apache2/sites-enabled/000-default.conf
ENV APACHE_RUN_USER spiderman
ENV APACHE_RUN_GROUP spiderman

# Activation des modules Apache
RUN a2enmod rewrite headers expires deflate

# Configuration PHP
ADD 7.4/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
RUN cp -p ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini && chmod 644 ${PHP_INI_DIR}/conf.d/spiderman.ini

# Installation de composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && chmod +x /usr/local/bin/composer

# Ajout de l'utilisateur
RUN groupadd --gid 1000 spiderman && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash spiderman && useradd --uid 1026 --gid users synology
USER spiderman


###
# Version CLI
##
FROM php:7.4-cli AS cli

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets PHP supplémentaires
#  - Modules PHP : pdo_mysql gd ldap zip xml intl
#  - Git
#  - MariaDB client
#  - CRON
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libldap2-dev \
    wget zip unzip git cron mariadb-client && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install pdo_mysql exif gd ldap zip xml intl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Installation du cron
RUN apt-get install -y mariadb-client

# Configuration PHP
ADD 7.4/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
RUN cp -p ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini && chmod 644 ${PHP_INI_DIR}/conf.d/spiderman.ini

# Création du fichier de cron et de log et prise en compte de la crontab
RUN touch /etc/cron.d/crontabs \
    && mkdir /var/log/cron \
    && touch /var/log/cron/schedule.log

# Installation de composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && chmod +x /usr/local/bin/composer

# Ajout de l'utilisateur
RUN groupadd --gid 1000 spiderman && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash spiderman && useradd --uid 1026 --gid users synology
USER spiderman

# Dossier de travail
WORKDIR /var/www/html
