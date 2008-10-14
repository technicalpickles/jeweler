require 'test/unit'

require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'ruby-debug'
require 'ruby-debug'
gem 'mocha'
require 'mocha'

gem 'mhennemeyer-output_catcher'
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

class Test::Unit::TestCase
  
  def catch_out(&block)
     OutputCatcher.catch_out do
       block.call
     end
  end
end