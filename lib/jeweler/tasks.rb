require 'rake'
require 'rake/tasklib'

class Jeweler
  class Tasks < ::Rake::TaskLib
    attr_accessor :gemspec, :jeweler

    def initialize(gemspec = nil, &block)
      @gemspec = gemspec || Gem::Specification.new()
      yield @gemspec if block_given?

      @jeweler = Jeweler.new(@gemspec)

      define
    end

  private
    def define
      desc "Setup initial version of 0.0.0"
      file "VERSION.yml" do
        @jeweler.write_version 0, 0, 0, :commit => false
        $stdout.puts "Created VERSION.yml: 0.0.0"
      end

      desc "Build gem"
      task :build do
        @jeweler.build_gem
      end

      desc "Install gem using sudo"
      task :install => :build do
        @jeweler.install_gem
      end

      desc "Generate and validates gemspec"
      task :gemspec => ['gemspec:generate', 'gemspec:validate']

      namespace :gemspec do
        desc "Validates the gemspec"
        task :validate => 'VERSION.yml' do
          @jeweler.validate_gemspec
        end

        desc "Generates the gemspec, using version from VERSION.yml"
        task :generate => 'VERSION.yml' do
          @jeweler.write_gemspec
        end
      end

      desc "Displays the current version"
      task :version => 'version:setup' do
        $stdout.puts "Current version: #{@jeweler.version}"
      end

      namespace :version do
        desc "Setup initial version of 0.0.0"
        task :setup => "VERSION.yml"

        desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH"
        task :write do
          major, minor, patch = ENV['MAJOR'].to_i, ENV['MINOR'].to_i, ENV['PATCH'].to_i
          @jeweler.write_version(major, minor, patch, :announce => false, :commit => false)
          $stdout.puts "Updated version: #{@jeweler.version}"
        end

        namespace :bump do
          desc "Bump the gemspec by a major version."
          task :major => ['VERSION.yml', :version] do
            @jeweler.bump_major_version
            $stdout.puts "Updated version: #{@jeweler.version}"
          end

          desc "Bump the gemspec by a minor version."
          task :minor => ['VERSION.yml', :version] do
            @jeweler.bump_minor_version
            $stdout.puts "Updated version: #{@jeweler.version}"
          end

          desc "Bump the gemspec by a patch version."
          task :patch => ['VERSION.yml', :version] do
            @jeweler.bump_patch_version
            $stdout.puts "Updated version: #{@jeweler.version}"
          end
        end
      end

      desc "Release the current version. Includes updating the gemspec, pushing, and tagging the release"
      task :release do
        @jeweler.release
      end
      
      namespace :rubyforge do
        desc "Release the current gem version to RubyForge."
        task :release do
          @jeweler.release_gem_to_rubyforge
        end

        desc "Setup a rubyforge project for this gem"
        task :setup do
          begin 
            @jeweler.setup_rubyforge
          rescue NoRubyForgeProjectInGemspecError => e
            abort "Setting up RubyForge requires that you specify a 'rubyforge_project' in your Jeweler::Tasks declaration"
          end
        end

      end
    end
  end
end
