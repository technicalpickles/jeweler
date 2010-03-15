class Jeweler
  class Generator
    module DocumentationFrameworks

      def self.klass(documentation_framework)
        documentation_framework_class_name = documentation_framework.to_s.capitalize
        if DocumentationFrameworks.const_defined?(documentation_framework_class_name)
          DocumentationFrameworks.const_get(documentation_framework_class_name)
        else
          raise ArgumentError, "Using #{documentation_framework} requires a #{documentation_framework_class_name} to be defined"
        end
      end

      class Base < Plugin
        def initialize(generator)
          super
          use_inline_templates! __FILE__
        end
      end

      class Yard < Base
        def initialize(generator)
          super
          rakefile_snippets << inline_templates[:yard_rakefile_snippet]
          development_dependencies << ['yard', '>= 0']
        end
      end

      class Rdoc < Base
        def initialize(generator)
          super
          rakefile_snippets << inline_templates[:rdoc_rakefile_snippet]
        end
      end
    end
  end
end
__END__
@@ yard_rakefile_snippet
require 'yard'
YARD::Rake::YardocTask.new
@@ rdoc_rakefile_snippet
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "<%= project_name %> #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
