require File.dirname(__FILE__) + '/test_helper'

class JewelerGeneratorTest < Test::Unit::TestCase
  def self.should_create_directory(directory)
    should "create #{directory} directory" do
      assert File.exists?(File.join(@tmp_dir, directory))
      assert File.directory?(File.join(@tmp_dir, directory))
    end
  end

  def self.should_create_files(*files)
    should "create #{files.join ', '}" do
      files.each do |file|
        assert File.exists?(File.join(@tmp_dir, file))
        assert File.file?(File.join(@tmp_dir, file))        
      end
    end
  end

  def self.should_be_checked_in(*files)
    should "have #{files.join ', '} checked in" do
      files.each do |file|        
        status = @repo.status[file]
        assert_not_nil status, "wasn't able to get status for #{file}"
        assert ! status.untracked, "#{file} was untracked"
        assert_nil status.type, "#{file} had a type. it should have been nil"
      end
    end
  end
  
  def self.should_have_sane_license
    context "LICENSE" do
      setup do
        @content = File.read((File.join(@tmp_dir, 'LICENSE')))
      end

      should "include copyright for this year with user's name" do
        assert_match 'Copyright (c) 2008 foo', @content
      end
    end
  end
  
  def self.should_have_sane_gitignore
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
  end
  
  def self.should_have_sane_rakefile(options)
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

      should "include the summary in the gem" do
        assert_match %Q{s.summary = %Q{zomg, so good}}, @content
      end

      should "include the github repo's url as the gem's url" do
        assert_match 's.homepage = "http://github.com/technicalpickles/the-perfect-gem"', @content
      end

      should "include #{options[:pattern]} in the TestTask" do
        assert_match "t.pattern = '#{options[:pattern]}'", @content
      end

      should "include #{options[:pattern]} in the RcovTask" do
        assert_match "t.test_files = FileList['#{options[:pattern]}']", @content
      end

      should "push #{options[:libs]} dir into RcovTask libs" do
        assert_match "t.libs << '#{options[:libs]}'", @content
      end
    end
  end
  
  def self.should_have_sane_origin_remote
    should "have git@github.com:technicalpickles/the-perfect-gem.git as origin remote" do
      assert_equal 1, @repo.remotes.size
      remote = @repo.remotes.first
      assert_equal 'origin', remote.name
      assert_equal 'git@github.com:technicalpickles/the-perfect-gem.git', remote.url
    end
  end

  context "with valid git user configuration" do
    setup do
      Jeweler::Generator.any_instance.stubs(:read_git_config).
        returns({'user.name' => 'foo', 'user.email' => 'bar@example.com', 'github.user' => 'technicalpickles', 'github.token' => 'zomgtoken'})
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

      context "for generating technicalpickles's the-perfect-gem repo in 'tmp'" do
        setup do
          @generator = Jeweler::Generator.new('the-perfect-gem', :directory => @tmp_dir, :summary => 'zomg, so good')
        end

        should "use tmp for target directory" do
          assert_equal @tmp_dir, @generator.target_dir
        end

        context "running with default test style" do
          setup do
            @output = catch_out { @generator.run }
          end

          should 'create target directory' do
            assert File.exists?(@tmp_dir)
          end

          should_create_directory 'lib'
          should_create_directory 'test'

          should_create_files 'LICENSE', 'README', 'lib/the_perfect_gem.rb', 'test/test_helper.rb', 'test/the_perfect_gem_test.rb', '.gitignore'

          should_have_sane_rakefile :libs => 'test', :pattern => 'test/**/*_test.rb'
          should_have_sane_license
          should_have_sane_gitignore


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

            should "have one commit log an initial commit message" do
              assert_equal 1, @repo.log.size
              # TODO message seems to include leading whitespace, could probably fix that in ruby-git
              assert_match 'Initial commit to the-perfect-gem.', @repo.log.first.message
            end

            should_be_checked_in 'README', 'Rakefile', 'LICENSE', 'lib/the_perfect_gem.rb', 'test/test_helper.rb', 'test/the_perfect_gem_test.rb', '.gitignore'

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

            should_have_sane_origin_remote
          end
        end

        context "running with bacon test style" do
          setup do
            @generator.test_style = :bacon
            @output = catch_out {
              @generator.run
            }
          end

          should 'create target directory' do
            assert File.exists?(@tmp_dir)
          end

          should_create_directory 'lib'
          should_create_directory 'spec'

          should_create_files 'LICENSE', 'README', 'lib/the_perfect_gem.rb', 'spec/spec_helper.rb', 'spec/the_perfect_gem_spec.rb', '.gitignore'

          should_have_sane_rakefile :libs => 'spec', :pattern => 'spec/**/*_spec.rb'
          should_have_sane_license
          should_have_sane_gitignore


          context "spec/the_perfect_gem_spec.rb" do
            setup do
              @content = File.read((File.join(@tmp_dir, 'spec', 'the_perfect_gem_spec.rb')))
            end

            should "describe ThePerfectGem" do
              assert_match 'describe "ThePerfectGem" do', @content
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

            should_be_checked_in 'README', 'Rakefile', 'LICENSE', 'lib/the_perfect_gem.rb', 'spec/spec_helper.rb', 'spec/the_perfect_gem_spec.rb', '.gitignore'

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

            should_have_sane_origin_remote
          end
        end
      end
    end
  end
end
