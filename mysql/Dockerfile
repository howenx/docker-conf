FROM ubuntu:wily

# Update the package repository
RUN sed -ri 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y locales && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
   	DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils ca-certificates apt-transport-https build-essential mysql-server-5.6

ENV LANG en_US.utf8

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Clean image
RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

USER root
RUN   mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'kakaogift';" &&\
      mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'kakaogift';" &&\
      mysql -u root -pkakaogift -e "show databases;"  &&\
	  sleep 5

EXPOSE 3306

CMD ["tail -f /var/log/mysql/error.log"]
