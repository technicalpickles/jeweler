require 'date'

class Jeweler
  def self.gemspec=(gemspec)
    @@instance = new(gemspec)
  end
  
  def self.instance
    @@instance
  end
  
  attr_reader :gemspec
  attr_accessor :base_dir
  def initialize(gemspec, base_dir = '.')
    @gemspec = gemspec
    @base_dir = base_dir
    
    load_version()
    
    @gemspec.version = version
    @gemspec.files ||= FileList["[A-Z]*", "{generators,lib,test,spec}/**/*"]
  end
  
  def major_version
    version_module.const_get(:MAJOR)
  end
  
  def minor_version
    version_module.const_get(:MINOR)
  end
  
  def patch_version
    version_module.const_get(:PATCH)
  end
  
  def version
    "#{major_version}.#{minor_version}.#{patch_version}"
  end
  
  def date
    date = DateTime.now
    "#{date.year}-#{date.month}-#{date.day}"
  end
  
  def bump_patch_version()
    patch = self.patch_version + 1
    
    bump_version(major_version, minor_version, patch)
    write_gemspec
  end
  
  def bump_minor_version()
    minor = minor_version + 1
    
    bump_version(major_version, minor, 0)
    write_gemspec
  end
  
  def bump_major_version()
    major = major_version + 1
    
    bump_version(major, 0, 0)
    write_gemspec
  end
    
  def bump_version(major, minor, patch)
    main_module_or_class = constantize(main_module_name)
    keyword = top_level_keyword
    
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
    @gemspec.version = "#{major}.#{minor}.#{patch}"
    refresh_version
  end
  
  def write_gemspec
    @gemspec.date = self.date
    File.open(gemspec_path, 'w') do |f|
      f.write @gemspec.to_ruby
    end
  end
  
  private
  
  def top_level_keyword
    main_module_or_class = constantize(main_module_name)
    case main_module_or_class
    when Class
      'class'
    when Module
      'module'
    else
      raise "Uh, main_module_name should be a class or module, but was a #{main_module_or_class.class}"
    end
  end
  
  def gemspec_path
    File.join(@base_dir, "#{@gemspec.name}.gemspec")
  end
  
  def version_module_path
    File.join(@base_dir, 'lib', @gemspec.name, 'version.rb')
  end
  
  def version_module
    constantize("#{main_module_name}::Version")
  end
  
  def main_module_name
    camelize(@gemspec.name)
  end
  
  def refresh_version
    # Remove the constants, so we can reload the version_module
    undefine_versions()
    load_version()
  end
  
  def undefine_versions
    version_module.module_eval do
      remove_const(:MAJOR) if const_defined?(:MAJOR)
      remove_const(:MINOR) if const_defined?(:MINOR)
      remove_const(:PATCH) if const_defined?(:PATCH)
    end
  end
  
  def load_version
    load version_module_path
  end
end

require 'jeweler/active_support' # Adds the stolen camelize and constantize

require 'jeweler/tasks' if defined?(Rake)