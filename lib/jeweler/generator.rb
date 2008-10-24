require 'git'
require 'erb'

class Jeweler
  class Generator
    attr_accessor :target_dir, :user_name, :user_email, :github_repo_name, :github_remote, :github_url, :github_username, :lib_dir

    def initialize(github_remote, dir = nil)

      self.github_remote = github_remote
      check_user_git_config()
      determine_github_stuff()

      self.target_dir = dir || self.github_repo_name
      self.lib_dir = File.join(target_dir, 'lib')
    end

    def check_user_git_config
      lib = Git::Lib.new(nil, nil)
      config = lib.parse_config '~/.gitconfig'
      unless config.has_key? 'user.name'
        puts %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
        exit 1
      end
      unless config.has_key? 'user.email'
        puts %Q{No user.name set in ~/.gitconfig. Set it with: git config --global user.name 'Your Name Here'}
        exit 1
      end
      @user_name = config['user.name'].gsub('"', '')
      @user_email = config['user.email'].gsub('"', '')
    end

    def determine_github_stuff
      self.github_url = self.github_remote.gsub(/^git@github\.com:/, 'http://github.com/').gsub(/\.git$/, '/tree')
      self.github_repo_name = self.github_remote.match(/\/(.*)\.git$/)[1]
    end

    def run
      begin
        FileUtils.mkdir target_dir
      rescue Errno::EEXIST => e
        puts "The directory #{target_dir} already exists, aborting. Maybe move it out of the way before continuing?"
        exit 1
      end

      FileUtils.mkdir lib_dir

      rakefile = template('Rakefile')
      File.open(File.join(target_dir, 'Rakefile'), 'w') {|file| file.write(rakefile.result(binding))}

      license = template('LICENSE')
      File.open(File.join(target_dir, 'LICENSE'), 'w') {|file| file.write(license.result(binding))}

      FileUtils.touch File.join(lib_dir, "#{github_repo_name}.rb")

    end

    def template(file)
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', file)))
    end

    def gitify
      saved_pwd = Dir.pwd
      Dir.chdir(target_dir)
      begin
        repo = Git.init()
        repo.add('.')
        repo.commit 'First commit courtesy of jeweler.'
        repo.add_remote('origin', github_remote)
        repo.push('origin', 'master')
      rescue Git::GitExecuteError => e
        puts "Encountered an error during gitification. Maybe the repo already exists, or has already been pushed to?"
        puts
        raise
      end
      Dir.chdir(saved_pwd)
    end
  end
end