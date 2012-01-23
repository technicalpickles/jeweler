require 'shellwords'

class Jeweler
  class Generator
    class Application
      class << self
        include Shellwords

        def run!(*arguments)
          options = build_options(arguments)

          if options[:invalid_argument]
            $stderr.puts options[:invalid_argument]
            options[:show_help] = true
          end

          if options[:show_version]
            $stderr.puts Jeweler::Version::STRING
            return 1
          end

          if options[:show_help]
            $stderr.puts options.opts
            return 1
          end

          if options[:project_name].nil? || options[:project_name].squeeze.strip == ""
            $stderr.puts options.opts
            return 1
          end

          begin
            generator = Jeweler::Generator.new(options)
            generator.run
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

        def build_options(arguments)
          env_opts_string = ENV['JEWELER_OPTS'] || ""
          env_opts        = Jeweler::Generator::Options.new(shellwords(env_opts_string))
          argument_opts   = Jeweler::Generator::Options.new(arguments)

          env_opts.merge(argument_opts)
        end

      end

    end
  end
end
