# Use version of Ruby 2.2.5
FROM ruby:2.3.3

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Longport TECH <admin@longportaviation.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -qq -y build-essential nodejs cron

# ENV RAILS_ENV production
ENV RAILS_ENV development

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /test_tecnical
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# RUN bundle install --without development test
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Execute migrates
RUN bundle exec rake db:migrate

# Provide dummy data to Rails so it can pre-compile assets.
# RUN bundle exec rake assets:precompile

# The default command that gets ran will be to start the Unicorn server.
# RUN bundle exec whenever --update-crontab
# CMD cron && bundle exec puma -C config/puma.rb
CMD bundle exec puma -C config/puma.rb
