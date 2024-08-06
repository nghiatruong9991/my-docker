FROM php:7.4-fpm-alpine as fpm_base

COPY php.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache \
    gcc make g++ zlib-dev autoconf \
    nano libsodium-dev libzip-dev zip \
    libxml2-dev libpng libpng-dev shadow \
    bash git openssh oniguruma \
    imagemagick \
    imagemagick-libs \
    imagemagick-dev &&\
    docker-php-ext-install pdo_mysql exif zip gd opcache xml bcmath

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install redis a
RUN pecl install imagick &&\
    docker-php-ext-enable imagick

# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1001 www-data &&\
    groupmod -g 1001 www-data

USER www-data
