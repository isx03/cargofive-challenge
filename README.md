# Lumen PHP Framework

[![Build Status](https://travis-ci.org/laravel/lumen-framework.svg)](https://travis-ci.org/laravel/lumen-framework)
[![Total Downloads](https://img.shields.io/packagist/dt/laravel/lumen-framework)](https://packagist.org/packages/laravel/lumen-framework)
[![Latest Stable Version](https://img.shields.io/packagist/v/laravel/lumen-framework)](https://packagist.org/packages/laravel/lumen-framework)
[![License](https://img.shields.io/packagist/l/laravel/lumen)](https://packagist.org/packages/laravel/lumen-framework)

Laravel Lumen is a stunningly fast PHP micro-framework for building web applications with expressive, elegant syntax. We believe development must be an enjoyable, creative experience to be truly fulfilling. Lumen attempts to take the pain out of development by easing common tasks used in the majority of web projects, such as routing, database abstraction, queueing, and caching.

> **Note:** In the years since releasing Lumen, PHP has made a variety of wonderful performance improvements. For this reason, along with the availability of [Laravel Octane](https://laravel.com/docs/octane), we no longer recommend that you begin new projects with Lumen. Instead, we recommend always beginning new projects with [Laravel](https://laravel.com).

## Official Documentation

Documentation for the framework can be found on the [Lumen website](https://lumen.laravel.com/docs).

## Contributing

Thank you for considering contributing to Lumen! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Security Vulnerabilities

If you discover a security vulnerability within Lumen, please send an e-mail to Taylor Otwell at taylor@laravel.com. All security vulnerabilities will be promptly addressed.

## License

The Lumen framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

##################################################################################

## steps to install lumen at local enviroment

# install dependencies
sudo apt install php8.1-cli \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-curl \
    php8.1-mysql \
    php8.1-gd \
    php8.1-zip

# run migrations
php artisan migrate

# run seeders to create tables and insert data in database
php artisan db:seed

# run server
php -S localhost:8000 -t public

# todo
estandarizar surcharges por alias para definier un solo nombre por dichos alias

('Bill Of Lading', ['BL Fee', 'BL', 'Bill of Lading (BL)'], 2)
('Ocean Freight', ['Ocean Freight', 'Ocean Freight Charge'], 1)
('Basic Freight', ['Basic Freight'], 1)
('Terminal Handling', ['Terminal Handling Charge Origin', 'Terminal Handling Charge', 'Terminal Handling Charge Destination'], 1)
('Bunker Adjustment', ['Bunker Adjustment', 'Bunker Adjustment Fee'], 1)
('Documentation Fee', ['Doc fee', 'Documentation fee'], 2)
('Peak Season', ['Peak Season', 'Peak Season Surcharge', 'Peak Season Adjustment Factor'], 1)
('Booking Fee', ['Booking fee'], 2)
('Port Charges', ['Port Charges Import', 'Port Charges Export'], 2)
('Overweight', ['Overweight', 'Overweight surcharge'], 1)
('T3', ['T3 Origin', 'T3'], 1)

# Definitions

- Charge -> A charge is a fee or payment required for a specific service or use of a facility
- Surcharge -> A surcharge is an additional charge added to an existing fee or tax
- Factor -> 

# doubts

1.  en el caso que en el excel haya datos que aun no estan en db la duda es la siguiente, mandar un error que en la fila x el valor tal no existe, crearlo automaticamente ese valor faltante en base de datos o crear endpoint que permite crear un surcharge?