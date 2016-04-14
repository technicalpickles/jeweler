class Jeweler
  module Commands
    class InstallGem
      include FileUtils

      attr_accessor :gemspec_helper, :output

      def initialize
        self.output = $stdout
      end

      def run
        command = "#{gem_command} install #{gemspec_helper.gem_path}"
        output.puts "Executing #{command.inspect}:"

        sh command # TODO: where does sh actually come from!? - rake, apparently
      end

      def gem_command
        "#{RbConfig::CONFIG['RUBY_INSTALL_NAME']} -S gem"
      end

      def self.build_for(jeweler)
        command = new
        command.output = jeweler.output
        command.gemspec_helper = jeweler.gemspec_helper
        command
      end
    end
  end
end
