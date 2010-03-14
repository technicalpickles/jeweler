class Jeweler
  class Generator
    class Plugin
      include Thor::Base
      include Thor::Actions

      attr_accessor :base, :generator, :development_dependencies, :rakefile_snippets

      def initialize(generator)
        self.generator = generator
        self.development_dependencies = []
        self.rakefile_snippets = []

        self.destination_root = generator.destination_root
      end

      def run
      end

      def method_missing(meth, *args, &block)
        generator.send(meth, *args, &block)
      end

      def respond_to?(meth, include_private = false)
        super || generator.respond_to?(meth, include_private)
      end

      def options
        generator.options
      end

      def self.source_root
        Generator.source_root
      end
    end
  end
end
