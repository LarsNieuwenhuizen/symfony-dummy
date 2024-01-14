# Backend compile
FROM php:8.2-fpm-alpine as backend-compile

WORKDIR /var/www

COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer
COPY ./ /var/www

RUN RUN set -eux; \
    COMPOSER_MIRROR_PATH_REPOS=1 composer install --no-dev -o --no-ansi -q --no-interaction

# Webserver image
FROM larsnieuwenhuizen/nginx-unprivileged:1.21.6 as webserver

COPY --from=backend-compile /var/www/public /var/www/public

EXPOSE 8080

USER 101

# FPM image
FROM php:8.2-fpm-alpine as fpm

PHP_VERSION=8.2

COPY --from=backend-compile /var/www /var/www
COPY Build/php/php-fpm-pool.con /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY Build/php/php.ini /etc/php/${PHP_VERSION}/fpm/conf.d/9999-php.ini

EXPOSE 9000

RUN mkdir -p /run/php

ENTRYPOINT php-fpm -F

WORKDIR /var/www
