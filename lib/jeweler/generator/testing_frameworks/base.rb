class Jeweler
  class Generator
    module TestingFrameworks
      class Base < Plugin
        def initialize(generator)
          super

          development_dependencies << ["rcov", ">= 0"]

          compat_mixin_name = "Jeweler::Generator::#{generator.testing_framework.to_s.capitalize}Mixin"
          extend constantize(compat_mixin_name)
        end

        def run
          testing_framework = generator.testing_framework

          template "#{testing_framework.to_s}/helper.rb", "#{test_dir}/#{test_helper_filename}"
          template "#{testing_framework.to_s}/flunking.rb", "#{test_dir}/#{test_filename}"
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
