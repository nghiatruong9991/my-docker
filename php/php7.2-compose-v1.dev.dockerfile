FROM php:7.2-fpm-alpine

COPY php.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache \
    gcc make g++ zlib-dev autoconf nano libsodium-dev libzip-dev zip libpng libpng-dev shadow bash git openssh &&\
    docker-php-ext-install pdo_mysql exif zip gd opcache mbstring

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.6.3

# Install redis
RUN pecl install redis &&\
    docker-php-ext-enable redis

# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1000 www-data &&\
    groupmod -g 1000 www-data

USER www-data
