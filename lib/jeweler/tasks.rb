desc "Generate a gemspec file for GitHub"
task :gemspec do
  Jeweler.instance.write_gemspec
end

desc "Displays the current version"
task :version do
  puts Jeweler.instance.version
end

namespace :version do
  namespace :bump do
    desc "Bump the gemspec a major version."
    task :major do
      jeweler = Jeweler.instance
      
      major = jeweler.major_version + 1
      
      jeweler.bump_version(major, 0, 0)
      jeweler.write_gemspec
      
      puts "Version bumped to #{jeweler.version}"
    end
    
    desc "Bump the gemspec a minor version."
    task :minor do
      jeweler = Jeweler.instance
      jeweler.bump_minor_version
      puts "Version bumped to #{jeweler.version}"
    end
    
    desc "Bump the gemspec a patch version."
    task :patch do
      jeweler = Jeweler.instance
      jeweler.bump_patch_version
      puts "Version bumped to #{jeweler.version}"
    end
  end
end