class Jeweler
  module Commands
    class WriteGemspec
      attr_accessor :base_dir, :gemspec, :version, :output, :gemspec_helper, :version_helper

      def initialize
        self.output = $stdout
      end

      def run
        version_helper.refresh
        gemspec_helper.spec.version = version_helper.to_s
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
