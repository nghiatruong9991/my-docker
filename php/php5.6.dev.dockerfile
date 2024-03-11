# FROM php:5.6-apache
# FROM php:5.6-fpm-alpine
FROM php:5.6.40-fpm-alpine

# COPY bin /usr/local/bin

# Install modules
# RUN apt-get update && apt-get install -y \
#         libfreetype6-dev \
#         libjpeg62-turbo-dev \
#         libmcrypt-dev \
#         libpng-dev \
#         libmemcached-dev \
#         git \
#         libicu-dev \
#         libssl-dev \
#         zlib1g-dev \
#         libxml2-dev \
#         libssh2-1-dev \
#         imagemagick

# RUN { yes '/usr' | pecl install memcached-2.2.0; } \
#     && echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini \
#     && docker-php-ext-install iconv mcrypt pdo_mysql mbstring intl zip opcache \
#     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#     && docker-php-ext-install gd soap

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mysql
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install iconv
# RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mbstring
# RUN docker-php-ext-install intl
# RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache 

RUN docker-php-ext-enable pdo_mysql

# ssh2 module
# RUN pecl install ssh2 channel://pecl.php.net/ssh2-0.13 \
#   && echo "extension=ssh2.so" > /usr/local/etc/php/conf.d/ext-ssh2.ini

# ENV USE_XDEBUG no
# ENV XDEBUG_VERSION 2.5.4
# RUN docker-php-pecl-install xdebug-$XDEBUG_VERSION && \
#     echo "xdebug.remote_enable=on\nxdebug.remote_connect_back=on" > /usr/local/etc/php/conf.d/xdebug.ini && \
#     mkdir -p /usr/local/etc/php/xdebug.d && \
#     mv /usr/local/etc/php/conf.d/*xdebug.ini /usr/local/etc/php/xdebug.d/

# Grab gosu for easy step-down from root
# ENV GOSU_VERSION 1.10
# RUN set -x \
#   && curl -sSLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
#   && curl -sSLo /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
#   && export GNUPGHOME="$(mktemp -d)" \
#   && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#   && chmod +x /usr/local/bin/gosu \
#   && gosu nobody true


# Include composer
# RUN apt-get install -y --no-install-recommends rsync && \
#     docker-php-ext-install zip && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# ENV COMPOSER_HOME /var/www/.composer
# ENV COMPOSER_VERSION 1.4.2
# ENV PATH vendor/bin:$COMPOSER_HOME/vendor/bin:$PATH

# RUN curl -sS https://getcomposer.org/installer | php -- \
#       --install-dir=/usr/local/bin \
#       --filename=composer \
#       --version=${COMPOSER_VERSION}

# RUN mkdir -p $COMPOSER_HOME/cache && \
#     chown -R www-data:www-data /var/www && \
#     echo "phar.readonly = off" > /usr/local/etc/php/conf.d/phar.ini
# VOLUME $COMPOSER_HOME/cache

# RUN a2enmod rewrite headers

# Add configs
# COPY etc/*.ini /usr/local/etc/php/
# COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# COPY docker-entrypoint.sh /
# ENTRYPOINT ["/docker-entrypoint.sh"]

# WORKDIR /usr/src/app

# CMD ["apache2-foreground"]