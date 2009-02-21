require 'test_helper'

class TestOptions < Test::Unit::TestCase

  def self.should_have_testing_framework(testing_framework)
    should "use #{testing_framework} for testing" do
      assert_equal testing_framework.to_sym, @options[:testing_framework]
    end
  end

  def setup_options(*arguments)
    @options = Jeweler::Generator::Options.new(arguments)
  end

  def self.for_options(*options)
    context options.join(' ') do
      setup { setup_options *options }
      yield
    end
  end

  context "default options" do
    setup { setup_options }
    should_have_testing_framework :shoulda
    should 'not create repository' do
      assert ! @options[:create_repo]
    end
  end

  for_options '--shoulda' do
    should_have_testing_framework :shoulda
  end

  for_options "--bacon" do
    should_have_testing_framework :bacon
  end

  for_options "--testunit" do
    should_have_testing_framework :testunit
  end

  for_options '--minitest' do
    should_have_testing_framework :minitest
  end

  for_options '--rspec' do
    should_have_testing_framework :rspec
  end

  for_options '--cucumber' do
    should 'enable cucumber' do
      assert_equal true, @options[:use_cucumber]
    end
  end

  for_options '--create-repo' do
    should 'create repository' do
      assert @options[:create_repo]
    end
  end

  for_options '--summary', 'zomg so awesome' do
    should 'have summary zomg so awesome' do
      assert_equal 'zomg so awesome', @options[:summary]
    end
  end

  for_options '--directory', 'foo' do
    should 'have directory foo' do
      assert_equal 'foo', @options[:directory]
    end
  end

  for_options '--help' do
    should 'show help' do
      assert @options[:show_help]
    end
  end

  for_options '-h' do
    should 'show help' do
      assert @options[:show_help]
    end
  end

end
