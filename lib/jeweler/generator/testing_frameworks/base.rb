class Jeweler
  class Generator
    module TestingFrameworks
      class Base
        attr_accessor :development_dependencies, :generator

        def initialize(generator)
          self.generator = generator
          self.development_dependencies = []

          compat_mixin_name = "Jeweler::Generator::#{self.class.name.split('::').last}Mixin"
          extend constantize(compat_mixin_name)
        end

        def require_name
          generator.require_name
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
            @rake_task = string
          end
        end

        def rake_task
          self.class.rake_task
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
