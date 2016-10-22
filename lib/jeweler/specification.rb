
require 'rubygems/specification'

class Jeweler
  # Extend a Gem::Specification instance with this module to give it Jeweler
  # super-cow powers.
  #
  # [files] a Rake::FileList of anything that is in git and not gitignored. You can include/exclude this default set, or override it entirely
  # [extra_rdoc_files] a Rake::FileList including files like README*, ChangeLog*, and LICENSE*
  # [executables] uses anything found in the bin/ directory.
  module Specification
    def self.filelist_attribute(name)
      code = %{
        def #{name}
          if @#{name} && @#{name}.class != FileList
            @#{name} = FileList[@#{name}]
          end
          @#{name} ||= FileList[]
        end
        def #{name}=(value)
          @#{name} = FileList[value]
        end
      }

      module_eval code, __FILE__, __LINE__ - 9
    end

    filelist_attribute :files
    filelist_attribute :extra_rdoc_files

    # Assigns the Jeweler defaults to the Gem::Specification
    def set_jeweler_defaults(base_dir, git_base_dir = nil)
      base_dir = File.expand_path(base_dir)
      git_base_dir = if git_base_dir
                       File.expand_path(git_base_dir)
                     else
                       base_dir
                     end
      can_git = git_base_dir && base_dir.include?(git_base_dir) && File.directory?(File.join(git_base_dir, '.git'))

      Dir.chdir(git_base_dir) do
        repo = if can_git
                 require 'git'
                 Git.open(git_base_dir)
               end

        if blank?(files) && repo
          base_dir_with_trailing_separator = File.join(base_dir, '')

          ignored_files = repo.lib.ignored_files + ['.gitignore']
          self.files = (repo.ls_files(base_dir).keys - ignored_files).compact.map do |file|
            File.expand_path(file).sub(base_dir_with_trailing_separator, '')
          end
        end

        if blank?(executables) && repo
          self.executables = (repo.ls_files(File.join(base_dir, 'bin')).keys - repo.lib.ignored_files).map do |file|
            File.basename(file)
          end
        end

        if blank?(extensions)
          self.extensions = FileList['ext/**/{extconf,mkrf_conf}.rb']
        end

        if blank?(extra_rdoc_files)
          self.extra_rdoc_files = FileList['README*', 'ChangeLog*', 'LICENSE*', 'TODO']
        end

        if File.exist?('Gemfile')
          require 'bundler'
          bundler_runtime = Bundler.load
          bundler_dependencies_for(bundler_runtime, :default, :runtime).each do |dependency|
            add_dependency dependency.name, *dependency.requirement.as_list
          end
          bundler_dependencies_for(bundler_runtime, :development).each do |dependency|
            add_development_dependency dependency.name, *dependency.requirement.as_list
          end
        end
      end
    end

    # Used by Specification#to_ruby to generate a ruby-respresentation of a Gem::Specification
    def ruby_code(obj)
      case obj
      when Rake::FileList then obj.uniq.to_a.inspect
      else super
      end
    end

    private

    # Backported (or rather forward-ported) from Bunder::Runtime#dependencies_for.
    # This method was available until Bundler 1.13, and then removed. We need it
    # to be able to tell which gems are listed in the Gemfile without loading
    # those gems first.
    def bundler_dependencies_for(bundler_runtime, *groups)
      if groups.empty?
        bundler_runtime.dependencies
      else
        bundler_runtime.dependencies.select {|d| (groups & d.groups).any? }
      end
    end

    def blank?(value)
      value.nil? || value.empty?
    end
  end
end

# Workaround for cloning/duping a Gem::Specification
# documented in http://github.com/technicalpickles/jeweler/issues#issue/73
Gem::Specification.class_eval do
  # TODO: fix 'warning: method redefined; discarding old initialize_copy'
  def initialize_copy(original)
    super

    self.files = original.files.to_a
    self.extra_rdoc_files = original.extra_rdoc_files.to_a
  end
end
