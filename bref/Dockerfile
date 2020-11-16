FROM bref/php-74-fpm-dev
USER root
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 > /usr/local/bin/json2hcl \
  && chmod 755 /usr/local/bin/json2hcl \
  && json2hcl -version
RUN curl -SsL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 > /usr/local/bin/jq \
  && chmod 755 /usr/local/bin/jq \
  && jq --version
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache && \
  yum install -y zip
USER sbx_user1051
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache
COPY --from=composer:2.0.6 /usr/bin/composer /usr/local/bin/composer
COPY --from=cytopia/php-cs-fixer:2 /usr/bin/php-cs-fixer /usr/local/bin/php-cs-fixer
COPY --from=bref/extra-blackfire-php-74 /opt/bref-extra/blackfire.so /opt/bref-extra/blackfire.so
