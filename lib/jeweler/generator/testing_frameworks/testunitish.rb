class Jeweler
  class Generator
    module TestingFrameworks
      class Testunitish < Base
        def initialize(generator)
          super
          use_inline_templates! __FILE__

          rakefile_snippets << lookup_inline_template(:rakefile_snippet)
        end
        
      end
    end
  end
end
__END__
@@ rakefile_snippet
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = %Q{test/**/test_*.rb}
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
