class Jeweler
  class Generator
    module RdocMixin
      def self.extended(generator)
        generator.development_dependencies << ['rdoc', '~> 3.12']
      end

      def doc_task
        'rdoc'
      end
    end
  end
end
