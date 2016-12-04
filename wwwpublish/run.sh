#!/bin/sh

set -e

name=tackwww

docker rm -f $name || true

docker build -t oklischat/wwwpublish:latest .
docker run -d --net=pubnet -h $name --name=$name --ip=192.168.142.17 -v /media:/media oklischat/wwwpublish:latest

