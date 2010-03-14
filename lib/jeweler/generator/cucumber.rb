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
        template File.join(%w(features default.feature)), File.join('features', feature_filename)

        template File.join(features_support_dir, 'env.rb')

        create_file           File.join(features_steps_dir, steps_filename)
      end

      def method_missing(meth, *args, &block)
        testing_framework.send(meth, *args, &block)
      end

      protected

      def features_dir
        'features'
      end

      def features_support_dir
        File.join(features_dir, 'support')
      end

      def features_steps_dir
        File.join(features_dir, 'step_definitions')
      end
    end
  end
end
