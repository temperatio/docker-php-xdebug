FROM php:7.2-apache

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libldap2-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
        && docker-php-ext-install ldap \
        && docker-php-ext-install zip \
        && docker-php-ext-install mysqli \
        && apt-get purge -y libpng-dev libjpeg-dev libldap2-dev


# Install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN chown -hR www-data:www-data /var/www/html

VOLUME /var/www/html

EXPOSE 80