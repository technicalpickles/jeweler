require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase
  
  context "given a nil github username" do
    setup do
      @block = lambda { Jeweler::Generator.new(nil, 'the-perfect-gem', nil) }
    end

    should "raise an error" do
      assert_raise Jeweler::NoGitHubUsernameGiven do
        @block.call
      end
    end
  end
  
  context "given a nil github repo name" do
    setup do
      @block = lambda { Jeweler::Generator.new('technicalpickles', nil, nil) }
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
        @block = lambda { Jeweler::Generator.new('technicalpickles', 'the-perfect-gem')}
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
        @block = lambda { Jeweler::Generator.new('technicalpickles', 'the-perfect-gem')}
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
      Jeweler::Generator.any_instance.stubs(:read_git_config).returns({'user.name' => 'foo', 'user.email' => 'bar@example.com'})
    end
    
    context "for technicalpickle's the-perfect-gem repository" do
      setup do
        @generator = Jeweler::Generator.new('technicalpickles', 'the-perfect-gem')
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
      
      context "for technicalpickles's the-perfect-gem repo and working directory 'tmp'" do
        setup do
          @generator = Jeweler::Generator.new('technicalpickles', 'the-perfect-gem', @tmp_dir)
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
          
          should "create LICENSE" do
            assert File.exists?(File.join(@tmp_dir, 'LICENSE'))
            assert File.file?(File.join(@tmp_dir, 'LICENSE'))
          end
          
          should "create README" do
            assert File.exists?(File.join(@tmp_dir, 'README'))
            assert File.file?(File.join(@tmp_dir, 'README'))
          end
          
          should "create lib/the-perfect-gem.rb" do
            assert File.exists?(File.join(@tmp_dir, 'lib', 'the-perfect-gem.rb'))
            assert File.file?(File.join(@tmp_dir, 'lib', 'the-perfect-gem.rb'))
          end
          
          context "LICENSE" do
            setup do
              @content = File.read((File.join(@tmp_dir, 'LICENSE')))
            end

            should "include copyright for this year with user's name" do
              assert_match 'Copyright (c) 2008 foo', @content
            end
          end
          
          context "Rakefile" do
            setup do
              @content = File.read((File.join(@tmp_dir, 'Rakefile')))
            end
            
            should "include repo's name as the gem's name" do
              assert_match 's.name = "the-perfect-gem"', @content
            end
            
            should "include the user's email as the gem's email" do
              assert_match 's.email = "bar@example.com"', @content
            end
            
            should "include the github repo's url as the gem's url" do
              assert_match 's.homepage = "http://github.com/technicalpickles/the-perfect-gem"', @content
            end
          end
          
          context "created git repo" do
            setup do
              @repo = Git.open(@tmp_dir)
            end

            should 'have one commit log' do
              assert_equal 1, @repo.log.size
            end
            
            should "have one commit log an initial commit message" do
              # TODO message seems to include leading whitespace, could probably fix that in ruby-git
              assert_match 'Initial commit to the-perfect-gem.', @repo.log.first.message
            end
            
            should "have README checked in" do
              status = @repo.status['README']
              assert ! status.untracked # not untracked
              assert_nil status.type # not modified, changed, or deleted
            end
            
            should "have Rakefile checked in" do
              status = @repo.status['Rakefile']
              assert ! status.untracked
              assert_nil status.type
            end
            
            should "have LICENSE checked in" do
              status = @repo.status['LICENSE']
              assert ! status.untracked
              assert_nil status.type
            end
            
            should "have no untracked files" do
              assert_equal 0, @repo.status.untracked.size
            end
            
            should "have no changed files" do
              assert_equal 0, @repo.status.changed.size
            end
            
            should "have no added files" do
              assert_equal 0, @repo.status.added.size
            end
            
            should "have no deleted files" do
              assert_equal 0, @repo.status.deleted.size
            end
            
            should "have lib/the-perfect-gem.rb checked in" do
              status = @repo.status['lib/the-perfect-gem.rb']
              assert ! status.untracked
              assert_nil status.type
            end
            
            should "have git@github.com:technicalpickles/the-perfect-gem.git as origin remote" do
              assert_equal 1, @repo.remotes.size
              remote = @repo.remotes.first
              assert_equal 'origin', remote.name
              assert_equal 'git@github.com:technicalpickles/the-perfect-gem.git', remote.url
            end
          end
          
          
        end
          
      end
    end
  end
  
end
