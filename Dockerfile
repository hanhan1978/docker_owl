
FROM ubuntu:14.04

MAINTAINER hanhan1978 <ryo.tomidokoro@gmail.com>

# RUN instructions execute any commands and commit the results


RUN apt-get install -y software-properties-common
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN add-apt-repository 'deb http://dl.hhvm.com/ubuntu trusty main'

RUN apt-get update 
RUN apt-get install -y nginx 
RUN apt-get install -y nginx-extras

RUN apt-get install -y hhvm 
RUN apt-get install -y git 
RUN apt-get install -y curl 
RUN apt-get install -y sqlite 

RUN mkdir /var/www
RUN git clone https://github.com/fortkle/owl.git /var/www/owl
RUN cd /var/www/owl;curl -sS https://getcomposer.org/installer | php
RUN cd /var/www/owl;php composer.phar install

RUN cd /var/www/owl; php artisan vendor:publish --provider="Owl\Providers\TwitterBootstrapServiceProvider" --force
RUN cd /var/www/owl; php artisan migrate --force

RUN chown -R www-data:www-data /var/www/owl

ADD default.conf /etc/nginx/conf.d/default.conf
ADD server.ini /etc/hhvm/server.ini
ADD run.sh /usr/bin/run.sh


EXPOSE 8000
CMD ["/usr/bin/run.sh"]
