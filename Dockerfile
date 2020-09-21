FROM ruby:2.7.1-alpine

RUN apt install imagemagick libvips

EXPOSE 5678
ENV RACK_ENV production
ENV RUBYOPT --jit

WORKDIR /app
COPY . /app

RUN bundle install --without development test

CMD bundler exec rackup -o 0.0.0.0 -p 5678 -E ${RACK_ENV}
