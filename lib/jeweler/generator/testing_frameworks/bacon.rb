class Jeweler
  class Generator
    module TestingFrameworks
      class Bacon < Base
        def initialize(generator)
          super
          use_inline_templates! __FILE__

          rakefile_snippets << inline_templates[:rakefile_snippet]
          development_dependencies << ["bacon", ">= 0"]
        end

        def default_rake_task
          'spec'
        end

        def feature_support_require
          'test/unit/assertions'
        end

        def feature_support_extend
          'Test::Unit::Assertions' # NOTE can't use bacon inside of cucumber actually
        end

        def test_dir
          'spec'
        end

        def test_filename
          "#{require_name}_spec.rb"
        end

        def test_helper_filename
          "spec_helper.rb"
        end
      end
    end
  end
end
__END__
@@ rakefile_snippet
require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = %Q{spec/**/*_spec.rb}
  spec.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end
