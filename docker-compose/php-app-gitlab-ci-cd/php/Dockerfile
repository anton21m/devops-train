FROM php:8.0.30-fpm-alpine3.16

# pph fast cgi protocol
EXPOSE 9000 

# folder  is create!
WORKDIR /var/www/

COPY www /var/www

CMD ["php-fpm"]

