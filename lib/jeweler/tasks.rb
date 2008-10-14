desc "Generate and validates gemspec"
task :gemspec => ['gemspec:generate', 'gemspec:validate']

namespace :gemspec do
  desc "Validates the gemspec"
  task :validate do
    Jeweler.instance.validate_gemspec
  end
  
  desc "Generates the gemspec"
  task :generate do
    Jeweler.instance.write_gemspec
  end
end

desc "Displays the current version"
task :version do
  puts Jeweler.instance.version
end

namespace :version do
  desc "Creates an initial version file"
  task :create do
    jeweler = Jeweler.instance
    jeweler.write_version(ENV['MAJOR'], ENV['MINOR'], ENV['PATCH'])
    puts "Wrote VERSION.yml: #{jeweler.version}"
  end
  namespace :bump do
    desc "Bump the gemspec by a major version."
    task :major do
      jeweler = Jeweler.instance
      jeweler.bump_major_version
      puts "Version bumped to #{jeweler.version}"
    end
    
    desc "Bump the gemspec by a minor version."
    task :minor do
      jeweler = Jeweler.instance
      jeweler.bump_minor_version
      puts "Version bumped to #{jeweler.version}"
    end
    
    desc "Bump the gemspec by a patch version."
    task :patch do
      jeweler = Jeweler.instance
      jeweler.bump_patch_version
      puts "Version bumped to #{jeweler.version}"
    end
  end
end