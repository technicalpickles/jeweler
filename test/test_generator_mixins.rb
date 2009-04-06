require 'test_helper'

class TestGeneratorMixins < Test::Unit::TestCase

  [Jeweler::Generator::BaconMixin, Jeweler::Generator::MicronautMixin,
   Jeweler::Generator::RspecMixin, Jeweler::Generator::ShouldaMixin,
   Jeweler::Generator::TestunitMixin, Jeweler::Generator::MinitestMixin].each do |mixin|
    context "#{mixin}" do
      %w(default_task feature_support_require feature_support_extend
         test_dir test_or_spec).each do |method|
          should "define #{method}" do
            assert mixin.method_defined?(method)
          end
       end
    end
   end
end
