require 'test_helper'

class Jeweler
  module Commands
    module Version
      class TestBase < Test::Unit::TestCase
        build_command_context 'build for jeweler' do
          setup do
            @command = Jeweler::Commands::Version::Base.build_for(@jeweler)
          end

          should 'assign repo' do
            assert_equal @repo, @command.repo
          end

          should 'assign version_helper' do
            assert_equal @version_helper, @command.version_helper
          end

          should 'assign gemspec' do
            assert_equal @gemspec, @command.gemspec
          end

          should 'assign commit' do
            assert_equal @commit, @command.commit
          end

          context 'commit_version' do
            setup do
              @dir = Object.new
              stub(@repo).dir { @dir }
              stub(@dir).path { Dir.pwd }
              stub(@version_helper).path { Pathname.new 'VERSION' }
              stub(@version_helper).to_s { '1.0.0' }
              stub(@repo) do
                add(anything)
                commit(anything)
              end
              @command.base_dir = Dir.pwd
              @command.commit_version
            end

            should 'add VERSION' do
              assert_received(@repo) { |repo| repo.add('VERSION') }
              assert_received(@repo) { |repo| repo.commit('Version bump to 1.0.0') }
            end
          end
        end
      end
    end
  end
end
