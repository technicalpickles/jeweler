require 'rake'

$LOAD_PATH.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jeweler"
    gem.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    gem.email = "josh@technicalpickles.com"
    gem.homepage = "http://github.com/technicalpickles/jeweler"
    gem.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    gem.authors = ["Josh Nichols"]
    gem.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*", 'lib/jeweler/templates/.gitignore']
    gem.add_dependency 'peterwald-git'
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/test_*.rb'
  test.libs << 'test'
  test.verbose = true
  test.ruby_opts << '-rtest_helper'
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'jeweler'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new(:rcov) do |rcov|
    rcov.libs << 'test'
    rcov.pattern = 'test/**/test_*.rb'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

if ENV["RUN_CODE_RUN"] == "true"
  task :default => [:test, :features]
else
  task :default => :test
end
