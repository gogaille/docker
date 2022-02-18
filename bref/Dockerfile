ARG PHP_VERSION=81
ARG ALPINE_VERSION=3.15
ARG BREF_VERSION=1.5.3

FROM bref/extra-redis-php-${PHP_VERSION}:0.11.25 AS redis_extension

FROM alpine:${ALPINE_VERSION} as tools-installer
RUN apk add --no-cache curl gnupg

FROM tools-installer as json2hcl
ARG JSON2HCL_VERSION=0.0.6
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v${JSON2HCL_VERSION}/json2hcl_v${JSON2HCL_VERSION}_linux_amd64 > /usr/local/bin/json2hcl && \
  chmod 755 /usr/local/bin/json2hcl && \
  json2hcl -version

FROM tools-installer as jtc
RUN curl -SsL https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-linux-64.latest > /usr/local/bin/jtc && \
  chmod 755 /usr/local/bin/jtc && \
  jtc -help

FROM tools-installer as phive
ARG PHIVE_VERSION=0.15.0
RUN curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar > /usr/local/bin/phive && \
  curl -SsL https://github.com/phar-io/phive/releases/download/${PHIVE_VERSION}/phive-${PHIVE_VERSION}.phar.asc > /tmp/phive.phar.asc && \
  gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x9D8A98B29B2D5D79 && \
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
COPY --from=composer:2.2.6 /usr/bin/composer /usr/local/bin/composer
COPY --from=phive /usr/local/bin/phive /usr/local/bin/
RUN phive --version
COPY --from=json2hcl /usr/local/bin/json2hcl /usr/local/bin/
COPY --from=jtc /usr/local/bin/jtc /usr/local/bin/
COPY --from=redis_extension /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=redis_extension /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini
ENTRYPOINT [ "/gogaille-entrypoint.sh" ]
CMD ["/opt/bin/php-fpm", "--nodaemonize", "--fpm-config", "/opt/bref/etc/php-fpm.conf", "-d", "opcache.validate_timestamps=1", "--force-stderr"]
