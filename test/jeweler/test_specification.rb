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
                Gem::Specification.new()
              end
    gemspec.extend(Jeweler::Specification)
    gemspec
  end

  context "basic defaults" do
    setup do
      @gemspec = build_jeweler_gemspec
    end

    should "make files a FileList" do
      assert_equal FileList, @gemspec.files.class
    end

    should "make test_files a FileList" do
      assert_equal FileList, @gemspec.test_files.class
    end

    should "make extra_rdoc_files a FileList" do
      assert_equal FileList, @gemspec.extra_rdoc_files.class
    end

    should "enable rdoc" do
      assert @gemspec.has_rdoc
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


      should "have empty gemspec executables" do
        assert_equal [], @gemspec.executables
      end
    end

    context "and has been previously set executables" do
      setup do
        @gemspec  = build_jeweler_gemspec do |gemspec|
          gemspec.executables = %w(non-existant)
        end
        @gemspec.set_jeweler_defaults(@project)
      end

      should "have only the original executables in the gemspec" do
        assert_equal %w(non-existant), @gemspec.executables
      end
    end
  end

  context "there are multiple executables in the project directory" do
    setup do
      @project.directory('bin') do |bin|
        bin.file 'burnination'
        bin.file 'trogdor'
      end
    end

    context "and there hasn't been any set on the gemspec" do
      setup do
        @gemspec  = build_jeweler_gemspec
        @gemspec.set_jeweler_defaults(@project)
      end

      should "have the executables in the gemspec" do
        assert_equal %w(burnination trogdor), @gemspec.executables
      end
    end
    context "and has been previously set executables" do
      setup do
        @gemspec  = build_jeweler_gemspec do |gemspec|
          gemspec.executables = %w(burnination)
        end
        @gemspec.set_jeweler_defaults(@project)
      end
      should "have only the original executables in the gemspec" do
        assert_equal %w(burnination), @gemspec.executables
      end
    end
  end

  context "there are some files and is setup for git" do
    setup do
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      repo = Git.init(@project)
      repo.add('.')
      repo.commit('Initial commit')


      @gemspec  = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@project, @project)
    end

    should "populate files from git" do
      assert_equal %w(Rakefile lib/example.rb), @gemspec.files
    end
  end

  context "there are some files and is setup for git with ignored files" do
    setup do
      @project.file '.gitignore', 'ignored'
      @project.file 'ignored'
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      repo = Git.init(@project)
      repo.add('.')
      repo.commit('Initial commit')


      @gemspec  = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@project, @project)
    end

    should "populate files from git excluding ignored" do
      assert_equal %w(.gitignore Rakefile lib/example.rb), @gemspec.files
    end
  end

  context "there are some files and is setup for git and working in a sub directory" do
    setup do
      @subproject = File.join(@project, 'subproject')
      @project.file 'Rakefile'
      @project.directory 'subproject' do |subproject|
        subproject.directory('lib') do |lib|
          lib.file 'subproject_example.rb'
        end
      end

      repo = Git.init(@project)
      repo.add('.')
      repo.commit('Initial commit')

      @gemspec  = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@subproject, @project)
    end

    should "populate files from git relative to sub directory" do
      assert_equal %w(lib/subproject_example.rb).sort, @gemspec.files.sort
    end
  end

  context "there are some files and is not setup for git" do
    setup do
      @project.file 'Rakefile'
      @project.directory('lib') do |lib|
        lib.file 'example.rb'
      end

      @gemspec  = build_jeweler_gemspec
      @gemspec.set_jeweler_defaults(@project, @project)
    end

    should "not populate files" do
      assert_equal [], @gemspec.files.sort
    end
  end

  #context "Gem::Specification with Jeweler monkey-patches" do
  #  setup do
  #    remove_tmpdir!
  #    path = File.join(FIXTURE_DIR, "existing-project-with-version-yaml")
  #    Git.init(path)
  #    FileUtils.cp_r path, tmp_dir

  #    @spec = Gem::Specification.new
  #    @spec.extend(Jeweler::Specification)

  #  end

  #  context "when setting defaults" do
  #    setup do
  #      @spec.set_jeweler_defaults(tmp_dir)
  #    end

  #    should_eventually "should populate `files'" do
  #      assert_equal %w{Rakefile VERSION.yml bin/foo_the_ultimate_bin lib/foo_the_ultimate_lib.rb }, @spec.files.sort
  #    end

  #    context "with values already set" do
  #      setup do
  #        @spec.files = %w{ hey_include_me_in_gemspec }
  #        @spec.set_jeweler_defaults(fixture_dir)
  #      end

  #      should "not re-populate `files'" do
  #        assert_equal %w{ hey_include_me_in_gemspec }, @spec.files
  #      end
  #    end
  #  end

  #end
end
