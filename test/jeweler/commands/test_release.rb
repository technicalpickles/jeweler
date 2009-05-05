require 'test_helper'

class Jeweler
  module Commands
    class TestRelease < Test::Unit::TestCase

      context "with pending changes" do
        setup do
          @repo = Object.new
          stub(@repo).checkout(anything)
          stub(@repo).status { status }

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'

          stub(@command).any_pending_changes? { true }
        end

        should 'raise error' do
          assert_raises RuntimeError, /try commiting/i do
            @command.run
          end
        end
      end

      context "run without pending changes, and gemspec changed, and tagged not created already" do
        setup do
          @repo = Object.new
          stub(@repo) do
            checkout(anything)
            add(anything)
            commit(anything)
            push
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new :output => @output,
                                                                   :repo => @repo,
                                                                   :gemspec_helper => @gemspec_helper,
                                                                   :version => '1.2.3'

          stub(@command).tag_release!
          stub(@command).gemspec_changed? { true }
          stub(@command).any_pending_changes? { false }
          stub(@command).regenerate_gemspec!
          stub(@command).commit_gemspec!
          stub(@command).release_tagged? { false }

          @command.run
        end

        should "checkout master" do
          assert_received(@repo) {|repo| repo.checkout('master') }
        end

        should "regenerate gemspec" do
          assert_received(@command) {|command| command.regenerate_gemspec! }
        end

        should "commit gemspec" do
          assert_received(@command) {|command| command.commit_gemspec! }
        end

        should "tag release" do
          assert_received(@command) {|command| command.tag_release! }
        end
      end

      context "run without pending changes, and gemspec didn't change, and tagged not created already" do
        setup do
          @repo = Object.new
          stub(@repo) do
            checkout(anything)
            add(anything)
            commit(anything)
            push
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new :output => @output,
                                                                   :repo => @repo,
                                                                   :gemspec_helper => @gemspec_helper,
                                                                   :version => '1.2.3'

          stub(@command).tag_release!
          stub(@command).any_pending_changes? { false }
          stub(@command).gemspec_changed? { false } 
          stub(@command).regenerate_gemspec!
          stub(@command).release_tagged? { false }

          @command.run
        end

        should "checkout master" do
          assert_received(@repo) {|repo| repo.checkout('master') }
        end

        should "regenerate gemspec" do
          assert_received(@command) {|command| command.regenerate_gemspec! }
        end

        should_eventually "not commit gemspec" do
          # need a way to assert it wasn't received short of not stubbing it
          #assert_received(@command) {|command| command.commit_gemspec! }
        end

        should "tag release" do
          assert_received(@command) {|command| command.tag_release! }
        end
      end

      context "run without pending changes and tagged already" do
        setup do
          @repo = Object.new
          stub(@repo) do
            checkout(anything)
            add(anything)
            commit(anything)
            push
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new :output => @output,
                                                                   :repo => @repo,
                                                                   :gemspec_helper => @gemspec_helper,
                                                                   :version => '1.2.3'

          #stub(@command).tag_release!
          stub(@command).any_pending_changes? { false }
          stub(@command).regenerate_gemspec!
          stub(@command).release_tagged? { true }

          @command.run
        end

        should "checkout master" do
          assert_received(@repo) {|repo| repo.checkout('master') }
        end

        should "regenerate gemspec" do
          assert_received(@command) {|command| command.regenerate_gemspec! }
        end

        should_eventually "not tag release" do
          # need to have a way to verify tag_release! not being called, short of not stubbing it
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

      context "any_pending_changes?" do

        should "be true if there added files" do
          repo = build_repo :added => %w(README)

          command = Jeweler::Commands::Release.new :repo => repo

          assert command.any_pending_changes?
        end

        should "be true if there are changed files" do
          repo = build_repo :changed => %w(README)

          command = Jeweler::Commands::Release.new
          command.repo = repo

          assert command.any_pending_changes?
        end

        should "be true if there are deleted files" do
          repo = build_repo :deleted => %w(README)

          command = Jeweler::Commands::Release.new
          command.repo = repo

          assert command.any_pending_changes?
        end

        should "be false if nothing added, changed, or deleted" do
          repo = build_repo

          command = Jeweler::Commands::Release.new
          command.repo = repo

          assert ! command.any_pending_changes?
        end
      end

      context "tag_release!" do
        setup do
          @repo = Object.new
          stub(@repo) do
            add_tag(anything)
            push(anything, anything)
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'

          @command.tag_release!
        end

        should "tag release" do
          assert_received(@repo) {|repo| repo.add_tag("v1.2.3")}
        end

        should "push tag to repository" do
          assert_received(@repo) {|repo| repo.push('origin', 'v1.2.3')}
        end
      end

      context "regenerate_gemspec!" do
        setup do
          @repo = Object.new
          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new :output => @output,
                                                                   :repo => @repo,
                                                                   :gemspec_helper => @gemspec_helper,
                                                                   :version => '1.2.3'

          @command.regenerate_gemspec!
        end

        should "refresh gemspec version" do
          assert_received(@gemspec_helper) {|gemspec_helper| gemspec_helper.update_version('1.2.3') }
        end

        should "write gemspec" do
          assert_received(@gemspec_helper) {|gemspec_helper| gemspec_helper.write }
        end
      end

      context "commit_gemspec!" do
        setup do
          @repo = Object.new
          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            path {'zomg.gemspec'}
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new :output => @output,
                                                                   :repo => @repo,
                                                                   :gemspec_helper => @gemspec_helper,
                                                                   :version => '1.2.3'

          @command.commit_gemspec!
        end

        should "add gemspec to repository" do
          assert_received(@repo) {|repo| repo.add('zomg.gemspec') }
        end

        should "commit with commit message including version" do
          assert_received(@repo) {|repo| repo.commit("Regenerated gemspec for version 1.2.3") }
        end

      end

      context "release_tagged? when no tag exists" do
        setup do
          @repo = Object.new
          stub(@repo).tag('v1.2.3') {raise Git::GitTagNameDoesNotExist, tag}
          #stub(@repo) do
            #tag('v1.2.3') do |tag|
              #raise Git::GitTagNameDoesNotExist, tag
            #end
          #end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.version        = '1.2.3'
        end

        should_eventually "be false" do
          assert ! @command.release_tagged?
        end

      end

      context "release_tagged? when tag exists" do
        setup do
          @repo = Object.new
          stub(@repo) do
            tag('v1.2.3') { Object.new }
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::Release.new
          @command.output         = @output
          @command.repo           = @repo
          @command.version        = '1.2.3'
        end

        should_eventually "be true" do
          assert @command.release_tagged?
        end

      end

      def build_repo(options = {})
        status = build_status options
        repo = Object.new
        stub(repo).status { status }
        repo
      end

      def build_status(options = {})
        options = {:added => [], :deleted => [], :changed => []}.merge(options)

        status = Object.new
        stub(status) do
          added { options[:added] }
          deleted { options[:deleted] }
          changed { options[:changed] }
        end
        
      end
    end
  end
end
