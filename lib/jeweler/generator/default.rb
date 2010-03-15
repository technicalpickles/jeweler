class Jeweler
  class Generator
    class Default < Plugin

      def initialize(generator)
        super
        development_dependencies << ["jeweler", ">= 1.4.0"]
      end

      def run
        template '.gitignore'
        template 'Rakefile'
        template 'LICENSE'
        template 'README.rdoc'
        template '.document'
        create_file "lib/#{project_name}.rb"
      end
    end
  end
end
