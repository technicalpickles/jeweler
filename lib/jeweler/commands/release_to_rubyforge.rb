require 'rubyforge'

class Jeweler
  module Commands
    class ReleaseToRubyforge
      attr_accessor :gemspec, :version, :repo, :output, :gemspec_helper, :rubyforge

      def initialize
        self.output = $stdout
      end

      def run
        raise NoRubyForgeProjectInGemspecError unless @gemspec.rubyforge_project
        
        @rubyforge.configure rescue nil

        output.puts 'Logging in rubyforge'
        @rubyforge.login

        @rubyforge.userconfig['release_notes'] = @gemspec.description if @gemspec.description
        @rubyforge.userconfig['preformatted'] = true

        output.puts "Releasing #{@gemspec.name}-#{@version} to #{@gemspec.rubyforge_project}"
        begin
          @rubyforge.add_release(@gemspec.rubyforge_project, @gemspec.name, @version.to_s, @gemspec_helper.gem_path)
        rescue StandardError => e
          if e.message =~ /no <package_id> configured for <#{Regexp.escape @gemspec.name}>/i
            raise MissingRubyForgePackageError, @gemspec.name
          else
            raise
          end
        end
      end
      
    end
  end
end
