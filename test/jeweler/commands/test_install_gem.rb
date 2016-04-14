require 'test_helper'

class Jeweler
  module Commands
    class TestInstallGem < Test::Unit::TestCase
      rubyforge_command_context 'running' do
        setup do
          stub(@gemspec_helper).gem_path { 'pkg/zomg-1.1.1.gem' }
          stub(@command).gem_command { 'ruby -S gem' }
          stub(@command).sh

          @command.run
        end

        should 'call sh with gem install' do
          assert_received(@command) { |command| command.sh 'ruby -S gem install pkg/zomg-1.1.1.gem' }
        end
      end

      build_command_context 'build for jeweler' do
        setup do
          @command = Jeweler::Commands::InstallGem.build_for(@jeweler)
        end

        should 'assign gemspec helper' do
          assert_equal @gemspec_helper, @command.gemspec_helper
        end

        should 'assign output' do
          assert_equal @output, @command.output
        end
      end
    end
  end
end
