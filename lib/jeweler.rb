require 'date'

require 'jeweler/bumping'
require 'jeweler/versioning'

class Jeweler
  def self.gemspec=(gemspec)
    @@instance = new(gemspec)
  end
  
  def self.instance
    @@instance
  end
  
  include Jeweler::Bumping
  include Jeweler::Versioning
  
  attr_reader :gemspec
  attr_accessor :base_dir
  def initialize(gemspec, base_dir = '.')
    @gemspec = gemspec
    @base_dir = base_dir
    
    load_version()
    
    @gemspec.version = version
    @gemspec.files ||= FileList["[A-Z]*", "{generators,lib,test,spec}/**/*"]
  end
  
  def date
    date = DateTime.now
    "#{date.year}-#{date.month}-#{date.day}"
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