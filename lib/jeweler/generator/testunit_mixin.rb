class Jeweler
  class Generator
    module TestunitMixin

      def default_task
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

      def test_or_spec
        'test'
      end

      def test_task
        'test'
      end

      def test_pattern
        'test/**/*_test.rb'
      end

      def test_filename
        "#{require_name}_test.rb"
      end

    end
  end
end
