require 'test_helper'

class Jeweler
  module Commands
    class TestInstallGem < Test::Unit::TestCase
      build_command_context "build for jeweler" do
        setup do
          @command = Jeweler::Commands::InstallGem.build_for(@jeweler)
        end

        should "assign gemspec helper" do
          assert_equal @gemspec_helper, @command.gemspec_helper
        end

        should "assign output" do
          assert_equal @output, @command.output
        end
      end
    end
  end
end
