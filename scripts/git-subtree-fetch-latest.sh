#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "usage: $0 <subdirectory>";
    exit 1;
fi

cd "$(dirname $0)/.."

git fetch "${1}-origin" master:$1-master
