require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  def teardown
    FileUtils.rm_rf("#{File.dirname(__FILE__)}/tmp")
  end
  
  def build_spec
    Gem::Specification.new do |s|
      s.name = "bar"
      s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.email = "josh@technicalpickles.com"
      s.homepage = "http://github.com/technicalpickles/jeweler"
      s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.authors = ["Josh Nichols", "Dan Croak"]
      s.files =  FileList["[A-Z]*", "{generators,lib,test}/**/*"]
    end
  end
  
  def fixture_dir
    File.join(File.dirname(__FILE__), 'fixtures', 'bar')
  end
  
  def tmp_dir
    File.join(File.dirname(__FILE__), 'tmp')
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
  
  context "A Jeweler with an existing VERSION.yml" do
    setup do
      @now = Time.now
      Time.stubs(:now).returns(@now)
      FileUtils.cp_r(fixture_dir, tmp_dir)

      @jeweler = Jeweler.new(build_spec, tmp_dir)
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
        assert File.exists?(File.join(tmp_dir, 'bar.gemspec'))
      end

      should "have created a valid gemspec" do
        assert @jeweler.valid_gemspec?
      end
      
      should "output the name of the gemspec" do
        assert_match 'bar.gemspec', @output
      end
    
      
      context "re-reading the gemspec" do
        setup do
          data = File.read(File.join(tmp_dir, 'bar.gemspec'))

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