class Jeweler
  class Generator
    class Roodi < Plugin

      def initialize(generator)
        super

        use_inline_templates! __FILE__
        rakefile_snippets << inline_templates[:rakefile_snippet]

        development_dependencies <<  ["roodi", ">= 0"]
      end
    end
  end
end
__END__
@@ rakefile_snippet
require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end
