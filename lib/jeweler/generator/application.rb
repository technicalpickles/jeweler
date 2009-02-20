class Jeweler
  class Generator
    class Application
      class << self
        def run!(*arguments)
          options = Jeweler::Generator::Options.new(ARGV)

          unless ARGV.size == 1
            puts options.opts
            exit 1
          end

          github_repo_name = ARGV.first

          begin
            generator = Jeweler::Generator.new github_repo_name, options
            generator.run
          rescue Jeweler::NoGitUserName
            $stderr.puts %Q{No user.name found in ~/.gitconfig. Please tell git about yourself (see http://github.com/guides/tell-git-your-user-name-and-email-address for details). For example: git config --global user.name "mad voo"}
            exit 1
          rescue Jeweler::NoGitUserEmail
            $stderr.puts %Q{No user.email found in ~/.gitconfig. Please tell git about yourself (see http://github.com/guides/tell-git-your-user-name-and-email-address for details). For example: git config --global user.email mad.vooo@gmail.com}
            exit 1
          rescue Jeweler::NoGitHubUser
            $stderr.puts %Q{No github.user found in ~/.gitconfig. Please tell git about your GitHub account (see http://github.com/blog/180-local-github-config for details). For example: git config --global github.user defunkt}
            exit 1
          rescue Jeweler::NoGitHubToken
            $stderr.puts %Q{No github.token found in ~/.gitconfig. Please tell git about your GitHub account (see http://github.com/blog/180-local-github-config for details). For example: git config --global github.token 6ef8395fecf207165f1a82178ae1b984}
            exit 1
          rescue Jeweler::FileInTheWay
            $stderr.puts "The directory #{github_repo_name} already exists. Maybe move it out of the way before continuing?"
            exit 1
          end
        end
      end

    end
  end
end
