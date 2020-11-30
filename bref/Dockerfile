FROM bref/php-80-fpm-dev:1.0.1
USER root
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 > /usr/local/bin/json2hcl && \
  chmod 755 /usr/local/bin/json2hcl && \
  json2hcl -version
RUN curl --compressed -SsL https://github.com/antonmedv/fx/releases/download/20.0.2/fx-linux.zip -o - | \
  gunzip - > /usr/local/bin/fx && \
  chmod 755 /usr/local/bin/fx
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache && \
  yum install -y zip
USER sbx_user1051
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache
COPY --from=composer:2.0.7 /usr/bin/composer /usr/local/bin/composer
ENV PHP_CS_FIXER_IGNORE_ENV=1
COPY --from=oskarstark/php-cs-fixer-ga:2.16.7 /usr/local/bin/php-cs-fixer /usr/local/bin/php-cs-fixer
COPY --from=bref/extra-redis-php-80:0.7.2 /opt/bref-extra/redis.so /opt/bref-extra/redis.so
COPY --from=bref/extra-redis-php-80:0.7.2 /opt/bref/etc/php/conf.d/ext-redis.ini /opt/bref/etc/php/conf.d/ext-redis.ini
