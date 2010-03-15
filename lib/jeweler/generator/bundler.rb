class Jeweler
  class Generator
    class Bundler < Plugin
      def initialize(generator)
        super
        use_inline_templates! __FILE__

        self.rakefile_head_snippet = lookup_inline_template(:rakefile_head_snippet)

        self.jeweler_task_snippet = lookup_inline_template(:jeweler_task_snippet)
        development_dependencies << ["bundler", ">= 0.9.5"] 
      end

      def run
        template 'Gemfile'
      end
    end
  end
end
__END__
@@ rakefile_head_snippet
require 'bundler'
begin
  Bundler.setup(:runtime, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
@@ jeweler_task_snippet
  # Have dependencies? Add them to Gemfile
