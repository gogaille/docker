#!/bin/sh
set -e

[ $(id -u) -eq 0 ] && update-ca-trust && cp /etc/ssl/certs/ca-bundle.trust.crt /opt/bref/ssl/cert.pem

exec /bref-entrypoint.sh $@
