require 'test/unit'

require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'ruby-debug'
require 'ruby-debug'
gem 'mocha'
require 'mocha'

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
  end
end

TMP_DIR = File.join(File.dirname(__FILE__), 'tmp')
FileUtils.rm_f(TMP_DIR) # GAH, dirty hax. Somewhere isn't tearing up correctly, so do some cleanup first

class Test::Unit::TestCase


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
end
