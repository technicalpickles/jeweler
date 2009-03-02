require 'test_helper'

class Jeweler
  module Commands
    class TestWriteGemspec < Test::Unit::TestCase

      context "after run" do
        setup do
          @output = StringIO.new
          @command = Jeweler::Commands::WriteGemspec.new
          @command.base_dir = 'tmp'
          @command.version = '1.2.3'
          @command.gemspec = Gem::Specification.new {|s| s.name = 'zomg' }
          @command.output = @output

          stub.instance_of(Jeweler::GemSpecHelper).write

          @now = Time.now
          stub(Time.now).now { @now }

          @command.run
        end

        should "update gemspec version" do
          assert_equal '1.2.3', @command.gemspec.version.to_s
        end

        should "update gemspec date to the beginning of today" do
          assert_equal Time.mktime(@now.year, @now.month, @now.day, 0, 0), @command.gemspec.date
        end

        should_eventually "output that the gemspec was written" do
          assert_equal @output.string, "Generated: tmp/zomg.gemspec"
        end

      end

    end
  end
end
