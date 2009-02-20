require 'git'
require 'erb'

require 'net/http'
require 'uri'

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

  class Generator    
    attr_accessor :target_dir, :user_name, :user_email, :summary, :testing_framework,
                  :github_repo_name, :github_username, :github_token,
                  :repo, :should_create_repo

    def initialize(github_repo_name, options = {})
      if github_repo_name.nil?
        raise NoGitHubRepoNameGiven
      end

      use_user_git_config
      
      self.github_repo_name   = github_repo_name

      self.testing_framework  = options[:testing_framework] || :shoulda
      self.target_dir         = options[:directory] || self.github_repo_name

      self.should_create_repo = options[:create_repo]
      self.summary            = options[:summary] || 'TODO'
    end

    def run
      create_files
      gitify
      $stdout.puts "Jeweler has prepared your gem in #{github_repo_name}"
      if should_create_repo
        create_and_push_repo
        $stdout.puts "Jeweler has pushed your repo to #{github_url}"
        enable_gem_for_repo
        $stdout.puts "Jeweler has enabled gem building for your repo"
      end
    end


    def test_dir
      test_or_spec
    end

    def feature_support_require
      case testing_framework.to_sym
      when :testunit, :shoulda, :bacon # NOTE bacon doesn't really work inside of cucumber
        'test/unit/assertions'
      when :minitest
        'mini/test'
      when :rspec
        'spec/expectations'
      else
        raise "Don't know what to require for #{testing_framework}"
      end
    end

    def feature_support_extend
      case testing_framework.to_sym
      when :testunit, :shoulda, :bacon # NOTE bacon doesn't really work inside of cucumber
        'Test::Unit::Assertions'
      when :minitest
        'Mini::Test::Assertions'
      when :rspec
        nil
      else
        raise "Don't know what to extend for #{testing_framework}"
      end
    end

    def github_remote
      "git@github.com:#{github_username}/#{github_repo_name}.git"
    end

    def github_url
      "http://github.com/#{github_username}/#{github_repo_name}"
    end

    
    def constant_name
      self.github_repo_name.split(/[-_]/).collect{|each| each.capitalize }.join
    end

    def file_name_prefix
      self.github_repo_name.gsub('-', '_')
    end

    def lib_dir
      'lib'
    end

    def test_dir
      test_or_spec
    end

    def test_filename
      "#{file_name_prefix}_#{test_or_spec}.rb"
    end

    def test_helper_filename
      "#{test_or_spec}_helper.rb"
    end

    def feature_filename
      "#{file_name_prefix}.feature"
    end

    def steps_filename
      "#{file_name_prefix}_steps.rb"
    end

    def features_dir
      'features'
    end

    def features_support_dir
      File.join(features_dir, 'support')
    end

    def features_steps_dir
      File.join(features_dir, 'steps')
    end

  protected

    # This is in a separate method so we can stub it out during testing
    def read_git_config
      # we could just use Git::Base's .config, but that relies on a repo being around already
      # ... which we don't have yet, since this is part of a sanity check
      lib = Git::Lib.new(nil, nil)
      config = lib.parse_config '~/.gitconfig'
    end

    def test_or_spec
      case testing_framework.to_sym
      when :shoulda, :testunit, :minitest
        'test'
      when :bacon, :rspec
        'spec'
      else
        raise "Unknown test style: #{testing_framework}"
      end
    end

  private
    def create_files
      unless File.exists?(target_dir) || File.directory?(target_dir)
        FileUtils.mkdir target_dir
      else
        raise FileInTheWay, "The directory #{target_dir} already exists, aborting. Maybe move it out of the way before continuing?"
      end


      output_template_in_target '.gitignore'
      output_template_in_target 'Rakefile'
      output_template_in_target 'LICENSE'
      output_template_in_target 'README.rdoc'

      mkdir_in_target           lib_dir
      touch_in_target           File.join(lib_dir, "#{file_name_prefix}.rb")

      mkdir_in_target           test_dir
      output_template_in_target File.join(testing_framework.to_s, 'helper.rb'), File.join(test_dir, test_helper_filename)
      output_template_in_target File.join(testing_framework.to_s, 'flunking.rb'), File.join(test_dir, test_filename)

      mkdir_in_target           features_dir
      output_template_in_target File.join(%w(features default.feature)), File.join('features', feature_filename)

      mkdir_in_target           features_support_dir
      output_template_in_target File.join(features_support_dir, 'env.rb')

      mkdir_in_target           features_steps_dir
      output_template_in_target File.join(features_steps_dir, 'default_steps.rb'), File.join('features', 'steps', steps_filename)

    end

    def use_user_git_config
      git_config = self.read_git_config

      unless git_config.has_key? 'user.name'
        raise NoGitUserName
      end
      
      unless git_config.has_key? 'user.email'
        raise NoGitUserEmail
      end
      
      unless git_config.has_key? 'github.user'
        raise NoGitHubUser
      end
      
      unless git_config.has_key? 'github.token'
        raise NoGitHubToken
      end

      self.user_name       = git_config['user.name']
      self.user_email      = git_config['user.email']
      self.github_username = git_config['github.user']
      self.github_token    = git_config['github.token']
    end

    def output_template_in_target(source, destination = source)
      final_destination = File.join(target_dir, destination)

      template_contents = File.read(File.join(template_dir, source))
      template = ERB.new(template_contents, nil, '<>')

      template_result = template.result(binding)

      File.open(final_destination, 'w') {|file| file.write(template_result)}

      $stdout.puts "\tcreate\t#{destination}"
    end

    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end

    def mkdir_in_target(directory)
      final_destination = File.join(target_dir, directory)

      FileUtils.mkdir final_destination

      $stdout.puts "\tcreate\t#{directory}"
    end

    def touch_in_target(destination)
      final_destination = File.join(target_dir, destination)
      FileUtils.touch  final_destination
      $stdout.puts "\tcreate\t#{destination}"
    end

    def gitify
      saved_pwd = Dir.pwd
      Dir.chdir(target_dir)
      begin
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
          @repo.commit "Initial commit to #{github_repo_name}."
        rescue Git::GitExecuteError => e
          raise
        end

        begin
          @repo.add_remote('origin', github_remote)
        rescue Git::GitExecuteError => e
          puts "Encountered an error while adding origin remote. Maybe you have some weird settings in ~/.gitconfig?"
          raise
        end
      ensure
        Dir.chdir(saved_pwd)
      end
    end
    
    def create_and_push_repo
      Net::HTTP.post_form URI.parse('http://github.com/repositories'),
                                'login' => github_username,
                                'token' => github_token,
                                'repository[description]' => summary,
                                'repository[name]' => github_repo_name
      # TODO do a HEAD request to see when it's ready
      @repo.push('origin')
    end

    def enable_gem_for_repo
      url = "https://github.com/#{github_username}/#{github_repo_name}/update"
      `curl -F 'login=#{github_username}' -F 'token=#{github_token}' -F 'field=repository_rubygem' -F 'value=1' #{url} 2>/dev/null`
      # FIXME use NET::HTTP instead of curl
      #Net::HTTP.post_form URI.parse(url),
                                #'login' => github_username,
                                #'token' => github_token,
                                #'field' => 'repository_rubygem',
                                #'value' => '1'
    end

  end
end
