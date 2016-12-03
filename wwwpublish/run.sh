#!/bin/sh

set -e

docker build -t oklischat/wwwpublish:latest .
docker run -d --name=wwwpublish -v /media:/media -p 8080:80 oklischat/wwwpublish:latest

