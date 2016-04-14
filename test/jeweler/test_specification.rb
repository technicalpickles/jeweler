require 'test_helper'

class TestSpecification < Test::Unit::TestCase
  def setup
    @project = create_construct
  end

  def teardown
    @project.destroy!
  end

  def build_jeweler_gemspec(&block)
    gemspec = if block
                Gem::Specification.new(&block)
              else
                Gem::Specification.new
              end
    gemspec.extend(Jeweler::Specification)
    gemspec
  end

  should 'be able to use to_ruby on a duped gemspec without error' do
    gemspec = build_jeweler_gemspec
    gemspec.files.include 'throwaway value'

    gemspec.dup.to_ruby
  end

  context 'basic defaults' do
    setup do
      @gemspec = build_jeweler_gemspec
    end

    should 'make files a FileList' do
      assert_equal FileList, @gemspec.files.class
    end

    should 'make extra_rdoc_files a FileList' do
      assert_equal FileList, @gemspec.extra_rdoc_files.class
    end
  end

  context "there aren't any executables in the project directory" do
    setup do
      @project.directory 'bin'
    end

    context "and there hasn't been any set on the gemspec" do
      setup do
        @gemspec = build_jeweler_gemspec
        @gemspec.set_jeweler_defaults(@project)
      end

      should 'have empty gemspec executables' do
        assert_equal [], @gemspec.executables
      end
    end

    context 'and has been previously set executables' do
      setup do
        @gemspec = build_jeweler_gemspec do |gemspec|
          gemspec.executables = %w(non-existant)
        end
        @gemspec.set_jeweler_defaults(@project)
      end

      should 'have only the original executables in the gemspec' do
        assert_equal %w(non-existant), @gemspec.executables
      end
    end
  end

  context 'there are multiple executables in the project directory' do
    setup do
      @project.directory('bin') do |bin|
        bin.file 'burnination'
        bin.file 'trogdor'
      end
      repo = Git.init(@project.to_s)
      repo.config('user.name', 'who')
      repo.config('user.email', 'who@where.com')
      repo.add('bin/burnination')
      repo.commit('Initial commit')
    end

    context "and there hasn't been any set on the gemspec" do
      setup do
        @gemspec = build_jeweler_gemspec
        @gemspec.set_jeweler_defaults(@project)
      end

      should 'have the executables under version control in the gemspec' do
        assert_equal %w(burnination), @gemspec.executables
      end
    end
    context 'and has been previously set executables' do
      setup do
        @gemspec = build_jeweler_gemspec do |gemspec|
          gemspec.executables = %w(burnination)
        end
        @gemspec.set_jeweler_defaults(@project)
      end
      should 'have only the original executables in the gemspec' do
        assert_equal %w(burnination), @gemspec.executables
      end
    end
  end

  context 'there are mutiple extconf.rb and mkrf_conf.rb in the project directory' do
    setup do
      @project.directory('ext') do |ext|
        ext.file 'extconf.rb'
        ext.file 'mkrf_conf.rb'
        ext.directory('trogdor_native') do |trogdor_native|
          trogdor_native.file 'extconf.rb'
          trogdor_native.file 'mkrf_conf.rb'
        end
      end
    end

    context "and there hasn't been any extensions set on the gemspec" do
      setup do
        @gemspec = build_jeweler_gemspec
        @gemspec.set_jeweler_defaults(@project)
      end

      should 'have all the extconf.rb and mkrf_config.rb files in extensions' do
        assert_equal %w(ext/mkrf_conf.rb ext/trogdor_native/mkrf_conf.rb ext/extconf.rb ext/trogdor_native/extconf.rb).sort, @gemspec.extensions.sort
      end
    end
  end

  context 'there are some files and is setup for git' do
    setup do
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      repo = Git.init(@project.to_s)
      repo.config('user.name', 'who')
      repo.config('user.email', 'who@where.com')
      repo.add('.')
      repo.commit('Initial commit')
    end

    context 'and the files defaults are used' do
      setup do
        @gemspec = build_jeweler_gemspec
        @gemspec.set_jeweler_defaults(@project, @project)
      end

      should 'populate files from git' do
        assert_equal %w(Rakefile lib/example.rb), @gemspec.files.sort
      end
    end

    context 'and the files specified manually' do
      setup do
        @gemspec = build_jeweler_gemspec do |gemspec|
          gemspec.files = %w(Rakefile)
        end
        @gemspec.set_jeweler_defaults(@project, @project)
      end

      should 'not be overridden by files from git' do
        assert_equal %w(Rakefile), @gemspec.files
      end
    end
  end

  context 'there are some files and is setup for git with ignored files' do
    setup do
      @project.file '.gitignore', 'ignored'
      @project.file 'ignored'
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      repo = Git.init(@project.to_s)
      repo.config('user.name', 'who')
      repo.config('user.email', 'who@where.com')
      repo.add('.')
      repo.commit('Initial commit')

      @gemspec = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@project, @project)
    end

    should 'populate files from git excluding ignored and .gitignore' do
      assert_equal %w(Rakefile lib/example.rb), @gemspec.files.sort
    end
  end

  context 'there are some files and is setup for git and working in a sub directory' do
    setup do
      @subproject = File.join(@project, 'subproject')
      @project.file 'Rakefile'
      @project.file 'README'
      @project.directory 'subproject' do |subproject|
        subproject.file 'README'
        subproject.directory('lib') do |lib|
          lib.file 'subproject_example.rb'
        end
      end

      repo = Git.init(@project.to_s)
      repo.config('user.name', 'who')
      repo.config('user.email', 'who@where.com')
      repo.add('.')
      repo.commit('Initial commit')

      @gemspec = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@subproject, @project)
    end

    should 'populate files from git relative to sub directory' do
      assert_equal %w(lib/subproject_example.rb README).sort, @gemspec.files.sort
    end
  end

  context 'there are some files and is not setup for git' do
    setup do
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      @gemspec = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@project, @project)
    end

    should 'not populate files' do
      assert_equal [], @gemspec.files.sort
    end
  end
end
