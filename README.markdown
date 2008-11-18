# Jeweler: Let us craft you the perfect gem

Rubygems are the awesome way of distributing your code to others. GitHub is the awesome way of managing the source code of your project. GitHub can even generate a Rubygem if you include a gemspec.

Trouble is when developing your Rubygems on GitHub, you generally do one of the following:

 * Manage the gemspec by hand
  * ... why bother doing something by hand when you can automate it?
 * Write your own Rake stuff to create the Gem::Specification and output it to a gemspec file, and deal with keeping the Rakefile and gemspec in sync
  * ... why keep reinventing the wheel?
 * Use hoe or echoe for generating the gemspec
  * ... why use utilities made for the days before GitHub existed?
  * ... why have extra stuff you aren't going to use?

Jeweler was created with a few goals in mind:

 * Only use a Gem::Specification as configuration
 * Be one command away from version bumping and releasing
 * Store version information in one place
 * Only concern itself with git, gems, and versioning
 * Not be a requirement for using your Rakefile (you just wouldn't be able to use its tasks)
 * Use Jeweler internally. Oh the meta!

## Installation

Run the following if you haven't already:

    gem sources -a http://gems.github.com

Install the gem:

    sudo gem install technicalpickles-jeweler

## Configuration for an existing project

Armed with the gem, we can begin diving into an example. [the-perfect-gem](http://github.com/technicalpickles/the-perfect-gem/tree) was setup as a Jeweler showcase, and a simple example:

    begin
      require 'jeweler'
      Jeweler::Tasks.new do |s|
        s.name = "the-perfect-gem"
        s.summary = "TODO"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/the-perfect-gem"
        s.description = "TODO"
        s.authors = ["Josh Nichols"]
      end
    rescue LoadError
      puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
    end

Here's a rundown of what's happening:

 * Wrap everything in a begin block, and rescue from LoadError
  * This lets us degrade gracefully if jeweler isn't installed
 * Make a new `Jeweler::Tasks`
   * It gets yielded a new `Gem::Specification`
   * This is where all the configuration happens
    * Things you definitely need to specify:
      * `name`
    * Things you probably want to specify:
      * `summary`
      * `email`
      * `homepage`
      * `description`
      * `authors`
    * Things you can specify, but have defaults
     * `files`, defaults to `FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]`
    * Things you shouldn't specify:
     * `version`, because Jeweler takes care of this for you
    * Other things of interest
     * `executables`, if you have any scripts
     * `add_dependency`, if you have any dependencies
    * Keep in mind that this is a `Gem::Specification`, so you can do whatever you would need to do to get your gem in shape

## Bootstrap a new project

Before proceeding, take a minute to setup your git environment, specifically your name and email address:

    $ git config --global user.email johndoe@example.com
    $ git config --global user.name 'John Doe'

Jeweler provides a generator of sorts, `jeweler`. It takes two arguments: your GitHub username and a repository name.

    $ jeweler technicalpickles the-perfect-gem

Basically, this does:

 * Creates the the-perfect-gem directory
 * Seeds it with some basic files:
  * `.gitignore`, with the usual suspects predefined
  * `Rakefile`, setup with tasks for jeweler, test, rdoc, and rcov
  * `README`, with your project name
  * `LICENSE`, MIT, with your name prefilled
  * `test/test_helper`, setup with shoulda, mocha, and a re-opened `Test::Unit::TestCase`
  * `test/the_perfect_gem.rb`, placeholder failing test
  * `lib/the_perfect_gem.rb`, placeholder library file
 * Makes it a git repo
 * Sets up `git@github.com:technicalpickles/jeweler.git` as the `origin` git remote
 * Makes an initial commit, but does not push

At this point, you probably should create a repository by wandering to [http://github.com/repositories/new](http://github.com/repositories/new). Be sure to use the same project name you told Jeweler.

With the repository firmly created, just push it:

    $ git push origin master

You also probably should [enable RubyGem creation for you repository](http://github.com/blog/51-github-s-rubygem-server): Go to your project's edit page and check the 'RubyGem' box.

## Overview of Jeweler workflow

Here's the general idea:

 * Hack, commit, hack, commit, etc, etc
 * Version bump
 * Release
 * Have a delicious scotch

The hacking and the scotch are up to you, but Jeweler provides rake tasks for the rest.

### Versioning

Versioning information is stored in `VERSION.yml`. It's a plain ol' YAML file which contains three things:

 * major
 * minor
 * patch

Consider, for a second, `1.5.3`.

 * major = 1
 * minor = 5
 * patch = 3

#### Your first time

When you first start using Jeweler, there won't be a `VERSION.yml`, so it'll assume 0.0.0.

If you need some arbitrary version, you can do one of the following:

 * `rake version:write MAJOR=6 MINOR=0 PATCH=3`
 * Write `VERSION.yml` by hand (lame)


#### After that

You have a few rake tasks for doing the version bump:

    $ rake version:bump:patch # 1.5.1 -> 1.5.2
    $ rake version:bump:minor # 1.5.1 -> 1.6.0
    $ rake version:bump:major # 1.5.1 -> 2.0.0

If you need to do an arbitrary bump, use the same task you used to create `VERSION.yml`:

    $ rake version:write MAJOR=6 MINOR=0 PATCH=3

The process of version bumping does a commit to your repo, so make sure your repo is in a clean state (ie nothing uncommitted).

### Release it

It's pretty straight forward:

    $ rake release

This takes care of:

 * Generating a `.gemspec` for you project, with the version you just bumped to
 * Commit and push the updated `.gemspec`
 * Create a tag
 * Push the tag

### Play the waiting game

How do you know when your gem is built? [Has My Gem Built Yet](http://hasmygembuiltyet.org/) was specifically designed to answer that question.

If it happens to be down, you can also check out the GitHub Gem repo's [list](http://gems.github.com/list). Just search for youname-yourrepo.s

### Putting it all together

    <hack, hack, hack, commit>
    $ rake version:bump:patch release

Now browse to http://gems.github.com/yourname/yourproject, and wait for it to be built.
