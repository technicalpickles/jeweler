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

class RubyForgeStub
  attr_accessor :userconfig, :autoconfig
  
  def initialize
    @userconfig = {}
    @autoconfig = {}
  end
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

  class << self
    attr_accessor :subject_block
  end
  def self.subject(&block)
    self.subject_block = block
  end

  def subject
    self.class.subject_block.call
  end

  def self.rubyforge_command_context(description, &block)
    context description do
      setup do
        @command = subject

        if @command.respond_to? :gemspec=
          @gemspec = Object.new
          @command.gemspec = @gemspec
        end

        if @command.respond_to? :gemspec_helper=
          @gemspec_helper = Object.new
          @command.gemspec_helper = @gemspec_helper
        end

        if @command.respond_to? :rubyforge=
          @rubyforge = RubyForgeStub.new
          @command.rubyforge = @rubyforge
        end

        if @command.respond_to? :output
          @output = StringIO.new
          @command.output = @output
        end
      end

      context "", &block
    end
  end
end
