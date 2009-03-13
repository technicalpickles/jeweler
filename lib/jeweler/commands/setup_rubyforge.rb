class Jeweler
  module Commands
    class SetupRubyforge
      attr_accessor :gemspec, :output, :rubyforge

      def run
        raise NoRubyForgeProjectInGemspecError unless @gemspec.rubyforge_project

        @rubyforge.configure

        output.puts "Logging into rubyforge"
        @rubyforge.login

        output.puts "Creating #{@gemspec.name} package in the #{@gemspec.rubyforge_project} project"
        begin
          @rubyforge.create_package(@gemspec.rubyforge_project, @gemspec.name)
        rescue StandardError => e
          case e.message
          when /no <group_id> configured for <#{Regexp.escape @gemspec.rubyforge_project}>/
            raise RubyForgeProjectNotConfiguredError, @gemspec.rubyforge_project
          else
            raise
          end
        end
      end
    end
  end
end
