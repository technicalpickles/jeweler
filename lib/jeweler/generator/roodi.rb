class Jeweler
  class Generator
    class Roodi < Plugin

      def initialize(generator)
        super

        rakefile_snippets << <<-END
require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end
        END

        development_dependencies <<  ["roodi", ">= 0"]
      end
    end
  end
end
