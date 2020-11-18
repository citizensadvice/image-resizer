FROM ruby:2.7.2-alpine AS build

RUN apk --no-cache --update add build-base vips vips-dev imagemagick tiff-tools

ADD Gemfile* /app/
WORKDIR /app

ENV LANG=C.UTF-8

RUN gem update --system \
    && gem install bundler \
    && bundle install --without development \
    && gem cleanup

RUN adduser -D -u 3000 app && \
    mkdir /app && \
    chown app: /app

COPY --chown=app:app --from=build /usr/local /usr/local
COPY --chown=app:app ./ /app

WORKDIR /app

USER 3000

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]