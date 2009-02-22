# jeweler x.y.z

 * Cucumber is now optional. Generate stories using --cucumber
 * Avoid puts'ing in Rakefile when LoadError occurs. Instead, define a task
 that aborts with instructions to install.
 * Rakefile uses more readable block variable names
 * .gitignore now includes pkg and coverage directories
 * Updated year to 2009
 * shoulda and test/unit test_helpers no longers require mocha 
 * Refactored how the generator is invoked, to make it easier to test

# jeweler 0.8.1 2009-02-03

 * Fixed minitest generator

# jeweler 0.8.0 2009-02-03

 * Generator:
  * Supports these new testing frameworks:
   * test/unit
   * minitest
   * rspec
  * Added support for cucumber
  * Creating a new gem is now more verbose, and will show files/directories created
 * Binaries will now be automatically detected in 'bin'
  
# jeweler 0.7.2 2009-01-29

 * Added rake task 'version:bump' which is shorthand for 'version:bump:patch'
 * Generated projects no longer assume RCov is installed.

# jeweler 0.7.1 2009-01-26

 * Fixed yaml not being required
 * Automatically add files in bin as executables in gemspec

# jeweler 0.7.0 2009-01-19

 * Added support to generator for specifying a description
 * Condensed README.markdown to be less novel-like
 * RDoc is now included in your gemspec
 * Rescue errors that raise in the generator, and display better error message, and exit with a non-zero exit status

# jeweler 0.6.5 2009-01-14

 * `jeweler --create-repo foo` now enables gem creation in addition to creating the repository

# jeweler 0.6.4 2009-01-13

 * Added tasks `build` and `install` as shortcuts for `gem:build` and `gem:install`
