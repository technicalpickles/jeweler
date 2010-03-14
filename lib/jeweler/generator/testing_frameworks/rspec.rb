require 'jeweler/generator/rspec_mixin'
class Jeweler
  class Generator
    module TestingFrameworks
      class Rspec < Base

        rake_task <<-END
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end
END
      end
    end
  end
end
