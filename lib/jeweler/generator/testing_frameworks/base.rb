class Jeweler
  class Generator
    module TestingFrameworks
      class Base < Plugin
        def initialize(generator)
          super

          development_dependencies << ["rcov", ">= 0"]
        end

        def run
          template "#{template_subdir}/helper.rb", "#{test_dir}/#{test_helper_filename}"
          template "#{template_subdir}/flunking.rb", "#{test_dir}/#{test_filename}"
        end

        def template_subdir
          self.class.name.split('::').last.downcase
        end

      end
    end
  end
end
