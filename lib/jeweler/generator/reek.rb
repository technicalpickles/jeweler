class Jeweler
  class Generator
    class Reek < Plugin

      class_option :reek, :type => :boolean, :default => false,
        :desc => 'generate rake task for reek'

      def initialize(generator)
        super

        use_inline_templates! __FILE__
        rakefile_snippets << lookup_inline_template(:rakefile_snippet)

        development_dependencies << ["reek", ">= 0"] 
      end
    end
  end
end
__END__
@@ rakefile_snippet
require 'reek/adapters/rake_task'
Reek::RakeTask.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end
