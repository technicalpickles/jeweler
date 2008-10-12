# Jeweler: Let us craft you the perfect gem

Rubygems are the awesome way of distributing your code to others. GitHub is the awesome way of managing the source code of your project. GitHub can even generate a Rubygem if you include a gemspec.

Trouble is when developing your Rubygems on GitHub, you generally do one of the following:

 * Manage the gemspec by hand
  * ... why bother doing something by hand when you can automate it?
 * Write your own rake stuff to manage the gemspec, and deal with managing the version somehow
  * ... why keep reinventing the wheel?
 * use hoe or echoe for generating the gemspec
  * ... why use utilities made for the days before GitHub existed?
  * ... why have extra stuff you aren't going to use?
 
Jeweler was created with some simple goals:

 * The only configuration should be providing a Gem::Specification to Jeweler
 * Version bumping should only be one command away
 * Authoritative version information should stored in one place, a Version module in your project
 * Jeweler should only concern itself with versioning and gems (and one day, git)
 * Your Rakefile should be usable when Jeweler isn't installed (you just wouldn't be able to version bump or generate a gemspec)
 * Jeweler should use Jeweler. Oh the meta!
 
## Use Jeweler in a new project

We'll use Jeweler as an example for creating a new project.

### Install it

Run the following if you haven't already:

    gem sources -a http://gems.github.com

Install the gem:

    sudo gem install technicalpickles-jeweler

### Create a directory and git repo

    $ mkdir jeweler
    $ cd jeweler
    $ git init

### Create a Rakefile:

    require 'rake'
    
    begin
      require 'rubygems'
      require 'jeweler'
      Jeweler.gemspec = Gem::Specification.new do |s|
        s.name = "jeweler"
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
    rescue LoadError
      puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
    end

Note, we don't include 'date', or 'version'. Jeweler handles filing these in when it needs them.

If you don't specify `s.files`, it will use `s.files = FileList["[A-Z]*", "{generators,lib,test,spec}/**/*"]`.

For now, `s.name` should be lower-cased and underscored, without hyphens. That's because Jeweler camelizes and constantizes this value internally. For example, `ruby-debug` would be camelized/constanized to `Ruby-debug`, which isn't a valid constant. Use `ruby_debug` instead (for now).

### Create a version file

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

Which you use depends on how you want to organize your gem. If you have a top-level class, like Jeweler, use the first. If you have a top level module, like ActiveRecord, use the latter.

### Generate the gemspec

    $ rake gemspec
    
This also validates that the gemspec should work on GitHub.

### Commit it already

    $ git add .
    $ git commit -a -m "First commit, yo."
    
### Make a github repository

Wander to http://github.com/repositories/new and follow the instructions to get it pushed.

### Enable RubyGem building on the repository

Go to your project's edit page and check the 'RubyGem' box.

### Implement something awesome

I'll let you figure that out on your own.

### Bump the version

You have a few rake tasks for doing the version bump:

    $ rake version:bump:patch # 1.5.1 -> 1.5.2
    $ rake version:bump:minor # 1.5.1 -> 1.6.0
    $ rake version:bump:major # 1.5.1 -> 2.0.0

After that, commit and push it:

    $ git commit -a -m "Version bump, yo."
    $ git push origin master

### Play the waiting game

Wander over to [Has My Gem Built Yet](http://hasmygembuiltyet.org/) to play the waiting game.

## Extra stuff you might want to for your RubyGem project

As was mentioned, Jeweler tries to only do versioning and gem stuff. Most projects have a few other needs:

 * Testing
 * RDoc
 * Default task

Jeweler doesn't provide these. But it's easy enough to use Rake's built in tasks:

    require 'rake'
    require 'rake/testtask'
    require 'rake/rdoctask'

    begin
      require 'rubygems'
      require 'jeweler'
      Jeweler.gemspec = Gem::Specification.new do |s|
        s.name = "jeweler"
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
    rescue LoadError
      puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
    end

    Rake::TestTask.new do |t|
      t.libs << 'lib'
      t.pattern = 'test/**/*_test.rb'
      t.verbose = false
    end

    desc 'Generate documentation for the safety_valve plugin.'
    Rake::RDocTask.new(:rdoc) do |rdoc|
      rdoc.rdoc_dir = 'rdoc'
      rdoc.title    = 'Jeweler'
      rdoc.options << '--line-numbers' << '--inline-source'
      rdoc.rdoc_files.include('README.*')
      rdoc.rdoc_files.include('lib/**/*.rb')
    end

    desc "Run the test suite"
    task :default => :test
