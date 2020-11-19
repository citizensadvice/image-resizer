FROM ruby:2.7.2-alpine

WORKDIR /app

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
 && rm -rf /tmp/* /var/cache/apk/*
RUN apk -U upgrade \
 && apk add -t vips \
 && apk add -t vips-dev \
 && rm -rf /tmp/* /var/cache/apk/*

RUN apk -U upgrade && apk add imagemagick tiff-tools

COPY Gemfile* /app/
RUN gem install bundler && bundle install

COPY . /app/

RUN addgroup ruby -g 3000 \
    && adduser -D -h /home/ruby -u 3000 -G ruby ruby
USER ruby

EXPOSE 4567
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]