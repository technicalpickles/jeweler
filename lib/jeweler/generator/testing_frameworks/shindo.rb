require 'jeweler/generator/shindo_mixin'
class Jeweler
  class Generator
    module TestingFrameworks
      class Shindo < Base

        rake_task <<-END
require 'shindo/rake'
Shindo::Rake.new
        END
      end
    end
  end
end

