require 'date'

require 'jeweler/bumping'
require 'jeweler/versioning'
require 'jeweler/singleton'
require 'jeweler/gemspec'
require 'jeweler/errors'
require 'jeweler/generator'

require 'jeweler/tasks' if defined?(Rake)

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler
  include Jeweler::Singleton
  include Jeweler::Bumping
  include Jeweler::Versioning
  include Jeweler::Gemspec
  
  attr_reader :gemspec
  attr_accessor :base_dir
  
  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?
    @gemspec = gemspec
    @base_dir = base_dir
    
    @gemspec.files ||= FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]
  end
end

