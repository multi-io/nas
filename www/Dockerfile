FROM ubuntu:24.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_ID=1000
ARG USER_NAME=olaf
ARG USERS_GROUP=users

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8 && locale-gen de_DE.UTF-8 && update-locale LANG=en_US.UTF-8 && \
    apt-get -yy upgrade && \
    apt-get -yy install apache2 && \
    userdel -f ubuntu && useradd -u $USER_ID -d /home/olaf -g users -G www-data $USER_NAME && \
    printf "export APACHE_RUN_USER=${USER_NAME}\nexport APACHE_RUN_GROUP=${USERS_GROUP}\n" >>/etc/apache2/envvars

COPY port80.conf /etc/apache2/sites-available/
COPY index.html  /var/www/html/

RUN /usr/sbin/a2dissite 000-default && \
    /usr/sbin/a2ensite port80 && \
    /usr/sbin/a2enmod ssl cgi

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

