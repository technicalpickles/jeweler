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
        output.puts 'Logging in'
        @ruby_forge.login

        @ruby_forge.userconfig['release_notes'] = @gemspec.description if @gemspec.description
        @ruby_forge.userconfig['preformatted'] = true

        output.puts "Releasing #{@gemspec.name} v. #{@version} as #{@gemspec.rubyforge_project}"
        @ruby_forge.add_release(@gemspec.rubyforge_project, @gemspec.name, @version.to_s, @gemspec_helper.gem_path)
      end
      
    end
  end
end
