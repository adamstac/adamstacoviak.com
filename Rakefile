require 'rubygems'
require 'bundler'
Bundler.setup

desc "Run the jekyll server"
task :server do
  system "jekyll serve"
end

desc "Deploy!"
task :deploy do
  system "rsync -arvuz --delete _site/ adamstac@static:/var/www/adamstacoviak.com/html"
end
