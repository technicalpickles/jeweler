require 'rubygems'
require 'test/unit'
<% if use_sinatra %>
require 'rack/test'  
<% end %>

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require '<%= require_name %>'

class Test::Unit::TestCase
<% if use_sinatra %>
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

<% end %>
end
