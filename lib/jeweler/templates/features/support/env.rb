$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require '<%= file_name_prefix %>'

require '<%= feature_support_require %>'

require 'test/unit/assertions'

World do |world|
  <% if feature_support_extend %>
  world.extend(<%= feature_support_extend %>)
  <% end %>
  world
end
