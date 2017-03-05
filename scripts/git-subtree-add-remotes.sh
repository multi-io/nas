#!/usr/bin/env bash
# initialize git remotes that the other git-* scripts rely on.
# Needs to be done only once

set -x

cd "$(dirname $0)/.."

. scripts/subtrees.sh

for subdir in "${!subtrees[@]}"; do
    git remote add "${subdir}-origin" ${subtrees[$subdir]};
done
