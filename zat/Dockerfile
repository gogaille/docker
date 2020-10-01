FROM ruby:2.3-alpine as zat

RUN gem install rake

RUN set -ex \
  && apk add --update nodejs \
  && apk add --virtual build-base ruby-dev
RUN gem install zendesk_apps_tools
WORKDIR /app

RUN adduser -u 1001 -D zat \
  && chown zat:zat /app
USER zat

CMD ["zat", "server", "--app-id=0", "--bind=0.0.0.0", "-p", "dist"]

EXPOSE 4567
