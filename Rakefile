require 'rake'
require 'rake/testtask'
begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

require 'rcov/rcovtask'

$:.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "jeweler"
    s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    s.email = "josh@technicalpickles.com"
    s.homepage = "http://github.com/technicalpickles/jeweler"
    s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    s.authors = ["Josh Nichols"]
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*", 'lib/jeweler/templates/.gitignore']
    s.add_dependency 'schacon-git'
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


Rake::TestTask.new 

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'jeweler'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new 

task :default => :rcov
