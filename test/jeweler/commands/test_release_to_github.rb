require 'test_helper'
require 'pathname'

class Jeweler
  module Commands
    class TestReleaseGemspec < Test::Unit::TestCase
      rubyforge_command_context 'running' do
        context 'happily' do
          setup do
            stub(@command).clean_staging_area? { true }

            stub(@repo).checkout(anything)

            stub(@command).regenerate_gemspec!

            stub(@command).gemspec_changed? { true }
            stub(@command).commit_gemspec! { true }

            stub(@repo).push

            stub(@command).release_not_tagged? { true }

            @command.run
          end

          should 'checkout master' do
            assert_received(@repo) { |repo| repo.checkout('master') }
          end

          should 'regenerate gemspec' do
            assert_received(@command, &:regenerate_gemspec!)
          end

          should 'commit gemspec' do
            assert_received(@command, &:commit_gemspec!)
          end

          should 'push' do
            assert_received(@repo) { |repo| repo.push('origin', 'master:master') }
          end
        end

        context 'happily with different remote, local branch and remote branch' do
          setup do
            stub(@command).clean_staging_area? { true }

            stub(@repo).checkout(anything)

            stub(@command).regenerate_gemspec!

            stub(@command).gemspec_changed? { true }
            stub(@command).commit_gemspec! { true }

            stub(@repo).push

            stub(@command).release_not_tagged? { true }

            @command.run(remote: 'upstream', local_branch: 'branch', remote_branch: 'remote_branch')
          end

          should 'checkout local branch' do
            assert_received(@repo) { |repo| repo.checkout('branch') }
          end

          should 'regenerate gemspec' do
            assert_received(@command, &:regenerate_gemspec!)
          end

          should 'commit gemspec' do
            assert_received(@command, &:commit_gemspec!)
          end

          should 'push' do
            assert_received(@repo) { |repo| repo.push('upstream', 'branch:remote_branch') }
          end
        end

        context 'happily with different branch' do
          setup do
            stub(@command).clean_staging_area? { true }

            stub(@repo).checkout(anything)

            stub(@command).regenerate_gemspec!

            stub(@command).gemspec_changed? { true }
            stub(@command).commit_gemspec! { true }

            stub(@repo).push

            stub(@command).release_not_tagged? { true }

            @command.run(branch: 'v3')
          end

          should 'checkout local branch' do
            assert_received(@repo) { |repo| repo.checkout('v3') }
          end

          should 'regenerate gemspec' do
            assert_received(@command, &:regenerate_gemspec!)
          end

          should 'commit gemspec' do
            assert_received(@command, &:commit_gemspec!)
          end

          should 'push' do
            assert_received(@repo) { |repo| repo.push('origin', 'v3:v3') }
          end
        end

        context 'with an unclean staging area' do
          setup do
            stub(@command).clean_staging_area? { false }
            stub(@command).system
          end

          should 'raise error' do
            assert_raises RuntimeError, 'Unclean staging area! Be sure to commit or .gitignore everything first. See `git status` above.' do
              @command.run
            end
          end

          should 'display git status' do
            begin
              @command.run
            rescue
              nil
            end
            assert_received(@command) { |command| command.system('git status') }
          end
        end

        context 'with an unchanged gemspec' do
          setup do
            stub(@command).clean_staging_area? { true }

            stub(@repo).checkout(anything)

            stub(@command).regenerate_gemspec!

            stub(@command).gemspec_changed? { false }
            dont_allow(@command).commit_gemspec! { true }

            stub(@repo).push

            stub(@command).release_not_tagged? { true }

            @command.run
          end

          should 'checkout master' do
            assert_received(@repo) { |repo| repo.checkout('master') }
          end

          should 'regenerate gemspec' do
            assert_received(@command, &:regenerate_gemspec!)
          end

          should 'push' do
            assert_received(@repo) { |repo| repo.push('origin', 'master:master') }
          end
        end

        context 'with a release already tagged' do
          setup do
            stub(@command).clean_staging_area? { true }

            stub(@repo).checkout(anything)

            stub(@command).regenerate_gemspec!

            stub(@command).gemspec_changed? { true }
            stub(@command).commit_gemspec! { true }

            stub(@repo).push

            stub(@command).release_not_tagged? { false }

            @command.run
          end

          should 'checkout master' do
            assert_received(@repo) { |repo| repo.checkout('master') }
          end

          should 'regenerate gemspec' do
            assert_received(@command, &:regenerate_gemspec!)
          end

          should 'commit gemspec' do
            assert_received(@command, &:commit_gemspec!)
          end

          should 'push' do
            assert_received(@repo) { |repo| repo.push('origin', 'master:master') }
          end
        end
      end

      build_command_context 'building from jeweler' do
        setup do
          @command = Jeweler::Commands::ReleaseGemspec.build_for(@jeweler)
        end

        should 'assign gemspec' do
          assert_same @gemspec, @command.gemspec
        end

        should 'assign version' do
          assert_same @version, @command.version
        end

        should 'assign repo' do
          assert_same @repo, @command.repo
        end

        should 'assign output' do
          assert_same @output, @command.output
        end

        should 'assign gemspec_helper' do
          assert_same @gemspec_helper, @command.gemspec_helper
        end

        should 'assign base_dir' do
          assert_same @base_dir, @command.base_dir
        end
      end

      # FIXME: this code had its ruby-git stuff replaced with `` and system, which is much harder to test, so re-enable these someday
      # context "clean_staging_area?" do

      #  should "be false if there added files" do
      #    repo = build_repo :added => %w(README)

      #    command = Jeweler::Commands::ReleaseGemspec.new :repo => repo

      #    assert ! command.clean_staging_area?
      #  end

      #  should "be false if there are changed files" do
      #    repo = build_repo :changed => %w(README)

      #    command = Jeweler::Commands::ReleaseGemspec.new
      #    command.repo = repo

      #    assert ! command.clean_staging_area?
      #  end

      #  should "be false if there are deleted files" do
      #    repo = build_repo :deleted => %w(README)

      #    command = Jeweler::Commands::ReleaseGemspec.new
      #    command.repo = repo

      #    assert ! command.clean_staging_area?
      #  end

      #  should "be true if nothing added, changed, or deleted" do
      #    repo = build_repo

      #    command = Jeweler::Commands::ReleaseGemspec.new
      #    command.repo = repo

      #    assert command.clean_staging_area?
      #  end
      # end

      context 'regenerate_gemspec!' do
        setup do
          @repo = Object.new
          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            write
            path { 'zomg.gemspec' }
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command = Jeweler::Commands::ReleaseGemspec.new output: @output,
                                                           repo: @repo,
                                                           gemspec_helper: @gemspec_helper,
                                                           version: '1.2.3'

          @command.regenerate_gemspec!
        end

        should 'refresh gemspec version' do
          assert_received(@gemspec_helper) { |gemspec_helper| gemspec_helper.update_version('1.2.3') }
        end

        should 'write gemspec' do
          assert_received(@gemspec_helper, &:write)
        end
      end

      context 'commit_gemspec!' do
        setup do
          @repo = Object.new
          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            path { 'zomg.gemspec' }
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command = Jeweler::Commands::ReleaseGemspec.new output: @output,
                                                           repo: @repo,
                                                           gemspec_helper: @gemspec_helper,
                                                           version: '1.2.3'

          stub(@command).working_subdir { Pathname.new('.') }
          @command.commit_gemspec!
        end

        should 'add gemspec to repository' do
          assert_received(@repo) { |repo| repo.add('zomg.gemspec') }
        end

        should 'commit with commit message including version' do
          assert_received(@repo) { |repo| repo.commit('Regenerate gemspec for version 1.2.3') }
        end
      end

      context 'commit_gemspec! in top dir' do
        setup do
          @repo = Object.new

          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            path { 'zomg.gemspec' }
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command = Jeweler::Commands::ReleaseGemspec.new output: @output,
                                                           repo: @repo,
                                                           gemspec_helper: @gemspec_helper,
                                                           version: '1.2.3',
                                                           base_dir: '.'

          @dir = Object.new
          stub(@repo).dir { @dir }
          stub(@dir).path { '/x/y/z' }

          stub(@command).base_dir_path { Pathname.new('/x/y/z') }

          @command.commit_gemspec!
        end

        should 'add gemspec to repository' do
          assert_received(@repo) { |repo| repo.add('zomg.gemspec') }
        end
      end

      context 'commit_gemspec! in sub dir' do
        setup do
          @repo = Object.new

          stub(@repo) do
            add(anything)
            commit(anything)
          end

          @gemspec_helper = Object.new
          stub(@gemspec_helper) do
            path { 'zomg.gemspec' }
            update_version('1.2.3')
          end

          @output = StringIO.new

          @command = Jeweler::Commands::ReleaseGemspec.new output: @output,
                                                           repo: @repo,
                                                           gemspec_helper: @gemspec_helper,
                                                           version: '1.2.3',
                                                           base_dir: '.'

          @dir = Object.new
          stub(@repo).dir { @dir }
          stub(@dir).path { '/x/y/z' }

          stub(@command).base_dir_path { Pathname.new('/x/y/z/gem') }

          @command.commit_gemspec!
        end

        should 'add gemspec to repository' do
          assert_received(@repo) { |repo| repo.add('gem/zomg.gemspec') }
        end
      end

      context 'release_tagged? when no tag exists' do
        setup do
          @repo = Object.new
          stub(@repo).tag('v1.2.3') { raise Git::GitTagNameDoesNotExist, tag }

          @output = StringIO.new

          @command                = Jeweler::Commands::ReleaseGemspec.new
          @command.output         = @output
          @command.repo           = @repo
          @command.version        = '1.2.3'
        end

        should_eventually 'be true' do
          assert @command.release_not_tagged?
        end
      end

      context 'release_tagged? when tag exists' do
        setup do
          @repo = Object.new
          stub(@repo) do
            tag('v1.2.3') { Object.new }
          end

          @output = StringIO.new

          @command                = Jeweler::Commands::ReleaseGemspec.new
          @command.output         = @output
          @command.repo           = @repo
          @command.version        = '1.2.3'
        end

        should_eventually 'be false' do
          assert @command.release_not_tagged?
        end
      end

      def build_repo(options = {})
        status = build_status options
        repo = Object.new
        stub(repo).status { status }
        repo
      end

      def build_status(options = {})
        options = { added: [], deleted: [], changed: [] }.merge(options)

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
