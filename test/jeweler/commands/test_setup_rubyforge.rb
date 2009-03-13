require 'test_helper'

class Jeweler
  module Commands
    class TestSetupRubyforge < Test::Unit::TestCase
      #subject { Jeweler::Commands::SetupRubyforge.new }

      rubyforge_command_context "rubyforge_project is defined in gemspec and package exists on rubyforge" do
        setup do
          stub(@rubyforge).configure
          stub(@rubyforge).login
          stub(@rubyforge).create_package('myproject', 'zomg')

          stub(@gemspec).name { 'zomg' }
          stub(@gemspec).rubyforge_project { 'myproject' }

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

      rubyforge_command_context "rubyforge_project not configured" do
        setup do
          stub(@gemspec).name { 'zomg' }
          stub(@gemspec).rubyforge_project { nil }
        end

        should "raise NoRubyForgeProjectConfigured" do
          assert_raises Jeweler::NoRubyForgeProjectInGemspecError do
            @command.run
          end
        end
      end

      rubyforge_command_context "rubyforge project doesn't exist or not setup in ~/.rubyforge/autoconfig.yml" do
        setup do
          stub(@rubyforge).configure
          stub(@rubyforge).login
          stub(@rubyforge).create_package('some_project_that_doesnt_exist', 'zomg')do
            raise RuntimeError, "no <group_id> configured for <some_project_that_doesnt_exist>"
          end

          stub(@gemspec).name { 'zomg' }
          stub(@gemspec).rubyforge_project { 'some_project_that_doesnt_exist' }
        end

        should "raise RubyForgeProjectNotConfiguredError" do
          assert_raises RubyForgeProjectNotConfiguredError do
            @command.run
          end
        end 

      end


    end
  end
end
