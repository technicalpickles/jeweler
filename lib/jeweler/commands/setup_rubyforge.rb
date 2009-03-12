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
        @rubyforge.create_package(@gemspec.rubyforge_project, @gemspec.name)
      end
    end
  end
end
