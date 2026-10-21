FROM php:8.4-fpm

# Prevent interactive package installation
ENV TMPDIR=/tmp

#Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip default-mysql-client \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql zip

#Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis    

RUN mkdir -p /tmp \
    && chmod 1777 /tmp

#Install composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

#Copy entrypoint
COPY docker/scripts/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]