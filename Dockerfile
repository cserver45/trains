# The "builder" image will build nokogiri
FROM ruby:3.2-alpine AS builder

# Nokogiri's build dependencies
RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev

COPY Gemfile Gemfile

RUN bundle install

# The final image: we start clean
FROM ruby:3.2-alpine

# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

WORKDIR /app

COPY . .

RUN groupadd -g 10001 trains && \
   useradd -u 10000 -g trains trains \
   && chown -R trains:trains /app

USER trains:trains

CMD ruby main.rb

VOLUME ["/app/config"]