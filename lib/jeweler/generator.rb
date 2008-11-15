require 'git'
require 'erb'

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

  class Generator
    attr_accessor :target_dir, :user_name, :user_email,
                  :github_repo_name, :github_remote, :github_url, :github_username,
                  :lib_dir, :constant_name, :file_name_prefix, :config, :spec

    def initialize(github_repo_name, dir = nil)
      check_user_git_config()

      if github_repo_name.nil?
        raise NoGitHubRepoNameGiven
      end
      self.github_repo_name = github_repo_name

      self.github_remote = "git@github.com:#{github_username}/#{github_repo_name}.git"
      self.github_url = "http://github.com/#{github_username}/#{github_repo_name}"


      self.target_dir = dir || self.github_repo_name
      self.lib_dir = File.join(target_dir, 'lib')
      self.constant_name = self.github_repo_name.split(/[-_]/).collect{|each| each.capitalize }.join
      self.file_name_prefix = self.github_repo_name.gsub('-', '_')
    end

    def run
      create_files
      gitify
    end

    def testspec
      if self.spec
        'spec'
      else
        'test'
      end
    end

    def test_dir
      File.join(target_dir, testspec)
    end


  private
    def create_files
      begin
        FileUtils.mkdir target_dir
      rescue Errno::EEXIST => e
        puts "The directory #{target_dir} already exists, aborting. Maybe move it out of the way before continuing?"
        exit 1
      end

      FileUtils.mkdir lib_dir
      FileUtils.mkdir test_dir

      output_template_in_target('.gitignore')
      output_template_in_target('Rakefile')
      output_template_in_target('LICENSE')
      output_template_in_target('README')
      output_template_in_target("#{testspec}/#{testspec}_helper.rb")
      output_template_in_target("#{testspec}/flunking_#{testspec}.rb", "#{testspec}/#{file_name_prefix}_#{testspec}.rb")

      FileUtils.touch File.join(lib_dir, "#{file_name_prefix}.rb")
    end

    def check_user_git_config
      self.config = read_git_config
      unless config.has_key? 'user.name'
        raise NoGitUserName, %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
      end
      unless config.has_key? 'user.email'
        raise NoGitUserEmail, %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
      end
      unless config.has_key? 'github.user'
        raise NoGitHubUser, %Q{No github.user set in ~/.gitconfig. Set it with: git config --global github.user 'Your username here'}
      end

      self.user_name = config['user.name']
      self.user_email = config['user.email']
      self.github_username = config['github.user']
    end

    def output_template_in_target(source, destination = source)
      template = ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', source)))
      File.open(File.join(target_dir, destination), 'w') {|file| file.write(template.result(binding))}
    end

    def gitify
      saved_pwd = Dir.pwd
      Dir.chdir(target_dir)
      begin
        repo = Git.init()
        repo.add('.')
        repo.commit "Initial commit to #{github_repo_name}."
        repo.add_remote('origin', github_remote)
      rescue Git::GitExecuteError => e
        puts "Encountered an error during gitification. Maybe the repo already exists, or has already been pushed to?"
        puts
        raise
      end
      Dir.chdir(saved_pwd)
    end

    def read_git_config
      # we could just use Git::Base's .config, but that relies on a repo being around already
      # ... which we don't have yet, since this is part of a sanity check
      lib = Git::Lib.new(nil, nil)
      config = lib.parse_config '~/.gitconfig'
    end
  end
end
