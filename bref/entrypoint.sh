#!/bin/sh
set -e

[ $(id -u) -eq 0 ] && update-ca-trust

exec "$@"
