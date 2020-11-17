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
COPY Gemfile* /app/
RUN gem install bundler \
	&& bundle config mirror.https://rubygems.org https://nexus.devops.citizensadvice.org.uk/repository/rubygems-proxy \
    && bundle config mirror.https://rubygems.org.fallback_timeout 1 \
    && bundle config set path "vendor/bundle" \
    && bundle config set jobs 6 \
    && bundle install --full-index

RUN gem install bundler && bundle install

COPY . /app/

EXPOSE 4567

# Add user
RUN addgroup ruby -g 3000 \
    && adduser -D -h /home/ruby -u 3000 -G ruby ruby

USER ruby

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]