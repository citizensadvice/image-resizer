FROM ruby:2.7.2-alpine AS final

ENV SYSTEM="bash"
ENV DEPENDENCIES \
	build-base \
	vips \
 	vips-dev \
 	imagemagick \
 	tiff-tools

RUN apk --no-cache add $SYSTEM $DEPENDENCIES
RUN gem install bundler

ENV LANG=C.UTF-8

############################################################

FROM final

WORKDIR /app

COPY Gemfile* /app/
RUN bundle config mirror.https://rubygems.org https://nexus.devops.citizensadvice.org.uk/repository/rubygems-proxy \
    && bundle config mirror.https://rubygems.org.fallback_timeout 1 \
    && bundle config set path "vendor/bundle" \
    && bundle config set jobs 6 \
    && bundle install --full-index

COPY . /app/

EXPOSE 4567

# Add user
RUN addgroup ruby -g 3000 \
    && adduser -D -h /home/ruby -u 3000 -G ruby ruby

USER ruby

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]