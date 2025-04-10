FROM ruby:3.2.2-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libsqlite3-dev \
    git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set working directory
WORKDIR /app

# Install Rails
RUN gem install rails -v 7.2.2

# Install Rails dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Create and set permissions for storage directory
RUN mkdir -p storage && \
    chmod -R 777 storage

# Add a non-root user
RUN useradd -m -u 1000 rails_user && \
    chown -R rails_user:rails_user /app
USER rails_user

# Copy the application code
COPY --chown=rails_user:rails_user . .

# Start the Rails server
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
