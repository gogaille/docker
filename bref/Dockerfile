FROM bref/php-74-fpm-dev
USER root
RUN mkdir /composer-cache && \
  chmod a+rw /composer-cache && \
  yum install -y zip
USER sbx_user1051
ENV PATH=$PATH:/var:/var/task/bin \
  COMPOSER_CACHE_DIR=/composer-cache
COPY --from=composer:2.0.0-alpha3 /usr/bin/composer /usr/local/bin/composer
COPY --from=cytopia/php-cs-fixer:2 /usr/bin/php-cs-fixer /usr/local/bin/php-cs-fixer
