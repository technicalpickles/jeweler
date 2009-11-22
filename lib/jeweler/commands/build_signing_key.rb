class Jeweler
  module Commands
    class BuildSigningKey
      attr_accessor :gemspec_helper, :output, :signer

      def initialize
        self.output = $stdout
        self.signer = Signer.new
      end

      def run
        if signer.can_sign?
          output.puts "Signing key already exists, skipping."
        else
          output.puts "Generating certificate"
          signer.build_for(gemspec_helper.parse.email)
          output.puts "Installed key and certificate."
        end
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

