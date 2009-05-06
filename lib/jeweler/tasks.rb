require 'rake'
require 'rake/tasklib'

class Rake::Application
  attr_accessor :jeweler
end

class Jeweler
  class Tasks < ::Rake::TaskLib
    attr_accessor :gemspec, :jeweler

    def initialize(gemspec = nil, &block)
      @gemspec = gemspec || Gem::Specification.new
      @jeweler = Jeweler.new(@gemspec)
      yield @gemspec if block_given?

      Rake.application.jeweler = @jeweler
      define
    end

  private
    def define
      desc "Setup initial version of 0.0.0"
      task :version_required do
        unless jeweler.version_exists?
          abort "Expected VERSION or VERSION.yml to exist. See version:write to create an initial one."
        end
      end

      desc "Build gem"
      task :build do
        jeweler.build_gem
      end

      desc "Install gem using sudo"
      task :install => :build do
        jeweler.install_gem
      end

      desc "Generate and validates gemspec"
      task :gemspec => ['gemspec:generate', 'gemspec:validate']

      namespace :gemspec do
        desc "Validates the gemspec"
        task :validate => :version_required do
          jeweler.validate_gemspec
        end

        desc "Generates the gemspec, using version from VERSION"
        task :generate => :version_required do
          jeweler.write_gemspec
        end
      end

      desc "Displays the current version"
      task :version => :version_required do
        $stdout.puts "Current version: #{jeweler.version}"
      end

      namespace :version do
        desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH"
        task :write do
          major, minor, patch = ENV['MAJOR'].to_i, ENV['MINOR'].to_i, ENV['PATCH'].to_i
          jeweler.write_version(major, minor, patch, :announce => false, :commit => false)
          $stdout.puts "Updated version: #{jeweler.version}"
        end

        namespace :bump do
          desc "Bump the gemspec by a major version."
          task :major => [:version_required, :version] do
            jeweler.bump_major_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end

          desc "Bump the gemspec by a minor version."
          task :minor => [:version_required, :version] do
            jeweler.bump_minor_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end

          desc "Bump the gemspec by a patch version."
          task :patch => [:version_required, :version] do
            jeweler.bump_patch_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end
        end
      end

      desc "Release the current version. Includes updating the gemspec, pushing, and tagging the release"
      task :release do
        jeweler.release
      end
      
      namespace :rubyforge do
        namespace :release do
          desc "Release the current gem version to RubyForge."
          task :gem => [:gemspec, :build] do
            begin
              jeweler.release_gem_to_rubyforge
            rescue NoRubyForgeProjectInGemspecError => e
              abort "Setting up RubyForge requires that you specify a 'rubyforge_project' in your Jeweler::Tasks declaration"
            rescue MissingRubyForgePackageError => e
              abort "Rubyforge reported that the #{e.message} package isn't setup. Run rake rubyforge:setup to do so."
            rescue RubyForgeProjectNotConfiguredError => e
              abort "RubyForge reported that #{e.message} wasn't configured. This means you need to run 'rubyforge setup', 'rubyforge login', and 'rubyforge configure', or maybe the project doesn't exist on RubyForge"
            end
          end
        end

        desc "Setup a rubyforge project for this gem"
        task :setup do
          begin 
            jeweler.setup_rubyforge
          rescue NoRubyForgeProjectInGemspecError => e
            abort "Setting up RubyForge requires that you specify a 'rubyforge_project' in your Jeweler::Tasks declaration"
          rescue RubyForgeProjectNotConfiguredError => e
            abort "The RubyForge reported that #{e.message} wasn't configured. This means you need to run 'rubyforge setup', 'rubyforge login', and 'rubyforge configure', or maybe the project doesn't exist on RubyForge"
          end
        end

      end
    end
  end
end
