FROM phusion/baseimage:latest
MAINTAINER Karol D Sz


ENV TZ "${TZ:-Europe/Warsaw}"

ENV APP nginx
ENV APP_PORT 80
ENV APP_USER www-data 
ENV APP_HOME /opt/app
ENV APP_LOG_VOLUME /var/log/nginx

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -q -y --no-install-recommends install nginx psmisc curl wget less net-tools lsof iproute2 tzdata 

# cleanup
RUN apt-get autoremove -y; apt-get clean all
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service
RUN rm -rf /etc/service/sshd

# create app directory, set permissions
RUN mkdir -p $APP_HOME
RUN chown -R $APP_USER:$APP_USER $APP_HOME

WORKDIR $APP_HOME
EXPOSE $APP_PORT

CMD ["/sbin/my_init"]

