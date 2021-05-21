# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gamirjan <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/27 12:41:11 by gamirjan          #+#    #+#              #
#    Updated: 2021/02/27 17:57:54 by gamirjan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install wget nginx mariadb-server php7.3 php-mysql php-fpm php-pdo php-gd  php-cli php-mbstring php-zip php-xmlrpc php-xml php-soap php-intl 

WORKDIR /etc/nginx/sites-available/

COPY ./srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled

WORKDIR /var/www/server
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm -rf latest.tar.gz
RUN chown -R www-data:www-data /var/www/server/wordpress
WORKDIR /var/www/server/wordpress
COPY ./srcs/wp-config.php .

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages/ /var/www/server/phpmyadmin
COPY ./srcs/my-admin.php /var/www/server/phpmyadmin

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt  -subj "/C=AM/ST=Yerevan/L=Yerevan/O=42 School/OU=gamirjan/CN=localhost" 

COPY ./srcs/setup.sh ./

CMD bash ./setup.sh