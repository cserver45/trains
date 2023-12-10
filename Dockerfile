# The "builder" image will build nokogiri
FROM ruby:3.2-alpine AS builder

# Nokogiri's build dependencies
RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev

RUN echo 'source "https://rubygems.org"; gem "nokogiri"' > Gemfile

RUN bundle install

# The final image: we start clean
FROM ruby:3.2-alpine

# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

WORKDIR /app

COPY . .

CMD ruby main.rb

VOLUME ["/app/config"]