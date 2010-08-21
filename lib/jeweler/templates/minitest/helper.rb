require 'rubygems'
<%= render_template 'bundler_setup.erb' %>
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require '<%= require_name %>'

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun
