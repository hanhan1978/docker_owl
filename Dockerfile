
FROM centos:centos6

MAINTAINER hanhan1978 <ryo.tomidokoro@gmail.com>

# RUN instructions execute any commands and commit the results

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

RUN yum -y install nginx 
RUN yum -y install --enablerepo=remi php56 php56-php-fpm php56-php-mbstring php56-php-mcrypt php56-php-pdo

RUN yum -y install git




RUN ln -s /usr/bin/php56 /usr/bin/php
RUN mkdir /var/www
RUN git clone https://github.com/fortkle/owl.git /var/www/owl
RUN cd /var/www/owl;curl -sS https://getcomposer.org/installer | php
RUN cd /var/www/owl;php composer.phar install


RUN cd /var/www/owl; yes | php artisan migrate --package=cartalyst/sentry
RUN cd /var/www/owl; yes | php artisan migrate
RUN cd /var/www/owl; yes | php artisan db:seed

RUN chown -R nginx:nginx /var/www/owl 

RUN sed -i 's/apache/nginx/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf

ADD default.conf /etc/nginx/conf.d/default.conf
ADD run.sh /usr/bin/run.sh

EXPOSE 80
# CMD ["/etc/init.d/php56-fpm start"]
CMD ["/usr/bin/run.sh"]

#  CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
