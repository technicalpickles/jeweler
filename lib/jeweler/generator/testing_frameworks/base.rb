class Jeweler
  class Generator
    module TestingFrameworks
      class Base
        attr_accessor :development_dependencies, :generator

        def initialize(generator)
          self.generator = generator
          self.development_dependencies = []
        end

        def require_name
          generator.require_name
        end
      end
    end
  end
end
