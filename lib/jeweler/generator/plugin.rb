class Jeweler
  class Generator
    class Plugin
      include Thor::Base
      include Thor::Actions

      attr_accessor :base, :generator, :development_dependencies,
        :rakefile_snippets, :jeweler_task_snippet,
        :inline_templates

      def initialize(generator)
        self.generator = generator
        self.development_dependencies = []
        self.rakefile_snippets = []
        self.inline_templates = {}

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

      def use_inline_templates!(file)
        begin
          app, data =
            ::IO.read(file).gsub("\r\n", "\n").split(/^__END__$/, 2)
        rescue Errno::ENOENT
          app, data = nil
        end

        if data
          lines = app.count("\n") + 1
          template = nil
          data.each_line do |line|
            lines += 1
            if line =~ /^@@\s*(.*)/
              template = ''
              inline_templates[$1.to_sym] = { :filename => file, :line => lines, :template => template }
            elsif template
              template << line
            end
          end
        end
      end

      def self.source_root
        Generator.source_root
      end
    end
  end
end
