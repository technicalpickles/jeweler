require 'test_helper'

class Jeweler
  module Commands
    class TestRelease < Test::Unit::TestCase

      context "with added files" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)

          status = Object.new
          stub(status).added { ['README'] }
          stub(status).deleted { [] }
          stub(status).changed { [] }
          stub(@repo).status { status }

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'
        end

        should 'raise error' do
          assert_raises RuntimeError, /try commiting/i do
            @command.run
          end
        end
      end

      context "with deleted files" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)

          status = Object.new
          stub(status).added { [] }
          stub(status).deleted { ['README'] }
          stub(status).changed { [] }
          stub(@repo).status { status }

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'
        end

        should 'raise error' do
          assert_raises RuntimeError, /try commiting/i do
            @command.run
          end
        end
      end

      context "with changed files" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)

          status = Object.new
          stub(status).added { [] }
          stub(status).deleted { [] }
          stub(status).changed { ['README'] }
          stub(@repo).status { status }

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'
        end

        should 'raise error' do
          assert_raises RuntimeError, /try commiting/i do
            @command.run
          end
        end
      end

      context "after running without pending changes" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)
          stub(@repo).add(anything)
          stub(@repo).commit(anything)
          stub(@repo).push
          stub(@repo).push(anything)
          stub(@repo).add_tag(anything)

          @gemspec_helper = Object.new
          stub(@gemspec_helper).write
          stub(@gemspec_helper).path {'zomg.gemspec'}

          status = Object.new
          stub(status).added { [] }
          stub(status).deleted { [] }
          stub(status).changed { [] }
          stub(@repo).status { status }

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'

          @command.run
        end

        should "checkout master" do
          assert_received(@repo) {|repo| repo.checkout('master') }
        end

        should "write gemspec" do
          assert_received(@gemspec_helper) {|gemspec_helper| gemspec_helper.write }

        end

        should "add gemspec to repository" do
          assert_received(@repo) {|repo| repo.add('zomg.gemspec') }
        end

        should "commit with commit message including version" do
          assert_received(@repo) {|repo| repo.commit("Regenerated gemspec for version 1.2.3") }
        end

        should "push repository" do
          assert_received(@repo) {|repo| repo.push }
        end

        should "tag release" do
          assert_received(@repo) {|repo| repo.add_tag("v1.2.3")}
        end

        should "push tag to repository" do
          assert_received(@repo) {|repo| repo.push('origin', 'v1.2.3')}
        end
      end

    end
  end
end
