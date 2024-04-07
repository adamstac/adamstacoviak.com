# Use a build argument to specify architecture
ARG ARCH=arm64v8

# Use the official Ruby image, dynamically selecting the architecture
FROM ${ARCH}/ruby:3.0-bullseye as builder

# Set the working directory
WORKDIR /usr/src/app

# Update package list, install necessary dependencies for Jekyll, and clean up in one run to reduce image size
RUN apt-get update -qq && \
    apt-get install -y build-essential libxml2-dev libxslt1-dev tzdata nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set the timezone to US Central
ENV TZ="America/Chicago"

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile ./

# Install bundler and gems specified in Gemfile
# Specify bundler version if needed, e.g., RUN gem install bundler -v 2.2.16
RUN gem install bundler && bundle install

# Copy the rest of the application code into the working directory
COPY . .

# The final base image
FROM ${ARCH}/ruby:3.0-bullseye

# Copy artifacts from the builder stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /usr/src/app /usr/src/app

WORKDIR /usr/src/app

# Set the entrypoint for Jekyll
ENTRYPOINT ["bundle", "exec", "jekyll"]
