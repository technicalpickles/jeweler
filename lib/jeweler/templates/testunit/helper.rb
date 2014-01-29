<%= render_template 'simplecov.erb' %>
require 'rubygems'
<%= render_template 'bundler_setup.erb' %>
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require '<%= require_name %>'

class Test::Unit::TestCase
end
