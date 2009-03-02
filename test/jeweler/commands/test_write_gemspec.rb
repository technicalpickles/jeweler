require 'test_helper'

class Jeweler
  module Commands
    class TestWriteGemspec < Test::Unit::TestCase

      context "after run" do
        setup do
          @gemspec = Gem::Specification.new {|s| s.name = 'zomg' }
          @gemspec_helper = Object.new
          stub(@gemspec_helper).spec { @gemspec }
          stub(@gemspec_helper).path { 'zomg.gemspec' }
          stub(@gemspec_helper).write

          @output = StringIO.new

          @command = Jeweler::Commands::WriteGemspec.new
          @command.base_dir = 'tmp'
          @command.version = '1.2.3'
          @command.gemspec = @gemspec
          @command.output = @output
          @command.gemspec_helper = @gemspec_helper

          @now = Time.now
          stub(Time.now).now { @now }

          @command.run
        end

        should "update gemspec version" do
          assert_equal '1.2.3', @gemspec.version.to_s
        end

        should "update gemspec date to the beginning of today" do
          assert_equal Time.mktime(@now.year, @now.month, @now.day, 0, 0), @gemspec.date
        end

        should "write gemspec" do
          assert_received(@gemspec_helper) {|gemspec_helper| gemspec_helper.write }
        end

        should_eventually "output that the gemspec was written" do
          assert_equal @output.string, "Generated: tmp/zomg.gemspec"
        end

      end

    end
  end
end
