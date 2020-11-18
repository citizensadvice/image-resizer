FROM ruby:2.7.2-alpine AS build

RUN apk --no-cache --update add build-base vips vips-dev imagemagick tiff-tools

ENV LANG=C.UTF-8

WORKDIR /app

COPY Gemfile* /app/

RUN gem install bundler \
    && bundle config set without 'development' \
    && bundle install --full-index

COPY . /app/

RUN addgroup ruby -g 3000 \
    && adduser -D -h /home/ruby -u 3000 -G ruby ruby \
    && mkdir /app/tmp /app/log \
    && chmod -R 777 /app/tmp /app/log

USER ruby

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]