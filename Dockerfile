FROM ruby:2.7.4 as base

RUN apt-get update -qq && apt-get install -y curl gnupg2
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y build-essential apt-utils libpq-dev nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

WORKDIR /docker/app
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN bundle exec rake assets:precompile


