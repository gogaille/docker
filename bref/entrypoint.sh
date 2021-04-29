#!/bin/sh
set -e

update-ca-trust force-enable

exec "$@"
