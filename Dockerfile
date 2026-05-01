FROM ruby:4.0.3-alpine3.22 AS base

ENV LANG=C.UTF-8
ENV APP_ROOT=/app

#################################################

FROM base AS builder

RUN apk add --update --no-cache build-base git yaml-dev imagemagick tiff-tools jemalloc

WORKDIR $APP_ROOT
COPY Gemfile* /app/

RUN gem install bundler \
 && bundle install \
 && rm -rf /usr/local/bundle/*/*/cache \
 && find /usr/local/bundle -name "*.c" -delete \
 && find /usr/local/bundle -name "*.o" -delete

#################################################

FROM base

ENV RACK_ENV=production
ENV RUBY_YJIT_ENABLE=1
ENV LD_PRELOAD=libjemalloc.so.2

RUN apk update \
 && apk upgrade \
 && apk --no-cache add imagemagick tiff-tools file gcompat

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY . $APP_ROOT
WORKDIR $APP_ROOT

RUN addgroup ruby -g 3000 \
 && adduser -D -h /home/ruby -u 3000 -G ruby ruby

USER ruby

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "-p", "4567"]
