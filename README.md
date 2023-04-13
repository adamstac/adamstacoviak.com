# Source code for adamstacoviak.com

The source code for [adamstacoviak.com](http://adamstacoviak.com/)

## TODO

- Update the date styles on a post's show page
- Add tag support
- Fix images
- Add a link to the feed URL

## Dockerfile

The Docker image builds on [arm64v8/ruby:2.7-bullseye](https://github.com/docker-library/ruby/blob/master/2.7/bullseye/Dockerfile)

The image that gets built is "jekyll-m1".

The container name is "jekyll".

The ports that are exposed are `4000` and `35729`.

The default jekyll command that starts the app is `jekyll serve --watch --livereload --drafts --host 0.0.0.0`.