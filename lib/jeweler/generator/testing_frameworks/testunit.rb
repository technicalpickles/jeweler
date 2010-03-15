class Jeweler
  class Generator
    module TestingFrameworks
      class Testunit < Testunitish
        def default_rake_task
          'test'
        end

        def feature_support_require
          'test/unit/assertions'
        end

        def feature_support_extend
          'Test::Unit::Assertions'
        end

        def test_dir
          'test'
        end

        def test_task
          'test'
        end

        def test_pattern
          'test/**/test_*.rb'
        end

        def test_filename
          "test_#{require_name}.rb"
        end

        def test_helper_filename
          "helper.rb"
        end
      end
    end
  end
end
