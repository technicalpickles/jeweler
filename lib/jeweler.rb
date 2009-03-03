require 'date'
require 'rubygems/builder'

require 'jeweler/version'
require 'jeweler/gemspec'
require 'jeweler/errors'
require 'jeweler/generator'
require 'jeweler/generator/options'
require 'jeweler/generator/application'

require 'jeweler/commands'

require 'jeweler/tasks'

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler

  attr_reader :gemspec
  attr_accessor :base_dir, :output

  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?

    @base_dir = base_dir
    @gemspec  = fill_in_gemspec_defaults(gemspec)
    @repo     = Git.open(base_dir) if in_git_repo?
    @version  = Jeweler::Version.new(@base_dir)
    @output   = $stdout
  end

  # Major version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 1.
  def major_version
    @version.major
  end

  # Minor version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def minor_version
    @version.minor
  end

  # Patch version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def patch_version
    @version.patch
  end

  # Human readable version, which is used in the gemspec.
  def version
    @version.to_s
  end

  # Writes out the gemspec
  def write_gemspec
    @version.refresh

    command = build_command(Jeweler::Commands::WriteGemspec)
    command.run
  end

  # Validates the project's gemspec from disk in an environment similar to how 
  # GitHub would build from it. See http://gist.github.com/16215
  def validate_gemspec
    begin
      gemspec_helper.parse
      output.puts "#{gemspec_path} is valid."
    rescue Exception => e
      output.puts "#{gemspec_path} is invalid. See the backtrace for more details."
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

  def build_gem
    parsed_gemspec = unsafe_parse_gemspec()
    Gem::Builder.new(parsed_gemspec).build

    pkg_dir = File.join(@base_dir, 'pkg')
    FileUtils.mkdir_p pkg_dir

    gem_filename = File.join(@base_dir, parsed_gemspec.file_name)
    FileUtils.mv gem_filename, pkg_dir
  end

  def install_gem
    command = "sudo gem install #{gem_path}"
    output.puts "Executing #{command.inspect}:"
    sh command
  end

  # Bumps the patch version.
  #
  # 1.5.1 -> 1.5.2
  def bump_patch_version(options = {})
    build_command(Jeweler::Commands::Version::BumpPatch).run
  end

  # Bumps the minor version.
  #
  # 1.5.1 -> 1.6.0
  def bump_minor_version(options = {})
    build_command(Jeweler::Commands::Version::BumpMinor).run
  end

  # Bumps the major version.
  #
  # 1.5.1 -> 2.0.0
  def bump_major_version(options = {})
    build_command(Jeweler::Commands::Version::BumpMajor).run
  end

  # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
  def write_version(major, minor, patch, options = {})
    command = build_command(Jeweler::Commands::Version::Write)
    command.major = major
    command.minor = minor
    command.patch = patch

    command.run
  end


  def release
    build_command(Jeweler::Commands::Release).run
  end

  protected

  def build_command(command_class)
    command = command_class.new
    command.repo = @repo if command.respond_to?(:repo=)
    command.version_helper = @version if command.respond_to?(:version_helper=)
    command.gemspec = @gemspec if command.respond_to?(:gemspec=)
    command.commit = true if command.respond_to?(:commit=)
    command.version = @version.to_s if command.respond_to?(:version=)
    command.output = output if command.respond_to?(:output=)
    command.base_dir = @base_dir if command.respond_to?(:base_dir=)

    command
  end

  def gemspec_helper(&block)
    GemSpecHelper.new(@gemspec, @base_dir, &block)
  end

  def gemspec_path
    gemspec_helper.path
  end

  def gem_path
    parsed_gemspec = unsafe_parse_gemspec()
    File.join(@base_dir, 'pkg', parsed_gemspec.file_name)
  end

  def in_git_repo?
    File.exists?(File.join(self.base_dir, '.git'))
  end

  def fill_in_gemspec_defaults(gemspec)
    if gemspec.files.nil? || gemspec.files.empty?
      gemspec.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]
    end

    if gemspec.executables.nil? || gemspec.executables.empty?
      gemspec.executables = Dir["#{@base_dir}/bin/*"].map do |f|
        File.basename(f)
      end
    end

    gemspec.has_rdoc = true
    gemspec.rdoc_options << '--inline-source' << '--charset=UTF-8'

    if gemspec.extra_rdoc_files.nil? || gemspec.extra_rdoc_files.empty?
      gemspec.extra_rdoc_files = FileList["README*", "ChangeLog*", "LICENSE*"]
    end

    gemspec
  end
end

