class Jeweler
  class Generator
    module TestingFrameworks
      class Base
        attr_accessor :development_dependencies

        def initialize
          self.development_dependencies = []
        end
      end
    end
  end
end
