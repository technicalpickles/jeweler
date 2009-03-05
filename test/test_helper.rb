require 'test/unit'

require 'rubygems'
require 'shoulda'
begin
  require 'ruby-debug' 
rescue LoadError
end
require 'rr'
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

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)

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
