$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'jeweler'

require 'mocha'
require 'output_catcher'

require 'test/unit/assertions'

World do |world|
  world.extend(Test::Unit::Assertions)
  world
end

