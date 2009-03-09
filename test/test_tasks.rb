require 'test_helper'

require 'rake'
class TestTasks < Test::Unit::TestCase
  include Rake

  context 'instantiating Jeweler::Tasks' do
    setup do
      Task.clear

      @jt = Jeweler::Tasks.new {}
    end

    should 'assign @gemspec' do
      assert_not_nil @jt.gemspec
    end

    should 'assign @jeweler' do
      assert_not_nil @jt.jeweler
    end

    should 'yield the gemspec instance' do
      spec = nil; Jeweler::Tasks.new { |s| spec = s }
      assert_not_nil spec
    end

    should 'set the gemspec defaults before yielding it' do
      Jeweler::Tasks.new do |s|
        assert !s.files.empty?
      end
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
      assert Task.task_defined?(:'rubyforge:release:gem')
      assert Task.task_defined?(:'rubyforge:setup')
    end
  end
end
