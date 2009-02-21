require 'test/unit'

require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'ruby-debug'
require 'ruby-debug'
gem 'rr'
require 'rr'

require File.dirname(__FILE__) + '/shoulda_macros/jeweler_macros'

# Use vendored gem because of limited gem availability on runcoderun
# This is loosely based on 'vendor everything'.
Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', '**')].each do |dir|
  lib = "#{dir}/lib"
  $LOAD_PATH.unshift(lib) if File.directory?(lib)
end

require 'output_catcher'
require 'time'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jeweler'

# Fake out FileList from Rake
class FileList
  def self.[](*args)
    TMP_DIR.entries - ['.','..','.DS_STORE']
  end
end

TMP_DIR = File.join(File.dirname(__FILE__), 'tmp')
FileUtils.rm_f(TMP_DIR) # GAH, dirty hax. Somewhere isn't tearing up correctly, so do some cleanup first

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def catch_out(&block)
     OutputCatcher.catch_out do
       block.call
     end
  end
  def catch_err(&block)
     OutputCatcher.catch_err do
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
      s.authors = ["Josh Nichols", "Dan Croak"]
      s.files = FileList[*files] unless files.empty?
    end
  end
end
