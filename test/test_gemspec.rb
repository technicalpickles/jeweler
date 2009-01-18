require File.dirname(__FILE__) + '/test_helper'

class TestGemspec < Test::Unit::TestCase
  context "A Jeweler::GemSpec, given a gemspec" do
    setup do
      @spec = build_spec
      @helper = Jeweler::GemSpecHelper.new(@spec, File.dirname(__FILE__))
    end

    should 'have sane gemspec path' do
      assert_equal "test/#{@spec.name}.gemspec", @helper.path
    end
  end

  context "Jeweler::GemSpec#write" do
    setup do
      @spec = build_spec
      @helper = Jeweler::GemSpecHelper.new(@spec)
      FileUtils.rm_f(@helper.path)

      @helper.write
    end

    should "create gemspec file" do
      assert File.exists?(@helper.path)
    end

    should "make valid spec" do
      assert @helper.valid?
    end
  end
end
