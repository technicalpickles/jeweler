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
      end
    end
  end
end
