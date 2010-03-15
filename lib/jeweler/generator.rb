require 'git'
require 'erb'

require 'net/http'
require 'uri'

require 'thor'
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
  class Generator 
    include Thor::Base
    include Thor::Actions

    require 'jeweler/generator/options'
    require 'jeweler/generator/application'

    require 'jeweler/generator/github_mixin'

    require 'jeweler/generator/rdoc_mixin'
    require 'jeweler/generator/yard_mixin'

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
                  :options,
                  :git_remote,
                  :plugins

    def initialize(options = {})
      self.options = options

      self.summary      = options[:summary] || 'TODO: one-line summary of your gem'
      self.description  = options[:description] || 'TODO: longer description of your gem'
      self.user_name    = options[:user_name]
      self.user_email   = options[:user_email]
      self.homepage     = options[:homepage]
      self.git_remote   = options[:git_remote]
      self.project_name = options[:project_name]
      if self.project_name.nil? || self.project_name.squeeze.strip == ""
        raise NoGitHubRepoNameGiven
      end

      raise NoGitUserName unless self.user_name
      raise NoGitUserEmail unless self.user_email

      self.plugins                  = []
      self.destination_root         = Pathname.new(options[:directory] || self.project_name).expand_path

      self.testing_framework_base = TestingFramework.determine_class(options[:testing_framework]).new(self)
      documentation_framework_base = DocumentationFrameworks.klass(options[:documentation_framework]).new(self)

      plugins << Bundler.new(self)
      plugins << Default.new(self)
      plugins << Rubyforge.new(self) if options[:rubyforge]
      plugins << self.testing_framework_base
      plugins << documentation_framework_base
      plugins << Cucumber.new(self, testing_framework_base) if options[:use_cucumber]
      plugins << Reek.new(self) if options[:use_reek]
      plugins << Roodi.new(self) if options[:use_roodi]
      plugins << GitVcs.new(self)

      extend GithubMixin
    end

    def run
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
