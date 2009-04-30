require 'rake'

$LOAD_PATH.unshift('lib')

gem 'schacon-git'
require 'git'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jeweler"
    gem.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    gem.email = "josh@technicalpickles.com"
    gem.homepage = "http://github.com/technicalpickles/jeweler"
    gem.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
    gem.authors = ["Josh Nichols"]
    gem.files.include %w(lib/jeweler/templates/.document lib/jeweler/templates/.gitignore)
    gem.add_dependency "schacon-git", ">= 1.1.1"
    gem.add_dependency "rubyforge"
    gem.rubyforge_project = "pickles"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'jeweler'
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

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/pickles"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

if ENV["RUN_CODE_RUN"] == "true"
  task :default => [:test, :features]
else
  task :default => :test
end
