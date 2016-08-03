#!/bin/bash

service php5.6-fpm start
chmod 777 /var/run/php/php5.6-fpm.sock
# Start nginx
nginx -g 'daemon off;'
