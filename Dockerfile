FROM ruby:3.2.2-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git cron nano

COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 3008

ADD . /app

RUN touch /var/log/cron_log.log
RUN bundle exec whenever --update-crontab
# RUN service cron restart
# * * * * * /bin/bash -l -c 'cd /app && bundle exec rake test:write_to_file'

CMD service cron start && bundle exec ruby start.rb
