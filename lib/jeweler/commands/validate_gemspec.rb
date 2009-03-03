class Jeweler
  module Commands
    class ValidateGemspec
      attr_accessor :gemspec_helper, :output

      def initialize
        self.output = $stdout
      end

      def run
        begin
          gemspec_helper.parse
          output.puts "#{gemspec_helper.path} is valid."
        rescue Exception => e
          output.puts "#{gemspec_helper.path} is invalid. See the backtrace for more details."
          raise
        end
      end
    end
  end
end
