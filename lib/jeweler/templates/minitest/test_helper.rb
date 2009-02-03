require 'rubygems'
require 'mini/test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require '<%= file_name_prefix %>'

class Mini::Test::TestCase
end

Mini::Test.autorun
