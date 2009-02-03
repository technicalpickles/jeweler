# jeweler 0.8.0

 * Generator:
  * Supports these new testing frameworks:
   * test/unit
   * minitest
   * rspec
  * Added support for cucumber
  * Creating a new gem is now more verbose, and will show files/directories created
 * Binaries will now be automatically detected in 'bin'
  
# jeweler 0.7.2

 * Added rake task 'version:bump' which is shorthand for 'version:bump:patch'
 * Generated projects no longer assume RCov is installed.

# jeweler 0.7.1

 * Fixed yaml not being required

# jeweler 0.7.0

 * Added support to generator for specifying a description
 * Condensed README.markdown to be less novel-like
 * RDoc is now included in your gemspec
 * Rescue errors that raise in the generator, and display better error message, and exit with a non-zero exit status

# jeweler 0.6.5

 * `jeweler --create-repo foo` now enables gem creation in addition to creating the repository

# jeweler 0.6.4

 * Added tasks `build` and `install` as shortcuts for `gem:build` and `gem:install`
