FROM php:7.2-apache
RUN apt-get update && apt-get install -y \
	libxslt-dev \
	&& docker-php-ext-install -j$(nproc) xsl \
	&& a2enmod rewrite \
	&& mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY html/ /var/www/html
COPY 000-default.conf /etc/apache2/sites-available/
