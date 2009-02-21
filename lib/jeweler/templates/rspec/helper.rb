require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require '<%= file_name_prefix %>'

Spec::Runner.configure do |config|
  
end
