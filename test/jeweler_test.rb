require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  def teardown
    FileUtils.rm_rf("#{File.dirname(__FILE__)}/lib")
    FileUtils.rm_f("#{File.dirname(__FILE__)}/foo.gemspec")
    FileUtils.rm_f("#{File.dirname(__FILE__)}/bar.gemspec")
    FileUtils.rm_f("#{File.dirname(__FILE__)}/VERSION.yml")
  end
  
  class << self
    def should_have_major_version(version)
      should "have major version of #{version}" do 
        assert_equal version, @jeweler.major_version
      end
    end
    
    def should_have_minor_version(version)
      should "have minor version of #{version}" do
        assert_equal version, @jeweler.minor_version
      end
    end
    
    def should_have_patch_version(version)
      should "have patch version of #{version}" do
        assert_equal version, @jeweler.patch_version
      end
    end
    
    def should_be_version(version)
      should "be version #{version}" do
        assert_equal version, @jeweler.version
      end
    end
  end
  
  context 'A jeweler (with a gemspec with top level module)' do
    setup do
      @spec = Gem::Specification.new do |s|
        s.name = 'foo'
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
      @jeweler = Jeweler.new(@spec, File.dirname(__FILE__))
      @jeweler.write_version(0, 1, 0)
    end
    
    should_have_major_version 0
    should_have_minor_version 1
    should_have_patch_version 0
    should_be_version '0.1.0'
    
    context "bumping the patch version" do
      setup do
        @jeweler.bump_patch_version
      end
      
      should_have_major_version 0
      should_have_minor_version 1
      should_have_patch_version 1
      should_be_version '0.1.1'
      
      should "still have module Foo" do
        # do some regexp of version.rb
      end
    end
    
    context "bumping the minor version" do
      setup do
        @jeweler.bump_minor_version
      end
      
      should_have_major_version 0
      should_have_minor_version 2
      should_have_patch_version 0
      should_be_version '0.2.0'
      
      should "still have module Foo" do
        # do some regexp of version.rb
      end
    end
    
    context "bumping the major version" do
      setup do
        @jeweler.bump_major_version
      end
      
      should_have_major_version 1
      should_have_minor_version 0
      should_have_patch_version 0
      should_be_version '1.0.0'
      
      should "still have module Foo" do
        # do some regexp of version.rb
      end
    end
    
  end
  
  context "A Jeweler (with a gemspec with top level class)" do
    setup do
      @spec = Gem::Specification.new do |s|
        s.name = "bar"
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
      @jeweler = Jeweler.new(@spec, File.dirname(__FILE__))
      @jeweler.write_version(1, 5, 2)
    end
    
    should_have_major_version 1
    should_have_minor_version 5
    should_have_patch_version 2
    should_be_version '1.5.2'
    
    context "bumping the patch version" do
      setup do
        @jeweler.bump_patch_version
      end
      
      should_have_major_version 1
      should_have_minor_version 5
      should_have_patch_version 3
      should_be_version '1.5.3'
      
      should_eventually "still have class Bar" do
        # do some regexp of version.rb
      end
    end
  end
  
  should "raise an exception when created with a nil gemspec" do
    assert_raises Jeweler::GemspecError do
      @jeweler = Jeweler.new(nil, File.dirname(__FILE__))
    end
  end
  
end