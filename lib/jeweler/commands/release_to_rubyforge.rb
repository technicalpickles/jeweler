require 'rubyforge'

class Jeweler
  module Commands
    class ReleaseToRubyforge
      attr_accessor :gemspec, :version, :repo, :output, :gemspec_helper, :ruby_forge

      def initialize
        self.output = $stdout
      end

      def run
        raise "rubyforge_project not configured.  Add this to the Jeweler::Tasks block in your Rakefile." if @gemspec.rubyforge_project.nil?
        
        @ruby_forge.configure rescue nil
        output.puts 'Logging in rubyforge'
        @ruby_forge.login

        @ruby_forge.userconfig['release_notes'] = @gemspec.description if @gemspec.description
        @ruby_forge.userconfig['preformatted'] = true

        output.puts "Releasing #{@gemspec.name}-#{@version} to #{@gemspec.rubyforge_project}"
        begin
          @ruby_forge.add_release(@gemspec.rubyforge_project, @gemspec.name, @version.to_s, @gemspec_helper.gem_path)
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
