<%= render_template 'simplecov.erb' %>
require 'rubygems'
<%= render_template 'bundler_setup.erb' %>
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require '<%= require_name %>'

class Test::Unit::TestCase
end
