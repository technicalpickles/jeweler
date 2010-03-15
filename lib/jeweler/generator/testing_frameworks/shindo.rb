class Jeweler
  class Generator
    module TestingFrameworks
      class Shindo < Base
        def initialize(generator)
          super
          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
          development_dependencies << ["shindo", ">= 0"]
        end

        def default_rake_task
          'tests'
        end

        def feature_support_require
          # 'test/unit/assertions'
          nil
        end

        def feature_support_extend
          # 'Test::Unit::Assertions'
          nil
        end

        def test_dir
          'tests'
        end

        def test_task
          'tests'
        end

        def test_pattern
          'tests/**/*_tests.rb'
        end

        def test_filename
          "#{require_name}_tests.rb"
        end

        def test_helper_filename
          "tests_helper.rb"
        end
      end
    end
  end
end

__END__
@@ rakefile_snippet
require 'shindo/rake'
Shindo::Rake.new
