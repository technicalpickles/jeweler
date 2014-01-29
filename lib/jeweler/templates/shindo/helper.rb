<%= render_template 'simplecov.erb' %>
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require '<%= require_name %>'
require 'rubygems'
<%= render_template 'bundler_setup.erb' %>
require 'shindo'
