require 'date'

require 'jeweler/bumping'
require 'jeweler/versioning'
require 'jeweler/singleton'
require 'jeweler/gemspec'

require 'jeweler/tasks' if defined?(Rake)
require 'jeweler/active_support' # Adds the stolen camelize and constantize

class Jeweler
  include Jeweler::Singleton
  include Jeweler::Bumping
  include Jeweler::Versioning
  include Jeweler::Gemspec
  
  attr_reader :gemspec
  attr_accessor :base_dir
  
  def initialize(gemspec, base_dir = '.')
    @gemspec = gemspec
    @base_dir = base_dir
    
    load_version()
    
    @gemspec.version = version
    @gemspec.files ||= FileList["[A-Z]*", "{generators,lib,test,spec}/**/*"]
  end
  
private  
  def main_module_name
    camelize(@gemspec.name)
  end
end

