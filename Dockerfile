FROM ubuntu:latest
RUN apt-get update && apt-get install -y apache2 curl mc zip unzip
RUN apt-get update && apt-get install -y php libapache2-mod-php php-mbstring php-cli php-bcmath php-json php-xml php-zip php-pdo php-common php-tokenizer 
RUN apt-get update && apt-get install -y php-mysql 
RUN apt-get update && apt-get install -y php-mysqli 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/html/my-qortex-test
RUN a2enmod rewrite
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
