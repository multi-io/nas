FROM ubuntu:16.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

RUN locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -yy upgrade

RUN apt-get -yy install apache2

RUN useradd -u 1000 -d /media/data/olaf -g users -G www-data olaf
RUN printf 'export APACHE_RUN_USER=olaf\nexport APACHE_RUN_GROUP=users\n' >>/etc/apache2/envvars

COPY data.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite 000-default
RUN /usr/sbin/a2ensite data
RUN /usr/sbin/a2enmod ssl

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

