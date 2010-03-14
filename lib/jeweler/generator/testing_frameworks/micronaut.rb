require 'jeweler/generator/micronaut_mixin'

class Jeweler
  class Generator
    module TestingFrameworks
      class Micronaut < Base

        rake_task <<-END
require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamples'
end
END

        rcov_rake_task <<-END
Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = '<%= test_pattern %>'
  examples.rcov_opts = '-Ilib -I<%= test_dir %>'
  examples.rcov = true
end
END
      end
    end
  end
end
