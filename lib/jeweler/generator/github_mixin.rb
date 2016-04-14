class Jeweler
  class Generator
    module GithubMixin
      def self.extended(generator)
        generator.github_username           = generator.options[:github_username]
        generator.should_create_remote_repo = generator.options[:create_repo]

        raise NoGitHubUser unless generator.github_username
      end

      def git_remote
        @git_remote ||= "git@github.com:#{github_username}/#{project_name}.git"
      end

      def homepage
        @homepage ||= "http://github.com/#{github_username}/#{project_name}"
      end
    end
  end
end
