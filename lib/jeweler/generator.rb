require 'git'
require 'erb'

require 'net/http'
require 'uri'

require 'thor'
require 'thor/group'
require 'pathname'

require 'thor/actions/git_init'
require 'thor/actions/git_remote'
require 'thor/actions/github_repo'

class Jeweler
  class NoGitUserName < StandardError
  end
  class NoGitUserEmail < StandardError
  end
  class FileInTheWay < StandardError
  end
  class NoGitHubRepoNameGiven < StandardError
  end
  class NoGitHubUser < StandardError
  end
  class NoGitHubToken < StandardError
  end
  class GitInitFailed < StandardError
  end    

  # Generator for creating a jeweler-enabled project
  class Generator < Thor::Group
    include Thor::Actions

    require 'jeweler/generator/options'
    require 'jeweler/generator/application'

    require 'jeweler/generator/github_mixin'

    require 'jeweler/generator/plugin'

    require 'jeweler/generator/default'
    require 'jeweler/generator/bundler'
    require 'jeweler/generator/documentation_frameworks'
    require 'jeweler/generator/testing_frameworks'
    require 'jeweler/generator/cucumber'
    require 'jeweler/generator/reek'
    require 'jeweler/generator/roodi'
    require 'jeweler/generator/git_vcs'
    require 'jeweler/generator/rubyforge'

    attr_accessor :user_name, :user_email, :summary, :homepage,
                  :description, :project_name, :github_username, :github_token,
                  :repo, :should_create_remote_repo, 
                  :testing_framework_base,
                  :git_remote,
                  :plugins

    argument :directory, :required => true

    class_option :summary, :type => :string, :default => 'TODO: one-line summary of your gem',
      :desc => 'one-line summary of your gem'
    class_option :homepage, :type => :string,
      :desc => "the homepage for your project (defaults to the GitHub repo)"
    class_option :description, :type => :string, :default => 'TODO: longer description of your gem' ,
      :desc => 'longer description of your gem'

    class_option :user_name, :type => :string,
      :desc => "the user's name, credited in the LICENSE"
    class_option :user_email, :type => :string,
      :desc => "the user's email, ie that is credited in the Gem specification"

    class_option :testing_framework, :type => :string, :default => 'shoulda',
      :desc => 'the testing framework to generate'
    class_option :documentation_framework, :type => :string, :default => 'rdoc',
      :desc => 'documentation framework to generate'

    class_option :git_remote, :type => :string,
      :desc => 'URI to use for git origin remote'
    class_option :create_repo, :type => :boolean, :default => false,
      :desc => 'create a repository on GitHub'

    def initialize(args = [], opts = {}, config = {})
      # next section yanked from Thor::Base, because apparently Thor::Group will pass in opts as an array
      parse_options = self.class.class_options
      array_options = hash_opts = nil
      if opts.is_a?(Array)
        task_options  = config.delete(:task_options) # hook for start
        parse_options = parse_options.merge(task_options) if task_options
        array_options, hash_options = opts, {}
      else
        array_options, hash_options = [], opts
      end
      opts = Thor::Options.parse(parse_options, array_options).dup

      git_config = Git.global_config
      opts[:user_name]       ||= git_config['user.name']
      opts[:user_email]      ||= git_config['user.email']
      opts[:github_username] ||= git_config['github.user']
      opts[:github_token]    ||= git_config['github.token']

      super

      self.destination_root         = Pathname.new(directory).expand_path

      self.project_name = Pathname.new(self.destination_root).basename.to_s
      self.summary      = options[:summary] 
      self.description  = options[:description]
      self.user_name    = options[:user_name]
      self.user_email   = options[:user_email]
      self.homepage     = options[:homepage]
      self.git_remote   = options[:git_remote]

      raise NoGitUserName unless self.user_name
      raise NoGitUserEmail unless self.user_email

      self.plugins                  = []

      self.testing_framework_base = TestingFramework.determine_class(options[:testing_framework]).new(self)
      documentation_framework_base = DocumentationFrameworks.klass(options[:documentation_framework]).new(self)

      plugins << Bundler.new(self)
      plugins << Default.new(self)
      plugins << Rubyforge.new(self) if options[:rubyforge]
      plugins << self.testing_framework_base
      plugins << documentation_framework_base
      plugins << Cucumber.new(self, testing_framework_base) if options[:cucumber]
      plugins << Reek.new(self) if options[:reek]
      plugins << Roodi.new(self) if options[:roodi]
      plugins << GitVcs.new(self)

      extend GithubMixin
    end

    def generate
      plugins.each do |plugin|
        plugin.run
      end

      if options[:create_repo]
        github_repo :login => options[:github_username],
                    :token => options[:github_token],
                    :description => options[:description],
                    :name => options[:project_name]
      end
    end

    no_tasks do

      def constant_name
        self.project_name.split(/[-_]/).collect{|each| each.capitalize }.join
      end

      def require_name
        self.project_name
      end

      def file_name_prefix
        self.project_name.gsub('-', '_')
      end

      def rakefile_head_snippet_plugins
        plugins.select {|plugin| plugin.rakefile_head_snippet }
      end

      def rakefile_snippet_plugins
        plugins.reject {|plugin| plugin.rakefile_snippets.empty? }
      end

      def jeweler_task_snippet_plugins
        plugins.select {|plugin| plugin.jeweler_task_snippet }
      end

      def plugins_with_development_dependencies
        plugins.reject {|plugin| plugin.development_dependencies.empty? }
      end

      def development_dependencies
        plugins_with_development_dependencies.inject([]) do |acc, plugin|
          acc.concat(plugin.development_dependencies)
        end
      end

    end

  protected

  private

    def render_erb(source)
      template          = ERB.new(source, nil, '<>')

      # squish extraneous whitespace from some of the conditionals
      template.result(binding).gsub(/\n\n\n+/, "\n\n")
    end

    def render_template(source)
      template_contents = File.read(File.join(source_root, source))
      render_erb(template_contents)
    end

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    def source_root
      self.class.source_root
    end
  end
end
