require 'jeweler/generator/shindo_mixin'
class Jeweler
  class Generator
    module TestingFrameworks
      class Shindo < Base
        def initialize(generator)
          super
          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
        end
      end
    end
  end
end

__END__
@@ rakefile_snippet
require 'shindo/rake'
Shindo::Rake.new
