# syntax=docker/dockerfile:1.4
ARG PHP_VERSION=82
ARG ALPINE_VERSION=3.16
ARG BREF_VERSION=1.7.22
ARG REDIS_EXTRA_VERSION=0.12.4

FROM bref/extra-redis-php-${PHP_VERSION}:${REDIS_EXTRA_VERSION} AS redis_extension

FROM alpine:${ALPINE_VERSION} as tools-installer
RUN apk add --no-cache curl gnupg

FROM tools-installer as hcl2json
ARG HCL2JSON_VERSION=0.3.5
RUN <<EOF ash -e
  curl -SsL https://github.com/tmccombs/hcl2json/releases/download/${HCL2JSON_VERSION}/hcl2json_linux_amd64 > /usr/local/bin/hcl2json
  chmod 755 /usr/local/bin/hcl2json
  hcl2json -help
EOF

FROM tools-installer as jtc
RUN <<EOF ash -e
  curl -SsL https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-linux-64.latest > /usr/local/bin/jtc
  chmod 755 /usr/local/bin/jtc
  jtc -help
EOF

FROM tools-installer as phive
ARG PHIVE_VERSION=0.15.2
RUN <<EOF ash -e
  curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar > /usr/local/bin/phive
  curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar.asc > /tmp/phive.phar.asc
  gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x6AF725270AB81E04D79442549D8A98B29B2D5D79
  gpg --verify /tmp/phive.phar.asc /usr/local/bin/phive
  chmod 755 /usr/local/bin/phive
EOF

FROM bref/php-${PHP_VERSION}:${BREF_VERSION}
RUN <<EOF bash -e
  mkdir /composer-cache
  chmod a+rw /composer-cache
  yum install -y unzip
  yum clean all
EOF
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache \
  PHIVE_HOME=/tmp/phive \
  PHP_INI_SCAN_DIR=/opt/bref/etc/php/conf.d:/var/task/php/conf.d:/var/task/php/conf.dev.d
COPY entrypoint.sh /gogaille-entrypoint.sh
COPY --from=composer:2.5 /usr/bin/composer /usr/local/bin/composer
COPY --from=phive /usr/local/bin/phive /usr/local/bin/
RUN phive --version
COPY --from=hcl2json /usr/local/bin/hcl2json /usr/local/bin/
COPY --from=jtc /usr/local/bin/jtc /usr/local/bin/
COPY --from=redis_extension /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=redis_extension /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini
COPY --from=ghcr.io/symfony-cli/symfony-cli:v5 /usr/local/bin/symfony /usr/local/bin/symfony
ENTRYPOINT [ "/gogaille-entrypoint.sh" ]
EXPOSE 8000
CMD ["symfony", "local:server:start", "--no-tls", "--no-interaction", "--port=8000"]
