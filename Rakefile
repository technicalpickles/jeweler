# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'semver'

def s_version
  SemVer.find.format "%M.%m.%p%s"
end

begin
  Bundler.setup(:default, :xzibit, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = 'jeweler'
  gem.version = s_version
  gem.homepage = 'http://github.com/technicalpickles/jeweler'
  gem.summary = 'Opinionated tool for creating and managing RubyGem projects'
  gem.description = 'Simple and opinionated helper for creating Rubygem projects on GitHub'
  gem.required_ruby_version = '>= 2.2.0'
  gem.license = 'MIT'
  gem.authors = ["Fred Mitchell", "Josh Nichols", "Yusuke Murata"]
  gem.email = ["fred.mitchell@gmx.de", "fred.mitchell@gmx.com", "info@muratayusuke.com"]
  gem.files.include %w(lib/jeweler/templates/.document lib/jeweler/templates/.gitignore)
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
    list.exclude 'test/fixtures/**/*.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

namespace :test do
  task :gemspec_dup do
    gemspec = Rake.application.jeweler.gemspec
    dupped_gemspec = gemspec.dup
    _cloned_gemspec = gemspec.clone
    puts gemspec.to_ruby
    puts dupped_gemspec.to_ruby
  end
end

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files = FileList['lib/**/*.rb'].exclude('lib/jeweler/templates/**/*.rb')
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = 'features --format progress'
end
namespace :features do
  Cucumber::Rake::Task.new(:pretty) do |features|
    features.cucumber_opts = 'features --format progress'
  end
end

if ENV['RUN_CODE_RUN'] == 'true'
  task default: [:test, :features]
else
  task default: :test
end
