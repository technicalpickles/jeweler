require 'rubygems/specification'

class Jeweler
  # Extend a Gem::Specification instance with this module to give it Jeweler
  # super-cow powers.
  module Specification
    # Return the `files' array _without_ duplicating it as the normal behaviour
    # of Gem::Specification is.
    def files
      @files
    end

    # Sets the 'files' array _without_ wrapping it as an Array, in order to keep it as a FileList
    def files=(value)
      @files = FileList.new(value)
    end

    def ruby_code(obj)
      case obj
      when Rake::FileList then obj.to_a.inspect
      else super
      end
    end

    # Assigns the Jeweler defaults to the Gem::Specification
    def set_jeweler_defaults(base_dir)
      Dir.chdir(base_dir) do
        if blank?(files)
          self.files = FileList["[A-Z]*.*", "{bin,examples,generators,lib,rails,spec,test}/**/*", 'Rakefile', 'LICENSE*']
        end

        if blank?(test_files)
          self.test_files = FileList['{spec,test,examples}/**/*.rb']
        end

        if blank?(executable)
          self.executables = Dir["bin/*"].map { |f| File.basename(f) }
        end

        self.has_rdoc = true
        rdoc_options << '--charset=UTF-8'

        if blank?(extra_rdoc_files)
          self.extra_rdoc_files = FileList["README*", "ChangeLog*", "LICENSE*"]
        end
      end
    end

    private

    def blank?(value)
      value.nil? || value.empty?
    end
  end
end
