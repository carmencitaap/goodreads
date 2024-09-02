FROM ruby:2.7.4 as base

# Install system dependencies
RUN apt-get update -qq && apt-get install -y curl gnupg2 build-essential apt-utils libpq-dev nodejs

# Install Node.js and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -y yarn

# Set the working directory
WORKDIR /docker/app

# Copy Gemfile and Gemfile.lock
COPY Gemfile* ./

# Install Gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Cleanup (optional)
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose port 3000 to the outside world
EXPOSE 3000

# Default command (this might be overridden by docker-compose)
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"]
