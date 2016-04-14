ENV.delete_if { |name, _| name.start_with?('GIT') }
require 'bundler'
begin
  Bundler.setup(:default, :xzibit, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'jeweler'
require 'mocha'
require 'mocha/api'
World(Mocha::API)

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end

require 'output_catcher'
require 'timecop'
require 'active_support'
require 'active_support/core_ext/object/blank'

require 'test/unit/assertions'
World(Test::Unit::Assertions)

require 'test_construct'
World(TestConstruct::Helpers)

def yank_task_info(content, task)
  if content =~ /#{Regexp.escape(task)}.new(\(.*\))? do \|(.*?)\|(.*?)^end$/m
    [$2, $3]
  end
end

def yank_group_info(content, group)
  $1 if content =~ /group :#{group} do(.*?)end/m
end

def fixture_dir
  File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures')
end

After do
  Timecop.return
end
