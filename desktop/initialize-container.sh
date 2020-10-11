#!/bin/sh

set -e

usermod -a -G mail olaf
chgrp crontab /var/spool/cron/crontabs
