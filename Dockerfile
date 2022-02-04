FROM php:8.1.2-fpm-alpine3.15

LABEL Sushant Shah

RUN apk update && apk add libzip-dev icu-dev autoconf build-base

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

RUN apk add --update --no-cache imagemagick-dev pcre-dev \
    && pecl install redis xdebug imagick \
    && docker-php-ext-enable redis xdebug imagick \
    && apk del autoconf pcre-dev build-base

ADD php.ini /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && chmod +x /usr/bin/composer

WORKDIR /app
