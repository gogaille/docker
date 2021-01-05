FROM alpine:3.12 as dependencies
RUN apk add --no-cache curl
RUN curl -SsL https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-linux-64.latest > /usr/local/bin/jtc && \
  chmod 755 /usr/local/bin/jtc && \
  jtc -help
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 > /usr/local/bin/json2hcl && \
  chmod 755 /usr/local/bin/json2hcl && \
  json2hcl -version

FROM bref/php-80-fpm-dev:1.1.2
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache \
  PHP_CS_FIXER_IGNORE_ENV=1
COPY --from=composer:2.0.7 /usr/bin/composer /usr/local/bin/composer
COPY --from=dependencies /usr/local/bin/json2hcl /usr/local/bin/jtc /usr/local/bin/
COPY --from=bref/extra-redis-php-80:0.9.5 /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=bref/extra-redis-php-80:0.9.5 /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini
