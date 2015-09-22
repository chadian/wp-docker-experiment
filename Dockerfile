######################################################################
# phusion/baseimage image and setup

FROM phusion/baseimage:0.9.17

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

######################################################################
# Container configuration

ENV DEBIAN_FRONTEND=noninteractive

# Expose port 80
EXPOSE 80

# Update packages
RUN apt-get update -y

# Install apache
RUN apt-get install -y \
	apache2 \
	php5 \
	php-pear \
	mysql-server \
	php5-mysql

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

######################################################################
# Setup necessary services
# All services must be non-daemonized/run in the foreground
# Services boostrapped by /etc/service/[service name]/run.sh with
# run.sh being executable

# Apache
ENV APACHE_RUN_USER root
ENV APACHE_RUN_GROUP root
RUN mkdir -p /etc/service/apache
ADD .docker/apache/run.sh /etc/service/apache/run

# Mysql
RUN mkdir -p /etc/service/mysql
ADD .docker/mysql/run.sh /etc/service/mysql/run
ADD .docker/mysql/create-wp-db.sql /etc/service/mysql/create-wp-db.sql

# All run.sh files need to be executable
RUN chmod -R +x /etc/service/