class Jeweler
  class Generator
    module TestingFrameworks
      class Shoulda < Base
        include Jeweler::Generator::ShouldaMixin

        def initialize(generator)
          super
        end

      end
    end
  end
end
