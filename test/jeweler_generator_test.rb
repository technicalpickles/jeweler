require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  def setup
    @github_remote = 'git@github.com:technicalpickles/the-perfect-gem.git'
  end
  
  context "given a nil github remote" do
    setup do
      @block = lambda { Jeweler::Generator.new(nil) }
    end

    should "raise an error" do
      assert_raise Jeweler::NoRemoteGiven do
        @block.call
      end
    end
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
  
  context "with valid git user configuration" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).returns({'user.name' => 'foo', 'user.email' => 'foo@example.com'})
    end
    
    context "for a repository 'git@github.com:technicalpickles/the-perfect-gem.git'" do
      setup do
        @generator = Jeweler::Generator.new('git@github.com:technicalpickles/the-perfect-gem.git')
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
    end
    
    
    context "and cleaned out tmp directory" do
      setup do
        @tmp_dir = File.join(File.dirname(__FILE__), 'tmp')
        FileUtils.rm_rf(@tmp_dir)
        
        assert ! File.exists?(@tmp_dir)
      end

      teardown do
        FileUtils.rm_rf(@tmp_dir)
      end
      
      context "for a repository 'git@github.com:technicalpickles/the-perfect-gem.git' and working directory 'tmp'" do
        setup do
          @generator = Jeweler::Generator.new('git@github.com:technicalpickles/the-perfect-gem.git', @tmp_dir)
        end

        should "use tmp for target directory" do
          assert_equal @tmp_dir, @generator.target_dir
        end
        
        context "running" do
          setup do
            @generator.run
          end

          should 'create target directory' do
            assert File.exists?(@tmp_dir)
          end
          
          should "create lib directory" do
            assert File.exists?(File.join(@tmp_dir, 'lib'))
            assert File.directory?(File.join(@tmp_dir, 'lib'))
          end
          
          should "create README" do
            assert File.exists?(File.join(@tmp_dir, 'README'))
            assert File.file?(File.join(@tmp_dir, 'README'))
          end
          
          should "create lib/the-perfect-gem.rb" do
            assert File.exists?(File.join(@tmp_dir, 'lib', 'the-perfect-gem.rb'))
            assert File.file?(File.join(@tmp_dir, 'lib', 'the-perfect-gem.rb'))
          end
        end
          
      end
    end
  end
  
end
