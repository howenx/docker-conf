FROM ubuntu:wily

RUN sed -ri 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list \
	&& apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		vim
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update \
	 && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server \
	 && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf
	 
RUN apt-get -yqq clean && \
	     apt-get -yqq purge && \
	     rm -rf /tmp/* /var/tmp/* && \
	     rm -rf /var/lib/apt/lists/*	 

RUN mkdir /data
VOLUME /data
WORKDIR /data

# Expose ports.
EXPOSE 6379
CMD ["redis-server", "/etc/redis/redis.conf"]
