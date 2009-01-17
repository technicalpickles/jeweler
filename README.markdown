# Jeweler: Craft the perfect RubyGem

Jeweler provides two things:

 * Rake tasks for managing gems and versioning of a <a href="http://github.com">GitHub</a> project
 * A generator for creating kickstarting a new project

## Setting up in an existing project

It's easy to get up and running. Update your instantiate a `Jeweler::Tasks`, and give it a block with details about your project.


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

In this example, `s` is a Gem::Specification object. See the documentation for what possible values you can set on it. 

## Kicking off a new project

Jeweler provides a generator. It depends on you setting up [local github configuration](http://github.com/blog/180-local-github-config).

    jeweler the-perfect-gem

This will prepare a project in the 'the-perfect-gem' directory, setup to use Jeweler.

It supports a number of options:

 * --create-repo: in addition to preparing a project, it create an repo up on GitHub and enable RubyGem generation
 * --shoulda: generate test_helper.rb and empty test ready for shoulda (this is the default)
 * --bacon: generate spec_helper.rb and empty spec ready for bacon

## Gemspec

Jeweler handles generating a gemspec file for your project:

    rake gemspec

This creates a gemspec for your project. It's based on the info you give `Jeweler::Tasks`, the current version of your project, and some defaults that Jeweler provides.

## Gem

Jeweler gives you tasks for building and installing your gem:

    rake build
    rake install

## Versioning

Jeweler tracks the version of your project. It assumes you will be using a version in the format `x.y.z`. `x` is the 'major' version, `y` is the 'minor' version, and `z` is the patch version.

Initially, your project starts out at 0.0.0. Jeweler provides Rake tasks for bumping the version:

    rake version:bump:major
    rake version:bump:minor
    rake version:bump:patch

## Releasing

Jeweler handles releasing your gem into the wild:

    rake release

It does the following for you:

 * Regenerate the gemspec to the latest version of your project
 * Push to GitHub (which results in a gem being build)
 * Tag the version and push to GitHub

## Workflow

 * Hack, commit, hack, commit, etc, etc
 * `rake version:bump:patch release` to do the actual version bump and release
 * Have a delicious scotch
 * Go to [Has My Gem Built Yet](http://hasmygembuiltyet.org) and wait for your gem to be built

## Links

 * [Bugs](http://technicalpickles.lighthouseapp.com/projects/23560-jeweler/overview)
 * [Donate](http://pledgie.org/campaigns/2604)
