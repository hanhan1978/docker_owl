#!/bin/bash
/opt/remi/php56/root/usr/sbin/php-fpm -D & /usr/sbin/nginx -g 'daemon off;'
