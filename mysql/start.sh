#!/bin/sh

/usr/sbin/sshd

/etc/init.d/mysql start

tail -f /var/log/mysql/error.log
