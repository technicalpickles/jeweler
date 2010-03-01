require 'git'
require 'thor/actions/git_init'

class Thor
  module Actions
    def add_git_remote(destination, name, uri, config={})
      action GitRemote.new(self, destination, name, uri, config)
    end

    class GitRemote < GitInit
      attr_accessor :name, :uri
      def initialize(base, destination, name, uri, config)
        super(base, destination, config)
        self.name = name
        self.uri = uri
      end

      def invoke!
        invoke_with_conflict_check do
          FileUtils.mkdir_p(File.dirname(destination))
          repo = Git.init(destination)
          repo.add_remote(self.name, self.uri)
        end
      end

      def exists?
        super && Git.open(destination).remote(self.name).url
      end

      def invoke_with_conflict_check(&block)
        if exists?
          on_conflict_behavior(&block)
        else
          base.shell.say_status "git remote", "#{name} #{uri}" if config[:verbose]
          block.call unless pretend?
        end

        destination

      end

      def say_status(status, color)
        base.shell.say_status status, name, color if config[:verbose]
      end
    end

  end
end
