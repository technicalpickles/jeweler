class Jeweler
  class Generator
    module TestingFrameworks
      class Rspec < Base
        include Jeweler::Generator::RspecMixin

        def initialize(generator)
          super
          Jeweler::Generator::RspecMixin.extended(self)
        end
      end
    end
  end
end
