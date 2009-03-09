require 'test_helper'

class TestSpecification < Test::Unit::TestCase
  def setup
    @spec = Gem::Specification.new
  end

  context 'Gem::Specification with Jeweler monkey-patches' do
    should 'allow the user to concat files to the existing #files array' do
      @spec.files << 'foo'
      @spec.files << 'bar'

      assert_equal %w{ foo bar }, @spec.files
    end
  end
end