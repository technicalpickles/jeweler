require 'jeweler/generator/rspec_mixin'
class Jeweler
  class Generator
    module TestingFrameworks
      class Rspec < Base
        def initialize(generator)
          super

          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
        end

        def run
          super

          template 'rspec/spec.opts', 'spec/spec.opts'
        end
      end
    end
  end
end
__END__
@@ rakefile_snippet
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end
