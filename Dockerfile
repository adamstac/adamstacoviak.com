# Use the official Ruby image built for ARM64 architecture
# Source: https://hub.docker.com/r/arm64v8/ruby/
FROM arm64v8/ruby:3.0-bullseye

# Set the working directory
WORKDIR /usr/src/app

# Update package list and install necessary dependencies for Jekyll
RUN apt-get update -qq && \
    apt-get install -y build-essential \
    libxml2-dev \
    libxslt1-dev \
    tzdata

# Set the timezone to US Central
ENV TZ="America/Chicago"

# Install Node.js (if needed, uncomment the following line)
# RUN apt-get install -y nodejs

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile* ./

# Install bundler and install the gems specified in Gemfile
RUN gem install bundler && \
    bundle install

# Copy the rest of the application code into the working directory
COPY . .

# Set the entrypoint for Jekyll
ENTRYPOINT ["bundle", "exec", "jekyll"]
