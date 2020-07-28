FROM phusion/baseimage:latest
MAINTAINER Karol D Sz


ENV TZ "${TZ:-Europe/Warsaw}"

ENV APP nginx
ENV APP_PORT "${APP_PORT:-8080}"
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

# runit - prepare nginx service
RUN mkdir -p /etc/service/$APP
COPY $APP.run /etc/service/$APP/run
RUN chmod +x /etc/service/$APP/run

# create app and run directory, set permissions
RUN mkdir -p $APP_HOME /var/run/nginx
RUN chown -R $APP_USER:$APP_USER $APP_HOME $APP_LOG_VOLUME /var/lib/nginx/ /var/run/nginx

# add config file
RUN rm -f /etc/nginx/nginx.conf /etc/nginx/sites-available/default
ADD ./nginx.conf /etc/nginx/nginx.conf

WORKDIR $APP_HOME
EXPOSE $APP_PORT

CMD ["/sbin/my_init"]

