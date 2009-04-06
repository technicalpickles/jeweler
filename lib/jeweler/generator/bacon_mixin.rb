class Jeweler
  class Generator
    module BaconMixin

      def default_task
        'spec'
      end

      def feature_support_require
        'test/unit/assertions'
      end

      def feature_support_extend
        'Test::Unit::Assertions' # NOTE can't use bacon inside of cucumber actually
      end

      def test_dir
        'spec'
      end

      def test_or_spec
        'spec'
      end

    end
  end
end
