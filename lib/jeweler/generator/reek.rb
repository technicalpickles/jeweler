class Jeweler
  class Generator
    class Reek < Plugin

      def initialize(generator)
        super
        
        rakefile_snippets << <<-END
require 'reek/adapters/rake_task'
Reek::RakeTask.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end
END
      end
    end
  end
end
