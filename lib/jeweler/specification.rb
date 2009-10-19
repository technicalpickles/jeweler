require 'rubygems/specification'

class Jeweler
  # Extend a Gem::Specification instance with this module to give it Jeweler
  # super-cow powers.
  #
  # [files] a Rake::FileList of anything that is in git and not gitignored. You can include/exclude this default set, or override it entirely
  # [test_files] Similar to gem.files, except it's only things under the spec, test, or examples directory.
  # [extra_rdoc_files] a Rake::FileList including files like README*, ChangeLog*, and LICENSE*
  # [executables] uses anything found in the bin/ directory. You can override this.
  module Specification

    def self.filelist_attribute(name)
      code = %{
        def #{name}
          @#{name} ||= FileList[]
        end
        def #{name}=(value)
          @#{name} = FileList[value]
        end
      }

      module_eval code, __FILE__, __LINE__ - 9
    end

    filelist_attribute :files
    filelist_attribute :test_files
    filelist_attribute :extra_rdoc_files

    # Assigns the Jeweler defaults to the Gem::Specification
    def set_jeweler_defaults(base_dir, git_base_dir = nil)
      Dir.chdir(base_dir) do
        require 'git'
        if blank?(files) && git_base_dir
          git_subdir = File.expand_path(base_dir).sub(File.join(File.expand_path(git_base_dir), ""), "")          
          repo = Git.open(git_base_dir)
          self.files = (repo.ls_files.keys - repo.lib.ignored_files).map {|fn| fn.sub(File.join(git_subdir, ""), "")}
        end

        if blank?(test_files) && File.directory?(File.join(base_dir, '.git'))
          repo = Git.open(base_dir)
          self.test_files = FileList['{spec,test,examples}/**/*.rb'] - repo.lib.ignored_files
        end

        if blank?(executables)
          self.executables = Dir["bin/*"].map { |f| File.basename(f) }
        end

        self.has_rdoc = true
        rdoc_options << '--charset=UTF-8'

        if blank?(extra_rdoc_files)
          self.extra_rdoc_files = FileList["README*", "ChangeLog*", "LICENSE*"]
        end
      end
    end

    # Used by Specification#to_ruby to generate a ruby-respresentation of a Gem::Specification
    def ruby_code(obj)
      require 'rake'
      case obj
      when Rake::FileList then obj.to_a.inspect
      else super
      end
    end

    JEWELER_PROVIDED_ATTRIBUTES = [
      :has_rdoc,
      :date

    ]
    def to_jeweler_tasks
      mark_version
      result = []
      result << "require 'jeweler'"
      result << "Jeweler::Tasks.new do |gemspec|"
      result << "  gemspec.name = #{ruby_code name}"
      result << "  gemspec.version = #{ruby_code version}"
      unless platform.nil? or platform == Gem::Platform::RUBY then
        result << "  gemspec.platform = #{ruby_code original_platform}"
      end

      handled = [
        :dependencies,
        :name,
        :platform,
        :required_rubygems_version,
        :specification_version,
        :version,
      ]

      baseline_gemspec = Gem::Specification.new

      attributes = self.class.attribute_names.sort_by { |attr_name,| attr_name.to_s }

      attributes.each do |attr_name, default|
        next if handled.include? attr_name
        current_value = self.send(attr_name)
        baseline_value = baseline_gemspec.send(attr_name)
        if current_value != default  && current_value != baseline_value
          result << "  gemspec.#{attr_name} = #{ruby_code current_value}"
        end
      end

      unless dependencies.empty? then
        result << ""
        dependencies.each do |dep|
          version_reqs_param = dep.requirements_list.inspect
          dep.instance_variable_set :@type, :runtime if dep.type.nil? # HACK
          result << "  gemspec.add_#{dep.type}_dependency(%q<#{dep.name}>, #{version_reqs_param})"
        end
      end

      result << "end"
      result << nil

      result.join "\n"
    end

    private

    def blank?(value)
      value.nil? || value.empty?
    end
  end
end
