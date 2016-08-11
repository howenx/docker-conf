FROM ubuntu:xenial
# Update the package repository
RUN sed -ri 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y locales && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
   	DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates apt-transport-https vim
	
ENV LANG en_US.utf8

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C
RUN echo "deb http://ppa.launchpad.net/ondrej/mysql-5.6/ubuntu xenial main" > /etc/apt/sources.list.d/mysql.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AD829E29A018BAF8C3842FB080E7349A06ED541C
RUN echo "deb http://ppa.launchpad.net/nijel/phpmyadmin/ubuntu xenial main " > /etc/apt/sources.list.d/phpmyadmin.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main " > /etc/apt/sources.list.d/php.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B3981E7A6852F782CC4951600A6F0A3C300EE8C
RUN echo "deb http://ppa.launchpad.net/nginx/development/ubuntu xenial main" > /etc/apt/sources.list.d/nginx.list
	
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
						bzip2 \
						zip \
						nginx-full \
						gettext-base \
                        php5.6 \
                        php5.6-common \
						php5.6-cli \
						php5.6-curl \
						php5.6-fpm \
						php5.6-gd \
						php5.6-mcrypt \
						php5.6-mysql \
						php5.6-bz2 \
						php5.6-zip \
						php-gettext \
						php-mbstring \
						php5.6-mbstring \
						phpmyadmin \
						mysql-client-5.6 

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

COPY default /etc/nginx/sites-available/default

EXPOSE 80
ADD start.sh /start.sh

RUN chmod 660 -R /var/lib/phpmyadmin && \
	chmod 777 start.sh

CMD ["bash", "start.sh"]