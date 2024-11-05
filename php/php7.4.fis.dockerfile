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

# Install imagick a
RUN pecl install imagick &&\
    docker-php-ext-enable imagick

# Install node
# nvm environment variables
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.18.1
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN source ~/.bashrc
RUN node -v
RUN npm -v

# Modify uid and groupd id of www-data to 1000
RUN usermod -u 1001 www-data &&\
    groupmod -g 1001 www-data

USER www-data