
FROM php:7.0.11-apache 

MAINTAINER hanhan1978 <ryo.tomidokoro@gmail.com>

# install libraries
RUN apt-get update \
    && apt-get install -y \
       git \
       sqlite \
       libmcrypt-dev \
       npm \
       zlib1g-dev \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && ln -s /usr/bin/nodejs /usr/bin/node \
    && a2enmod rewrite

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/bin  --filename=composer \
    && php -r "unlink('composer-setup.php');"

WORKDIR /var/www

# clone source
RUN rm -rf /var/www/html \
    && git clone https://github.com/owl/owl.git /var/www/owl \
    && ln -s /var/www/owl/public /var/www/html

WORKDIR /var/www/owl

# setup app
RUN cp .env.example .env \
    && composer install \
    && php artisan key:generate \
    && cp storage/database.sqlite_default storage/database.sqlite \
    && chmod -R 777 storage/ \
    && chmod -R 777 public/images/ \
    && php artisan migrate --seed --force \
    && npm i \
    && npm run build
