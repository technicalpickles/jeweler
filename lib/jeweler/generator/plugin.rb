class Jeweler
  class Generator
    class Plugin
      attr_accessor :development_dependencies, :generator

      def initialize(generator)
        self.generator = generator
        self.development_dependencies = []
      end

      def run
        template File.join(%w(features default.feature)), File.join('features', feature_filename)

        template File.join(features_support_dir, 'env.rb')

        create_file           File.join(features_steps_dir, steps_filename)
      end

      def method_missing(meth, *args, &block)
        generator.send(meth, *args, &block)
      end

      def respond_to?(meth, include_private = false)
        super || generator.respond_to?(meth, include_private)
      end

    end
  end
end
