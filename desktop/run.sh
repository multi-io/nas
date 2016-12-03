#!/bin/sh

docker rm -f desktop

set -e

docker build -t oklischat/desktop:latest .
docker run -d --name=desktop -v desktop_etc_ssh:/etc/ssh -v /home:/home -v /media:/media -p 2022:22 oklischat/desktop:latest

