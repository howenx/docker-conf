FROM debian:jessie
# Update the package repository
RUN sed -ri 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y locales && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
   	DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates apt-transport-https vim
	
ENV LANG en_US.utf8

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6.32-1debian8
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
	echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
						nginx \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
						php5-cli \
						php5-curl \
						php5-fpm \
						php5-gd \
						php5-mcrypt \
						php5-mysql \
						inetutils-ping \
						phpmyadmin \
						mysql-community-client

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
ADD start.sh /start.sh

RUN chmod 777 start.sh \
	&& usermod -a -G www-data nginx \
	&& sed -i "s/;listen.mode = 0660/listen.mode = 0660/g" /etc/php5/fpm/pool.d/www.conf
CMD ["bash", "start.sh"]