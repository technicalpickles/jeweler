require 'date'

require 'jeweler/bumping'
require 'jeweler/versioning'
require 'jeweler/version'
require 'jeweler/gemspec'
require 'jeweler/errors'
require 'jeweler/generator'
require 'jeweler/release'

require 'jeweler/tasks'

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler
  include Jeweler::Bumping
  include Jeweler::Versioning
  include Jeweler::Release

  attr_reader :gemspec
  attr_accessor :base_dir

  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?
    @gemspec = gemspec
    @base_dir = base_dir

    @gemspec.files ||= FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]

    if File.exists?(File.join(base_dir, '.git'))
      @repo = Git.open(base_dir)
    end

    @version = Jeweler::Version.new(@base_dir)
  end

  # Writes out the gemspec
  def write_gemspec
    self.refresh_version

    helper = gemspec_helper do |s|
      s.version = self.version
      s.date = Time.now
    end

    helper.write

    puts "Generated: #{helper.path}"
  end

  # Validates the project's gemspec from disk in an environment similar to how 
  # GitHub would build from it. See http://gist.github.com/16215
  def validate_gemspec
    begin
      gemspec_helper.parse
      puts "#{gemspec_path} is valid."
    rescue Exception => e
      puts "#{gemspec_path} is invalid. See the backtrace for more details."
      raise
    end
  end


  # is the project's gemspec from disk valid?
  def valid_gemspec?
    gemspec_helper.valid?
  end

  # parses the project's gemspec from disk without extra sanity checks
  def unsafe_parse_gemspec(data = nil)
    data ||= File.read(gemspec_path)
    eval(data, binding, gemspec_path)
  end

  protected

  def gemspec_helper(&block)
    GemSpecHelper.new(@gemspec, @base_dir, &block)
  end

  def gemspec_path
    gemspec_helper.path
  end
end

