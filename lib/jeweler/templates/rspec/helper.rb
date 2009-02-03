require 'spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require '<%= file_name_prefix %>'

Spec::Runner.configure do |config|
  
end
