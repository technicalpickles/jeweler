class Jeweler
  # Gemspec related error
   class GemspecError < StandardError
   end

   class VersionYmlError < StandardError
   end

   class MissingRubyForgePackageError < StandardError
   end
end
