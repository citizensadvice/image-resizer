FROM ruby:2.6.6-alpine

WORKDIR /app

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
 && rm -rf /tmp/* /var/cache/apk/*

RUN apk -U upgrade \
 && apk add -t vips \
 && apk add -t vips-dev \
 && rm -rf /tmp/* /var/cache/apk/*

RUN apk -U upgrade && apk add imagemagick

COPY app/* ./
RUN gem install bundler && bundle install

EXPOSE 4567

CMD ruby app.rb
