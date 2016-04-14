require 'rake'
require 'rake/tasklib'

# Clean up after gem building
require 'rake/clean'
CLEAN.include('pkg/*.gem')

class Rake::Application
  attr_accessor :jeweler_tasks

  # The jeweler instance that has be instantiated in the current Rakefile.
  #
  # This is usually useful if you want to get at info like version from other files.
  def jeweler
    jeweler_tasks.jeweler
  end
end

class Jeweler
  # Rake tasks for managing your gem.
  #
  # Here's a basic usage example:
  #
  #   Jeweler::Tasks.new do |gem|
  #     gem.name = "jeweler"
  #     gem.summary = "Simple and opinionated helper for creating RubyGem projects on GitHub"
  #     gem.email = "josh@technicalpickles.com"
  #     gem.homepage = "http://github.com/technicalpickles/jeweler"
  #     gem.description = "Simple and opinionated helper for creating RubyGem projects on GitHub"
  #     gem.authors = ["Josh Nichols"]
  #   end
  #
  # The block variable gem is actually a Gem::Specification, so you can
  # do anything you would normally do with a Gem::Specification.
  # For more details, see the official gemspec reference:
  # http://guides.rubygems.org/specification-reference
  #
  # In addition, it provides reasonable defaults for several values. See Jeweler::Specification for more details.
  class Tasks < ::Rake::TaskLib
    attr_accessor :gemspec, :gemspec_building_block
    attr_writer :jeweler

    def initialize(gemspec = nil, &gemspec_building_block)
      @gemspec = gemspec || Gem::Specification.new
      self.gemspec_building_block = gemspec_building_block

      Rake.application.jeweler_tasks = self
      define
    end

    def jeweler
      @jeweler ||= jeweler!
    end

    private

    def jeweler!
      j = Jeweler.new(gemspec)
      gemspec_building_block.call gemspec if gemspec_building_block
      j
    end

    def yield_gemspec_set_version?
      yielded_gemspec = @gemspec.dup
      yielded_gemspec.extend(Jeweler::Specification)
      yielded_gemspec.files = FileList[]
      yielded_gemspec.extra_rdoc_files = FileList[]

      gemspec_building_block.call(yielded_gemspec) if gemspec_building_block

      !yielded_gemspec.version.nil?
    end

    def release_args
      args = {}
      args[:remote] = ENV['REMOTE']
      args[:branch] = ENV['BRANCH']
      args[:local_branch] = ENV['LOCAL_BRANCH']
      args[:remote_branch] = ENV['REMOTE_BRANCH']
      args
    end

    def define
      task :version_required do
        if jeweler.expects_version_file? && !jeweler.version_file_exist?
          abort "Expected VERSION or VERSION.yml to exist. Use 'rake version:write' to create an initial one."
        end
      end

      task :gemspec_required do
        unless File.exist?(jeweler.gemspec_helper.path)
          abort "Expected #{jeweler.gemspec_helper.path} to exist. See 'rake gemspec:write' to create it"
        end
      end

      desc 'Build gem into pkg/'
      task :build do
        jeweler.build_gem
      end

      desc 'Build and install gem using `gem install`'
      task install: [:build] do
        jeweler.install_gem
      end

      desc 'Displays the current version'
      task version: :version_required do
        $stdout.puts "Current version: #{jeweler.version}"
      end

      desc 'Release gem'
      task release: :clean do
      end

      desc 'Generate and validate gemspec'
      task gemspec: ['gemspec:generate', 'gemspec:validate']

      namespace :gemspec do
        desc 'Validates the gemspec on the filesystem'
        task validate: :gemspec_required do
          jeweler.validate_gemspec
        end

        desc 'Regenerate the gemspec on the filesystem'
        task generate: :version_required do
          jeweler.write_gemspec
        end

        desc 'Display the gemspec for debugging purposes, as jeweler knows it (not from the filesystem)'
        task :debug do
          # TODO: move to a command
          jeweler.gemspec_helper.spec.version ||= begin
                                                    jeweler.version_helper.refresh
                                                    jeweler.version_helper.to_s
                                                  end

          puts jeweler.gemspec_helper.to_ruby
        end

        desc 'Regenerate and validate gemspec, and then commits and pushes to git'
        task :release do
          jeweler.release_gemspec(release_args)
        end
      end

      task release: 'gemspec:release'

      unless yield_gemspec_set_version?
        namespace :version do
          desc 'Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH. Also recognizes BUILD, which defaults to nil'
          task :write do
            major = ENV['MAJOR'].to_i
            minor = ENV['MINOR'].to_i
            patch = ENV['PATCH'].to_i
            build = (ENV['BUILD'] || nil)
            jeweler.write_version(major, minor, patch, build, announce: false, commit: false)
            $stdout.puts "Updated version: #{jeweler.version}"
          end

          namespace :bump do
            desc 'Bump the major version by 1'
            task major: [:version_required, :version] do
              jeweler.bump_major_version
              $stdout.puts "Updated version: #{jeweler.version}"
            end

            desc 'Bump the a minor version by 1'
            task minor: [:version_required, :version] do
              jeweler.bump_minor_version
              $stdout.puts "Updated version: #{jeweler.version}"
            end

            desc 'Bump the patch version by 1'
            task patch: [:version_required, :version] do
              jeweler.bump_patch_version
              $stdout.puts "Updated version: #{jeweler.version}"
            end
          end
        end
      end

      namespace :git do
        desc 'Tag and push release to git. (happens by default with `rake release`)'
        task :release do
          jeweler.release_to_git(release_args)
        end
      end

      task release: 'git:release'

      unless File.exist?('Gemfile')
        desc 'Check that runtime and development dependencies are installed'
        task :check_dependencies do
          jeweler.check_dependencies
        end

        namespace :check_dependencies do
          desc 'Check that runtime dependencies are installed'
          task :runtime do
            jeweler.check_dependencies(:runtime)
          end

          desc'Check that development dependencies are installed'
          task :development do
            jeweler.check_dependencies(:development)
          end
        end
      end

      desc 'Start IRB with all runtime dependencies loaded'
      task :console, [:script] do |_t, args|
        # TODO: move to a command
        dirs = %w(ext lib).select { |dir| File.directory?(dir) }

        original_load_path = $LOAD_PATH

        _cmd = if File.exist?('Gemfile')
                 require 'bundler'
                 Bundler.setup(:default)
              end

        # add the project code directories
        $LOAD_PATH.unshift(*dirs)

        # clear ARGV so IRB is not confused
        ARGV.clear

        require 'irb'

        # set the optional script to run
        IRB.conf[:SCRIPT] = args.script
        IRB.start

        # return the $LOAD_PATH to it's original state
        $LOAD_PATH.reject! { |path| !original_load_path.include?(path) }
      end
    end
  end
end
