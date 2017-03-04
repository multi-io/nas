#!/usr/bin/env bash
# initialize git remotes that the other git-* scripts rely on.
# Needs to be done only once

set -e

cd "$(dirname $0)/.."

if [ -z "$1" ]; then
    echo "usage: $0 <subdirectory>" >&2;
    exit 1;
fi

. scripts/subtrees.sh

./scripts/git-subtree-fetch-latest.sh "$1"

git subtree pull  -P "$1" ${subtrees[$1]} master
