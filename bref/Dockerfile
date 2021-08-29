FROM alpine:3.14 as dependencies
RUN apk add --no-cache curl
RUN curl -SsL https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-linux-64.latest > /usr/local/bin/jtc && \
  chmod 755 /usr/local/bin/jtc && \
  jtc -help
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 > /usr/local/bin/json2hcl && \
  chmod 755 /usr/local/bin/json2hcl && \
  json2hcl -version

FROM bref/php-80-fpm-dev:1.2.12
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache && \
  yum install -y unzip && \
  yum clean all
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache \
  PHP_CS_FIXER_IGNORE_ENV=1
COPY entrypoint.sh /gogaille-entrypoint.sh
COPY --from=composer:2.1.6 /usr/bin/composer /usr/local/bin/composer
COPY --from=dependencies /usr/local/bin/json2hcl /usr/local/bin/jtc /usr/local/bin/
COPY --from=bref/extra-redis-php-80:0.11.14 /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=bref/extra-redis-php-80:0.11.14 /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini

ENTRYPOINT [ "/gogaille-entrypoint.sh" ]
CMD ["/opt/bin/php-fpm", "--nodaemonize", "--fpm-config", "/opt/bref/etc/php-fpm.conf", "-d", "opcache.validate_timestamps=1", "--force-stderr"]
