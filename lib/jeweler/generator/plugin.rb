class Jeweler
  class Generator
    class Plugin
      attr_accessor :generator, :development_dependencies, :rakefile_snippets

      def initialize(generator)
        self.generator = generator
        self.development_dependencies = []
        self.rakefile_snippets = []
      end

      def run
      end

      def method_missing(meth, *args, &block)
        generator.send(meth, *args, &block)
      end

      def respond_to?(meth, include_private = false)
        super || generator.respond_to?(meth, include_private)
      end

    end
  end
end
