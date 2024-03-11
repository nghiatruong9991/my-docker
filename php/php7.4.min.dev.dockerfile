FROM php:7.4-fpm-alpine

COPY php.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache \
    zlib-dev libsodium-dev libzip-dev zip libpng libpng-dev bash git shadow

RUN docker-php-ext-install pdo_mysql exif zip gd opcache

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install redis 
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS && \
    pecl update-channels && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del $PHPIZE_DEPS

# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1001 www-data &&\
    groupmod -g 1001 www-data

RUN apk del shadow bash git

USER www-data
