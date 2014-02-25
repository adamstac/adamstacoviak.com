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
