# syntax=docker/dockerfile:experimental
FROM curlimages/curl as symfony-cli
RUN curl --http2 --compressed --location \
  https://github.com/symfony/cli/releases/download/v4.17.0/symfony_linux_amd64.gz | \
  gunzip - > /tmp/symfony \
  && echo "01142b751526dff6f0a8a793a1782d798663daa7cedffcc6ddb107b863266bee  /tmp/symfony" | sha256sum -cs \
  && chmod +x /tmp/symfony


FROM php:7.4-fpm-alpine3.11 as php
RUN apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS \
  icu-dev \
  && pecl install redis-5.2.2 \
  && docker-php-ext-install intl \
  && docker-php-ext-enable redis opcache \
  && set -eux; \
  runDeps="$( \
  scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
  | tr ',' '\n' \
  | sort -u \
  | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )"; apk add --no-cache --virtual .phpexts-rundeps $runDeps; \
  apk del -f .build-deps

RUN adduser -u 1001 -D php
USER php
COPY --from=symfony-cli /tmp/symfony /usr/local/bin/symfony
COPY --from=composer:1.10.6 /usr/bin/composer /usr/local/bin/composer
# buildkit bug: despite uid=1001 in mount type cache... created with uid 0
RUN mkdir -p ~/.composer
# see https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md
RUN --mount=type=cache,uid=1001,gid=1001,id=composer,target=/home/php/.composer \
  composer global require hirak/prestissimo:0.3.10
