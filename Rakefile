require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

$:.unshift('lib')

begin
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

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Jeweler'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => :rcov
