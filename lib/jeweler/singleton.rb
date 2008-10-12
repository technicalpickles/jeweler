class Jeweler
  module Singleton
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # Gives Jeweler a gem to craft. This is really just a convience method for making the Rake usage nicer.
      # In reality, this creates a new Jeweler, and assigns that to the singleton instance.
      def craft(gemspec)
        @@instance = new(gemspec)
      end
      alias_method :gemspec=, :craft

      # Gets the current Jeweler. Typically only the Jeweler Rake tasks would use this. 
      def instance
        @@instance
      end
    end
  end
  
end