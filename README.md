# Images Docker PHP for applications Symfony


## List of docker images in different versions PHP

- **7.4** (apache and cli)
- **5.6** (apache and cli)


# Build of images : **php-apache**

## Apache
- Add user *spiderman* for process Apache
- Enable module `rewrite`, `headers`, `expires`, `deflate`

## PHP
- Add module `pdo_mysql`, `gd`, `exif`, `ldap`, `zip`, `xml`, `intl`
- Timezone on Paris

## Tools
- Add `git`, `composer`, `mariadb-client`


# Build of images : **php-cli**

## Cron
- Install crontab
- Add user *spiderman* for cron

## PHP
- Add module `pdo_mysql`, `gd`, `exif`, `ldap`, `zip`, `xml`, `intl`
- Timezone on Paris

## Tools
- Add `git`, `composer`, `mariadb-client`
