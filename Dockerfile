FROM ruby:2.7.2-alpine
ENV LANG C.UTF-8

WORKDIR /app

RUN apk update && \
  apk upgrade && \
  apk --no-cache add \
    build-base \
    git \
    vips \
    vips-dev \
    tiff-tools

COPY Gemfile* /app/

RUN gem install bundler && \
    bundle install

COPY . /app/

RUN addgroup ruby -g 3000 \
    && adduser -D -h /home/ruby -u 3000 -G ruby ruby
USER ruby

EXPOSE 4567
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]