FROM ubuntu:xenial

# Update the package repository
RUN sed -ri 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list 

ENV LANG en_US.utf8

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV GOSU_VERSION 1.7
RUN set -x \
		&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
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


RUN apt-get update && apt-get install -y perl pwgen --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6.32-1ubuntu16.04

RUN echo "deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN { \
			echo mysql-community-server mysql-community-server/data-dir select ''; \
			echo mysql-community-server mysql-community-server/root-pass password ''; \
			echo mysql-community-server mysql-community-server/re-root-pass password ''; \
			echo mysql-community-server mysql-community-server/remove-test-db select false; \
		} | debconf-set-selections \
		&& apt-get update && apt-get install -y mysql-client="${MYSQL_VERSION}" mysql-common="${MYSQL_VERSION}"  mysql-community-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/* \
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
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
