class Thor
  module Actions
    def github_repo(config={})
      action GithubRepo.new(self, config)
    end

    class GithubRepo
      attr_accessor :base, :config

      def initialize(base, config)
        self.base = base
        self.config = config
      end

      def invoke!
        Net::HTTP.post_form URI.parse('http://github.com/api/v2/yaml/repos/create'),
          'login' => config[:login],
          'token' => config[:token],
          'description' => config[:description],
          'name' => config[:name] 

        base.shell.say_status 'github repo', "#{config[:login]}/#{config[:name]}"
      end
      
    end
  end
end
