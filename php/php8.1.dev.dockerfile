FROM php:8.1-fpm-alpine

COPY php8.dev.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www

EXPOSE 9000

# Install php packages
RUN apk add --update --no-cache gcc make g++ zlib-dev autoconf nano libzip-dev zip libpng libpng-dev shadow bash git openssh oniguruma php-sockets openssl

RUN docker-php-ext-install pdo_mysql exif zip gd 
# opcache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install latest Node.js and npm
# RUN apk add nodejs npm

# Install redis a
# RUN pear update-channels && pecl update-channels && pecl install redis
# RUN docker-php-ext-enable redis exif gd opcache sodium zip

# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1001 www-data &&\
    groupmod -g 1001 www-data

# CMD cd ./public/nextjs-blog
# ENTRYPOINT "npm run dev"

USER www-data
