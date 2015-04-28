#!/bin/bash
/usr/bin/hhvm --mode daemon --config /etc/hhvm/server.ini & /usr/sbin/nginx -g 'daemon off;'
