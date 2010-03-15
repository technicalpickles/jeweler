class Jeweler
  class Generator
    class Bundler < Plugin
      def initialize(generator)
        super
        use_inline_templates! __FILE__

        self.rakefile_head_snippet = inline_templates[:rakefile_head_snippet]

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
require 'rake'
