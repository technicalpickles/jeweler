require File.dirname(__FILE__) + '/test_helper'

class GemspecTest < Test::Unit::TestCase
  context "A Jeweler::GemSpec, given a gemspec" do
    setup do
      @spec = build_spec
      @gemspec = Jeweler::GemSpec.new(@spec, File.dirname(__FILE__))
    end

    should 'have sane gemspec path' do
      assert_equal "test/#{@spec.name}.gemspec", @gemspec.path
    end
  end

  context "Jeweler::GemSpec#write" do
    setup do
      @spec = build_spec
      @gemspec = Jeweler::GemSpec.new(@spec)
      FileUtils.rm_f(@gemspec.path)

      @gemspec.write
    end

    should "create gemspec file" do
      assert File.exists?(@gemspec.path)
    end

    should "make valid spec" do
      assert @gemspec.valid?
    end
  end
end
