FROM ubuntu:wily
# Update the package repository
RUN DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y locales && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
   	DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates wget apt-transport-https curl vim build-essential
	
ENV LANG en_US.utf8

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
	echo "deb http://nginx.org/packages/mainline/ubuntu/ wily nginx" > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	apt-get install -y \
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
						php5-pgsql \
						php5-sqlite \
						inetutils-ping \
						phppgadmin

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get install postgresql-client-9.5


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/nginx/conf.d/default.conf


EXPOSE 80 443
COPY start.sh /start.sh
CMD ["/start.sh"]
