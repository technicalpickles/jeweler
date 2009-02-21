require File.dirname(__FILE__) + '/test_helper'

class TestApplication < Test::Unit::TestCase
  def run_application(*arguments)
    original_stdout = $stdout
    original_stderr = $stderr

    fake_stdout = StringIO.new
    fake_stderr = StringIO.new

    $stdout = fake_stdout
    $stderr = fake_stderr

    result = nil
    begin
      result = Jeweler::Generator::Application.run!(*arguments)
    ensure
      $stdout = original_stdout
      $stderr = original_stderr
    end

    @stdout = fake_stdout.string
    @stderr = fake_stderr.string

    result
  end

  def self.should_exit_with_code(code)
    should "exit with code #{code}" do
      assert_equal code, @result
    end
  end

  context "called without any args" do
    setup do
      @result = run_application
    end

    should_exit_with_code 1

    should 'display usage on stderr' do
      assert_match 'Usage:', @stderr
    end

    should 'not display anything on stdout' do
      assert_equal '', @stdout.squeeze.strip
    end
  end

  context "called with -h" do
    setup do
      Jeweler::Generator.any_instance.stubs(:run).raises StandardError
      assert_nothing_raised do
        @result = run_application("-h")
      end
    end

    should_exit_with_code 1

    should 'display usage on stderr' do
      assert_match 'Usage:', @stderr
    end

    should 'not display anything on stdout' do
      assert_equal '', @stdout.squeeze.strip
    end
  end

  context "when called with repo name" do
    setup do
      @options = {:testing_framework => :shoulda}
      @generator = Jeweler::Generator.new('zomg', @options)
      @generator.stubs(:run)
      Jeweler::Generator.stubs(:new).with('zomg', @options).returns(@generator)
    end

    should 'return exit code 0' do
      result = run_application("zomg")
      assert_equal 0, result
    end
    
    should 'create generator with repo name and no options' do
      Jeweler::Generator.expects(:new).with('zomg', @options).returns(@generator)

      run_application("zomg")
    end

    should 'run generator' do
      @generator.expects(:run)

      run_application("zomg")
    end

    should 'not display usage on stderr' do
      assert_no_match /Usage:/, @stderr
    end
  end

end
