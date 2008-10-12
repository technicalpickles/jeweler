require 'date'

class Jeweler
  def self.gemspec=(gemspec)
    @@gemspec = gemspec
    load version_module_path
    @@gemspec.version = version
    @@gemspec.files ||= FileList["[A-Z]*", "{generators,lib,test,spec}/**/*"]
  end
  
  def self.major_version
    version_module.const_get(:MAJOR)
  end
  
  def self.minor_version
    version_module.const_get(:MINOR)
  end
  
  def self.patch_version
    version_module.const_get(:PATCH)
  end
  
  def self.version
    "#{major_version}.#{minor_version}.#{patch_version}"
  end
  
  def self.date
    date = DateTime.now
    "#{date.year}-#{date.month}-#{date.day}"
  end
    
  def self.bump_version(major, minor, patch)
    main_module_or_class = constantize(main_module_name)
    keyword = case main_module_or_class.class
    when Class
      'class'
    when Module
      'module'
    else
      raise "Uh, main_module_name should be a class or module, but was a #{main_module_or_class.class}"
    end
    
    File.open(version_module_path, 'w') do |file|
      file.write <<-END
#{keyword} #{main_module_name}
  module Version
    MAJOR = #{major}
    MINOR = #{minor}
    PATCH = #{patch}
  end
end
      END
    end
    @@gemspec.version = "#{major}.#{minor}.#{patch}"
    refresh_version
  end
  
  def self.write_gemspec
    @@gemspec.date = self.date
    File.open(gemspec_path, 'w') do |f|
      f.write @@gemspec.to_ruby
    end
  end
  
  private
  
  def self.gemspec_path
    "#{@@gemspec.name}.gemspec"
  end
  
  def self.version_module_path
    "lib/#{@@gemspec.name}/version.rb"
  end
  
  def self.version_module
    constantize("#{main_module_name}::Version")
  end
  
  def self.main_module_name
    camelize(@@gemspec.name)
  end
  
  def self.refresh_version
    # Remove the constants, so we can reload the version_module
    version_module.module_eval do
      remove_const(:MAJOR)
      remove_const(:MINOR)
      remove_const(:PATCH)
    end
    load version_module_path
  end
end

require 'jeweler/active_support' # Adds the stolen camelize and constantize

require 'jeweler/tasks'