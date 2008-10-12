class Jeweler
  module Singleton
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def gemspec=(gemspec)
        @@instance = new(gemspec)
      end

      def instance
        @@instance
      end
    end
  end
  
end