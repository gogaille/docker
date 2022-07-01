ARG PHP_VERSION=81
ARG ALPINE_VERSION=3.16
ARG BREF_VERSION=1.6.0

FROM bref/extra-redis-php-${PHP_VERSION}:0.11.32 AS redis_extension

FROM alpine:${ALPINE_VERSION} as tools-installer
RUN apk add --no-cache curl gnupg

FROM tools-installer as hcl2json
ARG HCL2JSON_VERSION=0.3.4
RUN curl -SsL https://github.com/tmccombs/hcl2json/releases/download/v${HCL2JSON_VERSION}/hcl2json_linux_amd64 > /usr/local/bin/hcl2json && \
  chmod 755 /usr/local/bin/hcl2json && \
  hcl2json -help

FROM tools-installer as jtc
RUN curl -SsL https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-linux-64.latest > /usr/local/bin/jtc && \
  chmod 755 /usr/local/bin/jtc && \
  jtc -help

FROM tools-installer as phive
ARG PHIVE_VERSION=0.15.1
RUN curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar > /usr/local/bin/phive && \
  curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar.asc > /tmp/phive.phar.asc && \
  gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x6AF725270AB81E04D79442549D8A98B29B2D5D79 && \
  gpg --verify /tmp/phive.phar.asc /usr/local/bin/phive && \
  chmod 755 /usr/local/bin/phive

FROM bref/php-${PHP_VERSION}-fpm-dev:${BREF_VERSION}
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache && \
  yum install -y unzip && \
  yum clean all
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache \
  PHP_CS_FIXER_IGNORE_ENV=1 \
  PHIVE_HOME=/tmp/phive
COPY entrypoint.sh /gogaille-entrypoint.sh
COPY --from=composer:2.3.7 /usr/bin/composer /usr/local/bin/composer
COPY --from=phive /usr/local/bin/phive /usr/local/bin/
RUN phive --version
COPY --from=hcl2json /usr/local/bin/hcl2json /usr/local/bin/
COPY --from=jtc /usr/local/bin/jtc /usr/local/bin/
COPY --from=redis_extension /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=redis_extension /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini
ENTRYPOINT [ "/gogaille-entrypoint.sh" ]
CMD ["/opt/bin/php-fpm", "--nodaemonize", "--fpm-config", "/opt/bref/etc/php-fpm.conf", "-d", "opcache.validate_timestamps=1", "--force-stderr"]
