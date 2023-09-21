FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    php8.1\
    php8.1-fpm\
    php8.1-pgsql\
    php8.1-mbstring\
    unzip\
    git\
    php8.1-curl\
    zlib1g-dev\
    libpng-dev\
    libxml2\
    libxml2-dev\
    libzip-dev\
    php8.1-gd\
    --no-install-recommends libssl-dev\
    php-pear\
    php8.1-zip\
    php8.1-dev\
    php8.1-sqlite3 \
    php8.1-xdebug 

RUN apt-get update
RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y software-properties-common && add-apt-repository ppa:openswoole/ppa -y
RUN apt-get install -y g++
RUN apt-get install -y make
RUN apt-get install -y php8.1-openswoole

# RUN pecl channel-update pecl.php.net 
RUN pecl install swoole


WORKDIR /var/www/html

RUN apt-get install -y nodejs

RUN apt-get install -y npm

RUN npm install --save-dev chokidar

WORKDIR /var/www/html/Romigo
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1


ARG MOUNT_PATH


CMD echo "xdebug.mode=develop,debug,coverage" >> /etc/php/8.1/cli/php.ini;\ 
    bash -c "echo 'extension=swoole' >> $(php -i | grep /.+/php.ini -oE)" ;\
    composer install ;\
    echo 1| php artisan octane:install ;\
    php artisan key:generate ;\
    # php artisan migrate ;\
    # php artisan db:seed ;\
    php artisan octane:start --server=swoole --host=0.0.0.0 --port=8002 --workers=auto --task-workers=auto --max-requests=500 --watch
