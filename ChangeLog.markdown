# jeweler 2.2.1
	* Added a patch for a potential psych problem that hit juwelier.
				
# jeweler 2.1.2, 2016-10-22
  * Merged pull requests to support breaking changes to the Bundler API (thanks julik)
  * Updated gem dependencies		
				
# jeweler 2.0.0, 2014-01-05

 * Ruby 1.8 is not supported anymore.
 * rake release accepts remote and branches #249

# jeweler 1.8.7, 2013-08-12

 * Lock timecop version to 0.6.1 to keep support of 1.8.7 #243
 * Bump version in version.rb to reflect released gem version
 * jeweler's Rakefile reads version from version.rb

# jeweler 1.8.6, 2013-07-04

 * Fix dependency error when install #239

# jeweler 1.8.5, 2013-06-29

 * Support rubygems 2.x #238

# jeweler 1.8.2, 2012-01-24

 * Fixed jeweler's circular dependency on itself #224

# jeweler 1.8.2, 2012-01-24

 * Standardize on invoking jeweler in development: bundle exec jeweler #220
 * Add travis-ci configuration and build status to README #222
 * Updated version of rspec used by generator to 2.8.0 #223

# jeweler 1.8.1, 2012-01-24

 * Generated projects using yard now use ~> 0.7.4 #219

# jeweler 1.8.0, 2012-01-23

 * Generator now has a --version flag #217
 * Generated Gemfile now includes rdoc gem when using rdoc
 * Fixed jeweler's yardoc task #216
 * Updated version of yard used for new projects, and include rdoc compatability

# jeweler 1.7.0, 2012-01-23

 * Better grammars in README!
 * Generated Rakefile no longer uses deprecated rake/rdoctask
 * Added `rake clean`
 * `rake release` calls `rake clean` to avoid packaging built gems in pkg #216

# jeweler 1.6.4, 2011-07-07

 * Generator can now take an path to generate into, rather than just the name of the directory, ie `jeweler /path/to/awesomeness', not `jeweler --directory /path/to awesomeness`. Thanks invadersmustdie! #187
 * Generator's --directory is deprecated and will be removed for 2.0.0

# jeweler 1.6.3

 * Fix typo in Rake tasks, thanks yehezkielbs! #193
 * Fix deprecation warnings for `Gem.activate`, thanks tickmichaeledgar! #191

# jeweler 1.6.2

 * Loosen bundler dependency to work with 1.x #180

# jeweler 1.6.1

 * Fix "undefined method 'sh'" when using rake 0.9.0 #181, #182, #184

# jeweler 1.6.0

 * Fix generated RCov task to exclude gems
 * Generated .gitignore includes example for rubinius and redcar
 * Generated Rakefile includes magic utf-8 comment for better UTF-8 support #20
 * Generated Jeweler::Tasks now correctly documents that dependencies are managed in the Gemfile
 * Workaround issues with ruby 1.9.2 and psych #169
 * No longer deals with `test_files` #178
 * JEWELER_OPTS are overridden by command line flags #178

# jeweler 1.5.1

 * TODO

# jeweler 1.5.0

 * TODO

# jeweler 1.4.0 2009-11-19

 * Generator now adds gemcutter support by default. Disable it with --no-gemcutter
 * Generator now creates a reek task that works with the latest reek. If you have a previously generated project using it, you may need to change the require line to: require 'reek/adapters/rake_task'
 * Generator now exits with the correct exit code
 * `rake install` no longer uses `sudo` to install. If your ruby configuration needs sudo to install, use `sudo rake install` instead.
 * `rake install` now correctly installs dependencies as well
 * `rake install` should correctly figure out which `gem` binary to invoke now
 * `rake build` now will regenerate the gemspec as well
 * `rake gemspec` now eliminates duplicates for gemspec.files, gemspec.rdoc_files, etc
 * `rake gemspec` now automatically populates gemspec.extensions with any extconf.rb files you have in `ext`
 * Releasing to Rubyforge is now deprecated in favor of Gemcutter.

# jeweler 1.3.0

 * Now supports an additional version type, build. This can be used to add a fourth segment of the version that's arbitrary. One example use is having prereleases.
 * Jeweler now lazily loads, to avoid causing side-effects when running other rake tasks
 * Version can now be set explicitly on the gemspec, rather than relying on a VERSION file
 * Rubyforge and Gemcutter support now hooks into `rake release`
 * `rake build` now uses an in-memory copy of the gemspec, rather than the filesystem persisted one
 * Rubyforge support no longer forces the uploading of documentation
 * Generator:
  * Allow arbitrary homepage and git remotes, to decouple a bit from GitHub
  * Support for the riot testing framework: http://github.com/thumblemonks/riot/
  * Support for test/spec
  * .gitignore now ignores emacs temporary files
  * rspec support now creates a spec.opts with support for color and other stuff
  * Updated minitest support (formally miniunit)
  * Improved support for autotest

# jeweler 1.2.0 2009-08-06
 * Generator now adds development dependencies appropriate to your testing framework
 * Added check_dependencies tasks for verifying gem dependencies are installed
 * Fixed typo in generated yard task
 * Fixed generator from having a lot of extra newlines

# jeweler 1.1.0 2009-08-05

 * Support for generating a project that uses yard instead of rdoc
 * Generated gemspec now includes comments about it being generated by jeweler
 * Only use sudo for installing on non-windows platforms [#1]
 * Fixed rake release to be repeatable on the same version [#16]
 * Fixed rake rubyforge:setup to not create duplicate packages
 * Use a more recent version of ruby-git
  * Fixes various issues with reading values out of ~/.gitconfig [#26] [#21] [#19]
 * Experimenting with a rake task to check development time dependencies [#22]
 * Fixed generated rdoc task to load from VERSION instead of VERSION.yml

# jeweler 1.0.2 2009-07-29

 * Don't include git ignored files for default gemspec's files and test_files
 * Fixed rspec generator to allow specs to be run directly
 * Removed misleading docstring for version_required rake task [#17]
 * Includes some notes about contributed in generated README
 * Added support for generating a project to use reek and roodi

# jeweler 1.0.1 2009-05-15

# jeweler 0.11.1

 * Lots of internal refactorings to how project generation happens
 * Fixed missing dependency on rubyforge
 * Depend on a recent version of schacon-git which works on ruby 1.9
 * Updated cucumber support for 0.3.x
 * Tested on Ruby 1.9

# jeweler 0.11.0 2009-04-05

 * generator will respect JEWELER_OPTS, as a way to provide default options
 (pat-maddox)
 * Include 'examples' and 'rails' directories by default in gemspec files
 * generated gemspec now will only include files (not directories). also, they are listed one per line, and sorted.
 * Jeweler::Tasks's intializer has been improved:
  * You can now pass it an existing gemspec (othewise a new one will be created)
  * Jeweler sets its defaults before yielding the gemspec to you. This allows you to append to its defaults, so you aren't forced to entirely overwrite them just to add one value.
 * Managing a gemspec's files, test_files, and extra_rdoc_files is now more flexible. They are now wrapped in a FileList, so you can easily 'include' or 'exclude' patterns.

# jeweler 0.10.2 2009-03-26

 * 'rake install' now will 'rake build' first
 * Support for releasing to RubyForge, thanks to jtrupiano
 * Steps towards Ruby 1.9 support, thanks to rsanheim

# jeweler 0.9.1 2009-03-05

 * Tasks:
  * Fixed populating default spec's extra_rdoc_files
  * Removed redundant gem building/installing tasks. Use rake build and rake install
 * Generator:
  * Added support for micronaut
  * Generate nicer block variable names in Rakefile
  * Cucumber generation now places steps in features/step_features, to follow cucumber standards

  * shoulda and test/unit test_helpers no longer require mocha
  * Rakefile uses more readable block variable names
  * .gitignore now includes pkg and coverage directories
  * Avoid puts'ing in Rakefile when LoadError occurs. Instead, define a task that aborts with instructions to install.
  * Cucumber is now optional. Generate stories using --cucumber
  * Bacon's 'test' task is now 'spec'
  * Generate README.rdoc instead of just a plain text README
  * Updated year in README.rdoc and COPYRIGHT to be based on the current year instead of hardcoded

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
