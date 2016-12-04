#!/bin/sh

name=tackd

docker rm -f $name

set -e

docker build -t oklischat/desktop:latest .
docker run -d --net=pubnet -h $name --name=$name --ip=192.168.142.16 -v desktop_etc_ssh:/etc/ssh -v /home:/home -v /media:/media oklischat/desktop:latest

