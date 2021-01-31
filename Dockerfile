FROM php:7.4.12-fpm-alpine3.12

RUN apk update && apk add libzip-dev icu-dev

RUN apk add autoconf build-base

RUN docker-php-ext-install iconv \
            pcntl \
            intl \
            zip \
            pdo_mysql \
            exif

RUN apk add --no-cache libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg && \
  docker-php-ext-install -j "$(nproc)" gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev zlib-dev

RUN apk add --update --no-cache autoconf g++ imagemagick-dev libtool make pcre-dev \
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    && apk del autoconf g++ libtool make pcre-dev

ADD php.ini /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && chmod +x /usr/bin/composer

WORKDIR /app
