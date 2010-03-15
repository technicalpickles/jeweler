class Jeweler
  class Generator
    module TestingFrameworks
      class Base < Plugin
        def initialize(generator)
          super

          development_dependencies << ["rcov", ">= 0"]
        end

        def run
          testing_framework = generator.testing_framework

          template "#{testing_framework.to_s}/helper.rb", "#{test_dir}/#{test_helper_filename}"
          template "#{testing_framework.to_s}/flunking.rb", "#{test_dir}/#{test_filename}"
        end

      end
    end
  end
end
