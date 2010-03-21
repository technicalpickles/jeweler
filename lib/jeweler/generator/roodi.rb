class Jeweler
  class Generator
    class Roodi < Plugin

      class_option :roodi, :type => :boolean, :default => false,
        :desc => 'generate rake task for roodi'

      def initialize(generator)
        super

        use_inline_templates! __FILE__
        rakefile_snippets << lookup_inline_template(:rakefile_snippet)

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
