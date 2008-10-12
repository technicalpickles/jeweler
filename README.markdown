# Create a directory and git repo

    $ mkdir jeweler
    $ git init

# Create a Rakefile:

    require 'rake'
    require 'jeweler'

    Jeweler.gemspec = Gem::Specification.new do |s|
      s.name = "jeweler"
      s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.email = "josh@technicalpickles.com"
      s.homepage = "http://github.com/technicalpickles/jeweler"
      s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.authors = ["Josh Nichols"]
      s.files = FileList["[A-Z]*"]
    end
    
Note, we don't include 'date', or 'version'. Jeweler takes care of that.

Jeweler assumes you'll have either a class or module similar to your spec's name. This value gets camelized, so...

Good:

 * safety\_valve -> SafetyValve
 * clearance -> Clearance

Bad:

 * shoulda-generator -> Shoulda-generator (not valid!)
 * ruby-debug -> Ruby-debug (not valid!)

We're opinionated and lazy.

# Create a version file

Stick it in `lib/(spec_name_here)/version.rb`, and start it out at some version, like 0.0.0:

    class Jeweler
      module Version
        MAJOR = 0
        MINOR = 0
        PATCH = 0
      end
    end

OR

    module Jeweler
      module Version
        MAJOR = 0
        MINOR = 0
        PATCH = 0
      end
    end

Which you use depends on how you want to organize your gem. If you have a top-level class, like Jeweler, use the first. If you have a top level module, like Clearance, use the latter.

# Generate the first gemspec

    $ rake gemspec

# Commit it

    $ git add .
    $ git commit -a -m "First commit yo"
    
# Make a github repository

Wander to http://github.com/repositories/new and follow the instructions to get it pushed

# Enable Rubygem building on the repository

Go to your project's edit page and check the 'RubyGem' box.

# Go do something awesome

I'll let you figure that out

# Bump the version

You have a few rake tasks for automating the version bumping:

    $ rake version:bump:patch
    $ rake version:bump:minor
    $ rake version:bump:major
    
This will automatically regenerate your gemspec.

Just commit and push it afterwards:

    $ git commit -a -m "Version bump yo"
    $ git push origin master