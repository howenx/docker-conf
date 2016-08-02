FROM ubuntu:xenial

# Update the package repository
RUN sed -ri 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list 

ENV LANG en_US.utf8

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV GOSU_VERSION 1.7
RUN set -x \
		&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget vim \
		&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
		&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
		&& export GNUPGHOME="$(mktemp -d)" \
		&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
		&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
		&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
		&& chmod +x /usr/local/bin/gosu \
		&& gosu nobody true \
		&& apt-get purge -y --auto-remove ca-certificates wget

RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y perl pwgen --no-install-recommends

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C
RUN echo "deb http://ppa.launchpad.net/ondrej/mysql-5.6/ubuntu xenial main" > /etc/apt/sources.list.d/mysql.list

RUN { \
		echo mysql-server mysql-server/root_password password '123123'; \
		echo mysql-server mysql-server/root_password_again password '123123'; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server-5.6 \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld

RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
		&& echo 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
		&& mv /tmp/my.cnf /etc/mysql/my.cnf

VOLUME /var/lib/mysql
	
RUN apt-get -yqq clean && \
	    apt-get -yqq purge && \
	    rm -rf /tmp/* /var/tmp/* && \
	    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
