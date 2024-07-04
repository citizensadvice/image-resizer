FROM ruby:3.3.3-alpine3.20 as builder

ENV LANG C.UTF-8
WORKDIR /app

RUN apk update \
 && apk upgrade \
 && apk --no-cache add build-base git imagemagick tiff-tools

COPY Gemfile* /app/

RUN gem install bundler \
 && bundle install \
 && rm -rf /usr/local/bundle/*/*/cache \
 && find /usr/local/bundle -name "*.c" -delete \
 && find /usr/local/bundle -name "*.o" -delete

#################################################

FROM ruby:3.3.3-alpine3.20

WORKDIR /app
ENV RACK_ENV=production

RUN apk update \
 && apk upgrade \
 && apk --no-cache add imagemagick tiff-tools file gcompat

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY . /app/

RUN addgroup ruby -g 3000 \
 && adduser -D -h /home/ruby -u 3000 -G ruby ruby

USER ruby

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "-p", "4567"]
