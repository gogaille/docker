FROM bref/php-74-fpm-dev:0.5.31
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
COPY --from=cytopia/php-cs-fixer:2 /usr/bin/php-cs-fixer /usr/local/bin/php-cs-fixer
COPY --from=bref/extra-redis-php-74:0.5.3 /opt/bref-extra/redis.so /opt/bref-extra/redis.so
