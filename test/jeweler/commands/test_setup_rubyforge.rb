require 'test_helper'

class Jeweler
  module Commands
    class TestSetupRubyforge < Test::Unit::TestCase

      context "rubyforge_project is defined in gemspec and package exists on rubyforge" do
        setup do
          @rubyforge = RubyForgeStub.new
          stub(@rubyforge).configure
          stub(@rubyforge).login
          stub(@rubyforge).create_package('myproject', 'zomg')

          @gemspec = Object.new
          stub(@gemspec).name { 'zomg' }
          stub(@gemspec).rubyforge_project { 'myproject' }

          @output = StringIO.new

          @command = Jeweler::Commands::SetupRubyforge.new
          @command.output = @output
          @command.gemspec = @gemspec
          @command.rubyforge = @rubyforge

          @command.run
        end

        should "configure rubyforge" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.configure}
        end

        should "login to rubyforge" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.login}
        end

        should "create zomg package to myproject on rubyforge" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.create_package('myproject', 'zomg') }
        end
      end

    end
  end
end
