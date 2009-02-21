require 'test/unit'

require 'rubygems'
require 'shoulda'
require 'ruby-debug'
require 'rr'
require 'output_catcher'
require 'time'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'jeweler'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'shoulda_macros/jeweler_macros'

# Use vendored gem because of limited gem availability on runcoderun
# This is loosely based on 'vendor everything'.
Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', '**')].each do |dir|
  lib = "#{dir}/lib"
  $LOAD_PATH.unshift(lib) if File.directory?(lib)
end

# Fake out FileList from Rake
class FileList
  def self.[](*args)
    TMP_DIR.entries - ['.','..','.DS_STORE']
  end
end

TMP_DIR = File.join(File.dirname(__FILE__), 'tmp') unless defined?(TMP_DIR)
FileUtils.rm_f(TMP_DIR) # GAH, dirty hax. Somewhere isn't tearing up correctly, so do some cleanup first

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)

  def catch_out(&block)
     OutputCatcher.catch_out do
       block.call
     end
  end

  def fixture_dir
    File.join(File.dirname(__FILE__), 'fixtures', 'bar')
  end

  def tmp_dir
    File.join(File.dirname(__FILE__), 'tmp')
  end

  def build_spec(*files)
    Gem::Specification.new do |s|
      s.name = "bar"
      s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.email = "josh@technicalpickles.com"
      s.homepage = "http://github.com/technicalpickles/jeweler"
      s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.authors = ["Josh Nichols"]
      s.files = FileList[*files] unless files.empty?
    end
  end
end
