FROM ruby:2.3.3

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential netcat nodejs libpq-dev
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /usr/src/classroom
WORKDIR /usr/src/classroom

COPY Gemfile /usr/src/classroom/
COPY Gemfile.lock /usr/src/classroom/
RUN bundle install --binstubs

COPY . /usr/src/classroom
