class Jeweler
  class Generator
    class Cucumber < Plugin

      def initialize(generator)
        super

        rakefile_snippets << <<-END
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)
END
      end

      def run
        template File.join(%w(features default.feature)), File.join('features', feature_filename)

        template File.join(features_support_dir, 'env.rb')

        create_file           File.join(features_steps_dir, steps_filename)
        
      end
    end
  end
end
