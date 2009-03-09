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

    # Assigns the Jeweler defaults to the Gem::Specification
    def set_jeweler_defaults(base_dir)
      Dir.chdir(base_dir) do
        self.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"] if blank?(files)
        self.executables = Dir["bin/*"].map { |f| File.basename(f) } if blank?(executables)

        self.has_rdoc = true
        rdoc_options << '--inline-source' << '--charset=UTF-8'
        self.extra_rdoc_files = FileList["README*", "ChangeLog*", "LICENSE*"] if blank?(extra_rdoc_files)
      end
    end

    private

    def blank?(value)
      value.nil? || value.empty?
    end
  end
end