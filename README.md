

##################################################################################

## steps to install lumen at local enviroment

### install dependencies
sudo apt install php8.1-cli \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-curl \
    php8.1-mysql \
    php8.1-gd \
    php8.1-zip

### run migrations
php artisan migrate

### run seeders to create tables and insert data in database
php artisan db:seed

### run server
php -S localhost:8000 -t public

### run unit tests
./vendor/bin/phpunit