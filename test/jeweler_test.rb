require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  def write_version_file(name, keyword, const_name, major, minor, patch)
    dir = "#{File.dirname(__FILE__)}/lib/#{name}"
    FileUtils.mkdir_p(dir)
    File.open("#{dir}/version.rb", 'w+') do |file|
      file.write <<-END
#{keyword} #{const_name}
  module Version
    MAJOR = #{major}
    MINOR = #{minor}
    PATCH = #{patch}
  end
end
      END
    end
  end
  
  def teardown
    FileUtils.rm_rf("#{File.dirname(__FILE__)}/lib")
    FileUtils.rm_f("#{File.dirname(__FILE__)}/foo.gemspec")
    FileUtils.rm_f("#{File.dirname(__FILE__)}/bar.gemspec")
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
    
    def should_have_toplevel_keyword(keyword)
      should "have '#{keyword}' top level keyword" do
        assert_equal keyword, @jeweler.send(:top_level_keyword)
      end
    end
  end
  
  context 'A gem, with top level module,' do
    setup do
      write_version_file('foo', 'module', 'Foo', 0, 1, 0)
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
    end
    
    teardown do
      @jeweler.send(:undefine_versions) if @jeweler
    end
    
    should_have_major_version 0
    should_have_minor_version 1
    should_have_patch_version 0
    should_be_version '0.1.0'
    
    should_have_toplevel_keyword 'module'
    
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
  
  context "A gem, with top level class," do
    setup do
      write_version_file('bar', 'class', 'Bar', 1, 5, 2)
      
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
    end
    
    teardown do
      @jeweler.send(:undefine_versions) if @jeweler
    end
    
    should_have_major_version 1
    should_have_minor_version 5
    should_have_patch_version 2
    should_be_version '1.5.2'
    should_have_toplevel_keyword 'class'
    
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
  
end