require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  def setup
  end
  
  context "without git user's name set" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).returns({'user.email' => 'foo@example.com'})
    end
    
    context "instantiating new generator" do
      setup do
        @block = lambda { Jeweler::Generator.new('git@github.com:technicalpickles/the-perfect-gem.git')}
      end

      should "raise no git user name exception" do
        assert_raise Jeweler::NoGitUserName do
          @block.call
        end
      end
    end
  end
  
  context "without git user's email set" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).returns({'user.name' => 'foo'})
    end

    context "instantiating new generator" do
      setup do
        @block = lambda { Jeweler::Generator.new('git@github.com:technicalpickles/the-perfect-gem.git')}
      end

      should "raise no git user name exception" do
        assert_raise Jeweler::NoGitUserEmail do
          @block.call
        end
      end
    end
  end
end
