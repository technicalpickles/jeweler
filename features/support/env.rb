$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'jeweler'

require 'mocha'
require 'output_catcher'

require 'test/unit/assertions'

World do |world|
  world.extend(Test::Unit::Assertions)
  world
end

def yank_task_info(content, task)
  if content =~ /#{Regexp.escape(task)}.new(\(.*\))? do \|(.*?)\|(.*?)end/m
    [$2, $3]
  end
end

def fixture_dir
  File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures')
end
