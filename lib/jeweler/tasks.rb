desc "Generate a gemspec file for GitHub"
task :gemspec do
  Jeweler.write_gemspec
end

desc "Displays the current version"
task :version do
  puts Jeweler.version
end

namespace :version do
  namespace :bump do
    desc "Bump the gemspec a major version."
    task :major do
      major = Jeweler.major_version + 1
      Jeweler.bump_version(major, 0, 0)
      Jeweler.write_gemspec
    end
    
    desc "Bump the gemspec a minor version."
    task :minor do
      minor = Jeweler.minor_version + 1
      Jeweler.bump_version(Jeweler.major_version, minor, 0)
      Jeweler.write_gemspec
    end
    
    desc "Bump the gemspec a patch version."
    task :patch do
      patch = Jeweler.patch_version + 1
      Jeweler.bump_version(Jeweler.major_version, Jeweler.minor_version, patch)
      Jeweler.write_gemspec
    end
  end
end