
require 'rubygems'
begin
  require 'test/spec'
rescue LoadError
  raise "These tests depends upon the Test-Spec gem  [sudo gem install test-spec]"
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require '<%= require_name %>'

