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
      spec = Gem::Specification.new do |s|
        s.name = 'foo'
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
      @jeweler = Jeweler.new(spec, File.dirname(__FILE__))
      
      catch_out do
        @jeweler.write_version(0, 1, 0)
      end
      @jeweler = Jeweler.new(spec, File.dirname(__FILE__))
    end
    
    should_have_major_version 0
    should_have_minor_version 1
    should_have_patch_version 0
    should_be_version '0.1.0'
    
    context "bumping the patch version" do
      setup do
        @output = catch_out { @jeweler.bump_patch_version }
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
        @output = catch_out { @jeweler.bump_minor_version }
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
        @output = catch_out { @jeweler.bump_major_version }
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
      spec = Gem::Specification.new do |s|
        s.name = "bar"
        s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.email = "josh@technicalpickles.com"
        s.homepage = "http://github.com/technicalpickles/jeweler"
        s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
        s.authors = ["Josh Nichols", "Dan Croak"]
        s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
      end
      @jeweler = Jeweler.new(spec, File.dirname(__FILE__))

      @now = Time.now
      Time.stubs(:now).returns(@now)

      @output = catch_out { @jeweler.write_version(1, 5, 2) }
      @jeweler = Jeweler.new(spec, File.dirname(__FILE__))
    end  
    
    should_have_major_version 1
    should_have_minor_version 5
    should_have_patch_version 2
    should_be_version '1.5.2'
    
    context "bumping the patch version" do
      setup do
        @output = catch_out { @jeweler.bump_patch_version }
      end
      
      should_have_major_version 1
      should_have_minor_version 5
      should_have_patch_version 3
      should_be_version '1.5.3'
    end
    
    context "writing the gemspec" do
      setup do
        @output = catch_out { @jeweler.write_gemspec }
      end
      
      should "create bar.gemspec" do
        assert File.exists?(File.join(File.dirname(__FILE__), 'bar.gemspec'))
      end

      should "have created a valid gemspec" do
        assert @jeweler.valid_gemspec?
      end
    
      
      context "re-reading the gemspec" do
        setup do
          data = File.read(File.join(File.dirname(__FILE__), 'bar.gemspec'))

          @parsed_spec = eval("$SAFE = 3\n#{data}", binding, File.join(File.dirname(__FILE__), 'bar.gemspec'))
        end

        should "have version 1.5.2" do
          assert_equal '1.5.2', @parsed_spec.version.version
        end
        
        should "have date filled in" do
          assert_equal Time.local(@now.year, @now.month, @now.day), @parsed_spec.date
        end
      end
    end
  end
  
  should "raise an exception when created with a nil gemspec" do
    assert_raises Jeweler::GemspecError do
      @jeweler = Jeweler.new(nil, File.dirname(__FILE__))
    end
  end
  
end