require 'date'
require 'rubygems/builder'
require 'rubyforge'

require 'jeweler/version'
require 'jeweler/gemspec'
require 'jeweler/errors'
require 'jeweler/generator'
require 'jeweler/generator/options'
require 'jeweler/generator/application'

require 'jeweler/tasks'

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler

  attr_reader :gemspec
  attr_accessor :base_dir

  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?
    @gemspec = gemspec
    @base_dir = base_dir
    
    if @gemspec.files.nil? || @gemspec.files.empty?
      @gemspec.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]
    end

    if @gemspec.executables.nil? || @gemspec.executables.empty?
      @gemspec.executables = Dir["#{@base_dir}/bin/*"].map do |f|
        File.basename(f)
      end
    end

    @gemspec.has_rdoc = true
    @gemspec.rdoc_options << '--inline-source' << '--charset=UTF-8'
    @gemspec.extra_rdoc_files ||=  FileList["[A-Z]*.*"]

    if File.exists?(File.join(base_dir, '.git'))
      @repo = Git.open(base_dir)
    end

    @version = Jeweler::Version.new(@base_dir)
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
    $stdout.puts "Executing #{command.inspect}:"
    sh command
  end

  # Bumps the patch version.
  #
  # 1.5.1 -> 1.5.2
  def bump_patch_version(options = {})
    options = version_writing_options(options)

    @version.bump_patch
    @version.write

    commit_version if options[:commit]
  end

  # Bumps the minor version.
  #
  # 1.5.1 -> 1.6.0
  def bump_minor_version(options = {})
    options = version_writing_options(options)

    @version.bump_minor
    @version.write

    commit_version if options[:commit]
  end

  # Bumps the major version.
  #
  # 1.5.1 -> 2.0.0
  def bump_major_version(options = {})
    options = version_writing_options(options)

    @version.bump_major
    @version.write

    commit_version if options[:commit]
  end

  # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
  def write_version(major, minor, patch, options = {})
    options = version_writing_options(options)

    @version.update_to major, minor, patch
    @version.write

    @gemspec.version = @version.to_s

    commit_version if options[:commit]
  end


  def release
    @repo.checkout('master')

    raise "Hey buddy, try committing them files first" if any_pending_changes?

    write_gemspec()

    @repo.add(gemspec_path)
    $stdout.puts "Committing #{gemspec_path}"
    @repo.commit("Regenerated gemspec for version #{version}")

    $stdout.puts "Pushing master to origin"
    @repo.push

    $stdout.puts "Tagging #{release_tag}"
    @repo.add_tag(release_tag)

    $stdout.puts "Pushing #{release_tag} to origin"
    @repo.push('origin', release_tag)
  end
  
  def release_gem_to_rubyforge
    rf = RubyForge.new
    rf.configure rescue nil
    $stdout.puts 'Logging in'
    rf.login
  
    c = rf.userconfig
    c['release_notes'] = @gemspec.description if @gemspec.description
    c['preformatted'] = true
  
    puts "Releasing #{@gemspec.name} v. #{@version} as #{@gemspec.rubyforge_project}"
    rf.add_release(@gemspec.rubyforge_project, @gemspec.name, @version.to_s, gem_path)
  end
  
  def release_tag
    @release_tag ||= "v#{version}"
  end

  protected

  def version_writing_options(options)
    {:commit => true}.merge(options)
  end

  def commit_version
    if @repo
      @repo.add('VERSION.yml')
      @repo.commit("Version bump to #{version}", 'VERSION.yml')
    end
  end

  def refresh_version
    @version.refresh
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

  def any_pending_changes?
    unless ENV['JEWELER_DEBUG'].nil? || ENV['JEWELER_DEBUG'].squeeze == ''
      require 'ruby-debug'; breakpoint
    end
    !(@repo.status.added.empty? && @repo.status.deleted.empty? && @repo.status.changed.empty?)
  end

  protected
    def any_pending_changes?
      !(@repo.status.added.empty? && @repo.status.deleted.empty? && @repo.status.changed.empty?)
    end
end

