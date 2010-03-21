class Jeweler
  class Generator
    class Application
      class << self
        def run!(*arguments)
          env_args = if ENV['JEWELER_OPTS']
                       ENV['JEWELER_OPTS'].split(' ')
                     else
                       []
                     end

          begin
            Jeweler::Generator.start(arguments + env_args , {})

            return 0
          rescue Jeweler::NoGitUserName
            $stderr.puts %Q{No user.name found in ~/.gitconfig. Please tell git about yourself (see http://help.github.com/git-email-settings/ for details). For example: git config --global user.name "mad voo"}
            return 1
          rescue Jeweler::NoGitUserEmail
            $stderr.puts %Q{No user.email found in ~/.gitconfig. Please tell git about yourself (see http://help.github.com/git-email-settings/ for details). For example: git config --global user.email mad.vooo@gmail.com}
            return 1
          rescue Jeweler::NoGitHubUser
            $stderr.puts %Q{No github.user found in ~/.gitconfig. Please tell git about your GitHub account (see http://github.com/blog/180-local-github-config for details). For example: git config --global github.user defunkt}
            return 1
          rescue Jeweler::NoGitHubToken
            $stderr.puts %Q{No github.token found in ~/.gitconfig. Please tell git about your GitHub account (see http://github.com/blog/180-local-github-config for details). For example: git config --global github.token 6ef8395fecf207165f1a82178ae1b984}
            return 1
          rescue Jeweler::FileInTheWay
            $stderr.puts "The directory #{options[:project_name]} already exists. Maybe move it out of the way before continuing?"
            return 1
          end
        end
      end

    end
  end
end
