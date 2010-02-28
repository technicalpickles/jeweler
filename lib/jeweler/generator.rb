require 'git'
require 'erb'

require 'net/http'
require 'uri'

require 'thor'

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

    require 'jeweler/generator/bacon_mixin'
    require 'jeweler/generator/micronaut_mixin'
    require 'jeweler/generator/minitest_mixin'
    require 'jeweler/generator/rspec_mixin'
    require 'jeweler/generator/shoulda_mixin'
    require 'jeweler/generator/testspec_mixin'
    require 'jeweler/generator/testunit_mixin'
    require 'jeweler/generator/riot_mixin'
    require 'jeweler/generator/shindo_mixin'

    require 'jeweler/generator/rdoc_mixin'
    require 'jeweler/generator/yard_mixin'

    attr_accessor :user_name, :user_email, :summary, :homepage,
                  :description, :project_name, :github_username, :github_token,
                  :repo, :should_create_remote_repo, 
                  :testing_framework, :documentation_framework,
                  :should_use_cucumber, :should_setup_gemcutter,
                  :should_setup_rubyforge, :should_use_reek, :should_use_roodi,
                  :development_dependencies,
                  :options,
                  :git_remote

    def initialize(options = {})
      self.options = options

      self.project_name   = options[:project_name]
      if self.project_name.nil? || self.project_name.squeeze.strip == ""
        raise NoGitHubRepoNameGiven
      end

      self.development_dependencies = []
      self.testing_framework  = options[:testing_framework]
      self.documentation_framework = options[:documentation_framework]
      begin
        generator_mixin_name = "#{self.testing_framework.to_s.capitalize}Mixin"
        generator_mixin = self.class.const_get(generator_mixin_name)
        extend generator_mixin
      rescue NameError => e
        raise ArgumentError, "Unsupported testing framework (#{testing_framework})"
      end

      begin
        generator_mixin_name = "#{self.documentation_framework.to_s.capitalize}Mixin"
        generator_mixin = self.class.const_get(generator_mixin_name)
        extend generator_mixin
      rescue NameError => e
        raise ArgumentError, "Unsupported documentation framework (#{documentation_framework})"
      end

      self.destination_root             = Pathname.new(options[:directory] || self.project_name).expand_path

      self.summary                = options[:summary] || 'TODO: one-line summary of your gem'
      self.description            = options[:description] || 'TODO: longer description of your gem'
      self.should_use_cucumber    = options[:use_cucumber]
      self.should_use_reek        = options[:use_reek]
      self.should_use_roodi       = options[:use_roodi]
      self.should_setup_gemcutter = options[:gemcutter]
      self.should_setup_rubyforge = options[:rubyforge]

      development_dependencies << ["cucumber", ">= 0"] if should_use_cucumber

      # TODO make bundler optional?
      development_dependencies << ["bundler", ">= 0.9.5"]
      development_dependencies << ["jeweler", ">= 1.4.0"]
      development_dependencies << ["rcov", ">= 0"]

      development_dependencies << ["reek", ">= 0"] if should_use_reek
      development_dependencies << ["roodi", ">= 0"] if should_use_roodi

      self.user_name       = options[:user_name]
      self.user_email      = options[:user_email]
      self.homepage        = options[:homepage]
      
      self.git_remote      = options[:git_remote]

      raise NoGitUserName unless self.user_name
      raise NoGitUserEmail unless self.user_email

      extend GithubMixin
    end

    def run
      create_files
      create_version_control
      $stdout.puts "Jeweler has prepared your gem in #{destination_root}"
      if should_create_remote_repo
        create_and_push_repo
        $stdout.puts "Jeweler has pushed your repo to #{homepage}"
      end
    end

    no_tasks do

      def constant_name
        self.project_name.split(/[-_]/).collect{|each| each.capitalize }.join
      end

      def lib_filename
        "#{project_name}.rb"
      end

      def require_name
        self.project_name
      end

      def file_name_prefix
        self.project_name.gsub('-', '_')
      end

      def lib_dir
        'lib'
      end

      def feature_filename
        "#{project_name}.feature"
      end

      def steps_filename
        "#{project_name}_steps.rb"
      end

      def features_dir
        'features'
      end

      def features_support_dir
        File.join(features_dir, 'support')
      end

      def features_steps_dir
        File.join(features_dir, 'step_definitions')
      end
    end

  private
    def create_files
      template '.gitignore'
      template 'Rakefile'
      template 'Gemfile'
      template 'LICENSE'
      template 'README.rdoc'
      template '.document'

      create_file           File.join(lib_dir, lib_filename)

      template File.join(testing_framework.to_s, 'helper.rb'),
                                File.join(test_dir, test_helper_filename)
      template File.join(testing_framework.to_s, 'flunking.rb'),
                                File.join(test_dir, test_filename)


      if testing_framework == :rspec
        template File.join(testing_framework.to_s, 'spec.opts'),
                                  File.join(test_dir, 'spec.opts')

      end

      if should_use_cucumber
        template File.join(%w(features default.feature)), File.join('features', feature_filename)

        template File.join(features_support_dir, 'env.rb')

        create_file           File.join(features_steps_dir, steps_filename)
      end

    end

    def render_template(source)
      template_contents = File.read(File.join(source_root, source))
      template          = ERB.new(template_contents, nil, '<>')

      # squish extraneous whitespace from some of the conditionals
      template.result(binding).gsub(/\n\n\n+/, "\n\n")
    end

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    def source_root
      self.class.source_root
    end

    def create_version_control
      Dir.chdir(destination_root) do
        begin
          @repo = Git.init()
        rescue Git::GitExecuteError => e
          raise GitInitFailed, "Encountered an error during gitification. Maybe the repo already exists, or has already been pushed to?"
        end

        begin
          @repo.add('.')
        rescue Git::GitExecuteError => e
          #raise GitAddFailed, "There was some problem adding this directory to the git changeset"
          raise
        end

        begin
          @repo.commit "Initial commit to #{project_name}."
        rescue Git::GitExecuteError => e
          raise
        end

        begin
          @repo.add_remote('origin', git_remote)
        rescue Git::GitExecuteError => e
          puts "Encountered an error while adding origin remote. Maybe you have some weird settings in ~/.gitconfig?"
          raise
        end
      end
    end
    
    def create_and_push_repo
      Net::HTTP.post_form URI.parse('http://github.com/api/v2/yaml/repos/create'),
                                'login' => github_username,
                                'token' => github_token,
                                'description' => summary,
                                'name' => project_name
      # TODO do a HEAD request to see when it's ready?
      @repo.push('origin')
    end
  end
end
