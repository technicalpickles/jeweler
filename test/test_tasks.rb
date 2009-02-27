require 'test_helper'

require 'rake'
class TestTasks < Test::Unit::TestCase
  include Rake

  context 'instantiating Jeweler::Tasks' do
    setup do
      Task.clear

      @jt = Jeweler::Tasks.new do |s|
      end
    end

    should 'assign @gemspec' do
      assert_not_nil @jt.gemspec
    end

    should 'assign @jeweler' do
      assert_not_nil @jt.jeweler
    end

    should 'define tasks' do
      assert Task.task_defined?(:build)
      assert Task.task_defined?(:install)
      assert Task.task_defined?(:gemspec)
      assert Task.task_defined?(:build)
      assert Task.task_defined?(:install)
      assert Task.task_defined?(:'gemspec:validate')
      assert Task.task_defined?(:'gemspec:generate')
      assert Task.task_defined?(:version)
      assert Task.task_defined?(:'version:write')
      assert Task.task_defined?(:'version:bump:major')
      assert Task.task_defined?(:'version:bump:minor')
      assert Task.task_defined?(:'version:bump:patch')
      assert Task.task_defined?(:'release')
    end
  end
end
