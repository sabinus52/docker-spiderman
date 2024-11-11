###
# Version APACHE
##
FROM php:8.3-apache AS apache

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets systèmes complémentaires
RUN apt-get update \
    && apt-get install -y git unzip wget zip curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_mysql exif gd ldap zip xml intl bcmath gmp

# Configuration d'apache
ADD 8.3/apache.conf /etc/apache2/sites-enabled/000-default.conf
ENV APACHE_RUN_USER spiderman
ENV APACHE_RUN_GROUP spiderman

# Activation des modules Apache
RUN a2enmod rewrite headers expires deflate

# Configuration PHP
ADD 8.3/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
RUN cp -p ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini && chmod 644 ${PHP_INI_DIR}/conf.d/spiderman.ini

# Installation de composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Ajout de l'utilisateur
RUN groupadd --gid 1000 spiderman && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash spiderman && useradd --uid 1026 --gid users synology
ADD 8.3/bashrc /home/spiderman/.bashrc
USER spiderman


###
# Version CLI
##
FROM php:8.3-cli AS cli

# Configuration  de la timezone
ENV TZ="Europe/Paris"

# Installation des paquets systèmes complémentaires
RUN apt-get update \
    && apt-get install -y git unzip wget zip curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_mysql exif gd ldap zip xml intl bcmath gmp

# Configuration PHP
ADD 8.3/php.ini ${PHP_INI_DIR}/conf.d/spiderman.ini
RUN cp -p ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini && chmod 644 ${PHP_INI_DIR}/conf.d/spiderman.ini

# Création du fichier de cron et de log et prise en compte de la crontab
RUN touch /etc/cron.d/crontabs \
    && mkdir /var/log/cron \
    && touch /var/log/cron/schedule.log

# Installation de composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Ajout de l'utilisateur
RUN groupadd --gid 1000 spiderman && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash spiderman && useradd --uid 1026 --gid users synology
ADD 8.3/bashrc /home/spiderman/.bashrc
USER spiderman

# Dossier de travail
WORKDIR /var/www/html
