###
# Version APACHE
##
FROM php:8.2-apache AS apache

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets systèmes complémentaires
RUN apt-get update \
    && apt-get install -y git unzip wget zip curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev libldap2-dev libpq-dev libgmp-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install pdo_mysql exif gd ldap zip xml intl bcmath gmp && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configuration d'apache
ADD 8.2/apache.conf /etc/apache2/sites-enabled/000-default.conf
ENV APACHE_RUN_USER spiderman
ENV APACHE_RUN_GROUP spiderman

# Activation des modules Apache
RUN a2enmod rewrite headers expires deflate

# Configuration PHP
ADD 8.2/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
RUN cp -p ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini && chmod 644 ${PHP_INI_DIR}/conf.d/spiderman.ini

# Installation de composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && chmod +x /usr/local/bin/composer

# Ajout de l'utilisateur
RUN groupadd --gid 1000 spiderman && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash spiderman && useradd --uid 1026 --gid users synology
USER spiderman


###
# Version CLI
##
FROM php:8.2-cli AS cli

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets systèmes complémentaires
RUN apt-get update \
    && apt-get install -y git unzip wget zip curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP
RUN apt-get update && \
    apt-get install -y libzip-dev libxml2-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev libldap2-dev libpq-dev libgmp-dev &&\
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install pdo_mysql exif gd ldap zip xml intl bcmath gmp && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configuration PHP
ADD 8.2/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
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
