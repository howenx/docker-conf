#!/bin/bash

service php5-fpm restart
# Start nginx
nginx -g 'daemon off;'
