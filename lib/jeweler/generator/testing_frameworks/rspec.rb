require 'jeweler/generator/rspec_mixin'
class Jeweler
  class Generator
    module TestingFrameworks
      class Rspec < Base

        rake_task <<-END
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
end
END
        rcov_rake_task <<-END
Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end
END
      end
    end
  end
end
