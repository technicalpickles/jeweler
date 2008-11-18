require File.dirname(__FILE__) + '/../test_helper'

class JewelerGeneratorInitializerTest < Test::Unit::TestCase
  context "given a nil github repo name" do
    setup do
      @block = lambda { Jeweler::Generator.new(nil) }
    end

    should "raise an error" do
      assert_raise Jeweler::NoGitHubRepoNameGiven do
        @block.call
      end
    end
  end

  context "without git user's name set" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).returns({'user.email' => 'bar@example.com'})
    end

    context "instantiating new generator" do
      setup do
        @block = lambda { Jeweler::Generator.new('the-perfect-gem')}
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
        @block = lambda { Jeweler::Generator.new('the-perfect-gem')}
      end

      should "raise no git user name exception" do
        assert_raise Jeweler::NoGitUserEmail do
          @block.call
        end
      end
    end
  end

  context "without github username set" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).
        returns({'user.email' => 'bar@example.com', 'user.name' => 'foo'})
    end

    context "instantiating new generator" do
      setup do
        @block = lambda { Jeweler::Generator.new('the-perfect-gem')}
      end

      should "raise no github user exception" do
        assert_raise Jeweler::NoGitHubUser do
          @block.call
        end
      end
    end
  end
  
  context "with valid git user configuration" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).
        returns({'user.name' => 'foo', 'user.email' => 'bar@example.com', 'github.user' => 'technicalpickles', 'github.token' => 'zomgtoken'})
    end

    context "for technicalpickle's the-perfect-gem repository" do
      setup do
        @generator = Jeweler::Generator.new('the-perfect-gem')
      end

      should "assign 'foo' to user's name" do
        assert_equal 'foo', @generator.user_name
      end

      should "assign 'bar@example.com to user's email" do
        assert_equal 'bar@example.com', @generator.user_email
      end

      should "assign github remote" do
        assert_equal 'git@github.com:technicalpickles/the-perfect-gem.git', @generator.github_remote
      end

      should "determine github username as technicalpickles" do
        assert_equal 'technicalpickles', @generator.github_username
      end

      should "determine github repository name as the-perfect-gem" do
        assert_equal 'the-perfect-gem', @generator.github_repo_name
      end

      should "determine github url as http://github.com/technicalpickles/the-perfect-gem" do
        assert_equal 'http://github.com/technicalpickles/the-perfect-gem', @generator.github_url
      end

      should "determine target directory as the same as the github repository name" do
        assert_equal @generator.github_repo_name, @generator.target_dir
      end

      should "determine lib directory as being inside the target directory" do
        assert_equal File.join(@generator.target_dir, 'lib'), @generator.lib_dir
      end

      should "determine test directory as being inside the target directory" do
        assert_equal File.join(@generator.target_dir, 'test'), @generator.test_dir
      end

      should "determine constant name as ThePerfectGem" do
        assert_equal 'ThePerfectGem', @generator.constant_name
      end

      should "determine file name prefix as the_perfect_gem" do
        assert_equal 'the_perfect_gem', @generator.file_name_prefix
      end
    end
  end
end