class Jeweler
  class Generator
    class Cucumber < Plugin
      attr_accessor :testing_framework

      def initialize(generator, testing_framework)
        super(generator)
        self.testing_framework = testing_framework

        rakefile_snippets << <<-END
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)
END

        development_dependencies << ["cucumber", ">= 0"]
      end

      def run
        template "features/default.feature", "features/#{project_name}.feature"
        template "features/support/env.rb"
        create_file "features/step_definitions/#{project_name}_steps.rb"
      end

      def method_missing(meth, *args, &block)
        testing_framework.send(meth, *args, &block)
      end
    end
  end
end
