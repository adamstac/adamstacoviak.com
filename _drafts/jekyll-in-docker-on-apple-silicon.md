---
layout: post
title: Jekyll in Docker on Apple Silicon
type: post
slug: jekyll-in-docker-on-apple-silicon
date: 2023-03-27 22:52:00
---

After years and years (and years) of failing to blog consistently, I have concluded that **ONE of many reasons** is due to the need to maintain a local development environment for running Jekyll.

Maintaining a local development environment for Jekyll means managing Ruby versions, Ruby Gems, and all the local dependencies that come with it. If you're not activley maintaing this applicaiton (your blog) it can quickly become quite a loborius task.

Then there's the issue of different projects having different Ruby dependencies. In the past I used [rvm](https://rvm.io/) to manage Ruby versions, then in more recent years I used [rbenv](https://github.com/rbenv/rbenv). Over time I would forget which version(s) of Ruby I had installed and natually I'd have to consult the docs of either of those projects to recall how to manage Ruby.

Then there's the obvious Ruby Gems namespace collisions that would happen. This project requires that version, and that project requires this version. RVM offers compartmentalized independent ruby setups which separates (and self-contains) ruby, gems, and irb. But again, over time I would forget how things were setup and it was simply just to painful.

Docker simplifies all of this.

## Jekyll + Docker

Given the challenge of maintaining a local development environment and all that comes with that, running Jekyll in a Docker container truly simplifies things and makes the project platform agnostic. If I get a new machine, I can simply add Docker suppport to my new machine, clone the project, and run `docker compose up`.

The best way to run Jekyll in a local dev environment on Mac with Apple Silicon is inside a Docker container. But, the official Jekyll Docker image is not ARM64 friendly.

In this post we're going to define a Dockerfile to build our own image to run our development container. This requires a `Dockerfile` and a `docker-compose.yml` file to make running our application a more simplfied command. We could use `docker run`, but we'd have to remember several variables that are better left to Docker Compose to manage.

Running Jekyll in Docker on Apple Silicon has several benefits:

---

### Consistency
Docker provides a consistent environment for running Jekyll across different plaforms, including Apple Silicon. It ensures that dependencies, configurations, and runtime en ronments are the same, which helps eliminate discrepancies between development, testing, an production.

### Isolation

Docker containers run in isolation, which means they do not interfere with ot r applications or system settings on your Apple Silicon machine. This reduces the risk of co licts and makes it easier to manage multiple projects with different dependencies and co igurations.

### Portability

Docker images can be easily shared and run on any platform with Docker su ort, including Apple Silicon. This makes it simple to collaborate with team members who ma have different development environments, and it enables you to deploy your Jekyll site to va ous hosting providers that support Docker.

### Version control

Docker allows you to specify and manage different versions of de ndencies and configurations, which helps maintain a consistent environment throughout the de lopment lifecycle. This can be especially helpful when working with Jekyll, as you can ensure that your project runs on a specific version of Ruby or any other dependency.

### Performance

Docker for Apple Silicon leverages the native performance and efficiency of the ARM64 architecture, resulting in faster build times and improved resource utilization compared to running Jekyll in an emulated environment (such as Rosetta 2).

### Easier setup

Using Docker to run Jekyll on Apple Silicon simplifies the setup process. Developers do not need to manually install Ruby, Jekyll, and other dependencies on their machines, as the container handles everything. This reduces the time and effort required to get started with a Jekyll project.

Overall, running Jekyll in Docker on Apple Silicon streamlines the development process, improves consistency and portability, and takes advantage of the native performance benefits of the ARM64 architecture.

## Dockerfile

I'll explain each line of the `Dockerfile` you provided:

1. `FROM arm64v8/ruby:2.7`: This line specifies the base image for your Docker container. In th  case, it's using the official Ruby 2.7 image built for ARM64 architecture.
2. `WORKDIR /usr/src/app`: This line sets the working directory for the container to `/usr/sr app`. All the subsequent commands in the Dockerfile will be executed relative to this di ctory.
3. `RUN apt-get update -qq && \`: This line updates the package list for the container's pa age manager in a quiet mode (without displaying progress).
4. `apt-get install -y build-essential \`: This line installs necessary build tools and li aries required to compile and build software.
5. `libxml2-dev \`: This line installs the development files for the libxml2 library, which is sed for XML parsing.
6. `libxslt1-dev \`: This line installs the development files for the libxslt library, which is sed for XSLT processing.
7. `nodejs`: This line installs Node.js, which might be required for some Jekyll plugins or ot r JavaScript-related tasks.
8. `COPY Gemfile* ./`: This line copies the Gemfile and Gemfile.lock (if present) from the host machine to the container's working directory.
9. RUN gem install bundler && \`: This line installs the Bundler gem, which is a dependency ma er for Ruby applications.
10 `bundle install`: This line installs the gems specified in the Gemfile using Bundler.
11 `COPY . .`: This line copies the rest of the application code from the host machine to th ontainer's working directory.
12 `EXPOSE 4000`: This line exposes port 4000, which is the default port Jekyll uses to serve the site.
13. `ENTRYPOINT ["bundle", "exec", "jekyll"]`: This line sets the entrypoint for the container. When the container is run, it will execute the command `bundle exec jekyll`, which runs Jekyll using the bundled gems.

This Dockerfile sets up a Ruby environment with Jekyll and its dependencies, and prepares your application for building and serving using Jekyll.

```docker
# Use the official Ruby image built for ARM64 architecture
FROM arm64v8/ruby:2.7-bullseye

# Set the working directory
WORKDIR /usr/src/app

# Update package list and install necessary dependencies for Jekyll
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libxml2-dev \
                       libxslt1-dev

# Install Node.js
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
```

## docker-compose.yml file

```yml
version: '3.8'

services:
  jekyll:
    container_name: jekyll
    build: .
    image: jekyll-m1
    ports:
      - "4000:4000"
      - "35729:35729"
    volumes:
      - .:/usr/src/app
    command: serve --watch --livereload --drafts --host 0.0.0.0
```

## Gemfile

This is a `Gemfile` that lists out the gems required for a Jekyll website or application. Here's what it does:

- The first line sets the source of the gems to the RubyGems repository.    
- The second line specifies the version of Jekyll to be installed. In this case, it's `4.2`, and the `~>` symbol indicates that only minor version updates are allowed (e.g. `4.3`, `4.4`, etc.), but not major version updates (e.g. `5.x`).
- The rest of the gems are listed inside a `group` block, which is used to group gems that are only required in certain environments or configurations. In this case, all of the gems are part of the `:jekyll_plugins` group, which indicates that they are plugins for the Jekyll static site generator.

The gems listed inside the `:jekyll_plugins` group are:
    
- `jekyll-sitemap` - a Jekyll plugin that generates a sitemap.xml file for your website.
- `jekyll-feed` - a Jekyll plugin that generates an RSS feed for your website.
- `jekyll-seo-tag` - a Jekyll plugin that generates meta tags for search engine o mization (SEO).
- `jekyll-assets` - a Jekyll plugin that provides asset management features such as c atenation, compression, and fingerprinting.
- `jekyll-compose` - a Jekyll plugin that provides additional commands to simplify the a oring experience.
- `jekyll-paginate` - a Jekyll plugin that provides pagination features for your website.

By including these plugins in the `Gemfile`, they will be automatically installed and available for use when running Jekyll commands.

```ruby
# List Gems in alpha order
source 'https://rubygems.org'

gem 'jekyll', '~> 4.2'

group :jekyll_plugins do
  gem 'jekyll-sitemap'
  gem 'jekyll-feed'
  gem 'jekyll-seo-tag'
    gem 'jekyll-assets'
    gem 'jekyll-compose'
    gem 'jekyll-paginate'
end
```

## Create an alias for jekyll

To create an alias called `jekyll` that aliases to `docker-compose exec jekyll bundle exec jekyll` in your Zsh shell on macOS, add the following line to your `~/.zshrc` file:

```zsh
alias jekyll='docker-compose exec jekyll bundle exec jekyll'
```

This will define an alias for the `jekyll` command that will execute the specified Docker command. After adding this line to your `~/.zshrc` file, you can either restart your terminal or run the following command to apply the changes immediately:

```shell
source ~/.zshrc
```

Now you should be able to run `jekyll` in your terminal, and it will execute the Docker command `docker-compose exec jekyll bundle exec jekyll`.

## Deploy with Fly.io

Install `flyctl` on macOS

```shell
brew install flyctl
```