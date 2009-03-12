class Jeweler
  # Gemspec related error
   class GemspecError < StandardError
   end

   class VersionYmlError < StandardError
   end

   # Occurs when interacting with RubyForge, and an expected project isn't available on RubyForge.
   class MissingRubyForgePackageError < StandardError
   end

   # Occurs when interacting with RubyForge, and 'rubyforge_project' isn't set on the Gem::Specification
   class NoRubyForgeProjectInGemspecError < StandardError
   end
end
