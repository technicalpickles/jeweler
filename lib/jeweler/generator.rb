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
  class NoGitHubUsernameGiven < StandardError
  end
    
  class Generator
    attr_accessor :target_dir, :user_name, :user_email, :github_repo_name, :github_remote, :github_url, :github_username, :lib_dir

    def initialize(github_username, github_repo_name, dir = nil)
      if github_username.nil?
        raise NoGitHubUsernameGiven
      end
      self.github_username = github_username
      
      if github_repo_name.nil?
        raise NoGitHubRepoNameGiven
      end
      self.github_repo_name = github_repo_name
      
      self.github_remote = "git@github.com:#{github_username}/#{github_repo_name}.git"
      self.github_url = "http://github.com/#{github_username}/#{github_repo_name}"
      
      check_user_git_config()
      
      self.target_dir = dir || self.github_repo_name
      self.lib_dir = File.join(target_dir, 'lib')
    end



    def run
      create_files
      gitify
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

      output_template_in_target('Rakefile')
      output_template_in_target('LICENSE')
      output_template_in_target('README')
      
      FileUtils.touch File.join(lib_dir, "#{github_repo_name}.rb")
    end
  
    def check_user_git_config
      config = read_git_config
      unless config.has_key? 'user.name'
        raise NoGitUserName, %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
      end
      unless config.has_key? 'user.email'
        raise NoGitUserEmail, %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
      end

      self.user_name = config['user.name']
      self.user_email = config['user.email']
    end
    
    def output_template_in_target(file)
      template = ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', file)))
      File.open(File.join(target_dir, file), 'w') {|file| file.write(template.result(binding))}
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
    
  protected
    def read_git_config
      lib = Git::Lib.new(nil, nil)
      config = lib.parse_config '~/.gitconfig'
    end
  end
end