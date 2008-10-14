require 'ruby-debug'
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
task :version => 'version:display'

namespace :version do

  desc "Creates an initial version file"
  task :write do
    jeweler = Jeweler.instance
    jeweler.write_version(ENV['MAJOR'], ENV['MINOR'], ENV['PATCH'])
  end
  
  def ensure_version_yml(&block)
    if File.exists? 'VERSION.yml'
      block.call
    else
      abort "VERSION.yml is needed for this operation, but it doesn't exist. Try running 'rake version:write' first."
    end
  end
  
  desc "Displays the current version"
  task :display do
    ensure_version_yml do
      puts "Current version: #{Jeweler.instance.version}"
    end
  end
  
  namespace :bump do
    desc "Bump the gemspec by a major version."
    task :major => 'version:display' do
      ensure_version_yml do
        jeweler = Jeweler.instance
        jeweler.bump_major_version
        jeweler.write_gemspec
      end
    end
    
    desc "Bump the gemspec by a minor version."
    task :minor => 'version:display' do
      ensure_version_yml do
        jeweler = Jeweler.instance
        jeweler.bump_minor_version
        jeweler.write_gemspec
      end
    end
    
    desc "Bump the gemspec by a patch version."
    task :patch => 'version:display' do
      ensure_version_yml do
        jeweler = Jeweler.instance
        jeweler.bump_patch_version
        jeweler.write_gemspec
      end
    end
  end
end