#!/usr/bin/env bash

set -e

cd "$(dirname $0)/.."

. scripts/subtrees.sh

if [ -z "$1" ]; then
    echo "usage: $0 <subdirectory>" >&2;
    exit 1;
fi

git subtree split -P "$1/" -b "$1-master" --rejoin
