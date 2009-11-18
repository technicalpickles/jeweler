$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require '<%= require_name %>'
run Sinatra::Application
