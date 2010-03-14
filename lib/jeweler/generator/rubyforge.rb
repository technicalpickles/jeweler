class Jeweler
  class Generator
    class Rubyforge < Plugin
      def initialize(generator)

        self.jeweler_task_snippet = templates['jeweler_task_snippet']
        self.rakefile_snippets << templates['rakefile_snippets']
      end
      
    end
  end
end

__END__
@@ jeweler_task_snippet
gem.rubyforge_project = "#{generator.project_name}"

@@ rakefile_snippet
Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "#{generator.doc_task}"
end
