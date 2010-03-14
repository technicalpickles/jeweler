require 'jeweler/generator/bacon_mixin'

class Jeweler
  class Generator
    module TestingFrameworks
      class Bacon < Base
        rake_task <<-END
require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = %Q{spec/**/*_spec.rb}
  spec.verbose = true
end
END

        rcov_rake_task <<-END
require 'rcov/rcovtask'
Rcov::RcovTask.new do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end
END

      end
    end
  end
end
