class Jeweler
  class Generator
    module TestingFrameworks
      class Micronaut < Base
        def initialize(generator)
          super

          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
          development_dependencies << ["micronaut", ">= 0"]
        end

        def default_rake_task
          'examples'
        end

        def feature_support_require
          'micronaut/expectations'
        end

        def feature_support_extend
          'Micronaut::Matchers'
        end

        def test_dir
          'examples'
        end

        def test_task
          'examples'
        end

        def test_pattern
          'examples/**/*_example.rb'
        end

        def test_filename
          "#{require_name}_example.rb"
        end

        def test_helper_filename
          "example_helper.rb"
        end
      end
    end
  end
end

__END__
@@ rakefile_snippet
require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamples'
end
Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.rcov_opts = '-Ilib -Iexamples'
  examples.rcov = true
end
