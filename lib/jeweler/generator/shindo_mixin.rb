class Jeweler
  class Generator
    module ShindoMixin
      def self.extended(generator)
        generator.development_dependencies << ['shindo', '>= 0']
      end

      def default_task
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
        'tests_helper.rb'
      end
    end
  end
end
