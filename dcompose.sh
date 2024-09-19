#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

set -a
. ./_getenv.sh

exec docker compose -p nas "$@"
