require 'test_helper'

class RubyForgeStub
  attr_accessor :userconfig
  
  def initialize
    @userconfig = {}
  end
end

class Jeweler
  module Commands
    class TestRelease < Test::Unit::TestCase

      context "after running without pending changes" do
        setup do
          @rubyforge = RubyForgeStub.new
          stub(@rubyforge).configure
          stub(@rubyforge).login
          stub(@rubyforge).add_release("MyRubyForgeProjectName", "zomg", "1.2.3", "pkg/zomg-1.2.3.gem")

          @gempsec = Object.new
          stub(@gemspec).description {"The zomg gem rocks."}
          stub(@gemspec).rubyforge_project {"MyRubyForgeProjectName"}
          stub(@gemspec).name {"zomg"}
          
          @gemspec_helper = Object.new
          stub(@gemspec_helper).write
          stub(@gemspec_helper).gem_path {'pkg/zomg-1.2.3.gem'}
          stub(@gemspec_helper).update_version('1.2.3')

          status = Object.new
          stub(status).added { [] }
          stub(status).deleted { [] }
          stub(status).changed { [] }
          stub(@repo).status { status }

          @output = StringIO.new

          @command                = Jeweler::Commands::ReleaseToRubyforge.new
          @command.output         = @output
          @command.repo           = @repo
          @command.gemspec        = @gemspec
          @command.gemspec_helper = @gemspec_helper
          @command.version        = '1.2.3'
          @command.ruby_forge     = @rubyforge

          @command.run
        end

        should "configure" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.configure }
        end

        should "login" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.login }
        end
        
        should "set release notes" do
          assert_equal "The zomg gem rocks.", @rubyforge.userconfig["release_notes"]
        end
        
        should "set preformatted to true" do
          assert_equal true, @rubyforge.userconfig['preformatted']
        end
        
        should "add release" do
          assert_received(@rubyforge) {|rubyforge| rubyforge.add_release("MyRubyForgeProjectName", "zomg", "1.2.3", "pkg/zomg-1.2.3.gem") }
        end
        
      end
    end
  end
end
