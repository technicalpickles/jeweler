class Jeweler
  class Generator
    class Rubyforge < Plugin
      def initialize(generator)

        self.jeweler_task_snippet = <<-END
  gem.rubyforge_project = "#{generator.project_name}"
END

rakefile_snippets <<-END
Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "#{generator.doc_task}"
end
END
      end
    end
  end
end

__END__
