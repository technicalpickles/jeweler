class Jeweler
  module Commands
    class InstallGem
      attr_accessor :gemspec_helper, :output

      def initialize
        self.output = $stdout
      end


      def run
        command = "sudo gem install #{gemspec_helper.gem_path}"
        output.puts "Executing #{command.inspect}:"

        sh command # TODO where does sh actually come from!?
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
