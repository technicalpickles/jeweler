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

    require 'jeweler/generator/testing_frameworks/base'
    require 'jeweler/generator/testing_frameworks/bacon'
    require 'jeweler/generator/testing_frameworks/micronaut'
    require 'jeweler/generator/testing_frameworks/minitest'
    require 'jeweler/generator/testing_frameworks/rspec'
    require 'jeweler/generator/testing_frameworks/shoulda'
    require 'jeweler/generator/testing_frameworks/testspec'
    require 'jeweler/generator/testing_frameworks/testunit'
    require 'jeweler/generator/testing_frameworks/riot'
    require 'jeweler/generator/testing_frameworks/shindo'
    require 'jeweler/generator/cucumber'
    require 'jeweler/generator/reek'
    require 'jeweler/generator/roodi'

    attr_accessor :user_name, :user_email, :summary, :homepage,
                  :description, :project_name, :github_username, :github_token,
                  :repo, :should_create_remote_repo, 
                  :testing_framework, :testing_framework_base, :documentation_framework,
                  :should_setup_rubyforge,
                  :development_dependencies,
                  :options,
                  :git_remote,
                  :plugins

    def initialize(options = {})
      self.options = options

      self.project_name   = options[:project_name]
      if self.project_name.nil? || self.project_name.squeeze.strip == ""
        raise NoGitHubRepoNameGiven
      end

      self.development_dependencies = []
      self.plugins = []
      self.testing_framework  = options[:testing_framework]
      self.documentation_framework = options[:documentation_framework]
      self.destination_root             = Pathname.new(options[:directory] || self.project_name).expand_path

      testing_framework_class_name = self.testing_framework.to_s.capitalize

      if TestingFrameworks.const_defined?(testing_framework_class_name)
        self.testing_framework_base = TestingFrameworks.const_get(testing_framework_class_name).new(self)
        plugins << self.testing_framework_base
      else
        raise ArgumentError, "Using #{testing_framework} requires a #{testing_framework_class_name} to be defined"
      end

      begin
        generator_mixin_name = "#{self.documentation_framework.to_s.capitalize}Mixin"
        generator_mixin = self.class.const_get(generator_mixin_name)
        extend generator_mixin
      rescue NameError => e
        raise ArgumentError, "Unsupported documentation framework (#{documentation_framework})"
      end


      self.summary                = options[:summary] || 'TODO: one-line summary of your gem'
      self.description            = options[:description] || 'TODO: longer description of your gem'
      self.should_setup_rubyforge = options[:rubyforge]

      development_dependencies << ["bundler", ">= 0.9.5"] # TODO make bundler optional?
      development_dependencies << ["jeweler", ">= 1.4.0"]
      
      plugins << Cucumber.new(self, testing_framework_base) if options[:use_cucumber]
      plugins << Reek.new(self) if options[:use_reek]
      plugins << Roodi.new(self) if options[:use_roodi]

      self.user_name       = options[:user_name]
      self.user_email      = options[:user_email]
      self.homepage        = options[:homepage]
      
      self.git_remote      = options[:git_remote]

      raise NoGitUserName unless self.user_name
      raise NoGitUserEmail unless self.user_email

      extend GithubMixin
    end

    def run
      template '.gitignore'
      template 'Rakefile'
      template 'Gemfile'
      template 'LICENSE'
      template 'README.rdoc'
      template '.document'
      create_file "lib/#{project_name}.rb"

      plugins.each do |plugin|
        plugin.run
      end

      git_init '.'
      add_git_remote '.', 'origin', git_remote


      $stdout.puts "Jeweler has prepared your gem in #{destination_root}"
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
