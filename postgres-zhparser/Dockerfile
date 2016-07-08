FROM ubuntu:wily

# Update the package repository
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN sed -ri 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y locales && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive  apt-get install -yqq wget curl psmisc && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
   	DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates wget apt-transport-https python curl vim cmake build-essential git && \
    wget -O scws-1.2.1.tar.bz2 "http://www.xunsearch.com/scws/down/scws-1.2.1.tar.bz2" && \
	tar -xjvf scws-1.2.1.tar.bz2 && \
    cd scws-1.2.1 && \
    ./configure && \
    make install

ENV LANG en_US.utf8


RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wily-pgdg main' 9.5 > /etc/apt/sources.list.d/pgdg.list
RUN wget -O ACCC4CF8.asc "http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc" \
	&& apt-key add ACCC4CF8.asc

RUN apt-get update \
        && apt-get install -y postgresql-9.5 \
		&& apt-get install -y postgresql-9.5-postgis-2.2 \
		&& apt-get install -y libpq-dev \
		&& apt-get install -y postgresql-server-dev-all \
		&& apt-get install -y postgresql-common
	
RUN set -x \
        && cd ~ \
        && git clone https://github.com/amutu/zhparser.git \
        && cd zhparser \
        && SCWS_HOME=/usr/local make \
        && make install

RUN gpasswd -a postgres sudo && \
	echo "Defaults        env_reset" >> /etc/sudoers && \
	echo "Defaults        mail_badpass" >> /etc/sudoers && \
	echo "Defaults        secure_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'" >> /etc/sudoers && \
	echo "root    ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
	echo "postgres    ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
	echo "%admin ALL=(ALL) ALL" >> /etc/sudoers && \
	echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Clean image
RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

USER postgres
RUN /etc/init.d/postgresql start \
	&& psql --command "alter role postgres with password 'postgres';" \
	&& psql --command "create extension dblink;" \
	&& psql --command "create extension zhparser;" \
	&& /etc/init.d/postgresql stop 

USER root
RUN echo "host    all             all             0.0.0.0 0.0.0.0         md5" >> /etc/postgresql/9.5/main/pg_hba.conf \
	&& sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/main/postgresql.conf \
	&& sed -i "s/max_connections = 100/max_connections = 2000/g" /etc/postgresql/9.5/main/postgresql.conf
	
EXPOSE 5432
COPY start.sh /start.sh
COPY postgresql.conf /etc/postgresql/9.5/main/postgresql.conf
RUN chmod 777 start.sh
CMD ["bash", "start.sh"]
