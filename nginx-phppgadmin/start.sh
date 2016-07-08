#!/bin/bash

service php5-fpm restart
chmod 777 /var/run/php5-fpm.sock 
# Start nginx
nginx -g 'daemon off;'
