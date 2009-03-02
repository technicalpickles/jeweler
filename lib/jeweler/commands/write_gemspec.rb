class Jeweler
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :gemspec, :version, :output

      def initialize
        self.output = $stdout
      end

      def run
        helper = GemSpecHelper.new(self.gemspec, self.base_dir) do |s|
          s.version = self.version
          s.date = Time.now
        end

        helper.write

        output.puts "Generated: #{helper.path}"  
      end

    end
  end
end
