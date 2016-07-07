#!/bin/bash

service php5-fpm restart
# Start nginx
/usr/sbin/nginx -D FOREGROUND
