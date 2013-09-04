class Jeweler
  module Commands
    autoload :BuildGem,          'jeweler/commands/build_gem'
    autoload :InstallGem,        'jeweler/commands/install_gem'
    autoload :CheckDependencies, 'jeweler/commands/check_dependencies'
    autoload :ReleaseToGit,      'jeweler/commands/release_to_git'
    autoload :ReleaseGemspec,    'jeweler/commands/release_gemspec'
    autoload :ReleaseToRubygems, 'jeweler/commands/release_to_rubygems'
    autoload :ValidateGemspec,   'jeweler/commands/validate_gemspec'
    autoload :WriteGemspec,      'jeweler/commands/write_gemspec'

    module Version
      autoload :Base,      'jeweler/commands/version/base'
      autoload :BumpMajor, 'jeweler/commands/version/bump_major'
      autoload :BumpMinor, 'jeweler/commands/version/bump_minor'
      autoload :BumpPatch, 'jeweler/commands/version/bump_patch'
      autoload :Write,     'jeweler/commands/version/write'
    end
  end
end
