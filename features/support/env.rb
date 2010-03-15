require 'bundler'
begin
  Bundler.setup(:runtime, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'jeweler'
require 'mocha'
require 'output_catcher'

require 'test/unit/assertions'
World(Test::Unit::Assertions)

require 'construct'
World(Construct::Helpers)

def yank_task_info(content, task)
  if content =~ /#{Regexp.escape(task)}.new(\(.*\))? do \|(.*?)\|(.*?)end/m
    [$2, $3]
  end
end

def yank_group_info(content, group)
  if content =~ /group :#{group} do(.*?)end/m
    $1
  end
end

def fixture_dir
  File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures')
end
