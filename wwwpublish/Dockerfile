FROM ubuntu:16.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_ID=1000
ARG USER_NAME=oklischat
ARG USERS_GROUP=users

RUN locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -yy upgrade

RUN apt-get -yy install apache2

RUN useradd -u $USER_ID -d /media/data/olaf -g users -G www-data $USER_NAME
RUN printf "export APACHE_RUN_USER=${USER_NAME}\nexport APACHE_RUN_GROUP=${USERS_GROUP}\n" >>/etc/apache2/envvars

COPY data.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite 000-default
RUN /usr/sbin/a2ensite data
RUN /usr/sbin/a2enmod ssl

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

