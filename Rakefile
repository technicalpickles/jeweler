require 'rake'

$LOAD_PATH.unshift('lib')

gem 'git'
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

    gem.add_dependency "git", ">= 1.2.1"
    gem.add_dependency "rubyforge"

    gem.rubyforge_project = "pickles"

    gem.add_development_dependency "thoughtbot-shoulda"
    gem.add_development_dependency "mhennemeyer-output_catcher"
    gem.add_development_dependency "rr"
    gem.add_development_dependency "mocha"
    gem.add_development_dependency "redgreen"
  end

  Jeweler::RubyforgeTasks.new do |t|
    t.doc_task = :yardoc
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

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:yardoc) do |t|
    t.files   = FileList['lib/**/*.rb'].exclude('lib/jeweler/templates/**/*.rb')
  end
rescue LoadError
  task :yardoc do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
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
  Cucumber::Rake::Task.new(:features) do |features|
    features.cucumber_opts = "features --format progress"
  end
  namespace :features do
    Cucumber::Rake::Task.new(:pretty) do |features|
      features.cucumber_opts = "features --format progress"
    end
  end
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
  namespace :features do
    task :pretty do
      abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
    end
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

namespace :development_dependencies do
  task :check do
    missing_dependencies = Rake.application.jeweler.gemspec.development_dependencies.select do |dependency|
      begin
        Gem.activate dependency.name, dependency.version_requirements.to_s
        false
      rescue LoadError => e
        true
      end
    end

    #require 'ruby-debug'; breakpoint

    if missing_dependencies.empty?
      puts "Development dependencies seem to be installed."
    else
      puts "Missing some dependencies. Install them with the following commands:"
      missing_dependencies.each do |dependency|
        puts %Q{\tgem install #{dependency.name} --version "#{dependency.version_requirements}"}
      end
      abort "Run the specified gem commands before trying to run this again: #{$0} #{ARGV.join(' ')}"
    end

  end
end

task :test => 'development_dependencies:check'
task :features => 'development_dependencies:check'
