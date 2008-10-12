require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  context 'A gem, with top level module,' do
    setup do
      @spec = Gem::Specification.new do |s|
        s.name = "foo"
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
      @jeweler = Jeweler.new(@spec)
    end
    
    teardown do
      @jeweler.send(:undefine_versions)
    end
    
    should "have major version of 0" do
      assert_equal 0, @jeweler.major_version
    end
    
    should "have minor version of 1" do
      assert_equal 1, @jeweler.minor_version
    end
    
    should 'be version 0.1.0' do
      assert_equal '0.1.0', @jeweler.version
    end
    
    should "have 'module' top level keyword" do
      assert_equal 'module', @jeweler.send(:top_level_keyword)
    end
  end
  
  context "A gem, with top level class" do
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
      @jeweler = Jeweler.new(@spec)
    end
    
    teardown do
      @jeweler.send(:undefine_versions)
    end

    should "be version 1.5.2" do
      assert_equal '1.5.2', @jeweler.version
    end
    
    should "have 'class' top level keyword" do
      assert_equal 'class', @jeweler.send(:top_level_keyword)
    end
  end
  
end