require 'test/unit'

require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'ruby-debug'
require 'ruby-debug'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jeweler'

class FileList
  def self.[](*args)
  end
end