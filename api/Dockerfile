FROM ruby:2.5.7
EXPOSE 3000

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /api

COPY . /api

RUN gem install bundler && gem install rails

COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

ENV BUNDLE_PATH /bun

CMD ./start-dev.sh
