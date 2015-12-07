require 'rubygems'
require 'bundler'
Bundler.setup

namespace :sass do

  desc "Watch Sass"
  task :watch do
    puts "*** Watching Sass ***"
    system 'compass watch'
  end

  desc "Compile Sass for production"
  task :prod do
    puts "*** Compiling Sass ***"
    system 'compass clean'
    system 'compass compile --output-style compressed --force'
  end

end

desc "Compile Sass"
task :sass => 'sass:watch'

desc "Deploy!"
task :deploy do
  system "rsync -arvuz --rsync-path='sudo rsync' --delete _site/ adamstac@static:/var/www/adamstacoviak.com/html"
end
