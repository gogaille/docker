#!/bin/sh
set -e

[ $(id -u) -eq 0 ] && update-ca-trust && cp /etc/ssl/certs/ca-bundle.trust.crt /opt/bref/ssl/cert.pem

GGLL_LOCALHOST_IP=$(dig +short -t A ggll.localhost)

if [ id -u = 0 ]; then
  echo "export GGLL_LOCALHOST_IP=$GGLL_LOCALHOST_IP" >> ~/.bashrc
fi

exec env GGLL_LOCALHOST_IP=$GGLL_LOCALHOST_IP /bref-entrypoint.sh "$@"
