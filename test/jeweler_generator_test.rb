require File.dirname(__FILE__) + '/test_helper'

class JewelerTest < Test::Unit::TestCase

  def self.should_create_directory(directory)
    should "create #{directory} directory" do
      assert File.exists?(File.join(@tmp_dir, directory))
      assert File.directory?(File.join(@tmp_dir, directory))
    end
  end

  def self.should_create_file(file)
    should "create file #{file}" do
      assert File.exists?(File.join(@tmp_dir, file))
      assert File.file?(File.join(@tmp_dir, file))
    end
  end

  def self.should_be_checked_in(file)
    should "have #{file} checked in" do
      status = @repo.status[file]
      assert_not_nil status, "wasn't able to get status for #{file}"
      assert ! status.untracked, "#{file} was untracked"
      assert_nil status.type, "#{file} had a type. it should have been nil"
    end
  end

  context "given a nil github repo name" do
    setup do
      @block = lambda { Jeweler::Generator.new(nil, nil) }
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
        returns({'user.name' => 'foo', 'user.email' => 'bar@example.com', 'github.user' => 'technicalpickles'})
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
          @generator = Jeweler::Generator.new('the-perfect-gem', @tmp_dir)
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

          should_create_directory 'lib'
          should_create_directory 'test'

          should_create_file 'LICENSE'
          should_create_file 'README'
          should_create_file 'lib/the_perfect_gem.rb'
          should_create_file 'test/test_helper.rb'
          should_create_file 'test/the_perfect_gem_test.rb'
          should_create_file '.gitignore'

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

          context ".gitignore" do
            setup do
              @content = File.read((File.join(@tmp_dir, '.gitignore')))
            end

            should "include vim swap files" do
              assert_match '*.sw?', @content
            end

            should "include coverage" do
              assert_match 'coverage', @content
            end

            should "include .DS_Store" do
              assert_match '.DS_Store', @content
            end
          end


          context "test/the_perfect_gem_test.rb" do
            setup do
              @content = File.read((File.join(@tmp_dir, 'test', 'the_perfect_gem_test.rb')))
            end

            should "have class of ThePerfectGemTest" do
              assert_match 'class ThePerfectGemTest < Test::Unit::TestCase', @content
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

            should_be_checked_in 'README'
            should_be_checked_in 'Rakefile'
            should_be_checked_in 'LICENSE'
            should_be_checked_in 'lib/the_perfect_gem.rb'
            should_be_checked_in 'test/test_helper.rb'
            should_be_checked_in 'test/the_perfect_gem_test.rb'
            should_be_checked_in '.gitignore'

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
