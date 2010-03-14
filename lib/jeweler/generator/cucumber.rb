class Jeweler
  class Generator
    class Cucumber < Plugin
      attr_accessor :testing_framework
      attr_accessor :templates

      def initialize(generator, testing_framework)
        super(generator)
        self.templates = {}
        self.inline_templates = __FILE__

        self.testing_framework = testing_framework

        rakefile_snippets << templates[:rakefile_snippet]

        development_dependencies << ["cucumber", ">= 0"]
      end

      def run
        template "features/default.feature", "features/#{project_name}.feature"
        template "features/support/env.rb"
        create_file "features/step_definitions/#{project_name}_steps.rb"
      end

      def method_missing(meth, *args, &block)
        testing_framework.send(meth, *args, &block)
      end

      def inline_templates=(file=nil)
        file = (file.nil? || file == true) ? caller_files.first : file

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
              templates[$1.to_sym] = { :filename => file, :line => lines, :template => template }
            elsif template
              template << line
            end
          end
        end
      end
    end
  end
end

__END__
@@ rakefile_snippet
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)
