FROM php:8.0-fpm-alpine

COPY php.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache \
    gcc make g++ zlib-dev autoconf nano libsodium-dev libzip-dev zip libpng libpng-dev shadow bash git openssh oniguruma &&\
    docker-php-ext-install pdo_mysql exif zip gd opcache

RUN docker-php-ext-install sockets && \
    docker-php-ext-enable sockets

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install redis a
RUN pecl install redis &&\
    docker-php-ext-enable redis

# Install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini

    # && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1000 www-data &&\
    groupmod -g 1000 www-data

USER www-data