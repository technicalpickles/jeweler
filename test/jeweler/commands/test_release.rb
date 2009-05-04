require 'test_helper'

class Jeweler
  module Commands
    class TestRelease < Test::Unit::TestCase

      context "with added files" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)

          status = Object.new
          stub(status) do
            added { ['README'] }
            deleted { [] }
            changed { [] }
          end

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
          stub(status) do
            added { [] }
            deleted { ['README'] }
            changed { [] }
          end

          stub(@repo).status { status }

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'
          @command.base_dir       = '.'
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
          stub(status) do
            added { [] }
            deleted { [] }
            changed { ['README'] }
          end

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
          stub(@repo) do
            checkout(anything)
            add(anything)
            commit(anything)
            push
            push(anything)
            add_tag(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          status = Object.new
          stub(status) do
            added { [] }
            deleted { [] }
            changed { [] }
          end

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

        should "refresh gemspec version" do
          assert_received(@gemspec_helper) {|gemspec_helper| gemspec_helper.update_version('1.2.3') }
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

      build_command_context "building from jeweler" do
        setup do
          @command = Jeweler::Commands::Release.build_for(@jeweler)
        end

        should "assign gemspec" do
          assert_same @gemspec, @command.gemspec
        end

        should "assign version" do
          assert_same @version, @command.version
        end

        should "assign repo" do
          assert_same @repo, @command.repo
        end

        should "assign output" do
          assert_same @output, @command.output
        end

        should "assign gemspec_helper" do
          assert_same @gemspec_helper, @command.gemspec_helper
        end

        should "assign base_dir" do
          assert_same @base_dir, @command.base_dir
        end
      end
    end
  end
end
