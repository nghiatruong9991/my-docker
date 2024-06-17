FROM php:7.3-fpm-alpine

COPY php.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache \
    gcc make g++ zlib-dev autoconf nano libsodium-dev libzip-dev zip libpng libpng-dev shadow bash git openssh &&\
    docker-php-ext-install pdo_mysql exif zip gd opcache mbstring sockets

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.21
RUN composer self-update 2.0.1

# Install redis
RUN pecl install redis &&\
    docker-php-ext-enable redis

# Modify uid and groupd id of www-data to 1001
RUN usermod -u 1001 www-data &&\
    groupmod -g 1001 www-data

USER www-data
