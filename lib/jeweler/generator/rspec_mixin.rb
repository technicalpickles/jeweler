class Jeweler
  class Generator
    module RspecMixin

      def default_task
        'spec'
      end

      def feature_support_require
        'spec/expectations'
      end

      def feature_support_extend
        nil # Cucumber is smart enough extend Spec::Expectations on its own
      end

      def test_dir
        'spec'
      end

      def test_or_spec
        'spec'
      end

      def test_task
        'spec'
      end

    end
  end
end
