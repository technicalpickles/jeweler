require 'jeweler/generator/micronaut_mixin'

class Jeweler
  class Generator
    module TestingFrameworks
      class Micronaut < Base
        def initialize(generator)
          super

          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
        end
      end
    end
  end
end

__END__
@@ rakefile_snippet
require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamples'
end
Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.rcov_opts = '-Ilib -I<%= test_dir %>'
  examples.rcov = true
end
