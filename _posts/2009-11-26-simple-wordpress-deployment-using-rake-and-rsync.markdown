---
author: admin
comments: false
date: 2009-11-26 20:36:51+00:00
layout: post
slug: simple-wordpress-deployment-using-rake-and-rsync
title: Simple WordPress deployment using Rake and Rsync
wordpress_id: 11
categories:
- Web
tags:
- opensource
- rake
- rsync
- wordpress
---

Like most web developers, I prefer to save time by automating repetitive tasks. For example, deploying code to production.





> 
  
> 
> Laziness is a trait of a good developer.
> 
> 






When I started to use Wordpress again, I WAS NOT excited about using FTP to ship off changes to my theme. I wanted _a simple and easy use process_ to deploy updates to my theme and also automate a few processes that I needed to support as part of using Sass and Compass to create my CSS styles.





What's the alternative? FTP? Nope. Using rsync and typing the rsync command by hand each time? Nope again.





This is a simple Rakefile I wrote that helps me to do all this in simple and concise manner.





### Features:







  * Clear and generate tasks that clear and generate new styles using [Sass](http://sass-lang.com/) and [Compass](http://compass-style.org/) CLI methods


  * A deploy task that clears the styles, generates new styles and then finally deploys the theme using Rsync




    
    <code>require "rubygems"
    require "bundler"
    Bundler.setup
    
    # Settings for Compass and rsync deployment
    css_dir               = "sass"
    theme                 = "theme-name"
    ssh_user              = "user@domain.com" # for rsync deployment
    remote_root           = "~/path/to/remote/" # for rsync deployment
    
    namespace :styles do
      
      desc "Clear the styles"
      task :clear => ["compile:clear"]
      
      desc "Compile new styles"
      task :compile => ["compile:default"]
    
      namespace :compile do
        
        task :clear do
          puts "*** Clearing styles ***"
          system "rm -Rfv #{css_dir}/*"
        end
    
        task :default => :clear do
          puts "*** Compiling styles ***"
          system "compass compile"
        end
    
        desc "Compile new styles for production"
        task :production => :clear do
          puts "*** Compiling styles ***"
          system "compass compile --output-style compressed --force"
        end
    
      end
      
    end
    
    desc "Clears and generates new styles, builds and deploys"
    task :deploy do
      puts "*** Deploying the site ***"
      system "rsync -avz --delete . #{ssh_user}:#{remote_root}/wp-content/themes/#{theme}/"
    end</code>





The entire Rakefile is 45 lines and simple to use. Besides, typing `rake deploy` is much simpler than what most WordPress users are doing to deploy updates to their theme. [Capistrano](http://www.capify.org/index.php/Capistrano) could work, but it's a bit of an over-kill for me. The simplicity of [Rsync](http://samba.anu.edu.au/rsync/) is a much better fit and works perfectly. Also, the use of the `--delete` option ensures that files that don't exist on the sending side get deleted. In a nutshell, rsync keeps it simple and easy to use.





This Rakefile is a bit opinionated and assumes you're using [Sass](http://sass-lang.com/) and [Compass](http://compass-style.org/) ... aka [The Sass Way](http://thesassway.com/).



