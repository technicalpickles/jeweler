class Jeweler
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :gemspec, :version, :output, :gemspec_helper

      def initialize
        self.output = $stdout
      end

      def run
        gemspec_helper.spec.version = self.version
        gemspec_helper.spec.date    = Time.now

        gemspec_helper.write

        output.puts "Generated: #{gemspec_helper.path}"  
      end

      def gemspec_helper
        @gemspec_helper ||= GemSpecHelper.new(self.gemspec, self.base_dir)
      end

    end
  end
end
