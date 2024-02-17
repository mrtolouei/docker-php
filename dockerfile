# Use the official PHP 8.2 image as the base image
FROM php:8.2

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        libonig-dev \
        libcurl4-openssl-dev \
        libssl-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mysqli pdo zip curl

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer files and install dependencies
COPY composer.json ./
RUN composer install --no-interaction --optimize-autoloader
RUN composer dump-autoload

# Copy the rest of the application code
COPY . .

# Expose port 80 for web server
EXPOSE 80

# Command to run your application
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]