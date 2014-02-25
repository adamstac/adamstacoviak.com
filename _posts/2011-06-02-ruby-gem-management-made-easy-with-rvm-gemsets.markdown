---
author: admin
comments: false
date: 2011-06-02 02:57:57+00:00
layout: post
slug: ruby-gem-management-made-easy-with-rvm-gemsets
title: Ruby Gem management made easy with RVM gemsets
wordpress_id: 127
categories:
- Blog
tags:
- ruby
---

In the past I've had my fair share of issues with conflicting gems. When running `gem list` I'd have a HUGE list of gems, most with numerous versions installed. It was getting crazy. Before using RVM, my practice had been to just install gems. I wouldn't even worry if the version I was installing would cause another project to have a conflict, I couldn't. This practice would eventually create a mess and often lead to gem conflicts when versions or project dependencies changed. PITA!

### Hello RVM

[RVM](https://rvm.beginrescueend.com/) is a tool that makes it super easy to install, manage and work with multiple versions of Ruby, interpreters and sets of gems. For example, with RVM you can have 1.8.7 and 1.9.2 live together without any issues. You can even swap back and forth from 1.8.7 to 1.9.2 as you see fit.

### RVM Gemsets using .rvmrc

RVM's gemset feature allows you to completely separate your various development environments on a per project basis. This makes gem conflicts a lot less common and makes it very easy to get a handle on the gem dependencies of your project.

To take advantage of RVM's gemset feature in your project, all you need to do (besides having RVM installed) is add an `.rvmrc` file to the root of your project and set the ruby and gemset.

[Here's an example](https://github.com/adamstac/sinatra-bootstrap/blob/master/.rvmrc):

    rvm use ruby-1.9.2@sinatra-bootstrap

When you navigate into the project for the first time after adding the `.rvmrc` file you will get a notice to trust the file. Trusting the file means that whenever you `cd` into this directory, RVM will run this .rvmrc script in your shell. This is a good thing because we can use this to tell RVM to use a specific Ruby and gemset for this project. We can also check it into the project's repo so that everyone using the project can have the same setup.

So for all new projects you can start checking in an `.rvmrc` file to make your life, and the developers working with your code, much easier!

### Examples in practice





When you first start out, your gemset will be empty except for a copy of Rake. If you want to test this out run `gem list` to see what's in your gemset. Also, an important note to make is that RVM doesn't create the gemset for you, it just tries to use it upon execution of the `.rvmrc` file. You'll need to create the gemset in the Ruby you want to use in order to use it.





For example, if our `.rvmrc` file was set to use `ruby-1.9.2` and the gemset `rvmrc-test` but the gemset wasn't created, we'd get an error like this:





    <code>ERROR: Gemset 'rvmrc-test' does not exist, rvm gemset create 'rvmrc-test' first.
    </code>





We'd need to run this command first before we can use our new gemset.





    <code>rvm gemset create rvmrc-test
    </code>





If you run this command, RVM will create the new `rvmrc-test` gemset and it should also show that you are now using `ruby-1.9.2@rvmrc-test`. Now you're in gear to use your new gemset and add the gems you need for your project without any concern of conflicting with another project's gems.





It should also be known that what I covered here in this post is listed in the [RVM Best Practices](http://beginrescueend.com/rvm/best-practices/).



