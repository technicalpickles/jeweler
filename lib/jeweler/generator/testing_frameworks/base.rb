class Jeweler
  class Generator
    module TestingFrameworks
      class Base < Plugin
        def initialize(generator)
          super

          compat_mixin_name = "Jeweler::Generator::#{self.class.name.split('::').last}Mixin"
          extend constantize(compat_mixin_name)

          rakefile_snippets << rake_task << rcov_rake_task
        end

        def self.rake_task(string = nil)
          case string
          when nil
            @rake_task ||= <<-END
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = %Q{test/**/test_*.rb}
  test.verbose = true
end
END
          else
            @rcov_rake_task = string
          end
        end

        def rake_task
          self.class.rake_task
        end

        def self.rcov_rake_task(string = nil)
          case string
          when nil
            @rcov_rake_task ||= <<-END
require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
END
          else
            @rake_task = string
          end
        end

        def rcov_rake_task
          self.class.rcov_rake_task
        end

        def run
          testing_framework = self.class.name.split('::').last.downcase
          template File.join(testing_framework.to_s, 'helper.rb'),
            File.join(test_dir, test_helper_filename)
          template File.join(testing_framework.to_s, 'flunking.rb'),
            File.join(test_dir, test_filename)
        end

        private

        # stolen from active_support
        def constantize(camel_cased_word)
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = ::Object
          names.each do |name|
            constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
          end
          constant
        end
        
      end
    end
  end
end
